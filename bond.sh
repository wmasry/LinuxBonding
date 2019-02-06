#!/bin/bash

BOND="/etc/sysconfig/network-scripts/ifcfg-bond*"
BOND0="/etc/sysconfig/network-scripts/ifcfg-bond0"

ETH0="/etc/sysconfig/network-scripts/ifcfg-eth0"
ETH1="/etc/sysconfig/network-scripts/ifcfg-eth1"

echo -e "...\n"
echo -e "Looking for any Network Bonding Configuration Files \n"


IPADDR=$(grep -i IPADDR /etc/sysconfig/network-scripts/ifcfg-eth0 |  cut -d "=" -f  2)
MASK=$(grep -i NETMASK /etc/sysconfig/network-scripts/ifcfg-eth0 |  cut -d "=" -f  2)
GW=$(grep -i GATEWAY /etc/sysconfig/network-scripts/ifcfg-eth0 |  cut -d "=" -f  2)
HWADDR=$(grep -i HWADDR /etc/sysconfig/network-scripts/ifcfg-eth0 |  cut -d "=" -f  2)
NETWORK=$(grep -i NETWORK /etc/sysconfig/network-scripts/ifcfg-eth0)
BROADCAST=$(grep -i BROADCAST /etc/sysconfig/network-scripts/ifcfg-eth0)

HWADDR_ETH0=$(grep -i HWADDR /etc/sysconfig/network-scripts/ifcfg-eth0)
#HWADDR_ETH1=$(grep -i HWADDR /etc/sysconfig/network-scripts/ifcfg-eth1)

if [ -f $BOND ];
then
echo "Bonding Configuration Already exists"
else
echo "Bonding Configuration doesnt exists"
echo -e "Starting the Network Configuration\n"
echo -e "The current IP address is"
echo $IPADDR
echo -e "\n"
echo "DEVICE=bond0" > $BOND0
echo "ONBOOT=yes" >> $BOND0
echo "BOOTPROTO=static" >> $BOND0
echo $BROADCAST >> $BOND0
echo $NETWORK >> $BOND0
echo "IPADDR="$IPADDR >> $BOND0
echo "NETMASK="$MASK >> $BOND0
#echo "GATEWAY="$GW >> $BOND0
#echo "HWADDR="$HWADDR >> $BOND0
echo BONDING_OPTS=\"mode=1 miimon=100\"  >> $BOND0

#Here I need to check if the servers is

fi

#Create New Eth Files

if [ -f $ETH0 ];
then
mv /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/eth0.old
sed -i -e 's/^/#/' /etc/sysconfig/network-scripts/eth0.old
else
echo "File Doesnt Exist"
fi

if [ -f $ETH1 ];
then
HWADDR_ETH1=$(grep -i HWADDR /etc/sysconfig/network-scripts/ifcfg-eth1)
mv /etc/sysconfig/network-scripts/ifcfg-eth1 /etc/sysconfig/network-scripts/eth1.old
sed -i -e 's/^/#/' /etc/sysconfig/network-scripts/eth1.old
else
#echo "Cannot Proceed, Interface eth1 is missing"
HWADDR_ETH1="HWADDR="$(cat /sys/class/net/eth1/address)
fi

#Create New Eth Files

echo "DEVICE=eth0" > $ETH0
echo "ONBOOT=yes" >> $ETH0
echo "BOOTPROTO=none" >> $ETH0
echo "SLAVE=yes" >> $ETH0
echo "MASTER=bond0" >> $ETH0
echo $HWADDR_ETH0  >> $ETH0

echo "DEVICE=eth1" > $ETH1
echo "ONBOOT=yes" >> $ETH1
echo "BOOTPROTO=none" >> $ETH1
echo "SLAVE=yes" >> $ETH1
echo "MASTER=bond0" >> $ETH1
echo $HWADDR_ETH1  >> $ETH1


echo -e "Bonding Configured\n"
echo -e "Restart Network s\n"


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3GWK70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:59:26 -0400
Received: from hel.is.scarlet.be ([193.74.71.26]:38455 "EHLO hel.is.scarlet.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3GWK7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:59:25 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2013 06:59:25 EDT
X-Scarlet: d=1374576558 c=62.235.205.3
From: Treeve Jelbert <treeve@scarlet.be>
To: linux-kernel@vger.kernel.org
Subject: [NETWORKING DRIVERS RT2X00] please add support for Asus PCE-N53  (0x1814, 0x5592)
Date: Tue, 23 Jul 2013 12:49:17 +0200
Message-ID: <2108818.T0lx4Vi2Ui@horos>
User-Agent: KMail/4.11 rc1 (Linux/3.10.2; KDE/4.10.95; x86_64; git-152db2f; 2013-07-18)
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-DCC-scarlet.be-Metrics: hel 20002; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-3.10.0 does not support device  (0x1814, 0x5592) Asus PCE-N53 which I 
would like to use on with 5GHz network.

#lspci
02:00.0 Network controller: Ralink corp. Device 5592
        Subsystem: ASUSTeK Computer Inc. Device 851a

# lspci -d :5592 -nn
02:00.0 Network controller [0280]: Ralink corp. Device [1814:5592]

#modprobe rt2x00pci
[ 2724.173984] cfg80211: Calling CRDA to update world regulatory domain


device id (0x1814, 0x5592) 'Asus PCE-N53' not present in rt2800pci.c




After adding this device id , it get the following messages

[    8.993741] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading 
firmware file 'rt2860.bin'
[    8.994857] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware 
detected - version: 0.34
[    9.073053] NET: Registered protocol family 17
[   10.438586] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame 
received with unrecognized signal, mode=0x0000, signal=0x0000, type=4
[   69.171225] ieee80211 phy0: rt2x00lib_rxdone: Error - Wrong frame size 0
max 3840


#lsmod
rt2800pci               9514  0 
eeprom_93cx6            1913  1 rt2800pci
rt2x00pci               2368  1 rt2800pci
rt2800lib              52747  1 rt2800pci
crc_ccitt               1235  1 rt2800lib
rt2x00mmio              2425  1 rt2800pci
rt2x00lib              30593  4 rt2x00pci,rt2800lib,rt2800pci,rt2x00mmio
led_class               2531  1 rt2x00lib
mac80211              209216  3 rt2x00lib,rt2x00pci,rt2800lib

#ifconfig
wlan0     Link encap:Ethernet  HWaddr 30:85:A9:F4:B6:61  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)


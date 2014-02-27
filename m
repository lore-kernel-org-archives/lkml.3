Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaB0QRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:17:23 -0500
Received: from dd8000.kasserver.com ([85.13.132.92]:46682 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaB0QRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:17:22 -0500
Message-ID: <530F650F.60508@gmx.net>
Date: Thu, 27 Feb 2014 17:17:19 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [3.14-rc4 xHCI] Regression haswell B85 with xHCI on
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I migrated my system from H77 Ivy-bridge to a haswell Platform
B85 i3-4330.

The system has three dvb-c usb receivers connected. On the Ivy
Platform everything runs fine with xHCI. On the haswell Platform
xHCI explodes with  following messages:

2014-02-27T16:45:53.518332+01:00 vnas kernel: [  222.218703] xhci_hcd
0000:00:14.0: xHCI host not responding to stop endpoint command.
2014-02-27T16:45:53.518342+01:00 vnas kernel: [  222.218712] xhci_hcd
0000:00:14.0: Assuming host is dying, halting host.
2014-02-27T16:45:53.518346+01:00 vnas kernel: [  222.218808] xhci_hcd
0000:00:14.0: HC died; cleaning up
2014-02-27T16:45:53.518349+01:00 vnas kernel: [  222.218870] usb 1-1:
USB disconnect, device number 2
2014-02-27T16:45:53.518351+01:00 vnas kernel: [  222.218880] usb 1-1.2:
USB disconnect, device number 7
2014-02-27T16:45:53.518353+01:00 vnas kernel: [  222.218979] em2884 #0:
writing to i2c device at 0x52 failed (error=-19)
2014-02-27T16:45:53.518356+01:00 vnas kernel: [  222.218988] drxk: i2c
write error at addr 0x29
2014-02-27T16:45:53.518358+01:00 vnas kernel: [  222.218993] em2884 #2:
writing to i2c device at 0x52 failed (error=-19)
2014-02-27T16:45:53.518361+01:00 vnas kernel: [  222.218997] drxk: i2c
write error at addr 0x29
2014-02-27T16:45:53.518364+01:00 vnas kernel: [  222.219001] drxk:
write_block: i2c write error at addr 0x831ffd
2014-02-27T16:45:53.518366+01:00 vnas kernel: [  222.219006] drxk:
write_block: i2c write error at addr 0x831ffd
2014-02-27T16:45:53.518368+01:00 vnas kernel: [  222.219012] em2884 #1:
writing to i2c device at 0x52 failed (error=-19)
2014-02-27T16:45:53.518371+01:00 vnas kernel: [  222.219017] drxk: i2c
write error at addr 0x29
2014-02-27T16:45:53.518373+01:00 vnas kernel: [  222.219021] drxk:
write_block: i2c write error at addr 0x831ffd
2014-02-27T16:45:53.518375+01:00 vnas kernel: [  222.219070] em2884 #0:
Disconnecting em2884 #0
2014-02-27T16:45:53.518962+01:00 vnas kernel: [  222.219076] em2884 #0:
Closing audio extension

This happens when more then one DVB-C receiver is connected.
With only one it works.

If I disable xHCI Mode in Bios and run only with EHCI.
Everything is running fine either.

lsusb:

Bus 001 Device 002: ID 8087:8008 Intel
Corp.                                                                                                                                                              

Bus 002 Device 002: ID 8087:8000 Intel
Corp.                                                                                                                                                              

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root
hub                      
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root
hub                                                                                                                         

Bus 002 Device 003: ID
2109:2811                                                                                                               

Bus 002 Device 004: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x
UART Bridge / myAVR mySmartUSB light                
Bus 002 Device 005: ID 03eb:201l3 Atmel Corp.
Bus 002 Device 006: ID
9e88:9e8f                                                                                                                                                       

Bus 002 Device 007: ID 1a40:0101 Terminus Technology Inc. 4-Port HUB
Bus 002 Device 008: ID 2040:1605
Hauppauge                                                                 
Bus 002 Device 009: ID 2040:1605
Hauppauge                                                                                                        

Bus 002 Device 010: ID 2040:1605 Hauppauge
Bus 002 Device 011: ID 04e6:5116 SCM Microsystems, Inc. SCR331-LC1 /
SCR3310 SmartCard Reader
Bus 002 Device 012: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth
Dongle (HCI mode)
Bus 002 Device 013: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x
UART Bridge / myAVR mySmartUSB light
Bus 002 Device 014: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x
UART Bridge / myAVR mySmartUSB light

lspci: xHCI disabled:

00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor DRAM
Controller (rev 06)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th
Gen Core Processor Integrated Graphics Controller (rev 06)
00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
Processor HD Audio Controller (rev 06)
00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series
Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset
High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #1 (rev d5)
00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #3 (rev d5)
00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
Family PCI Express Root Port #4 (rev d5)
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation B85 Express LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset
Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family
SMBus Controller (rev 05)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)

Any Idea how to fix these?

Thanks

Otto


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaCAKTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 05:19:42 -0500
Received: from dd8000.kasserver.com ([85.13.132.92]:60186 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaCAKTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 05:19:38 -0500
Message-ID: <5311B436.8010900@gmx.net>
Date: Sat, 01 Mar 2014 11:19:34 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [3.14-rc4 xHCI] Regression haswell B85 with xHCI on
References: <530F650F.60508@gmx.net> <20140228184900.GB3405@xanatos>
In-Reply-To: <20140228184900.GB3405@xanatos>
Content-Type: multipart/mixed;
 boundary="------------090705050402050609060408"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090705050402050609060408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 28.02.2014 19:49, schrieb Sarah Sharp:
> On Thu, Feb 27, 2014 at 05:17:19PM +0100, Otto Meier wrote:
>> I migrated my system from H77 Ivy-bridge to a haswell Platform
>> B85 i3-4330.
>>
>> The system has three dvb-c usb receivers connected. On the Ivy
>> Platform everything runs fine with xHCI. On the haswell Platform
>> xHCI explodes with  following messages:
> Do these DVB-C receivers work with an earlier kernel on this machine?
> If so, that's technically not a regression, but it's still a bug that
> needs to get fixed.
For me regression means that on ivy hardware with series 7 chipset
xhci works fine and on series 8 hardware with haswell xhci explodes.

i have tested so far mainboards with b85, h87 and z87 chipsets from
biostar, gigabyte, msi, and zotac. All have the same Issue.
>
>> 2014-02-27T16:45:53.518332+01:00 vnas kernel: [  222.218703] xhci_hcd 0000:00:14.0: xHCI host not responding to stop endpoint command.
>> 2014-02-27T16:45:53.518342+01:00 vnas kernel: [  222.218712] xhci_hcd 0000:00:14.0: Assuming host is dying, halting host.
>> 2014-02-27T16:45:53.518346+01:00 vnas kernel: [  222.218808] xhci_hcd 0000:00:14.0: HC died; cleaning up
>> 2014-02-27T16:45:53.518349+01:00 vnas kernel: [  222.218870] usb 1-1: USB disconnect, device number 2
>> 2014-02-27T16:45:53.518351+01:00 vnas kernel: [  222.218880] usb 1-1.2: USB disconnect, device number 7
>> 2014-02-27T16:45:53.518353+01:00 vnas kernel: [  222.218979] em2884 #0: writing to i2c device at 0x52 failed (error=-19)
>> 2014-02-27T16:45:53.518356+01:00 vnas kernel: [  222.218988] drxk: i2c write error at addr 0x29
>> 2014-02-27T16:45:53.518358+01:00 vnas kernel: [  222.218993] em2884 #2: writing to i2c device at 0x52 failed (error=-19)
>> 2014-02-27T16:45:53.518361+01:00 vnas kernel: [  222.218997] drxk: i2c write error at addr 0x29
>> 2014-02-27T16:45:53.518364+01:00 vnas kernel: [  222.219001] drxk: write_block: i2c write error at addr 0x831ffd
>> 2014-02-27T16:45:53.518366+01:00 vnas kernel: [  222.219006] drxk: write_block: i2c write error at addr 0x831ffd
>> 2014-02-27T16:45:53.518368+01:00 vnas kernel: [  222.219012] em2884 #1: writing to i2c device at 0x52 failed (error=-19)
>> 2014-02-27T16:45:53.518371+01:00 vnas kernel: [  222.219017] drxk: i2c write error at addr 0x29
>> 2014-02-27T16:45:53.518373+01:00 vnas kernel: [  222.219021] drxk: write_block: i2c write error at addr 0x831ffd
>> 2014-02-27T16:45:53.518375+01:00 vnas kernel: [  222.219070] em2884 #0: Disconnecting em2884 #0
>> 2014-02-27T16:45:53.518962+01:00 vnas kernel: [  222.219076] em2884 #0: Closing audio extension
> Can you enable xHCI dynamic debugging (make sure you have
> CONFIG_DYNAMIC_DEBUG turned on), and send us more of the dmesg before
> the host died?
>
> echo -n 'module xhci_hcd =p' > /sys/kernel/debug/dynamic_debug/control
>
Please find the log attached.
>> This happens when more then one DVB-C receiver is connected.
>> With only one it works.
>>
>> If I disable xHCI Mode in Bios and run only with EHCI.
>> Everything is running fine either.
>>
>> lsusb:
>>
>> Bus 001 Device 002: ID 8087:8008 Intel Corp.
>> Bus 002 Device 002: ID 8087:8000 Intel Corp.
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub                      
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub                                                                                                                         
>> Bus 002 Device 003: ID 2109:2811                                                                                                               
>> Bus 002 Device 004: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge / myAVR mySmartUSB light                
>> Bus 002 Device 005: ID 03eb:201l3 Atmel Corp.
>> Bus 002 Device 006: ID 9e88:9e8f                                                                                                                                                       
>> Bus 002 Device 007: ID 1a40:0101 Terminus Technology Inc. 4-Port HUB
>> Bus 002 Device 008: ID 2040:1605 Hauppauge                                                                 
>> Bus 002 Device 009: ID 2040:1605 Hauppauge                                                                                                        
>> Bus 002 Device 010: ID 2040:1605 Hauppauge
>> Bus 002 Device 011: ID 04e6:5116 SCM Microsystems, Inc. SCR331-LC1 / SCR3310 SmartCard Reader
>> Bus 002 Device 012: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
>> Bus 002 Device 013: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge / myAVR mySmartUSB light
>> Bus 002 Device 014: ID 10c4:ea60 Cygnal Integrated Products, Inc. CP210x UART Bridge / myAVR mySmartUSB light
>>
>> lspci: xHCI disabled:
>>
>> 00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor DRAM
>> Controller (rev 06)
>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th
>> Gen Core Processor Integrated Graphics Controller (rev 06)
>> 00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
>> Processor HD Audio Controller (rev 06)
>> 00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series
>> Chipset Family MEI Controller #1 (rev 04)
>> 00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
>> Family USB EHCI #2 (rev 05)
>> 00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset
>> High Definition Audio Controller (rev 05)
>> 00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
>> Family PCI Express Root Port #1 (rev d5)
>> 00:1c.2 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
>> Family PCI Express Root Port #3 (rev d5)
>> 00:1c.3 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset
>> Family PCI Express Root Port #4 (rev d5)
>> 00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
>> Family USB EHCI #1 (rev 05)
>> 00:1f.0 ISA bridge: Intel Corporation B85 Express LPC Controller (rev 05)
>> 00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset
>> Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
>> 00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family
>> SMBus Controller (rev 05)
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
>> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
>>
>> Any Idea how to fix these?
> I won't know until I see more dmesg.
>
> Sarah Sharp
>
>
I hope this is what you are looking for. If I should test something else
please give me a hint.

Thanks for your support.

Otto


--------------090705050402050609060408
Content-Type: text/plain; charset=UTF-8;
 name="messages-debug-xhci.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="messages-debug-xhci.txt"

014-03-01T10:54:02.628134+01:00 vnas kernel: [  145.191789] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:02.628182+01:00 vnas kernel: [  145.191804] xhci_hcd 0000:00:14.0: Giveback URB ffff880035884540, len = 10, expected = 512, status = -121
2014-03-01T10:54:02.865234+01:00 vnas kernel: [  145.427978] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880212a47800
2014-03-01T10:54:02.865257+01:00 vnas kernel: [  145.427991] xhci_hcd 0000:00:14.0: drop ep 0x81, slot id 10, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8300002
2014-03-01T10:54:02.865260+01:00 vnas kernel: [  145.427997] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880212a47800
2014-03-01T10:54:02.865262+01:00 vnas kernel: [  145.428004] xhci_hcd 0000:00:14.0: drop ep 0x82, slot id 10, new drop flags = 0x28, new add flags = 0x0, new slot info = 0x8300002
2014-03-01T10:54:02.865264+01:00 vnas kernel: [  145.428009] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880212a47800
2014-03-01T10:54:02.865266+01:00 vnas kernel: [  145.428015] xhci_hcd 0000:00:14.0: drop ep 0x83, slot id 10, new drop flags = 0xa8, new add flags = 0x0, new slot info = 0x8300002
2014-03-01T10:54:02.865268+01:00 vnas kernel: [  145.428020] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880212a47800
2014-03-01T10:54:02.865269+01:00 vnas kernel: [  145.428026] xhci_hcd 0000:00:14.0: drop ep 0x84, slot id 10, new drop flags = 0x2a8, new add flags = 0x0, new slot info = 0x8300002
2014-03-01T10:54:02.865271+01:00 vnas kernel: [  145.428037] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 10, new drop flags = 0x2a8, new add flags = 0x8, new slot info = 0x18300002
2014-03-01T10:54:02.865273+01:00 vnas kernel: [  145.428051] xhci_hcd 0000:00:14.0: add ep 0x82, slot id 10, new drop flags = 0x2a8, new add flags = 0x28, new slot info = 0x28300002
2014-03-01T10:54:02.865274+01:00 vnas kernel: [  145.428061] xhci_hcd 0000:00:14.0: add ep 0x83, slot id 10, new drop flags = 0x2a8, new add flags = 0xa8, new slot info = 0x38300002
2014-03-01T10:54:02.865281+01:00 vnas kernel: [  145.428067] xhci_hcd 0000:00:14.0: add ep 0x84, slot id 10, new drop flags = 0x2a8, new add flags = 0x2a8, new slot info = 0x48300002
2014-03-01T10:54:02.865312+01:00 vnas kernel: [  145.428073] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff880212a47800
2014-03-01T10:54:02.865316+01:00 vnas kernel: [  145.428077] xhci_hcd 0000:00:14.0: New Input Control Context:
2014-03-01T10:54:02.865319+01:00 vnas kernel: [  145.428084] xhci_hcd 0000:00:14.0: @ffff880210a2a000 (virt) @210a2a000 (dma) 0x0002a8 - drop flags
2014-03-01T10:54:02.865321+01:00 vnas kernel: [  145.428089] xhci_hcd 0000:00:14.0: @ffff880210a2a004 (virt) @210a2a004 (dma) 0x0002a9 - add flags
2014-03-01T10:54:02.865323+01:00 vnas kernel: [  145.428095] xhci_hcd 0000:00:14.0: @ffff880210a2a008 (virt) @210a2a008 (dma) 0x000000 - rsvd2[0]
2014-03-01T10:54:02.865325+01:00 vnas kernel: [  145.428100] xhci_hcd 0000:00:14.0: @ffff880210a2a00c (virt) @210a2a00c (dma) 0x000000 - rsvd2[1]
2014-03-01T10:54:02.865328+01:00 vnas kernel: [  145.428105] xhci_hcd 0000:00:14.0: @ffff880210a2a010 (virt) @210a2a010 (dma) 0x000000 - rsvd2[2]
2014-03-01T10:54:02.865330+01:00 vnas kernel: [  145.428111] xhci_hcd 0000:00:14.0: @ffff880210a2a014 (virt) @210a2a014 (dma) 0x000000 - rsvd2[3]
2014-03-01T10:54:02.865332+01:00 vnas kernel: [  145.428116] xhci_hcd 0000:00:14.0: @ffff880210a2a018 (virt) @210a2a018 (dma) 0x000000 - rsvd2[4]
2014-03-01T10:54:02.865335+01:00 vnas kernel: [  145.428120] xhci_hcd 0000:00:14.0: @ffff880210a2a01c (virt) @210a2a01c (dma) 0x000000 - rsvd2[5]
2014-03-01T10:54:02.865337+01:00 vnas kernel: [  145.428124] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:02.865339+01:00 vnas kernel: [  145.428130] xhci_hcd 0000:00:14.0: @ffff880210a2a020 (virt) @210a2a020 (dma) 0x48300002 - dev_info
2014-03-01T10:54:02.865342+01:00 vnas kernel: [  145.428134] xhci_hcd 0000:00:14.0: @ffff880210a2a024 (virt) @210a2a024 (dma) 0x010000 - dev_info2
2014-03-01T10:54:02.865344+01:00 vnas kernel: [  145.428139] xhci_hcd 0000:00:14.0: @ffff880210a2a028 (virt) @210a2a028 (dma) 0x000000 - tt_info
2014-03-01T10:54:02.865347+01:00 vnas kernel: [  145.428144] xhci_hcd 0000:00:14.0: @ffff880210a2a02c (virt) @210a2a02c (dma) 0x000000 - dev_state
2014-03-01T10:54:02.865350+01:00 vnas kernel: [  145.428149] xhci_hcd 0000:00:14.0: @ffff880210a2a030 (virt) @210a2a030 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865352+01:00 vnas kernel: [  145.428155] xhci_hcd 0000:00:14.0: @ffff880210a2a034 (virt) @210a2a034 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865354+01:00 vnas kernel: [  145.428160] xhci_hcd 0000:00:14.0: @ffff880210a2a038 (virt) @210a2a038 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865357+01:00 vnas kernel: [  145.428165] xhci_hcd 0000:00:14.0: @ffff880210a2a03c (virt) @210a2a03c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:02.865359+01:00 vnas kernel: [  145.428170] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:02.865361+01:00 vnas kernel: [  145.428175] xhci_hcd 0000:00:14.0: @ffff880210a2a040 (virt) @210a2a040 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865364+01:00 vnas kernel: [  145.428180] xhci_hcd 0000:00:14.0: @ffff880210a2a044 (virt) @210a2a044 (dma) 0x400026 - ep_info2
2014-03-01T10:54:02.865366+01:00 vnas kernel: [  145.428185] xhci_hcd 0000:00:14.0: @ffff880210a2a048 (virt) @210a2a048 (dma) 0x210a16031 - deq
2014-03-01T10:54:02.865368+01:00 vnas kernel: [  145.428190] xhci_hcd 0000:00:14.0: @ffff880210a2a050 (virt) @210a2a050 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865370+01:00 vnas kernel: [  145.428195] xhci_hcd 0000:00:14.0: @ffff880210a2a054 (virt) @210a2a054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865373+01:00 vnas kernel: [  145.428200] xhci_hcd 0000:00:14.0: @ffff880210a2a058 (virt) @210a2a058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865375+01:00 vnas kernel: [  145.428205] xhci_hcd 0000:00:14.0: @ffff880210a2a05c (virt) @210a2a05c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865376+01:00 vnas kernel: [  145.428210] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:02.865378+01:00 vnas kernel: [  145.428214] xhci_hcd 0000:00:14.0: @ffff880210a2a060 (virt) @210a2a060 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865381+01:00 vnas kernel: [  145.428219] xhci_hcd 0000:00:14.0: @ffff880210a2a064 (virt) @210a2a064 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.865383+01:00 vnas kernel: [  145.428224] xhci_hcd 0000:00:14.0: @ffff880210a2a068 (virt) @210a2a068 (dma) 0x000000 - deq
2014-03-01T10:54:02.865385+01:00 vnas kernel: [  145.428228] xhci_hcd 0000:00:14.0: @ffff880210a2a070 (virt) @210a2a070 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865388+01:00 vnas kernel: [  145.428232] xhci_hcd 0000:00:14.0: @ffff880210a2a074 (virt) @210a2a074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865390+01:00 vnas kernel: [  145.428237] xhci_hcd 0000:00:14.0: @ffff880210a2a078 (virt) @210a2a078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865394+01:00 vnas kernel: [  145.428242] xhci_hcd 0000:00:14.0: @ffff880210a2a07c (virt) @210a2a07c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865396+01:00 vnas kernel: [  145.428247] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:02.865398+01:00 vnas kernel: [  145.428252] xhci_hcd 0000:00:14.0: @ffff880210a2a080 (virt) @210a2a080 (dma) 0x0a0000 - ep_info
2014-03-01T10:54:02.865401+01:00 vnas kernel: [  145.428256] xhci_hcd 0000:00:14.0: @ffff880210a2a084 (virt) @210a2a084 (dma) 0x01003e - ep_info2
2014-03-01T10:54:02.865403+01:00 vnas kernel: [  145.428261] xhci_hcd 0000:00:14.0: @ffff880210a2a088 (virt) @210a2a088 (dma) 0x2104f7401 - deq
2014-03-01T10:54:02.865405+01:00 vnas kernel: [  145.428267] xhci_hcd 0000:00:14.0: @ffff880210a2a090 (virt) @210a2a090 (dma) 0x010001 - tx_info
2014-03-01T10:54:02.865407+01:00 vnas kernel: [  145.428272] xhci_hcd 0000:00:14.0: @ffff880210a2a094 (virt) @210a2a094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865409+01:00 vnas kernel: [  145.428276] xhci_hcd 0000:00:14.0: @ffff880210a2a098 (virt) @210a2a098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865412+01:00 vnas kernel: [  145.428281] xhci_hcd 0000:00:14.0: @ffff880210a2a09c (virt) @210a2a09c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865413+01:00 vnas kernel: [  145.428285] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:02.865415+01:00 vnas kernel: [  145.428290] xhci_hcd 0000:00:14.0: @ffff880210a2a0a0 (virt) @210a2a0a0 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865416+01:00 vnas kernel: [  145.428294] xhci_hcd 0000:00:14.0: @ffff880210a2a0a4 (virt) @210a2a0a4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.865418+01:00 vnas kernel: [  145.428299] xhci_hcd 0000:00:14.0: @ffff880210a2a0a8 (virt) @210a2a0a8 (dma) 0x000000 - deq
2014-03-01T10:54:02.865419+01:00 vnas kernel: [  145.428303] xhci_hcd 0000:00:14.0: @ffff880210a2a0b0 (virt) @210a2a0b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865421+01:00 vnas kernel: [  145.428307] xhci_hcd 0000:00:14.0: @ffff880210a2a0b4 (virt) @210a2a0b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865422+01:00 vnas kernel: [  145.428312] xhci_hcd 0000:00:14.0: @ffff880210a2a0b8 (virt) @210a2a0b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865423+01:00 vnas kernel: [  145.428317] xhci_hcd 0000:00:14.0: @ffff880210a2a0bc (virt) @210a2a0bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865425+01:00 vnas kernel: [  145.428322] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:02.865426+01:00 vnas kernel: [  145.428326] xhci_hcd 0000:00:14.0: @ffff880210a2a0c0 (virt) @210a2a0c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865428+01:00 vnas kernel: [  145.428331] xhci_hcd 0000:00:14.0: @ffff880210a2a0c4 (virt) @210a2a0c4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:02.865429+01:00 vnas kernel: [  145.428335] xhci_hcd 0000:00:14.0: @ffff880210a2a0c8 (virt) @210a2a0c8 (dma) 0xd0cd1001 - deq
2014-03-01T10:54:02.865430+01:00 vnas kernel: [  145.428340] xhci_hcd 0000:00:14.0: @ffff880210a2a0d0 (virt) @210a2a0d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865432+01:00 vnas kernel: [  145.428345] xhci_hcd 0000:00:14.0: @ffff880210a2a0d4 (virt) @210a2a0d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865433+01:00 vnas kernel: [  145.428350] xhci_hcd 0000:00:14.0: @ffff880210a2a0d8 (virt) @210a2a0d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865435+01:00 vnas kernel: [  145.428354] xhci_hcd 0000:00:14.0: @ffff880210a2a0dc (virt) @210a2a0dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865436+01:00 vnas kernel: [  145.428359] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:02.865437+01:00 vnas kernel: [  145.428363] xhci_hcd 0000:00:14.0: @ffff880210a2a0e0 (virt) @210a2a0e0 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865439+01:00 vnas kernel: [  145.428367] xhci_hcd 0000:00:14.0: @ffff880210a2a0e4 (virt) @210a2a0e4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.865440+01:00 vnas kernel: [  145.428372] xhci_hcd 0000:00:14.0: @ffff880210a2a0e8 (virt) @210a2a0e8 (dma) 0x000000 - deq
2014-03-01T10:54:02.865442+01:00 vnas kernel: [  145.428377] xhci_hcd 0000:00:14.0: @ffff880210a2a0f0 (virt) @210a2a0f0 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865443+01:00 vnas kernel: [  145.428381] xhci_hcd 0000:00:14.0: @ffff880210a2a0f4 (virt) @210a2a0f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865444+01:00 vnas kernel: [  145.428386] xhci_hcd 0000:00:14.0: @ffff880210a2a0f8 (virt) @210a2a0f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865446+01:00 vnas kernel: [  145.428391] xhci_hcd 0000:00:14.0: @ffff880210a2a0fc (virt) @210a2a0fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865487+01:00 vnas kernel: [  145.428396] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:02.865489+01:00 vnas kernel: [  145.428400] xhci_hcd 0000:00:14.0: @ffff880210a2a100 (virt) @210a2a100 (dma) 0x030000 - ep_info
2014-03-01T10:54:02.865491+01:00 vnas kernel: [  145.428405] xhci_hcd 0000:00:14.0: @ffff880210a2a104 (virt) @210a2a104 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:02.865492+01:00 vnas kernel: [  145.428409] xhci_hcd 0000:00:14.0: @ffff880210a2a108 (virt) @210a2a108 (dma) 0xd0cd1801 - deq
2014-03-01T10:54:02.865493+01:00 vnas kernel: [  145.428415] xhci_hcd 0000:00:14.0: @ffff880210a2a110 (virt) @210a2a110 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:02.865495+01:00 vnas kernel: [  145.428420] xhci_hcd 0000:00:14.0: @ffff880210a2a114 (virt) @210a2a114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865496+01:00 vnas kernel: [  145.428424] xhci_hcd 0000:00:14.0: @ffff880210a2a118 (virt) @210a2a118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865498+01:00 vnas kernel: [  145.428429] xhci_hcd 0000:00:14.0: @ffff880210a2a11c (virt) @210a2a11c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865499+01:00 vnas kernel: [  145.428433] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:02.865501+01:00 vnas kernel: [  145.428438] xhci_hcd 0000:00:14.0: @ffff880210a2a120 (virt) @210a2a120 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865502+01:00 vnas kernel: [  145.428443] xhci_hcd 0000:00:14.0: @ffff880210a2a124 (virt) @210a2a124 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.865504+01:00 vnas kernel: [  145.428447] xhci_hcd 0000:00:14.0: @ffff880210a2a128 (virt) @210a2a128 (dma) 0x000000 - deq
2014-03-01T10:54:02.865505+01:00 vnas kernel: [  145.428452] xhci_hcd 0000:00:14.0: @ffff880210a2a130 (virt) @210a2a130 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.865506+01:00 vnas kernel: [  145.428456] xhci_hcd 0000:00:14.0: @ffff880210a2a134 (virt) @210a2a134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865508+01:00 vnas kernel: [  145.428461] xhci_hcd 0000:00:14.0: @ffff880210a2a138 (virt) @210a2a138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865509+01:00 vnas kernel: [  145.428466] xhci_hcd 0000:00:14.0: @ffff880210a2a13c (virt) @210a2a13c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865511+01:00 vnas kernel: [  145.428471] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:02.865512+01:00 vnas kernel: [  145.428476] xhci_hcd 0000:00:14.0: @ffff880210a2a140 (virt) @210a2a140 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.865514+01:00 vnas kernel: [  145.428481] xhci_hcd 0000:00:14.0: @ffff880210a2a144 (virt) @210a2a144 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:02.865515+01:00 vnas kernel: [  145.428485] xhci_hcd 0000:00:14.0: @ffff880210a2a148 (virt) @210a2a148 (dma) 0x35fb2401 - deq
2014-03-01T10:54:02.865516+01:00 vnas kernel: [  145.428490] xhci_hcd 0000:00:14.0: @ffff880210a2a150 (virt) @210a2a150 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:02.865518+01:00 vnas kernel: [  145.428495] xhci_hcd 0000:00:14.0: @ffff880210a2a154 (virt) @210a2a154 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.865519+01:00 vnas kernel: [  145.428500] xhci_hcd 0000:00:14.0: @ffff880210a2a158 (virt) @210a2a158 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.865521+01:00 vnas kernel: [  145.428504] xhci_hcd 0000:00:14.0: @ffff880210a2a15c (virt) @210a2a15c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.865522+01:00 vnas kernel: [  145.428510] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:02.865524+01:00 vnas kernel: [  145.428900] xhci_hcd 0000:00:14.0: Completed config ep cmd
2014-03-01T10:54:02.867263+01:00 vnas kernel: [  145.429682] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
2014-03-01T10:54:02.867273+01:00 vnas kernel: [  145.429692] xhci_hcd 0000:00:14.0: Output context after successful config ep cmd:
2014-03-01T10:54:02.867276+01:00 vnas kernel: [  145.429701] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:02.867278+01:00 vnas kernel: [  145.429707] xhci_hcd 0000:00:14.0: @ffff880211c8c000 (virt) @211c8c000 (dma) 0x48300002 - dev_info
2014-03-01T10:54:02.867280+01:00 vnas kernel: [  145.429712] xhci_hcd 0000:00:14.0: @ffff880211c8c004 (virt) @211c8c004 (dma) 0x010000 - dev_info2
2014-03-01T10:54:02.867282+01:00 vnas kernel: [  145.429717] xhci_hcd 0000:00:14.0: @ffff880211c8c008 (virt) @211c8c008 (dma) 0x000000 - tt_info
2014-03-01T10:54:02.867283+01:00 vnas kernel: [  145.429721] xhci_hcd 0000:00:14.0: @ffff880211c8c00c (virt) @211c8c00c (dma) 0x1800000a - dev_state
2014-03-01T10:54:02.867285+01:00 vnas kernel: [  145.429725] xhci_hcd 0000:00:14.0: @ffff880211c8c010 (virt) @211c8c010 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867287+01:00 vnas kernel: [  145.429729] xhci_hcd 0000:00:14.0: @ffff880211c8c014 (virt) @211c8c014 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867288+01:00 vnas kernel: [  145.429733] xhci_hcd 0000:00:14.0: @ffff880211c8c018 (virt) @211c8c018 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867290+01:00 vnas kernel: [  145.429737] xhci_hcd 0000:00:14.0: @ffff880211c8c01c (virt) @211c8c01c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:02.867291+01:00 vnas kernel: [  145.429742] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:02.867292+01:00 vnas kernel: [  145.429746] xhci_hcd 0000:00:14.0: @ffff880211c8c020 (virt) @211c8c020 (dma) 0x000001 - ep_info
2014-03-01T10:54:02.867294+01:00 vnas kernel: [  145.429750] xhci_hcd 0000:00:14.0: @ffff880211c8c024 (virt) @211c8c024 (dma) 0x400026 - ep_info2
2014-03-01T10:54:02.867295+01:00 vnas kernel: [  145.429754] xhci_hcd 0000:00:14.0: @ffff880211c8c028 (virt) @211c8c028 (dma) 0x210a16031 - deq
2014-03-01T10:54:02.867297+01:00 vnas kernel: [  145.429758] xhci_hcd 0000:00:14.0: @ffff880211c8c030 (virt) @211c8c030 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867299+01:00 vnas kernel: [  145.429762] xhci_hcd 0000:00:14.0: @ffff880211c8c034 (virt) @211c8c034 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867301+01:00 vnas kernel: [  145.429766] xhci_hcd 0000:00:14.0: @ffff880211c8c038 (virt) @211c8c038 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867302+01:00 vnas kernel: [  145.429769] xhci_hcd 0000:00:14.0: @ffff880211c8c03c (virt) @211c8c03c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867304+01:00 vnas kernel: [  145.429773] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:02.867305+01:00 vnas kernel: [  145.429777] xhci_hcd 0000:00:14.0: @ffff880211c8c040 (virt) @211c8c040 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.867307+01:00 vnas kernel: [  145.429781] xhci_hcd 0000:00:14.0: @ffff880211c8c044 (virt) @211c8c044 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.867308+01:00 vnas kernel: [  145.429785] xhci_hcd 0000:00:14.0: @ffff880211c8c048 (virt) @211c8c048 (dma) 0x000000 - deq
2014-03-01T10:54:02.867309+01:00 vnas kernel: [  145.429789] xhci_hcd 0000:00:14.0: @ffff880211c8c050 (virt) @211c8c050 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867311+01:00 vnas kernel: [  145.429793] xhci_hcd 0000:00:14.0: @ffff880211c8c054 (virt) @211c8c054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867313+01:00 vnas kernel: [  145.429797] xhci_hcd 0000:00:14.0: @ffff880211c8c058 (virt) @211c8c058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867314+01:00 vnas kernel: [  145.429800] xhci_hcd 0000:00:14.0: @ffff880211c8c05c (virt) @211c8c05c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867315+01:00 vnas kernel: [  145.429804] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:02.867317+01:00 vnas kernel: [  145.429808] xhci_hcd 0000:00:14.0: @ffff880211c8c060 (virt) @211c8c060 (dma) 0x0a0001 - ep_info
2014-03-01T10:54:02.867318+01:00 vnas kernel: [  145.429812] xhci_hcd 0000:00:14.0: @ffff880211c8c064 (virt) @211c8c064 (dma) 0x01003e - ep_info2
2014-03-01T10:54:02.867319+01:00 vnas kernel: [  145.429816] xhci_hcd 0000:00:14.0: @ffff880211c8c068 (virt) @211c8c068 (dma) 0x2104f7401 - deq
2014-03-01T10:54:02.867321+01:00 vnas kernel: [  145.429819] xhci_hcd 0000:00:14.0: @ffff880211c8c070 (virt) @211c8c070 (dma) 0x010001 - tx_info
2014-03-01T10:54:02.867323+01:00 vnas kernel: [  145.429823] xhci_hcd 0000:00:14.0: @ffff880211c8c074 (virt) @211c8c074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867324+01:00 vnas kernel: [  145.429827] xhci_hcd 0000:00:14.0: @ffff880211c8c078 (virt) @211c8c078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867326+01:00 vnas kernel: [  145.429831] xhci_hcd 0000:00:14.0: @ffff880211c8c07c (virt) @211c8c07c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867327+01:00 vnas kernel: [  145.429835] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:02.867328+01:00 vnas kernel: [  145.429838] xhci_hcd 0000:00:14.0: @ffff880211c8c080 (virt) @211c8c080 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.867330+01:00 vnas kernel: [  145.429842] xhci_hcd 0000:00:14.0: @ffff880211c8c084 (virt) @211c8c084 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.867331+01:00 vnas kernel: [  145.429846] xhci_hcd 0000:00:14.0: @ffff880211c8c088 (virt) @211c8c088 (dma) 0x000000 - deq
2014-03-01T10:54:02.867333+01:00 vnas kernel: [  145.429850] xhci_hcd 0000:00:14.0: @ffff880211c8c090 (virt) @211c8c090 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867334+01:00 vnas kernel: [  145.429854] xhci_hcd 0000:00:14.0: @ffff880211c8c094 (virt) @211c8c094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867336+01:00 vnas kernel: [  145.429857] xhci_hcd 0000:00:14.0: @ffff880211c8c098 (virt) @211c8c098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867337+01:00 vnas kernel: [  145.429861] xhci_hcd 0000:00:14.0: @ffff880211c8c09c (virt) @211c8c09c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867339+01:00 vnas kernel: [  145.429865] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:02.867340+01:00 vnas kernel: [  145.429869] xhci_hcd 0000:00:14.0: @ffff880211c8c0a0 (virt) @211c8c0a0 (dma) 0x000001 - ep_info
2014-03-01T10:54:02.867341+01:00 vnas kernel: [  145.429873] xhci_hcd 0000:00:14.0: @ffff880211c8c0a4 (virt) @211c8c0a4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:02.867343+01:00 vnas kernel: [  145.429877] xhci_hcd 0000:00:14.0: @ffff880211c8c0a8 (virt) @211c8c0a8 (dma) 0xd0cd1001 - deq
2014-03-01T10:54:02.867345+01:00 vnas kernel: [  145.429880] xhci_hcd 0000:00:14.0: @ffff880211c8c0b0 (virt) @211c8c0b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867346+01:00 vnas kernel: [  145.429884] xhci_hcd 0000:00:14.0: @ffff880211c8c0b4 (virt) @211c8c0b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867347+01:00 vnas kernel: [  145.429888] xhci_hcd 0000:00:14.0: @ffff880211c8c0b8 (virt) @211c8c0b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867349+01:00 vnas kernel: [  145.429892] xhci_hcd 0000:00:14.0: @ffff880211c8c0bc (virt) @211c8c0bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867350+01:00 vnas kernel: [  145.429895] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:02.867352+01:00 vnas kernel: [  145.429899] xhci_hcd 0000:00:14.0: @ffff880211c8c0c0 (virt) @211c8c0c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.867353+01:00 vnas kernel: [  145.429903] xhci_hcd 0000:00:14.0: @ffff880211c8c0c4 (virt) @211c8c0c4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.867355+01:00 vnas kernel: [  145.429907] xhci_hcd 0000:00:14.0: @ffff880211c8c0c8 (virt) @211c8c0c8 (dma) 0x000000 - deq
2014-03-01T10:54:02.867356+01:00 vnas kernel: [  145.429910] xhci_hcd 0000:00:14.0: @ffff880211c8c0d0 (virt) @211c8c0d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867357+01:00 vnas kernel: [  145.429914] xhci_hcd 0000:00:14.0: @ffff880211c8c0d4 (virt) @211c8c0d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867359+01:00 vnas kernel: [  145.429918] xhci_hcd 0000:00:14.0: @ffff880211c8c0d8 (virt) @211c8c0d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867360+01:00 vnas kernel: [  145.429922] xhci_hcd 0000:00:14.0: @ffff880211c8c0dc (virt) @211c8c0dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867362+01:00 vnas kernel: [  145.429926] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:02.867363+01:00 vnas kernel: [  145.429929] xhci_hcd 0000:00:14.0: @ffff880211c8c0e0 (virt) @211c8c0e0 (dma) 0x030001 - ep_info
2014-03-01T10:54:02.867365+01:00 vnas kernel: [  145.429933] xhci_hcd 0000:00:14.0: @ffff880211c8c0e4 (virt) @211c8c0e4 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:02.867366+01:00 vnas kernel: [  145.429937] xhci_hcd 0000:00:14.0: @ffff880211c8c0e8 (virt) @211c8c0e8 (dma) 0xd0cd1801 - deq
2014-03-01T10:54:02.867368+01:00 vnas kernel: [  145.429941] xhci_hcd 0000:00:14.0: @ffff880211c8c0f0 (virt) @211c8c0f0 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:02.867369+01:00 vnas kernel: [  145.429945] xhci_hcd 0000:00:14.0: @ffff880211c8c0f4 (virt) @211c8c0f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867371+01:00 vnas kernel: [  145.429949] xhci_hcd 0000:00:14.0: @ffff880211c8c0f8 (virt) @211c8c0f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867372+01:00 vnas kernel: [  145.429952] xhci_hcd 0000:00:14.0: @ffff880211c8c0fc (virt) @211c8c0fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867374+01:00 vnas kernel: [  145.429956] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:02.867375+01:00 vnas kernel: [  145.429960] xhci_hcd 0000:00:14.0: @ffff880211c8c100 (virt) @211c8c100 (dma) 0x000000 - ep_info
2014-03-01T10:54:02.867376+01:00 vnas kernel: [  145.429964] xhci_hcd 0000:00:14.0: @ffff880211c8c104 (virt) @211c8c104 (dma) 0x000000 - ep_info2
2014-03-01T10:54:02.867378+01:00 vnas kernel: [  145.429967] xhci_hcd 0000:00:14.0: @ffff880211c8c108 (virt) @211c8c108 (dma) 0x000000 - deq
2014-03-01T10:54:02.867380+01:00 vnas kernel: [  145.429971] xhci_hcd 0000:00:14.0: @ffff880211c8c110 (virt) @211c8c110 (dma) 0x000000 - tx_info
2014-03-01T10:54:02.867381+01:00 vnas kernel: [  145.429975] xhci_hcd 0000:00:14.0: @ffff880211c8c114 (virt) @211c8c114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867383+01:00 vnas kernel: [  145.429979] xhci_hcd 0000:00:14.0: @ffff880211c8c118 (virt) @211c8c118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867384+01:00 vnas kernel: [  145.429983] xhci_hcd 0000:00:14.0: @ffff880211c8c11c (virt) @211c8c11c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867385+01:00 vnas kernel: [  145.429986] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:02.867387+01:00 vnas kernel: [  145.429990] xhci_hcd 0000:00:14.0: @ffff880211c8c120 (virt) @211c8c120 (dma) 0x000001 - ep_info
2014-03-01T10:54:02.867388+01:00 vnas kernel: [  145.429994] xhci_hcd 0000:00:14.0: @ffff880211c8c124 (virt) @211c8c124 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:02.867390+01:00 vnas kernel: [  145.429998] xhci_hcd 0000:00:14.0: @ffff880211c8c128 (virt) @211c8c128 (dma) 0x35fb2401 - deq
2014-03-01T10:54:02.867392+01:00 vnas kernel: [  145.430002] xhci_hcd 0000:00:14.0: @ffff880211c8c130 (virt) @211c8c130 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:02.867394+01:00 vnas kernel: [  145.430005] xhci_hcd 0000:00:14.0: @ffff880211c8c134 (virt) @211c8c134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:02.867395+01:00 vnas kernel: [  145.430009] xhci_hcd 0000:00:14.0: @ffff880211c8c138 (virt) @211c8c138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:02.867418+01:00 vnas kernel: [  145.430013] xhci_hcd 0000:00:14.0: @ffff880211c8c13c (virt) @211c8c13c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:02.867419+01:00 vnas kernel: [  145.430019] xhci_hcd 0000:00:14.0: Cached old ring, 1 ring cached
2014-03-01T10:54:02.867421+01:00 vnas kernel: [  145.430022] xhci_hcd 0000:00:14.0: Cached old ring, 2 rings cached
2014-03-01T10:54:02.867422+01:00 vnas kernel: [  145.430026] xhci_hcd 0000:00:14.0: Cached old ring, 3 rings cached
2014-03-01T10:54:02.867424+01:00 vnas kernel: [  145.430029] xhci_hcd 0000:00:14.0: Cached old ring, 4 rings cached
2014-03-01T10:54:02.867425+01:00 vnas kernel: [  145.430214] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
2014-03-01T10:54:02.867427+01:00 vnas kernel: [  145.430219] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
2014-03-01T10:54:02.867428+01:00 vnas kernel: [  145.430222] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
2014-03-01T10:54:02.867429+01:00 vnas kernel: [  145.430226] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
2014-03-01T10:54:02.867431+01:00 vnas kernel: [  145.430481] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:02.867432+01:00 vnas kernel: [  145.430496] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 4 segments
2014-03-01T10:54:02.867434+01:00 vnas kernel: [  145.430525] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:02.867435+01:00 vnas kernel: [  145.430532] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 8 segments
2014-03-01T10:54:02.923705+01:00 vnas vdr: [2704] EPGSearch: timer conflict check started
2014-03-01T10:54:02.925092+01:00 vnas vdr: [2704] timer 1 (3 2100-2145 VPS 'Quarks & Co~Quarks & Co') set to event Die 11.03.2014 21:00-21:45 (VPS: 11.03. 21:00) 'Quarks & Co: Unkaputtbar - Die Magie neuer Materialien'
2014-03-01T10:54:02.925790+01:00 vnas vdr: [2704] timer 1 (1 2100-2145 VPS 'In aller Freundschaft~In aller Freundschaft') set to event Die 04.03.2014 21:00-21:45 (VPS: 04.03. 21:00) 'In aller Freundschaft (634)'
2014-03-01T10:54:02.927098+01:00 vnas kernel: [  145.489744] drxk: Error -22 on get_lock_status
2014-03-01T10:54:02.926463+01:00 vnas vdr: [2704] timer 1 (1 2100-2145 VPS 'In aller Freundschaft~In aller Freundschaft') set to event Die 04.03.2014 21:00-21:45 (VPS: 04.03. 21:00) 'In aller Freundschaft (634)'
2014-03-01T10:54:02.927175+01:00 vnas vdr: [2704] timer 1 (1 1850-1920 VPS 'LindenstraÃe~LindenstraÃe') set to event Son 02.03.2014 18:50-19:20 (VPS: 02.03. 18:50) 'LindenstraÃe (1470)'
2014-03-01T10:54:02.928018+01:00 vnas vdr: [2704] timer 1 (1 1850-1920 VPS 'LindenstraÃe~LindenstraÃe') set to event Son 02.03.2014 18:50-19:20 (VPS: 02.03. 18:50) 'LindenstraÃe (1470)'
2014-03-01T10:54:02.928578+01:00 vnas vdr: [2704] EPGSearch: timer conflict check finished
2014-03-01T10:54:02.929250+01:00 vnas vdr: [2703] EPGSearch: search timer update started
2014-03-01T10:54:02.931949+01:00 vnas vdr: [2703] EPGSearch: search timer update finished
2014-03-01T10:54:03.028885+01:00 vnas kernel: [  145.592169] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:03.028925+01:00 vnas kernel: [  145.592185] xhci_hcd 0000:00:14.0: Giveback URB ffff880210daa600, len = 10, expected = 512, status = -121
2014-03-01T10:54:03.203990+01:00 vnas vdr: [2684] channel 1 (Das Erste HD) event Sam 01.03.2014 10:00-11:20 (VPS: 01.03. 10:00) 'Sportschau live' status 4
2014-03-01T10:54:03.423137+01:00 vnas kernel: [  145.985778] drxk: Error -22 on get_lock_status
2014-03-01T10:54:03.429665+01:00 vnas kernel: [  145.992613] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:03.429706+01:00 vnas kernel: [  145.992630] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963600, len = 10, expected = 512, status = -121
2014-03-01T10:54:03.434927+01:00 vnas vdr: [2701] XVDR: Starting garbage collection in recordings cache
2014-03-01T10:54:03.490180+01:00 vnas vdr: [2678] max. latency time 1 seconds
2014-03-01T10:54:03.830448+01:00 vnas kernel: [  146.393048] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:03.830494+01:00 vnas kernel: [  146.393065] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:03.938179+01:00 vnas kernel: [  146.500057] drxk: Error -22 on get_lock_status
2014-03-01T10:54:04.231237+01:00 vnas kernel: [  146.793517] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:04.231277+01:00 vnas kernel: [  146.793533] xhci_hcd 0000:00:14.0: Giveback URB ffff8802109630c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:04.434130+01:00 vnas kernel: [  146.996256] drxk: Error -22 on get_lock_status
2014-03-01T10:54:04.631999+01:00 vnas kernel: [  147.193950] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:04.632042+01:00 vnas kernel: [  147.193967] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963180, len = 10, expected = 512, status = -121
2014-03-01T10:54:04.949133+01:00 vnas kernel: [  147.510570] drxk: Error -22 on get_lock_status
2014-03-01T10:54:05.033408+01:00 vnas kernel: [  147.595038] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:05.033456+01:00 vnas kernel: [  147.595054] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:05.434203+01:00 vnas kernel: [  147.995488] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:05.434251+01:00 vnas kernel: [  147.995504] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963b40, len = 10, expected = 512, status = -121
2014-03-01T10:54:05.446132+01:00 vnas kernel: [  148.006761] drxk: Error -22 on get_lock_status
2014-03-01T10:54:05.834943+01:00 vnas kernel: [  148.395882] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:05.834984+01:00 vnas kernel: [  148.395898] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:05.961141+01:00 vnas kernel: [  148.521177] drxk: Error -22 on get_lock_status
2014-03-01T10:54:06.235778+01:00 vnas kernel: [  148.796391] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:06.235806+01:00 vnas kernel: [  148.796410] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997d80, len = 10, expected = 512, status = -121
2014-03-01T10:54:06.457144+01:00 vnas kernel: [  149.017189] drxk: Error -22 on get_lock_status
2014-03-01T10:54:06.637157+01:00 vnas kernel: [  149.197422] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:06.637195+01:00 vnas kernel: [  149.197439] xhci_hcd 0000:00:14.0: Giveback URB ffff8802109630c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:06.972138+01:00 vnas kernel: [  149.531754] drxk: Error -22 on get_lock_status
2014-03-01T10:54:07.037929+01:00 vnas kernel: [  149.597864] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:07.037966+01:00 vnas kernel: [  149.597880] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:07.438719+01:00 vnas kernel: [  149.998317] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:07.438759+01:00 vnas kernel: [  149.998333] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963c00, len = 10, expected = 512, status = -121
2014-03-01T10:54:07.468112+01:00 vnas kernel: [  150.027537] drxk: Error -22 on get_lock_status
2014-03-01T10:54:07.839478+01:00 vnas kernel: [  150.398740] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:07.839515+01:00 vnas kernel: [  150.398757] xhci_hcd 0000:00:14.0: Giveback URB ffff8802109630c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:07.983120+01:00 vnas kernel: [  150.542091] drxk: Error -22 on get_lock_status
2014-03-01T10:54:08.240247+01:00 vnas kernel: [  150.799186] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:08.240296+01:00 vnas kernel: [  150.799202] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963b40, len = 10, expected = 512, status = -121
2014-03-01T10:54:08.480120+01:00 vnas kernel: [  151.037958] drxk: Error -22 on get_lock_status
2014-03-01T10:54:08.641051+01:00 vnas kernel: [  151.199642] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:08.641111+01:00 vnas kernel: [  151.199659] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963b40, len = 10, expected = 512, status = -121
2014-03-01T10:54:08.995168+01:00 vnas kernel: [  151.552526] drxk: Error -22 on get_lock_status
2014-03-01T10:54:09.041836+01:00 vnas kernel: [  151.600082] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:09.041882+01:00 vnas kernel: [  151.600099] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963c00, len = 10, expected = 512, status = -121
2014-03-01T10:54:09.442586+01:00 vnas kernel: [  152.000501] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:09.442629+01:00 vnas kernel: [  152.000517] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:09.491123+01:00 vnas kernel: [  152.048769] drxk: Error -22 on get_lock_status
2014-03-01T10:54:09.843323+01:00 vnas kernel: [  152.400902] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:09.843364+01:00 vnas kernel: [  152.400921] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997540, len = 10, expected = 512, status = -121
2014-03-01T10:54:10.006112+01:00 vnas kernel: [  152.563151] drxk: Error -22 on get_lock_status
2014-03-01T10:54:10.244122+01:00 vnas kernel: [  152.801384] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:10.244171+01:00 vnas kernel: [  152.801407] xhci_hcd 0000:00:14.0: Giveback URB ffff8800359973c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:10.503123+01:00 vnas kernel: [  153.059232] drxk: Error -22 on get_lock_status
2014-03-01T10:54:10.644961+01:00 vnas kernel: [  153.201885] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:10.645017+01:00 vnas kernel: [  153.201900] xhci_hcd 0000:00:14.0: Giveback URB ffff880210961f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:11.017124+01:00 vnas kernel: [  153.573570] drxk: Error -22 on get_lock_status
2014-03-01T10:54:11.045723+01:00 vnas kernel: [  153.602302] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:11.045761+01:00 vnas kernel: [  153.602319] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963600, len = 10, expected = 512, status = -121
2014-03-01T10:54:11.446489+01:00 vnas kernel: [  154.002736] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:11.446528+01:00 vnas kernel: [  154.002752] xhci_hcd 0000:00:14.0: Giveback URB ffff880210963f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:11.514127+01:00 vnas kernel: [  154.069554] drxk: Error -22 on get_lock_status
2014-03-01T10:54:11.847273+01:00 vnas kernel: [  154.403184] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:11.847313+01:00 vnas kernel: [  154.403200] xhci_hcd 0000:00:14.0: Giveback URB ffff880211cac480, len = 10, expected = 512, status = -121
2014-03-01T10:54:12.028142+01:00 vnas kernel: [  154.583915] drxk: Error -22 on get_lock_status
2014-03-01T10:54:12.248104+01:00 vnas kernel: [  154.803664] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:12.248145+01:00 vnas kernel: [  154.803681] xhci_hcd 0000:00:14.0: Giveback URB ffff880211cacc00, len = 10, expected = 512, status = -121
2014-03-01T10:54:12.525121+01:00 vnas kernel: [  155.079994] drxk: Error -22 on get_lock_status
2014-03-01T10:54:12.648870+01:00 vnas kernel: [  155.204110] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:12.648913+01:00 vnas kernel: [  155.204127] xhci_hcd 0000:00:14.0: Giveback URB ffff880211cac240, len = 10, expected = 512, status = -121
2014-03-01T10:54:13.040130+01:00 vnas kernel: [  155.594422] drxk: Error -22 on get_lock_status
2014-03-01T10:54:13.049632+01:00 vnas kernel: [  155.604538] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:13.049671+01:00 vnas kernel: [  155.604554] xhci_hcd 0000:00:14.0: Giveback URB ffff88021096e9c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:13.450388+01:00 vnas kernel: [  156.004957] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:13.450425+01:00 vnas kernel: [  156.004974] xhci_hcd 0000:00:14.0: Giveback URB ffff88021096e9c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:13.536129+01:00 vnas kernel: [  156.090348] drxk: Error -22 on get_lock_status
2014-03-01T10:54:13.605477+01:00 vnas vdr: [2678] connect from 127.0.0.1, port 36535 - accepted
2014-03-01T10:54:13.647154+01:00 vnas vdr: [2678] closing SVDRP connection
2014-03-01T10:54:13.851116+01:00 vnas kernel: [  156.405384] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:13.851142+01:00 vnas kernel: [  156.405401] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04300, len = 10, expected = 512, status = -121
2014-03-01T10:54:14.051141+01:00 vnas kernel: [  156.604917] drxk: Error -22 on get_lock_status
2014-03-01T10:54:14.251855+01:00 vnas kernel: [  156.805745] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:14.251902+01:00 vnas kernel: [  156.805761] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997840, len = 10, expected = 512, status = -121
2014-03-01T10:54:14.547123+01:00 vnas kernel: [  157.100818] drxk: Error -22 on get_lock_status
2014-03-01T10:54:14.652596+01:00 vnas kernel: [  157.206155] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:14.652641+01:00 vnas kernel: [  157.206172] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04540, len = 10, expected = 512, status = -121
2014-03-01T10:54:15.053260+01:00 vnas kernel: [  157.606502] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:15.053310+01:00 vnas kernel: [  157.606526] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04300, len = 10, expected = 512, status = -121
2014-03-01T10:54:15.063139+01:00 vnas kernel: [  157.615489] drxk: Error -22 on get_lock_status
2014-03-01T10:54:15.454044+01:00 vnas kernel: [  158.006947] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:15.454100+01:00 vnas kernel: [  158.006961] xhci_hcd 0000:00:14.0: Giveback URB ffff880210961f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:15.559115+01:00 vnas kernel: [  158.111545] drxk: Error -22 on get_lock_status
2014-03-01T10:54:15.854833+01:00 vnas kernel: [  158.407398] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:15.854875+01:00 vnas kernel: [  158.407413] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04f00, len = 10, expected = 512, status = -121
2014-03-01T10:54:16.074159+01:00 vnas kernel: [  158.625919] drxk: Error -22 on get_lock_status
2014-03-01T10:54:16.255601+01:00 vnas kernel: [  158.807826] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:16.255642+01:00 vnas kernel: [  158.807842] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04600, len = 10, expected = 512, status = -121
2014-03-01T10:54:16.570143+01:00 vnas kernel: [  159.121872] drxk: Error -22 on get_lock_status
2014-03-01T10:54:16.656379+01:00 vnas kernel: [  159.208261] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:16.656424+01:00 vnas kernel: [  159.208277] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04540, len = 10, expected = 512, status = -121
2014-03-01T10:54:17.057137+01:00 vnas kernel: [  159.608682] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:17.057184+01:00 vnas kernel: [  159.608698] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d049c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:17.085133+01:00 vnas kernel: [  159.636350] drxk: Error -22 on get_lock_status
2014-03-01T10:54:17.457903+01:00 vnas kernel: [  160.009122] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:17.457942+01:00 vnas kernel: [  160.009138] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04000, len = 10, expected = 512, status = -121
2014-03-01T10:54:17.582134+01:00 vnas kernel: [  160.132678] drxk: Error -22 on get_lock_status
2014-03-01T10:54:17.858644+01:00 vnas kernel: [  160.409539] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:17.858695+01:00 vnas kernel: [  160.409555] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04300, len = 10, expected = 512, status = -121
2014-03-01T10:54:18.096108+01:00 vnas kernel: [  160.646796] drxk: Error -22 on get_lock_status
2014-03-01T10:54:18.259409+01:00 vnas kernel: [  160.809958] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:18.259447+01:00 vnas kernel: [  160.809974] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997540, len = 10, expected = 512, status = -121
2014-03-01T10:54:18.593145+01:00 vnas kernel: [  161.143256] drxk: Error -22 on get_lock_status
2014-03-01T10:54:18.660198+01:00 vnas kernel: [  161.210413] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:18.660241+01:00 vnas kernel: [  161.210428] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997d80, len = 10, expected = 512, status = -121
2014-03-01T10:54:19.061601+01:00 vnas kernel: [  161.611493] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:19.061629+01:00 vnas kernel: [  161.611510] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04300, len = 10, expected = 512, status = -121
2014-03-01T10:54:19.108176+01:00 vnas kernel: [  161.657167] drxk: Error -22 on get_lock_status
2014-03-01T10:54:19.463007+01:00 vnas kernel: [  162.012546] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:19.463053+01:00 vnas kernel: [  162.012562] xhci_hcd 0000:00:14.0: Giveback URB ffff880035997600, len = 10, expected = 512, status = -121
2014-03-01T10:54:19.605138+01:00 vnas kernel: [  162.153724] drxk: Error -22 on get_lock_status
2014-03-01T10:54:19.671142+01:00 vnas kernel: [  162.220048] drxk: Error -22 on get_lock_status
2014-03-01T10:54:19.671211+01:00 vnas kernel: [  162.220053] drxk: Error -22 on get_lock_status
2014-03-01T10:54:19.675194+01:00 vnas kernel: [  162.224525] xhci_hcd 0000:00:14.0: Cancel URB ffff880035e77000, dev 1.2, ep 0x84, starting at offset 0xcf2c11a0
2014-03-01T10:54:19.675233+01:00 vnas kernel: [  162.224543] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.675238+01:00 vnas kernel: [  162.224576] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
2014-03-01T10:54:19.675241+01:00 vnas kernel: [  162.224594] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11a0 (dma).
2014-03-01T10:54:19.675243+01:00 vnas kernel: [  162.224604] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11a0
2014-03-01T10:54:19.675249+01:00 vnas kernel: [  162.224610] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11b0 (dma).
2014-03-01T10:54:19.675257+01:00 vnas kernel: [  162.224618] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11b0
2014-03-01T10:54:19.675265+01:00 vnas kernel: [  162.224635] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11c0 (dma).
2014-03-01T10:54:19.675336+01:00 vnas kernel: [  162.224662] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11c0
2014-03-01T10:54:19.675338+01:00 vnas kernel: [  162.224668] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11d0 (dma).
2014-03-01T10:54:19.675341+01:00 vnas kernel: [  162.224677] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11d0
2014-03-01T10:54:19.675344+01:00 vnas kernel: [  162.224685] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11e0 (dma).
2014-03-01T10:54:19.675346+01:00 vnas kernel: [  162.224694] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11e0
2014-03-01T10:54:19.675349+01:00 vnas kernel: [  162.224702] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c11f0 (dma).
2014-03-01T10:54:19.675351+01:00 vnas kernel: [  162.224708] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c11f0
2014-03-01T10:54:19.675354+01:00 vnas kernel: [  162.224714] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1200 (dma).
2014-03-01T10:54:19.675356+01:00 vnas kernel: [  162.224720] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1200
2014-03-01T10:54:19.675359+01:00 vnas kernel: [  162.224727] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1210 (dma).
2014-03-01T10:54:19.675362+01:00 vnas kernel: [  162.224733] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1210
2014-03-01T10:54:19.675364+01:00 vnas kernel: [  162.224739] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1220 (dma).
2014-03-01T10:54:19.675367+01:00 vnas kernel: [  162.224746] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1220
2014-03-01T10:54:19.675369+01:00 vnas kernel: [  162.224752] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1230 (dma).
2014-03-01T10:54:19.675372+01:00 vnas kernel: [  162.224764] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1230
2014-03-01T10:54:19.675374+01:00 vnas kernel: [  162.224781] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1240 (dma).
2014-03-01T10:54:19.675377+01:00 vnas kernel: [  162.224796] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1240
2014-03-01T10:54:19.675379+01:00 vnas kernel: [  162.224812] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1250 (dma).
2014-03-01T10:54:19.675416+01:00 vnas kernel: [  162.224822] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1250
2014-03-01T10:54:19.675419+01:00 vnas kernel: [  162.224828] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1260 (dma).
2014-03-01T10:54:19.675421+01:00 vnas kernel: [  162.224835] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1260
2014-03-01T10:54:19.675424+01:00 vnas kernel: [  162.224842] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1270 (dma).
2014-03-01T10:54:19.675426+01:00 vnas kernel: [  162.224848] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1270
2014-03-01T10:54:19.675429+01:00 vnas kernel: [  162.224855] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1280 (dma).
2014-03-01T10:54:19.675431+01:00 vnas kernel: [  162.224862] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1280
2014-03-01T10:54:19.675434+01:00 vnas kernel: [  162.224869] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1290 (dma).
2014-03-01T10:54:19.675437+01:00 vnas kernel: [  162.224886] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1290
2014-03-01T10:54:19.675460+01:00 vnas kernel: [  162.224900] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12a0 (dma).
2014-03-01T10:54:19.675462+01:00 vnas kernel: [  162.224907] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12a0
2014-03-01T10:54:19.675465+01:00 vnas kernel: [  162.224913] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12b0 (dma).
2014-03-01T10:54:19.675467+01:00 vnas kernel: [  162.224920] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12b0
2014-03-01T10:54:19.675470+01:00 vnas kernel: [  162.224932] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12c0 (dma).
2014-03-01T10:54:19.675486+01:00 vnas kernel: [  162.224943] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12c0
2014-03-01T10:54:19.675489+01:00 vnas kernel: [  162.224950] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12d0 (dma).
2014-03-01T10:54:19.675533+01:00 vnas kernel: [  162.224956] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12d0
2014-03-01T10:54:19.675577+01:00 vnas kernel: [  162.224970] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12e0 (dma).
2014-03-01T10:54:19.675580+01:00 vnas kernel: [  162.224976] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12e0
2014-03-01T10:54:19.675583+01:00 vnas kernel: [  162.224982] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c12f0 (dma).
2014-03-01T10:54:19.675586+01:00 vnas kernel: [  162.224988] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c12f0
2014-03-01T10:54:19.675588+01:00 vnas kernel: [  162.224994] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1300 (dma).
2014-03-01T10:54:19.675591+01:00 vnas kernel: [  162.225000] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1300
2014-03-01T10:54:19.675594+01:00 vnas kernel: [  162.225006] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1310 (dma).
2014-03-01T10:54:19.675596+01:00 vnas kernel: [  162.225012] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1310
2014-03-01T10:54:19.675599+01:00 vnas kernel: [  162.225018] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1320 (dma).
2014-03-01T10:54:19.675602+01:00 vnas kernel: [  162.225030] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1320
2014-03-01T10:54:19.675604+01:00 vnas kernel: [  162.225047] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1330 (dma).
2014-03-01T10:54:19.675640+01:00 vnas kernel: [  162.225060] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1330
2014-03-01T10:54:19.675642+01:00 vnas kernel: [  162.225067] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1340 (dma).
2014-03-01T10:54:19.675645+01:00 vnas kernel: [  162.225073] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1340
2014-03-01T10:54:19.675647+01:00 vnas kernel: [  162.225080] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1350 (dma).
2014-03-01T10:54:19.675650+01:00 vnas kernel: [  162.225086] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1350
2014-03-01T10:54:19.675652+01:00 vnas kernel: [  162.225094] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1360 (dma).
2014-03-01T10:54:19.675655+01:00 vnas kernel: [  162.225117] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1360
2014-03-01T10:54:19.675676+01:00 vnas kernel: [  162.225126] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1370 (dma).
2014-03-01T10:54:19.675678+01:00 vnas kernel: [  162.225132] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1370
2014-03-01T10:54:19.675681+01:00 vnas kernel: [  162.225139] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1380 (dma).
2014-03-01T10:54:19.675683+01:00 vnas kernel: [  162.225151] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1380
2014-03-01T10:54:19.675695+01:00 vnas kernel: [  162.225160] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1390 (dma).
2014-03-01T10:54:19.675697+01:00 vnas kernel: [  162.225167] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1390
2014-03-01T10:54:19.675710+01:00 vnas kernel: [  162.225178] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c13a0 (dma).
2014-03-01T10:54:19.675712+01:00 vnas kernel: [  162.225187] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c13a0
2014-03-01T10:54:19.675721+01:00 vnas kernel: [  162.225196] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c13b0 (dma).
2014-03-01T10:54:19.675730+01:00 vnas kernel: [  162.225205] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c13b0
2014-03-01T10:54:19.675740+01:00 vnas kernel: [  162.225214] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c13c0 (dma).
2014-03-01T10:54:19.675749+01:00 vnas kernel: [  162.225223] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c13c0
2014-03-01T10:54:19.675758+01:00 vnas kernel: [  162.225232] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c13d0 (dma).
2014-03-01T10:54:19.675766+01:00 vnas kernel: [  162.225241] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c13d0
2014-03-01T10:54:19.675776+01:00 vnas kernel: [  162.225250] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c13e0 (dma).
2014-03-01T10:54:19.675784+01:00 vnas kernel: [  162.225259] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c13e0
2014-03-01T10:54:19.675794+01:00 vnas kernel: [  162.225268] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1400 (dma).
2014-03-01T10:54:19.675803+01:00 vnas kernel: [  162.225277] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1400
2014-03-01T10:54:19.675812+01:00 vnas kernel: [  162.225286] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1410 (dma).
2014-03-01T10:54:19.675820+01:00 vnas kernel: [  162.225295] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1410
2014-03-01T10:54:19.675829+01:00 vnas kernel: [  162.225304] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1420 (dma).
2014-03-01T10:54:19.675838+01:00 vnas kernel: [  162.225313] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1420
2014-03-01T10:54:19.675847+01:00 vnas kernel: [  162.225322] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1430 (dma).
2014-03-01T10:54:19.675856+01:00 vnas kernel: [  162.225331] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1430
2014-03-01T10:54:19.675866+01:00 vnas kernel: [  162.225340] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1440 (dma).
2014-03-01T10:54:19.675874+01:00 vnas kernel: [  162.225349] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1440
2014-03-01T10:54:19.675883+01:00 vnas kernel: [  162.225358] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1450 (dma).
2014-03-01T10:54:19.675892+01:00 vnas kernel: [  162.225367] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1450
2014-03-01T10:54:19.675901+01:00 vnas kernel: [  162.225376] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1460 (dma).
2014-03-01T10:54:19.675910+01:00 vnas kernel: [  162.225385] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1460
2014-03-01T10:54:19.675919+01:00 vnas kernel: [  162.225394] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1470 (dma).
2014-03-01T10:54:19.675929+01:00 vnas kernel: [  162.225403] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1470
2014-03-01T10:54:19.676267+01:00 vnas kernel: [  162.225415] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1480 (dma).
2014-03-01T10:54:19.676272+01:00 vnas kernel: [  162.225422] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1480
2014-03-01T10:54:19.676274+01:00 vnas kernel: [  162.225428] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1490 (dma).
2014-03-01T10:54:19.676276+01:00 vnas kernel: [  162.225434] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1490
2014-03-01T10:54:19.676277+01:00 vnas kernel: [  162.225440] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14a0 (dma).
2014-03-01T10:54:19.676278+01:00 vnas kernel: [  162.225445] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14a0
2014-03-01T10:54:19.676280+01:00 vnas kernel: [  162.225449] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14b0 (dma).
2014-03-01T10:54:19.676281+01:00 vnas kernel: [  162.225452] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14b0
2014-03-01T10:54:19.676283+01:00 vnas kernel: [  162.225456] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14c0 (dma).
2014-03-01T10:54:19.676284+01:00 vnas kernel: [  162.225460] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14c0
2014-03-01T10:54:19.676286+01:00 vnas kernel: [  162.225463] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14d0 (dma).
2014-03-01T10:54:19.676287+01:00 vnas kernel: [  162.225466] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14d0
2014-03-01T10:54:19.676289+01:00 vnas kernel: [  162.225470] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14e0 (dma).
2014-03-01T10:54:19.676290+01:00 vnas kernel: [  162.225473] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14e0
2014-03-01T10:54:19.676291+01:00 vnas kernel: [  162.225477] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c14f0 (dma).
2014-03-01T10:54:19.676293+01:00 vnas kernel: [  162.225480] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c14f0
2014-03-01T10:54:19.676294+01:00 vnas kernel: [  162.225483] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1500 (dma).
2014-03-01T10:54:19.676295+01:00 vnas kernel: [  162.225487] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1500
2014-03-01T10:54:19.676297+01:00 vnas kernel: [  162.225490] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1510 (dma).
2014-03-01T10:54:19.676299+01:00 vnas kernel: [  162.225494] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1510
2014-03-01T10:54:19.676300+01:00 vnas kernel: [  162.225497] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1520 (dma).
2014-03-01T10:54:19.676302+01:00 vnas kernel: [  162.225501] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1520
2014-03-01T10:54:19.676303+01:00 vnas kernel: [  162.225504] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1530 (dma).
2014-03-01T10:54:19.676304+01:00 vnas kernel: [  162.225507] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1530
2014-03-01T10:54:19.676306+01:00 vnas kernel: [  162.225511] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1540 (dma).
2014-03-01T10:54:19.676308+01:00 vnas kernel: [  162.225514] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1540
2014-03-01T10:54:19.676309+01:00 vnas kernel: [  162.225518] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1550 (dma).
2014-03-01T10:54:19.676311+01:00 vnas kernel: [  162.225521] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1550
2014-03-01T10:54:19.676312+01:00 vnas kernel: [  162.225525] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1560 (dma).
2014-03-01T10:54:19.676313+01:00 vnas kernel: [  162.225528] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1560
2014-03-01T10:54:19.676315+01:00 vnas kernel: [  162.225531] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1570 (dma).
2014-03-01T10:54:19.676316+01:00 vnas kernel: [  162.225535] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1570
2014-03-01T10:54:19.676318+01:00 vnas kernel: [  162.225538] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1580 (dma).
2014-03-01T10:54:19.676320+01:00 vnas kernel: [  162.225542] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1580
2014-03-01T10:54:19.676321+01:00 vnas kernel: [  162.225545] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1590 (dma).
2014-03-01T10:54:19.676322+01:00 vnas kernel: [  162.225549] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1590
2014-03-01T10:54:19.676324+01:00 vnas kernel: [  162.225552] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c15a0 (dma).
2014-03-01T10:54:19.676325+01:00 vnas kernel: [  162.225555] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c15a0
2014-03-01T10:54:19.676327+01:00 vnas kernel: [  162.225587] xhci_hcd 0000:00:14.0: Cancel URB ffff880035e73800, dev 1.2, ep 0x84, starting at offset 0xcf742570
2014-03-01T10:54:19.676328+01:00 vnas kernel: [  162.225597] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.676330+01:00 vnas kernel: [  162.225617] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
2014-03-01T10:54:19.676331+01:00 vnas kernel: [  162.225641] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742570 (dma).
2014-03-01T10:54:19.676333+01:00 vnas kernel: [  162.225657] xhci_hcd 0000:00:14.0: Finding endpoint context
2014-03-01T10:54:19.676334+01:00 vnas kernel: [  162.225672] xhci_hcd 0000:00:14.0: Finding segment containing last TRB in TD.
2014-03-01T10:54:19.676336+01:00 vnas kernel: [  162.225688] xhci_hcd 0000:00:14.0: Cycle state = 0x1
2014-03-01T10:54:19.676337+01:00 vnas kernel: [  162.225704] xhci_hcd 0000:00:14.0: New dequeue segment = ffff8800cf03bf60 (virtual)
2014-03-01T10:54:19.676339+01:00 vnas kernel: [  162.225719] xhci_hcd 0000:00:14.0: New dequeue pointer = 0xcf742580 (DMA)
2014-03-01T10:54:19.676340+01:00 vnas kernel: [  162.225734] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742580 (dma).
2014-03-01T10:54:19.676386+01:00 vnas kernel: [  162.225747] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742580
2014-03-01T10:54:19.676387+01:00 vnas kernel: [  162.225754] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742590 (dma).
2014-03-01T10:54:19.676389+01:00 vnas kernel: [  162.225760] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742590
2014-03-01T10:54:19.676390+01:00 vnas kernel: [  162.225767] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425a0 (dma).
2014-03-01T10:54:19.676391+01:00 vnas kernel: [  162.225773] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425a0
2014-03-01T10:54:19.676393+01:00 vnas kernel: [  162.225780] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425b0 (dma).
2014-03-01T10:54:19.676394+01:00 vnas kernel: [  162.225786] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425b0
2014-03-01T10:54:19.676396+01:00 vnas kernel: [  162.225793] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425c0 (dma).
2014-03-01T10:54:19.676397+01:00 vnas kernel: [  162.225799] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425c0
2014-03-01T10:54:19.676399+01:00 vnas kernel: [  162.225806] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425d0 (dma).
2014-03-01T10:54:19.676400+01:00 vnas kernel: [  162.225812] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425d0
2014-03-01T10:54:19.676402+01:00 vnas kernel: [  162.225819] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425e0 (dma).
2014-03-01T10:54:19.676403+01:00 vnas kernel: [  162.225825] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425e0
2014-03-01T10:54:19.676404+01:00 vnas kernel: [  162.225841] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7425f0 (dma).
2014-03-01T10:54:19.676406+01:00 vnas kernel: [  162.225857] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7425f0
2014-03-01T10:54:19.676420+01:00 vnas kernel: [  162.225870] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742600 (dma).
2014-03-01T10:54:19.676422+01:00 vnas kernel: [  162.225876] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742600
2014-03-01T10:54:19.676423+01:00 vnas kernel: [  162.225883] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742610 (dma).
2014-03-01T10:54:19.676425+01:00 vnas kernel: [  162.225889] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742610
2014-03-01T10:54:19.676436+01:00 vnas kernel: [  162.225904] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742620 (dma).
2014-03-01T10:54:19.676437+01:00 vnas kernel: [  162.225912] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742620
2014-03-01T10:54:19.677496+01:00 vnas kernel: [  162.225922] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742630 (dma).
2014-03-01T10:54:19.677508+01:00 vnas kernel: [  162.225929] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742630
2014-03-01T10:54:19.677551+01:00 vnas kernel: [  162.225935] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742640 (dma).
2014-03-01T10:54:19.677554+01:00 vnas kernel: [  162.225941] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742640
2014-03-01T10:54:19.677556+01:00 vnas kernel: [  162.225948] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742650 (dma).
2014-03-01T10:54:19.677558+01:00 vnas kernel: [  162.225954] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742650
2014-03-01T10:54:19.677560+01:00 vnas kernel: [  162.225961] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742660 (dma).
2014-03-01T10:54:19.677562+01:00 vnas kernel: [  162.225967] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742660
2014-03-01T10:54:19.677564+01:00 vnas kernel: [  162.225974] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742670 (dma).
2014-03-01T10:54:19.677567+01:00 vnas kernel: [  162.225980] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742670
2014-03-01T10:54:19.677569+01:00 vnas kernel: [  162.225986] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742680 (dma).
2014-03-01T10:54:19.677571+01:00 vnas kernel: [  162.225993] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742680
2014-03-01T10:54:19.677574+01:00 vnas kernel: [  162.225999] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742690 (dma).
2014-03-01T10:54:19.677576+01:00 vnas kernel: [  162.226005] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742690
2014-03-01T10:54:19.677578+01:00 vnas kernel: [  162.226012] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426a0 (dma).
2014-03-01T10:54:19.677581+01:00 vnas kernel: [  162.226018] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426a0
2014-03-01T10:54:19.677583+01:00 vnas kernel: [  162.226025] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426b0 (dma).
2014-03-01T10:54:19.677585+01:00 vnas kernel: [  162.226031] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426b0
2014-03-01T10:54:19.677587+01:00 vnas kernel: [  162.226037] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426c0 (dma).
2014-03-01T10:54:19.677589+01:00 vnas kernel: [  162.226044] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426c0
2014-03-01T10:54:19.677591+01:00 vnas kernel: [  162.226050] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426d0 (dma).
2014-03-01T10:54:19.677593+01:00 vnas kernel: [  162.226056] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426d0
2014-03-01T10:54:19.677596+01:00 vnas kernel: [  162.226063] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426e0 (dma).
2014-03-01T10:54:19.677598+01:00 vnas kernel: [  162.226069] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426e0
2014-03-01T10:54:19.677600+01:00 vnas kernel: [  162.226075] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7426f0 (dma).
2014-03-01T10:54:19.677602+01:00 vnas kernel: [  162.226081] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7426f0
2014-03-01T10:54:19.677604+01:00 vnas kernel: [  162.226088] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742700 (dma).
2014-03-01T10:54:19.677606+01:00 vnas kernel: [  162.226094] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742700
2014-03-01T10:54:19.677608+01:00 vnas kernel: [  162.226101] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742710 (dma).
2014-03-01T10:54:19.677610+01:00 vnas kernel: [  162.226107] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742710
2014-03-01T10:54:19.677613+01:00 vnas kernel: [  162.226113] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742720 (dma).
2014-03-01T10:54:19.677615+01:00 vnas kernel: [  162.226120] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742720
2014-03-01T10:54:19.677617+01:00 vnas kernel: [  162.226126] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742730 (dma).
2014-03-01T10:54:19.677619+01:00 vnas kernel: [  162.226132] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742730
2014-03-01T10:54:19.677621+01:00 vnas kernel: [  162.226138] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742740 (dma).
2014-03-01T10:54:19.677623+01:00 vnas kernel: [  162.226145] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742740
2014-03-01T10:54:19.677625+01:00 vnas kernel: [  162.226151] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742750 (dma).
2014-03-01T10:54:19.677627+01:00 vnas kernel: [  162.226158] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742750
2014-03-01T10:54:19.677629+01:00 vnas kernel: [  162.226164] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742760 (dma).
2014-03-01T10:54:19.677631+01:00 vnas kernel: [  162.226170] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742760
2014-03-01T10:54:19.677634+01:00 vnas kernel: [  162.226177] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742770 (dma).
2014-03-01T10:54:19.677636+01:00 vnas kernel: [  162.226183] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742770
2014-03-01T10:54:19.677638+01:00 vnas kernel: [  162.226189] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742780 (dma).
2014-03-01T10:54:19.677640+01:00 vnas kernel: [  162.226196] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742780
2014-03-01T10:54:19.677642+01:00 vnas kernel: [  162.226202] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742790 (dma).
2014-03-01T10:54:19.677644+01:00 vnas kernel: [  162.226208] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742790
2014-03-01T10:54:19.677646+01:00 vnas kernel: [  162.226215] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7427a0 (dma).
2014-03-01T10:54:19.677649+01:00 vnas kernel: [  162.226221] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7427a0
2014-03-01T10:54:19.677651+01:00 vnas kernel: [  162.226228] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7427b0 (dma).
2014-03-01T10:54:19.677653+01:00 vnas kernel: [  162.226234] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7427b0
2014-03-01T10:54:19.677655+01:00 vnas kernel: [  162.226241] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7427c0 (dma).
2014-03-01T10:54:19.677657+01:00 vnas kernel: [  162.226247] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7427c0
2014-03-01T10:54:19.677660+01:00 vnas kernel: [  162.226253] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7427d0 (dma).
2014-03-01T10:54:19.677662+01:00 vnas kernel: [  162.226260] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7427d0
2014-03-01T10:54:19.677664+01:00 vnas kernel: [  162.226266] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7427e0 (dma).
2014-03-01T10:54:19.677666+01:00 vnas kernel: [  162.226273] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7427e0
2014-03-01T10:54:19.677668+01:00 vnas kernel: [  162.226279] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742800 (dma).
2014-03-01T10:54:19.677671+01:00 vnas kernel: [  162.226285] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742800
2014-03-01T10:54:19.677673+01:00 vnas kernel: [  162.226292] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742810 (dma).
2014-03-01T10:54:19.677675+01:00 vnas kernel: [  162.226298] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742810
2014-03-01T10:54:19.677677+01:00 vnas kernel: [  162.226304] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742820 (dma).
2014-03-01T10:54:19.677679+01:00 vnas kernel: [  162.226310] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742820
2014-03-01T10:54:19.677681+01:00 vnas kernel: [  162.226317] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742830 (dma).
2014-03-01T10:54:19.677684+01:00 vnas kernel: [  162.226323] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742830
2014-03-01T10:54:19.677687+01:00 vnas kernel: [  162.226329] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742840 (dma).
2014-03-01T10:54:19.677689+01:00 vnas kernel: [  162.226336] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742840
2014-03-01T10:54:19.677691+01:00 vnas kernel: [  162.226342] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742850 (dma).
2014-03-01T10:54:19.677693+01:00 vnas kernel: [  162.226348] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742850
2014-03-01T10:54:19.677695+01:00 vnas kernel: [  162.226354] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742860 (dma).
2014-03-01T10:54:19.677697+01:00 vnas kernel: [  162.226361] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742860
2014-03-01T10:54:19.677699+01:00 vnas kernel: [  162.226368] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742870 (dma).
2014-03-01T10:54:19.677701+01:00 vnas kernel: [  162.226374] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742870
2014-03-01T10:54:19.677703+01:00 vnas kernel: [  162.226381] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742880 (dma).
2014-03-01T10:54:19.677706+01:00 vnas kernel: [  162.226387] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742880
2014-03-01T10:54:19.677708+01:00 vnas kernel: [  162.226394] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742890 (dma).
2014-03-01T10:54:19.677710+01:00 vnas kernel: [  162.226400] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742890
2014-03-01T10:54:19.677712+01:00 vnas kernel: [  162.226407] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428a0 (dma).
2014-03-01T10:54:19.677714+01:00 vnas kernel: [  162.226414] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428a0
2014-03-01T10:54:19.677716+01:00 vnas kernel: [  162.226420] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428b0 (dma).
2014-03-01T10:54:19.677718+01:00 vnas kernel: [  162.226427] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428b0
2014-03-01T10:54:19.677720+01:00 vnas kernel: [  162.226433] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428c0 (dma).
2014-03-01T10:54:19.677722+01:00 vnas kernel: [  162.226440] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428c0
2014-03-01T10:54:19.677725+01:00 vnas kernel: [  162.226446] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428d0 (dma).
2014-03-01T10:54:19.677727+01:00 vnas kernel: [  162.226453] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428d0
2014-03-01T10:54:19.677729+01:00 vnas kernel: [  162.226459] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428e0 (dma).
2014-03-01T10:54:19.677731+01:00 vnas kernel: [  162.226465] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428e0
2014-03-01T10:54:19.677733+01:00 vnas kernel: [  162.226472] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7428f0 (dma).
2014-03-01T10:54:19.677735+01:00 vnas kernel: [  162.226478] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7428f0
2014-03-01T10:54:19.677737+01:00 vnas kernel: [  162.226485] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742900 (dma).
2014-03-01T10:54:19.677739+01:00 vnas kernel: [  162.226492] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742900
2014-03-01T10:54:19.677742+01:00 vnas kernel: [  162.226498] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742910 (dma).
2014-03-01T10:54:19.677744+01:00 vnas kernel: [  162.226504] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742910
2014-03-01T10:54:19.677746+01:00 vnas kernel: [  162.226511] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742920 (dma).
2014-03-01T10:54:19.677748+01:00 vnas kernel: [  162.226517] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742920
2014-03-01T10:54:19.677750+01:00 vnas kernel: [  162.226524] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742930 (dma).
2014-03-01T10:54:19.677752+01:00 vnas kernel: [  162.226531] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742930
2014-03-01T10:54:19.677754+01:00 vnas kernel: [  162.226538] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742940 (dma).
2014-03-01T10:54:19.678104+01:00 vnas kernel: [  162.226543] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742940
2014-03-01T10:54:19.678106+01:00 vnas kernel: [  162.226549] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742950 (dma).
2014-03-01T10:54:19.678108+01:00 vnas kernel: [  162.226555] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742950
2014-03-01T10:54:19.678110+01:00 vnas kernel: [  162.226561] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742960 (dma).
2014-03-01T10:54:19.678112+01:00 vnas kernel: [  162.226568] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742960
2014-03-01T10:54:19.678115+01:00 vnas kernel: [  162.226578] xhci_hcd 0000:00:14.0: Set TR Deq Ptr cmd, new deq seg = ffff8800cf03bf60 (0xcf742400 dma), new deq ptr = ffff8800cf742580 (0xcf742580 dma), new cycle = 1
2014-03-01T10:54:19.678118+01:00 vnas kernel: [  162.226585] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.678120+01:00 vnas kernel: [  162.226610] xhci_hcd 0000:00:14.0: Successful Set TR Deq Ptr cmd, deq = @cf742581
2014-03-01T10:54:19.678122+01:00 vnas kernel: [  162.226640] xhci_hcd 0000:00:14.0: Cancel URB ffff880035e76000, dev 1.2, ep 0x84, starting at offset 0xcf742970
2014-03-01T10:54:19.678125+01:00 vnas kernel: [  162.226662] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.678127+01:00 vnas kernel: [  162.226695] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
2014-03-01T10:54:19.678129+01:00 vnas kernel: [  162.226714] xhci_hcd 0000:00:14.0: event_trb is a no-op TRB. Skip it
2014-03-01T10:54:19.678131+01:00 vnas kernel: [  162.226733] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742970 (dma).
2014-03-01T10:54:19.678133+01:00 vnas kernel: [  162.226753] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742970
2014-03-01T10:54:19.678135+01:00 vnas kernel: [  162.226772] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742980 (dma).
2014-03-01T10:54:19.678137+01:00 vnas kernel: [  162.226791] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742980
2014-03-01T10:54:19.678139+01:00 vnas kernel: [  162.226810] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742990 (dma).
2014-03-01T10:54:19.678141+01:00 vnas kernel: [  162.226829] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742990
2014-03-01T10:54:19.678143+01:00 vnas kernel: [  162.226849] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429a0 (dma).
2014-03-01T10:54:19.678146+01:00 vnas kernel: [  162.226868] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429a0
2014-03-01T10:54:19.678148+01:00 vnas kernel: [  162.226887] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429b0 (dma).
2014-03-01T10:54:19.678150+01:00 vnas kernel: [  162.226906] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429b0
2014-03-01T10:54:19.678152+01:00 vnas kernel: [  162.226926] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429c0 (dma).
2014-03-01T10:54:19.678154+01:00 vnas kernel: [  162.226945] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429c0
2014-03-01T10:54:19.678156+01:00 vnas kernel: [  162.226965] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429d0 (dma).
2014-03-01T10:54:19.678158+01:00 vnas kernel: [  162.226974] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429d0
2014-03-01T10:54:19.678160+01:00 vnas kernel: [  162.226981] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429e0 (dma).
2014-03-01T10:54:19.678199+01:00 vnas kernel: [  162.226987] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429e0
2014-03-01T10:54:19.678202+01:00 vnas kernel: [  162.226994] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf7429f0 (dma).
2014-03-01T10:54:19.678204+01:00 vnas kernel: [  162.227001] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf7429f0
2014-03-01T10:54:19.678206+01:00 vnas kernel: [  162.227007] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a00 (dma).
2014-03-01T10:54:19.678209+01:00 vnas kernel: [  162.227013] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a00
2014-03-01T10:54:19.678211+01:00 vnas kernel: [  162.227019] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a10 (dma).
2014-03-01T10:54:19.678213+01:00 vnas kernel: [  162.227025] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a10
2014-03-01T10:54:19.678216+01:00 vnas kernel: [  162.227032] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a20 (dma).
2014-03-01T10:54:19.678218+01:00 vnas kernel: [  162.227039] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a20
2014-03-01T10:54:19.678220+01:00 vnas kernel: [  162.227046] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a30 (dma).
2014-03-01T10:54:19.678223+01:00 vnas kernel: [  162.227053] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a30
2014-03-01T10:54:19.678225+01:00 vnas kernel: [  162.227060] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a40 (dma).
2014-03-01T10:54:19.678228+01:00 vnas kernel: [  162.227066] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a40
2014-03-01T10:54:19.678230+01:00 vnas kernel: [  162.227073] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a50 (dma).
2014-03-01T10:54:19.678232+01:00 vnas kernel: [  162.227080] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a50
2014-03-01T10:54:19.678234+01:00 vnas kernel: [  162.227087] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a60 (dma).
2014-03-01T10:54:19.678236+01:00 vnas kernel: [  162.227093] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a60
2014-03-01T10:54:19.678238+01:00 vnas kernel: [  162.227100] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a70 (dma).
2014-03-01T10:54:19.678240+01:00 vnas kernel: [  162.227106] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a70
2014-03-01T10:54:19.678243+01:00 vnas kernel: [  162.227113] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a80 (dma).
2014-03-01T10:54:19.678245+01:00 vnas kernel: [  162.227120] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a80
2014-03-01T10:54:19.678247+01:00 vnas kernel: [  162.227126] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742a90 (dma).
2014-03-01T10:54:19.678249+01:00 vnas kernel: [  162.227133] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742a90
2014-03-01T10:54:19.678251+01:00 vnas kernel: [  162.227139] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742aa0 (dma).
2014-03-01T10:54:19.678253+01:00 vnas kernel: [  162.227146] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742aa0
2014-03-01T10:54:19.678256+01:00 vnas kernel: [  162.227152] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742ab0 (dma).
2014-03-01T10:54:19.678258+01:00 vnas kernel: [  162.227159] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742ab0
2014-03-01T10:54:19.678260+01:00 vnas kernel: [  162.227165] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742ac0 (dma).
2014-03-01T10:54:19.678262+01:00 vnas kernel: [  162.227172] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742ac0
2014-03-01T10:54:19.678264+01:00 vnas kernel: [  162.227179] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742ad0 (dma).
2014-03-01T10:54:19.678267+01:00 vnas kernel: [  162.227185] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742ad0
2014-03-01T10:54:19.678269+01:00 vnas kernel: [  162.227192] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742ae0 (dma).
2014-03-01T10:54:19.678271+01:00 vnas kernel: [  162.227198] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742ae0
2014-03-01T10:54:19.678274+01:00 vnas kernel: [  162.227205] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742af0 (dma).
2014-03-01T10:54:19.678276+01:00 vnas kernel: [  162.227211] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742af0
2014-03-01T10:54:19.678278+01:00 vnas kernel: [  162.227217] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b00 (dma).
2014-03-01T10:54:19.678280+01:00 vnas kernel: [  162.227224] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b00
2014-03-01T10:54:19.678282+01:00 vnas kernel: [  162.227231] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b10 (dma).
2014-03-01T10:54:19.678284+01:00 vnas kernel: [  162.227237] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b10
2014-03-01T10:54:19.678286+01:00 vnas kernel: [  162.227251] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b20 (dma).
2014-03-01T10:54:19.678289+01:00 vnas kernel: [  162.227271] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b20
2014-03-01T10:54:19.678291+01:00 vnas kernel: [  162.227290] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b30 (dma).
2014-03-01T10:54:19.678293+01:00 vnas kernel: [  162.227310] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b30
2014-03-01T10:54:19.678295+01:00 vnas kernel: [  162.227329] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b40 (dma).
2014-03-01T10:54:19.678297+01:00 vnas kernel: [  162.227349] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b40
2014-03-01T10:54:19.678299+01:00 vnas kernel: [  162.227369] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b50 (dma).
2014-03-01T10:54:19.678301+01:00 vnas kernel: [  162.227388] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b50
2014-03-01T10:54:19.678303+01:00 vnas kernel: [  162.227407] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b60 (dma).
2014-03-01T10:54:19.678305+01:00 vnas kernel: [  162.227426] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b60
2014-03-01T10:54:19.678308+01:00 vnas kernel: [  162.227446] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b70 (dma).
2014-03-01T10:54:19.678310+01:00 vnas kernel: [  162.227465] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b70
2014-03-01T10:54:19.678312+01:00 vnas kernel: [  162.227484] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b80 (dma).
2014-03-01T10:54:19.678314+01:00 vnas kernel: [  162.227503] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b80
2014-03-01T10:54:19.678316+01:00 vnas kernel: [  162.227523] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742b90 (dma).
2014-03-01T10:54:19.678318+01:00 vnas kernel: [  162.227542] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742b90
2014-03-01T10:54:19.678320+01:00 vnas kernel: [  162.227548] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742ba0 (dma).
2014-03-01T10:54:19.678322+01:00 vnas kernel: [  162.227558] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742ba0
2014-03-01T10:54:19.678324+01:00 vnas kernel: [  162.227577] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742bb0 (dma).
2014-03-01T10:54:19.678499+01:00 vnas kernel: [  162.227587] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742bb0
2014-03-01T10:54:19.678501+01:00 vnas kernel: [  162.227594] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742bc0 (dma).
2014-03-01T10:54:19.678504+01:00 vnas kernel: [  162.227601] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742bc0
2014-03-01T10:54:19.678506+01:00 vnas kernel: [  162.227607] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742bd0 (dma).
2014-03-01T10:54:19.678508+01:00 vnas kernel: [  162.227614] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742bd0
2014-03-01T10:54:19.678510+01:00 vnas kernel: [  162.227620] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf742be0 (dma).
2014-03-01T10:54:19.678512+01:00 vnas kernel: [  162.227626] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf742be0
2014-03-01T10:54:19.678514+01:00 vnas kernel: [  162.227633] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2400 (dma).
2014-03-01T10:54:19.678517+01:00 vnas kernel: [  162.227639] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2400
2014-03-01T10:54:19.678519+01:00 vnas kernel: [  162.227646] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2410 (dma).
2014-03-01T10:54:19.678521+01:00 vnas kernel: [  162.227652] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2410
2014-03-01T10:54:19.678523+01:00 vnas kernel: [  162.227658] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2420 (dma).
2014-03-01T10:54:19.678525+01:00 vnas kernel: [  162.227664] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2420
2014-03-01T10:54:19.678540+01:00 vnas kernel: [  162.227671] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2430 (dma).
2014-03-01T10:54:19.678542+01:00 vnas kernel: [  162.227677] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2430
2014-03-01T10:54:19.678544+01:00 vnas kernel: [  162.227684] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2440 (dma).
2014-03-01T10:54:19.678546+01:00 vnas kernel: [  162.227691] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2440
2014-03-01T10:54:19.678548+01:00 vnas kernel: [  162.227698] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2450 (dma).
2014-03-01T10:54:19.678550+01:00 vnas kernel: [  162.227705] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2450
2014-03-01T10:54:19.678552+01:00 vnas kernel: [  162.227711] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2460 (dma).
2014-03-01T10:54:19.678559+01:00 vnas kernel: [  162.227718] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2460
2014-03-01T10:54:19.678561+01:00 vnas kernel: [  162.227725] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2470 (dma).
2014-03-01T10:54:19.678563+01:00 vnas kernel: [  162.227732] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2470
2014-03-01T10:54:19.678565+01:00 vnas kernel: [  162.227739] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2480 (dma).
2014-03-01T10:54:19.678567+01:00 vnas kernel: [  162.227745] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2480
2014-03-01T10:54:19.678569+01:00 vnas kernel: [  162.227752] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2490 (dma).
2014-03-01T10:54:19.678572+01:00 vnas kernel: [  162.227758] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2490
2014-03-01T10:54:19.678578+01:00 vnas kernel: [  162.227765] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24a0 (dma).
2014-03-01T10:54:19.678580+01:00 vnas kernel: [  162.227771] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24a0
2014-03-01T10:54:19.678582+01:00 vnas kernel: [  162.227778] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24b0 (dma).
2014-03-01T10:54:19.678584+01:00 vnas kernel: [  162.227785] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24b0
2014-03-01T10:54:19.678586+01:00 vnas kernel: [  162.227791] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24c0 (dma).
2014-03-01T10:54:19.678589+01:00 vnas kernel: [  162.227798] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24c0
2014-03-01T10:54:19.678591+01:00 vnas kernel: [  162.227805] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24d0 (dma).
2014-03-01T10:54:19.678603+01:00 vnas kernel: [  162.227816] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24d0
2014-03-01T10:54:19.678606+01:00 vnas kernel: [  162.227835] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24e0 (dma).
2014-03-01T10:54:19.678608+01:00 vnas kernel: [  162.227855] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24e0
2014-03-01T10:54:19.678610+01:00 vnas kernel: [  162.227875] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb24f0 (dma).
2014-03-01T10:54:19.678613+01:00 vnas kernel: [  162.227894] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb24f0
2014-03-01T10:54:19.678615+01:00 vnas kernel: [  162.227914] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2500 (dma).
2014-03-01T10:54:19.678617+01:00 vnas kernel: [  162.227934] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2500
2014-03-01T10:54:19.678625+01:00 vnas kernel: [  162.227953] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2510 (dma).
2014-03-01T10:54:19.678627+01:00 vnas kernel: [  162.227972] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2510
2014-03-01T10:54:19.678713+01:00 vnas kernel: [  162.227983] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2520 (dma).
2014-03-01T10:54:19.678716+01:00 vnas kernel: [  162.227989] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2520
2014-03-01T10:54:19.678718+01:00 vnas kernel: [  162.227996] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2530 (dma).
2014-03-01T10:54:19.678719+01:00 vnas kernel: [  162.228003] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2530
2014-03-01T10:54:19.678721+01:00 vnas kernel: [  162.228009] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2540 (dma).
2014-03-01T10:54:19.678726+01:00 vnas kernel: [  162.228015] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2540
2014-03-01T10:54:19.678728+01:00 vnas kernel: [  162.228022] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2550 (dma).
2014-03-01T10:54:19.678729+01:00 vnas kernel: [  162.228028] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2550
2014-03-01T10:54:19.678731+01:00 vnas kernel: [  162.228035] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2560 (dma).
2014-03-01T10:54:19.678732+01:00 vnas kernel: [  162.228041] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2560
2014-03-01T10:54:19.678733+01:00 vnas kernel: [  162.228048] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2570 (dma).
2014-03-01T10:54:19.678735+01:00 vnas kernel: [  162.228054] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2570
2014-03-01T10:54:19.678740+01:00 vnas kernel: [  162.228095] xhci_hcd 0000:00:14.0: Cancel URB ffff880035e75000, dev 1.2, ep 0x84, starting at offset 0x35fb2580
2014-03-01T10:54:19.678741+01:00 vnas kernel: [  162.228105] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.678743+01:00 vnas kernel: [  162.228119] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
2014-03-01T10:54:19.678744+01:00 vnas kernel: [  162.228126] xhci_hcd 0000:00:14.0: event_trb is a no-op TRB. Skip it
2014-03-01T10:54:19.678745+01:00 vnas kernel: [  162.228143] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2580 (dma).
2014-03-01T10:54:19.678747+01:00 vnas kernel: [  162.228161] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2580
2014-03-01T10:54:19.678748+01:00 vnas kernel: [  162.228181] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2590 (dma).
2014-03-01T10:54:19.678773+01:00 vnas kernel: [  162.228194] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2590
2014-03-01T10:54:19.678774+01:00 vnas kernel: [  162.228201] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25a0 (dma).
2014-03-01T10:54:19.678776+01:00 vnas kernel: [  162.228207] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25a0
2014-03-01T10:54:19.678777+01:00 vnas kernel: [  162.228214] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25b0 (dma).
2014-03-01T10:54:19.678778+01:00 vnas kernel: [  162.228220] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25b0
2014-03-01T10:54:19.678780+01:00 vnas kernel: [  162.228227] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25c0 (dma).
2014-03-01T10:54:19.678781+01:00 vnas kernel: [  162.228236] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25c0
2014-03-01T10:54:19.678797+01:00 vnas kernel: [  162.228250] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25d0 (dma).
2014-03-01T10:54:19.678798+01:00 vnas kernel: [  162.228256] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25d0
2014-03-01T10:54:19.678800+01:00 vnas kernel: [  162.228262] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25e0 (dma).
2014-03-01T10:54:19.678815+01:00 vnas kernel: [  162.228275] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25e0
2014-03-01T10:54:19.678843+01:00 vnas kernel: [  162.228282] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb25f0 (dma).
2014-03-01T10:54:19.678868+01:00 vnas kernel: [  162.228293] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb25f0
2014-03-01T10:54:19.678870+01:00 vnas kernel: [  162.228299] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2600 (dma).
2014-03-01T10:54:19.678872+01:00 vnas kernel: [  162.228306] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2600
2014-03-01T10:54:19.678873+01:00 vnas kernel: [  162.228312] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2610 (dma).
2014-03-01T10:54:19.678875+01:00 vnas kernel: [  162.228318] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2610
2014-03-01T10:54:19.678877+01:00 vnas kernel: [  162.228324] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2620 (dma).
2014-03-01T10:54:19.678878+01:00 vnas kernel: [  162.228337] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2620
2014-03-01T10:54:19.678893+01:00 vnas kernel: [  162.228350] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2630 (dma).
2014-03-01T10:54:19.678895+01:00 vnas kernel: [  162.228356] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2630
2014-03-01T10:54:19.678896+01:00 vnas kernel: [  162.228364] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2640 (dma).
2014-03-01T10:54:19.678903+01:00 vnas kernel: [  162.228375] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2640
2014-03-01T10:54:19.679210+01:00 vnas kernel: [  162.228385] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2650 (dma).
2014-03-01T10:54:19.679214+01:00 vnas kernel: [  162.228392] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2650
2014-03-01T10:54:19.679216+01:00 vnas kernel: [  162.228398] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2660 (dma).
2014-03-01T10:54:19.679219+01:00 vnas kernel: [  162.228405] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2660
2014-03-01T10:54:19.679221+01:00 vnas kernel: [  162.228411] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2670 (dma).
2014-03-01T10:54:19.679223+01:00 vnas kernel: [  162.228418] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2670
2014-03-01T10:54:19.679225+01:00 vnas kernel: [  162.228424] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2680 (dma).
2014-03-01T10:54:19.679227+01:00 vnas kernel: [  162.228431] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2680
2014-03-01T10:54:19.679229+01:00 vnas kernel: [  162.228437] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2690 (dma).
2014-03-01T10:54:19.679232+01:00 vnas kernel: [  162.228444] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2690
2014-03-01T10:54:19.679234+01:00 vnas kernel: [  162.228450] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26a0 (dma).
2014-03-01T10:54:19.679236+01:00 vnas kernel: [  162.228457] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26a0
2014-03-01T10:54:19.679238+01:00 vnas kernel: [  162.228463] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26b0 (dma).
2014-03-01T10:54:19.679240+01:00 vnas kernel: [  162.228469] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26b0
2014-03-01T10:54:19.679243+01:00 vnas kernel: [  162.228476] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26c0 (dma).
2014-03-01T10:54:19.679245+01:00 vnas kernel: [  162.228483] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26c0
2014-03-01T10:54:19.679247+01:00 vnas kernel: [  162.228489] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26d0 (dma).
2014-03-01T10:54:19.679249+01:00 vnas kernel: [  162.228496] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26d0
2014-03-01T10:54:19.679252+01:00 vnas kernel: [  162.228502] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26e0 (dma).
2014-03-01T10:54:19.679254+01:00 vnas kernel: [  162.228508] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26e0
2014-03-01T10:54:19.679256+01:00 vnas kernel: [  162.228514] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb26f0 (dma).
2014-03-01T10:54:19.679258+01:00 vnas kernel: [  162.228521] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb26f0
2014-03-01T10:54:19.679260+01:00 vnas kernel: [  162.228527] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2700 (dma).
2014-03-01T10:54:19.679268+01:00 vnas kernel: [  162.228534] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2700
2014-03-01T10:54:19.679270+01:00 vnas kernel: [  162.228540] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2710 (dma).
2014-03-01T10:54:19.679273+01:00 vnas kernel: [  162.228546] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2710
2014-03-01T10:54:19.679275+01:00 vnas kernel: [  162.228552] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2720 (dma).
2014-03-01T10:54:19.679277+01:00 vnas kernel: [  162.228559] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2720
2014-03-01T10:54:19.679279+01:00 vnas kernel: [  162.228578] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2730 (dma).
2014-03-01T10:54:19.679285+01:00 vnas kernel: [  162.228597] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2730
2014-03-01T10:54:19.679287+01:00 vnas kernel: [  162.228616] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2740 (dma).
2014-03-01T10:54:19.679289+01:00 vnas kernel: [  162.228634] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2740
2014-03-01T10:54:19.679291+01:00 vnas kernel: [  162.228653] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2750 (dma).
2014-03-01T10:54:19.679293+01:00 vnas kernel: [  162.228671] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2750
2014-03-01T10:54:19.679371+01:00 vnas kernel: [  162.228689] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2760 (dma).
2014-03-01T10:54:19.679373+01:00 vnas kernel: [  162.228695] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2760
2014-03-01T10:54:19.679379+01:00 vnas kernel: [  162.228701] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2770 (dma).
2014-03-01T10:54:19.679382+01:00 vnas kernel: [  162.228707] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2770
2014-03-01T10:54:19.679384+01:00 vnas kernel: [  162.228713] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2780 (dma).
2014-03-01T10:54:19.679386+01:00 vnas kernel: [  162.228718] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2780
2014-03-01T10:54:19.679388+01:00 vnas kernel: [  162.228724] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2790 (dma).
2014-03-01T10:54:19.679390+01:00 vnas kernel: [  162.228730] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2790
2014-03-01T10:54:19.679392+01:00 vnas kernel: [  162.228736] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb27a0 (dma).
2014-03-01T10:54:19.679402+01:00 vnas kernel: [  162.228741] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb27a0
2014-03-01T10:54:19.679404+01:00 vnas kernel: [  162.228747] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb27b0 (dma).
2014-03-01T10:54:19.679406+01:00 vnas kernel: [  162.228753] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb27b0
2014-03-01T10:54:19.679408+01:00 vnas kernel: [  162.228759] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb27c0 (dma).
2014-03-01T10:54:19.679410+01:00 vnas kernel: [  162.228765] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb27c0
2014-03-01T10:54:19.679412+01:00 vnas kernel: [  162.228770] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb27d0 (dma).
2014-03-01T10:54:19.679414+01:00 vnas kernel: [  162.228776] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb27d0
2014-03-01T10:54:19.679421+01:00 vnas kernel: [  162.228795] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb27e0 (dma).
2014-03-01T10:54:19.679423+01:00 vnas kernel: [  162.228814] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb27e0
2014-03-01T10:54:19.679425+01:00 vnas kernel: [  162.228833] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2800 (dma).
2014-03-01T10:54:19.679481+01:00 vnas kernel: [  162.228851] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2800
2014-03-01T10:54:19.679483+01:00 vnas kernel: [  162.228857] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2810 (dma).
2014-03-01T10:54:19.679485+01:00 vnas kernel: [  162.228863] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2810
2014-03-01T10:54:19.679487+01:00 vnas kernel: [  162.228868] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2820 (dma).
2014-03-01T10:54:19.679493+01:00 vnas kernel: [  162.228874] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2820
2014-03-01T10:54:19.679496+01:00 vnas kernel: [  162.228880] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2830 (dma).
2014-03-01T10:54:19.679498+01:00 vnas kernel: [  162.228886] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2830
2014-03-01T10:54:19.679500+01:00 vnas kernel: [  162.228891] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2840 (dma).
2014-03-01T10:54:19.679502+01:00 vnas kernel: [  162.228897] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2840
2014-03-01T10:54:19.679504+01:00 vnas kernel: [  162.228903] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2850 (dma).
2014-03-01T10:54:19.679506+01:00 vnas kernel: [  162.228911] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2850
2014-03-01T10:54:19.679513+01:00 vnas kernel: [  162.228930] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2860 (dma).
2014-03-01T10:54:19.679515+01:00 vnas kernel: [  162.228949] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2860
2014-03-01T10:54:19.679551+01:00 vnas kernel: [  162.228962] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2870 (dma).
2014-03-01T10:54:19.679553+01:00 vnas kernel: [  162.228968] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2870
2014-03-01T10:54:19.679555+01:00 vnas kernel: [  162.228973] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2880 (dma).
2014-03-01T10:54:19.679558+01:00 vnas kernel: [  162.228979] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2880
2014-03-01T10:54:19.679560+01:00 vnas kernel: [  162.228985] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2890 (dma).
2014-03-01T10:54:19.679566+01:00 vnas kernel: [  162.228991] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2890
2014-03-01T10:54:19.679568+01:00 vnas kernel: [  162.228997] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28a0 (dma).
2014-03-01T10:54:19.679570+01:00 vnas kernel: [  162.229016] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28a0
2014-03-01T10:54:19.679595+01:00 vnas kernel: [  162.229032] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28b0 (dma).
2014-03-01T10:54:19.679597+01:00 vnas kernel: [  162.229038] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28b0
2014-03-01T10:54:19.679599+01:00 vnas kernel: [  162.229044] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28c0 (dma).
2014-03-01T10:54:19.679601+01:00 vnas kernel: [  162.229049] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28c0
2014-03-01T10:54:19.679608+01:00 vnas kernel: [  162.229063] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28d0 (dma).
2014-03-01T10:54:19.679628+01:00 vnas kernel: [  162.229075] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28d0
2014-03-01T10:54:19.679630+01:00 vnas kernel: [  162.229081] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28e0 (dma).
2014-03-01T10:54:19.679632+01:00 vnas kernel: [  162.229087] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28e0
2014-03-01T10:54:19.679634+01:00 vnas kernel: [  162.229101] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb28f0 (dma).
2014-03-01T10:54:19.679649+01:00 vnas kernel: [  162.229110] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb28f0
2014-03-01T10:54:19.679651+01:00 vnas kernel: [  162.229116] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2900 (dma).
2014-03-01T10:54:19.679669+01:00 vnas kernel: [  162.229129] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2900
2014-03-01T10:54:19.679671+01:00 vnas kernel: [  162.229137] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2910 (dma).
2014-03-01T10:54:19.679685+01:00 vnas kernel: [  162.229147] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2910
2014-03-01T10:54:19.679687+01:00 vnas kernel: [  162.229153] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2920 (dma).
2014-03-01T10:54:19.679701+01:00 vnas kernel: [  162.229166] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2920
2014-03-01T10:54:19.679703+01:00 vnas kernel: [  162.229174] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2930 (dma).
2014-03-01T10:54:19.679712+01:00 vnas kernel: [  162.229183] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2930
2014-03-01T10:54:19.679726+01:00 vnas kernel: [  162.229193] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2940 (dma).
2014-03-01T10:54:19.679741+01:00 vnas kernel: [  162.229203] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2940
2014-03-01T10:54:19.679743+01:00 vnas kernel: [  162.229209] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2950 (dma).
2014-03-01T10:54:19.679757+01:00 vnas kernel: [  162.229221] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2950
2014-03-01T10:54:19.679759+01:00 vnas kernel: [  162.229229] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2960 (dma).
2014-03-01T10:54:19.679768+01:00 vnas kernel: [  162.229239] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2960
2014-03-01T10:54:19.679778+01:00 vnas kernel: [  162.229249] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2970 (dma).
2014-03-01T10:54:19.679792+01:00 vnas kernel: [  162.229258] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2970
2014-03-01T10:54:19.679807+01:00 vnas kernel: [  162.229268] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2980 (dma).
2014-03-01T10:54:19.679809+01:00 vnas kernel: [  162.229275] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2980
2014-03-01T10:54:19.679869+01:00 vnas kernel: [  162.229307] xhci_hcd 0000:00:14.0: Cancel URB ffff880035e75800, dev 1.2, ep 0x84, starting at offset 0x35fb2990
2014-03-01T10:54:19.679873+01:00 vnas kernel: [  162.229317] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:19.679882+01:00 vnas kernel: [  162.229345] xhci_hcd 0000:00:14.0: Stopped on Transfer TRB
2014-03-01T10:54:19.679888+01:00 vnas kernel: [  162.229352] xhci_hcd 0000:00:14.0: event_trb is a no-op TRB. Skip it
2014-03-01T10:54:19.679900+01:00 vnas kernel: [  162.229363] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2990 (dma).
2014-03-01T10:54:19.679901+01:00 vnas kernel: [  162.229370] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2990
2014-03-01T10:54:19.679910+01:00 vnas kernel: [  162.229381] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29a0 (dma).
2014-03-01T10:54:19.680183+01:00 vnas kernel: [  162.229391] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29a0
2014-03-01T10:54:19.680186+01:00 vnas kernel: [  162.229397] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29b0 (dma).
2014-03-01T10:54:19.680188+01:00 vnas kernel: [  162.229404] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29b0
2014-03-01T10:54:19.680194+01:00 vnas kernel: [  162.229411] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29c0 (dma).
2014-03-01T10:54:19.680196+01:00 vnas kernel: [  162.229417] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29c0
2014-03-01T10:54:19.680197+01:00 vnas kernel: [  162.229423] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29d0 (dma).
2014-03-01T10:54:19.680198+01:00 vnas kernel: [  162.229430] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29d0
2014-03-01T10:54:19.680200+01:00 vnas kernel: [  162.229436] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29e0 (dma).
2014-03-01T10:54:19.680201+01:00 vnas kernel: [  162.229443] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29e0
2014-03-01T10:54:19.680202+01:00 vnas kernel: [  162.229449] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb29f0 (dma).
2014-03-01T10:54:19.680207+01:00 vnas kernel: [  162.229455] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb29f0
2014-03-01T10:54:19.680209+01:00 vnas kernel: [  162.229462] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a00 (dma).
2014-03-01T10:54:19.680210+01:00 vnas kernel: [  162.229468] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a00
2014-03-01T10:54:19.680211+01:00 vnas kernel: [  162.229475] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a10 (dma).
2014-03-01T10:54:19.680213+01:00 vnas kernel: [  162.229481] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a10
2014-03-01T10:54:19.680214+01:00 vnas kernel: [  162.229487] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a20 (dma).
2014-03-01T10:54:19.680215+01:00 vnas kernel: [  162.229494] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a20
2014-03-01T10:54:19.680220+01:00 vnas kernel: [  162.229500] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a30 (dma).
2014-03-01T10:54:19.680222+01:00 vnas kernel: [  162.229506] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a30
2014-03-01T10:54:19.680223+01:00 vnas kernel: [  162.229513] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a40 (dma).
2014-03-01T10:54:19.680224+01:00 vnas kernel: [  162.229519] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a40
2014-03-01T10:54:19.680226+01:00 vnas kernel: [  162.229526] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a50 (dma).
2014-03-01T10:54:19.680227+01:00 vnas kernel: [  162.229532] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a50
2014-03-01T10:54:19.680228+01:00 vnas kernel: [  162.229538] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a60 (dma).
2014-03-01T10:54:19.680233+01:00 vnas kernel: [  162.229545] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a60
2014-03-01T10:54:19.680235+01:00 vnas kernel: [  162.229551] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a70 (dma).
2014-03-01T10:54:19.680236+01:00 vnas kernel: [  162.229557] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a70
2014-03-01T10:54:19.680237+01:00 vnas kernel: [  162.229564] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a80 (dma).
2014-03-01T10:54:19.680239+01:00 vnas kernel: [  162.229577] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a80
2014-03-01T10:54:19.680240+01:00 vnas kernel: [  162.229593] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2a90 (dma).
2014-03-01T10:54:19.680241+01:00 vnas kernel: [  162.229608] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2a90
2014-03-01T10:54:19.680248+01:00 vnas kernel: [  162.229623] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2aa0 (dma).
2014-03-01T10:54:19.680303+01:00 vnas kernel: [  162.229638] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2aa0
2014-03-01T10:54:19.680306+01:00 vnas kernel: [  162.229654] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2ab0 (dma).
2014-03-01T10:54:19.680374+01:00 vnas kernel: [  162.229663] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2ab0
2014-03-01T10:54:19.680376+01:00 vnas kernel: [  162.229670] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2ac0 (dma).
2014-03-01T10:54:19.680378+01:00 vnas kernel: [  162.229677] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2ac0
2014-03-01T10:54:19.680379+01:00 vnas kernel: [  162.229683] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2ad0 (dma).
2014-03-01T10:54:19.680381+01:00 vnas kernel: [  162.229689] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2ad0
2014-03-01T10:54:19.680383+01:00 vnas kernel: [  162.229696] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2ae0 (dma).
2014-03-01T10:54:19.680384+01:00 vnas kernel: [  162.229702] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2ae0
2014-03-01T10:54:19.680386+01:00 vnas kernel: [  162.229708] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2af0 (dma).
2014-03-01T10:54:19.680387+01:00 vnas kernel: [  162.229714] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2af0
2014-03-01T10:54:19.680389+01:00 vnas kernel: [  162.229720] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b00 (dma).
2014-03-01T10:54:19.680391+01:00 vnas kernel: [  162.229727] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b00
2014-03-01T10:54:19.680393+01:00 vnas kernel: [  162.229733] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b10 (dma).
2014-03-01T10:54:19.680394+01:00 vnas kernel: [  162.229739] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b10
2014-03-01T10:54:19.680396+01:00 vnas kernel: [  162.229746] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b20 (dma).
2014-03-01T10:54:19.680397+01:00 vnas kernel: [  162.229751] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b20
2014-03-01T10:54:19.680399+01:00 vnas kernel: [  162.229757] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b30 (dma).
2014-03-01T10:54:19.680400+01:00 vnas kernel: [  162.229764] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b30
2014-03-01T10:54:19.680402+01:00 vnas kernel: [  162.229771] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b40 (dma).
2014-03-01T10:54:19.680404+01:00 vnas kernel: [  162.229778] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b40
2014-03-01T10:54:19.680405+01:00 vnas kernel: [  162.229785] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b50 (dma).
2014-03-01T10:54:19.680406+01:00 vnas kernel: [  162.229797] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b50
2014-03-01T10:54:19.680408+01:00 vnas kernel: [  162.229813] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b60 (dma).
2014-03-01T10:54:19.680409+01:00 vnas kernel: [  162.229828] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b60
2014-03-01T10:54:19.680411+01:00 vnas kernel: [  162.229844] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b70 (dma).
2014-03-01T10:54:19.680433+01:00 vnas kernel: [  162.229855] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b70
2014-03-01T10:54:19.680434+01:00 vnas kernel: [  162.229862] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b80 (dma).
2014-03-01T10:54:19.680436+01:00 vnas kernel: [  162.229868] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b80
2014-03-01T10:54:19.680437+01:00 vnas kernel: [  162.229875] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2b90 (dma).
2014-03-01T10:54:19.680438+01:00 vnas kernel: [  162.229881] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2b90
2014-03-01T10:54:19.680440+01:00 vnas kernel: [  162.229888] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2ba0 (dma).
2014-03-01T10:54:19.680442+01:00 vnas kernel: [  162.229899] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2ba0
2014-03-01T10:54:19.680451+01:00 vnas kernel: [  162.229913] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2bb0 (dma).
2014-03-01T10:54:19.680452+01:00 vnas kernel: [  162.229920] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2bb0
2014-03-01T10:54:19.680460+01:00 vnas kernel: [  162.229931] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2bc0 (dma).
2014-03-01T10:54:19.680998+01:00 vnas kernel: [  162.229940] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2bc0
2014-03-01T10:54:19.681007+01:00 vnas kernel: [  162.229947] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2bd0 (dma).
2014-03-01T10:54:19.681009+01:00 vnas kernel: [  162.229954] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2bd0
2014-03-01T10:54:19.681011+01:00 vnas kernel: [  162.229960] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0x35fb2be0 (dma).
2014-03-01T10:54:19.681013+01:00 vnas kernel: [  162.229966] xhci_hcd 0000:00:14.0: TRB to noop at offset 0x35fb2be0
2014-03-01T10:54:19.681015+01:00 vnas kernel: [  162.229973] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1000 (dma).
2014-03-01T10:54:19.681016+01:00 vnas kernel: [  162.229980] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1000
2014-03-01T10:54:19.681019+01:00 vnas kernel: [  162.229986] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1010 (dma).
2014-03-01T10:54:19.681021+01:00 vnas kernel: [  162.229992] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1010
2014-03-01T10:54:19.681024+01:00 vnas kernel: [  162.229999] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1020 (dma).
2014-03-01T10:54:19.681026+01:00 vnas kernel: [  162.230005] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1020
2014-03-01T10:54:19.681029+01:00 vnas kernel: [  162.230012] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1030 (dma).
2014-03-01T10:54:19.681031+01:00 vnas kernel: [  162.230018] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1030
2014-03-01T10:54:19.681033+01:00 vnas kernel: [  162.230025] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1040 (dma).
2014-03-01T10:54:19.681035+01:00 vnas kernel: [  162.230031] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1040
2014-03-01T10:54:19.681038+01:00 vnas kernel: [  162.230038] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1050 (dma).
2014-03-01T10:54:19.681041+01:00 vnas kernel: [  162.230044] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1050
2014-03-01T10:54:19.681043+01:00 vnas kernel: [  162.230051] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1060 (dma).
2014-03-01T10:54:19.681046+01:00 vnas kernel: [  162.230057] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1060
2014-03-01T10:54:19.681048+01:00 vnas kernel: [  162.230063] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1070 (dma).
2014-03-01T10:54:19.681051+01:00 vnas kernel: [  162.230070] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1070
2014-03-01T10:54:19.681053+01:00 vnas kernel: [  162.230076] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1080 (dma).
2014-03-01T10:54:19.681056+01:00 vnas kernel: [  162.230083] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1080
2014-03-01T10:54:19.681058+01:00 vnas kernel: [  162.230089] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1090 (dma).
2014-03-01T10:54:19.681078+01:00 vnas kernel: [  162.230096] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1090
2014-03-01T10:54:19.681081+01:00 vnas kernel: [  162.230102] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10a0 (dma).
2014-03-01T10:54:19.681084+01:00 vnas kernel: [  162.230108] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10a0
2014-03-01T10:54:19.681086+01:00 vnas kernel: [  162.230115] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10b0 (dma).
2014-03-01T10:54:19.681105+01:00 vnas kernel: [  162.230121] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10b0
2014-03-01T10:54:19.681107+01:00 vnas kernel: [  162.230128] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10c0 (dma).
2014-03-01T10:54:19.681110+01:00 vnas kernel: [  162.230134] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10c0
2014-03-01T10:54:19.681112+01:00 vnas kernel: [  162.230140] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10d0 (dma).
2014-03-01T10:54:19.681115+01:00 vnas kernel: [  162.230147] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10d0
2014-03-01T10:54:19.681118+01:00 vnas kernel: [  162.230153] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10e0 (dma).
2014-03-01T10:54:19.681137+01:00 vnas kernel: [  162.230160] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10e0
2014-03-01T10:54:19.681140+01:00 vnas kernel: [  162.230166] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c10f0 (dma).
2014-03-01T10:54:19.681142+01:00 vnas kernel: [  162.230172] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c10f0
2014-03-01T10:54:19.681144+01:00 vnas kernel: [  162.230179] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1100 (dma).
2014-03-01T10:54:19.681146+01:00 vnas kernel: [  162.230185] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1100
2014-03-01T10:54:19.681148+01:00 vnas kernel: [  162.230192] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1110 (dma).
2014-03-01T10:54:19.681149+01:00 vnas kernel: [  162.230198] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1110
2014-03-01T10:54:19.681155+01:00 vnas kernel: [  162.230204] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1120 (dma).
2014-03-01T10:54:19.681157+01:00 vnas kernel: [  162.230211] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1120
2014-03-01T10:54:19.681158+01:00 vnas kernel: [  162.230217] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1130 (dma).
2014-03-01T10:54:19.681160+01:00 vnas kernel: [  162.230223] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1130
2014-03-01T10:54:19.681162+01:00 vnas kernel: [  162.230230] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1140 (dma).
2014-03-01T10:54:19.681165+01:00 vnas kernel: [  162.230236] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1140
2014-03-01T10:54:19.681167+01:00 vnas kernel: [  162.230243] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1150 (dma).
2014-03-01T10:54:19.681174+01:00 vnas kernel: [  162.230249] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1150
2014-03-01T10:54:19.681176+01:00 vnas kernel: [  162.230255] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1160 (dma).
2014-03-01T10:54:19.681179+01:00 vnas kernel: [  162.230262] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1160
2014-03-01T10:54:19.681181+01:00 vnas kernel: [  162.230268] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1170 (dma).
2014-03-01T10:54:19.681183+01:00 vnas kernel: [  162.230274] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1170
2014-03-01T10:54:19.681185+01:00 vnas kernel: [  162.230281] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1180 (dma).
2014-03-01T10:54:19.681188+01:00 vnas kernel: [  162.230287] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1180
2014-03-01T10:54:19.681196+01:00 vnas kernel: [  162.230294] xhci_hcd 0000:00:14.0: Removing canceled TD starting at 0xcf2c1190 (dma).
2014-03-01T10:54:19.681198+01:00 vnas kernel: [  162.230301] xhci_hcd 0000:00:14.0: TRB to noop at offset 0xcf2c1190
2014-03-01T10:54:19.863557+01:00 vnas kernel: [  162.412826] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:19.863582+01:00 vnas kernel: [  162.412838] xhci_hcd 0000:00:14.0: Giveback URB ffff880210daa000, len = 10, expected = 512, status = -121
2014-03-01T10:54:20.264249+01:00 vnas kernel: [  162.813122] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:20.264290+01:00 vnas kernel: [  162.813140] xhci_hcd 0000:00:14.0: Giveback URB ffff880210961600, len = 10, expected = 512, status = -121
2014-03-01T10:54:20.664982+01:00 vnas kernel: [  163.213521] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:20.665023+01:00 vnas kernel: [  163.213538] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04300, len = 10, expected = 512, status = -121
2014-03-01T10:54:20.971162+01:00 vnas kernel: [  163.519410] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff8802115a6000
2014-03-01T10:54:20.971192+01:00 vnas kernel: [  163.519424] xhci_hcd 0000:00:14.0: drop ep 0x81, slot id 12, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8300004
2014-03-01T10:54:20.971196+01:00 vnas kernel: [  163.519430] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff8802115a6000
2014-03-01T10:54:20.971199+01:00 vnas kernel: [  163.519436] xhci_hcd 0000:00:14.0: drop ep 0x82, slot id 12, new drop flags = 0x28, new add flags = 0x0, new slot info = 0x8300004
2014-03-01T10:54:20.971201+01:00 vnas kernel: [  163.519440] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff8802115a6000
2014-03-01T10:54:20.971204+01:00 vnas kernel: [  163.519445] xhci_hcd 0000:00:14.0: drop ep 0x83, slot id 12, new drop flags = 0xa8, new add flags = 0x0, new slot info = 0x8300004
2014-03-01T10:54:20.971206+01:00 vnas kernel: [  163.519448] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff8802115a6000
2014-03-01T10:54:20.971211+01:00 vnas kernel: [  163.519453] xhci_hcd 0000:00:14.0: drop ep 0x84, slot id 12, new drop flags = 0x2a8, new add flags = 0x0, new slot info = 0x8300004
2014-03-01T10:54:20.971241+01:00 vnas kernel: [  163.519538] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 12, new drop flags = 0x2a8, new add flags = 0x8, new slot info = 0x18300004
2014-03-01T10:54:20.971317+01:00 vnas kernel: [  163.519557] xhci_hcd 0000:00:14.0: add ep 0x82, slot id 12, new drop flags = 0x2a8, new add flags = 0x28, new slot info = 0x28300004
2014-03-01T10:54:20.971320+01:00 vnas kernel: [  163.519567] xhci_hcd 0000:00:14.0: add ep 0x83, slot id 12, new drop flags = 0x2a8, new add flags = 0xa8, new slot info = 0x38300004
2014-03-01T10:54:20.971323+01:00 vnas kernel: [  163.519578] xhci_hcd 0000:00:14.0: add ep 0x84, slot id 12, new drop flags = 0x2a8, new add flags = 0x2a8, new slot info = 0x48300004
2014-03-01T10:54:20.971326+01:00 vnas kernel: [  163.519586] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff8802115a6000
2014-03-01T10:54:20.971329+01:00 vnas kernel: [  163.519591] xhci_hcd 0000:00:14.0: New Input Control Context:
2014-03-01T10:54:20.971331+01:00 vnas kernel: [  163.519600] xhci_hcd 0000:00:14.0: @ffff8802107dc000 (virt) @2107dc000 (dma) 0x0002a8 - drop flags
2014-03-01T10:54:20.971335+01:00 vnas kernel: [  163.519608] xhci_hcd 0000:00:14.0: @ffff8802107dc004 (virt) @2107dc004 (dma) 0x0002a9 - add flags
2014-03-01T10:54:20.971337+01:00 vnas kernel: [  163.519615] xhci_hcd 0000:00:14.0: @ffff8802107dc008 (virt) @2107dc008 (dma) 0x000000 - rsvd2[0]
2014-03-01T10:54:20.971340+01:00 vnas kernel: [  163.519622] xhci_hcd 0000:00:14.0: @ffff8802107dc00c (virt) @2107dc00c (dma) 0x000000 - rsvd2[1]
2014-03-01T10:54:20.971342+01:00 vnas kernel: [  163.519628] xhci_hcd 0000:00:14.0: @ffff8802107dc010 (virt) @2107dc010 (dma) 0x000000 - rsvd2[2]
2014-03-01T10:54:20.971344+01:00 vnas kernel: [  163.519635] xhci_hcd 0000:00:14.0: @ffff8802107dc014 (virt) @2107dc014 (dma) 0x000000 - rsvd2[3]
2014-03-01T10:54:20.971347+01:00 vnas kernel: [  163.519641] xhci_hcd 0000:00:14.0: @ffff8802107dc018 (virt) @2107dc018 (dma) 0x000000 - rsvd2[4]
2014-03-01T10:54:20.971349+01:00 vnas kernel: [  163.519648] xhci_hcd 0000:00:14.0: @ffff8802107dc01c (virt) @2107dc01c (dma) 0x000000 - rsvd2[5]
2014-03-01T10:54:20.971352+01:00 vnas kernel: [  163.519668] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:20.971355+01:00 vnas kernel: [  163.519688] xhci_hcd 0000:00:14.0: @ffff8802107dc020 (virt) @2107dc020 (dma) 0x48300004 - dev_info
2014-03-01T10:54:20.971358+01:00 vnas kernel: [  163.519710] xhci_hcd 0000:00:14.0: @ffff8802107dc024 (virt) @2107dc024 (dma) 0x010000 - dev_info2
2014-03-01T10:54:20.971399+01:00 vnas kernel: [  163.519720] xhci_hcd 0000:00:14.0: @ffff8802107dc028 (virt) @2107dc028 (dma) 0x000000 - tt_info
2014-03-01T10:54:20.971402+01:00 vnas kernel: [  163.519727] xhci_hcd 0000:00:14.0: @ffff8802107dc02c (virt) @2107dc02c (dma) 0x000000 - dev_state
2014-03-01T10:54:20.971404+01:00 vnas kernel: [  163.519734] xhci_hcd 0000:00:14.0: @ffff8802107dc030 (virt) @2107dc030 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.971407+01:00 vnas kernel: [  163.519741] xhci_hcd 0000:00:14.0: @ffff8802107dc034 (virt) @2107dc034 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.971409+01:00 vnas kernel: [  163.519747] xhci_hcd 0000:00:14.0: @ffff8802107dc038 (virt) @2107dc038 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.971411+01:00 vnas kernel: [  163.519754] xhci_hcd 0000:00:14.0: @ffff8802107dc03c (virt) @2107dc03c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:20.971414+01:00 vnas kernel: [  163.519761] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:20.971416+01:00 vnas kernel: [  163.519783] xhci_hcd 0000:00:14.0: @ffff8802107dc040 (virt) @2107dc040 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.971438+01:00 vnas kernel: [  163.519800] xhci_hcd 0000:00:14.0: @ffff8802107dc044 (virt) @2107dc044 (dma) 0x400026 - ep_info2
2014-03-01T10:54:20.971440+01:00 vnas kernel: [  163.519808] xhci_hcd 0000:00:14.0: @ffff8802107dc048 (virt) @2107dc048 (dma) 0x211c76831 - deq
2014-03-01T10:54:20.971443+01:00 vnas kernel: [  163.519815] xhci_hcd 0000:00:14.0: @ffff8802107dc050 (virt) @2107dc050 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.971445+01:00 vnas kernel: [  163.519830] xhci_hcd 0000:00:14.0: @ffff8802107dc054 (virt) @2107dc054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.971461+01:00 vnas kernel: [  163.519841] xhci_hcd 0000:00:14.0: @ffff8802107dc058 (virt) @2107dc058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.971463+01:00 vnas kernel: [  163.519849] xhci_hcd 0000:00:14.0: @ffff8802107dc05c (virt) @2107dc05c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.971478+01:00 vnas kernel: [  163.519861] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:20.971480+01:00 vnas kernel: [  163.519870] xhci_hcd 0000:00:14.0: @ffff8802107dc060 (virt) @2107dc060 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.971488+01:00 vnas kernel: [  163.519880] xhci_hcd 0000:00:14.0: @ffff8802107dc064 (virt) @2107dc064 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.972255+01:00 vnas kernel: [  163.519891] xhci_hcd 0000:00:14.0: @ffff8802107dc068 (virt) @2107dc068 (dma) 0x000000 - deq
2014-03-01T10:54:20.972277+01:00 vnas kernel: [  163.519898] xhci_hcd 0000:00:14.0: @ffff8802107dc070 (virt) @2107dc070 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972280+01:00 vnas kernel: [  163.519905] xhci_hcd 0000:00:14.0: @ffff8802107dc074 (virt) @2107dc074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972283+01:00 vnas kernel: [  163.519911] xhci_hcd 0000:00:14.0: @ffff8802107dc078 (virt) @2107dc078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972285+01:00 vnas kernel: [  163.519918] xhci_hcd 0000:00:14.0: @ffff8802107dc07c (virt) @2107dc07c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972288+01:00 vnas kernel: [  163.519924] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:20.972290+01:00 vnas kernel: [  163.519931] xhci_hcd 0000:00:14.0: @ffff8802107dc080 (virt) @2107dc080 (dma) 0x0a0000 - ep_info
2014-03-01T10:54:20.972293+01:00 vnas kernel: [  163.519937] xhci_hcd 0000:00:14.0: @ffff8802107dc084 (virt) @2107dc084 (dma) 0x01003e - ep_info2
2014-03-01T10:54:20.972295+01:00 vnas kernel: [  163.519944] xhci_hcd 0000:00:14.0: @ffff8802107dc088 (virt) @2107dc088 (dma) 0x2109b0001 - deq
2014-03-01T10:54:20.972297+01:00 vnas kernel: [  163.519950] xhci_hcd 0000:00:14.0: @ffff8802107dc090 (virt) @2107dc090 (dma) 0x010001 - tx_info
2014-03-01T10:54:20.972300+01:00 vnas kernel: [  163.519957] xhci_hcd 0000:00:14.0: @ffff8802107dc094 (virt) @2107dc094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972303+01:00 vnas kernel: [  163.519964] xhci_hcd 0000:00:14.0: @ffff8802107dc098 (virt) @2107dc098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972306+01:00 vnas kernel: [  163.519975] xhci_hcd 0000:00:14.0: @ffff8802107dc09c (virt) @2107dc09c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972308+01:00 vnas kernel: [  163.519982] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:20.972310+01:00 vnas kernel: [  163.519989] xhci_hcd 0000:00:14.0: @ffff8802107dc0a0 (virt) @2107dc0a0 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972312+01:00 vnas kernel: [  163.519996] xhci_hcd 0000:00:14.0: @ffff8802107dc0a4 (virt) @2107dc0a4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.972315+01:00 vnas kernel: [  163.520003] xhci_hcd 0000:00:14.0: @ffff8802107dc0a8 (virt) @2107dc0a8 (dma) 0x000000 - deq
2014-03-01T10:54:20.972318+01:00 vnas kernel: [  163.520010] xhci_hcd 0000:00:14.0: @ffff8802107dc0b0 (virt) @2107dc0b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972320+01:00 vnas kernel: [  163.520018] xhci_hcd 0000:00:14.0: @ffff8802107dc0b4 (virt) @2107dc0b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972323+01:00 vnas kernel: [  163.520026] xhci_hcd 0000:00:14.0: @ffff8802107dc0b8 (virt) @2107dc0b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972325+01:00 vnas kernel: [  163.520033] xhci_hcd 0000:00:14.0: @ffff8802107dc0bc (virt) @2107dc0bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972327+01:00 vnas kernel: [  163.520039] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:20.972330+01:00 vnas kernel: [  163.520046] xhci_hcd 0000:00:14.0: @ffff8802107dc0c0 (virt) @2107dc0c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972332+01:00 vnas kernel: [  163.520053] xhci_hcd 0000:00:14.0: @ffff8802107dc0c4 (virt) @2107dc0c4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:20.972334+01:00 vnas kernel: [  163.520060] xhci_hcd 0000:00:14.0: @ffff8802107dc0c8 (virt) @2107dc0c8 (dma) 0x2109b0801 - deq
2014-03-01T10:54:20.972337+01:00 vnas kernel: [  163.520067] xhci_hcd 0000:00:14.0: @ffff8802107dc0d0 (virt) @2107dc0d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972339+01:00 vnas kernel: [  163.520075] xhci_hcd 0000:00:14.0: @ffff8802107dc0d4 (virt) @2107dc0d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972341+01:00 vnas kernel: [  163.520082] xhci_hcd 0000:00:14.0: @ffff8802107dc0d8 (virt) @2107dc0d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972344+01:00 vnas kernel: [  163.520089] xhci_hcd 0000:00:14.0: @ffff8802107dc0dc (virt) @2107dc0dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972346+01:00 vnas kernel: [  163.520096] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:20.972348+01:00 vnas kernel: [  163.520103] xhci_hcd 0000:00:14.0: @ffff8802107dc0e0 (virt) @2107dc0e0 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972350+01:00 vnas kernel: [  163.520110] xhci_hcd 0000:00:14.0: @ffff8802107dc0e4 (virt) @2107dc0e4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.972353+01:00 vnas kernel: [  163.520118] xhci_hcd 0000:00:14.0: @ffff8802107dc0e8 (virt) @2107dc0e8 (dma) 0x000000 - deq
2014-03-01T10:54:20.972355+01:00 vnas kernel: [  163.520125] xhci_hcd 0000:00:14.0: @ffff8802107dc0f0 (virt) @2107dc0f0 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972358+01:00 vnas kernel: [  163.520132] xhci_hcd 0000:00:14.0: @ffff8802107dc0f4 (virt) @2107dc0f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972361+01:00 vnas kernel: [  163.520140] xhci_hcd 0000:00:14.0: @ffff8802107dc0f8 (virt) @2107dc0f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972363+01:00 vnas kernel: [  163.520147] xhci_hcd 0000:00:14.0: @ffff8802107dc0fc (virt) @2107dc0fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972365+01:00 vnas kernel: [  163.520154] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:20.972368+01:00 vnas kernel: [  163.520161] xhci_hcd 0000:00:14.0: @ffff8802107dc100 (virt) @2107dc100 (dma) 0x030000 - ep_info
2014-03-01T10:54:20.972370+01:00 vnas kernel: [  163.520168] xhci_hcd 0000:00:14.0: @ffff8802107dc104 (virt) @2107dc104 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:20.972373+01:00 vnas kernel: [  163.520175] xhci_hcd 0000:00:14.0: @ffff8802107dc108 (virt) @2107dc108 (dma) 0x21154e401 - deq
2014-03-01T10:54:20.972375+01:00 vnas kernel: [  163.520182] xhci_hcd 0000:00:14.0: @ffff8802107dc110 (virt) @2107dc110 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:20.972377+01:00 vnas kernel: [  163.520189] xhci_hcd 0000:00:14.0: @ffff8802107dc114 (virt) @2107dc114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972380+01:00 vnas kernel: [  163.520197] xhci_hcd 0000:00:14.0: @ffff8802107dc118 (virt) @2107dc118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972383+01:00 vnas kernel: [  163.520204] xhci_hcd 0000:00:14.0: @ffff8802107dc11c (virt) @2107dc11c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972385+01:00 vnas kernel: [  163.520211] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:20.972387+01:00 vnas kernel: [  163.520218] xhci_hcd 0000:00:14.0: @ffff8802107dc120 (virt) @2107dc120 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972389+01:00 vnas kernel: [  163.520225] xhci_hcd 0000:00:14.0: @ffff8802107dc124 (virt) @2107dc124 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.972391+01:00 vnas kernel: [  163.520232] xhci_hcd 0000:00:14.0: @ffff8802107dc128 (virt) @2107dc128 (dma) 0x000000 - deq
2014-03-01T10:54:20.972394+01:00 vnas kernel: [  163.520241] xhci_hcd 0000:00:14.0: @ffff8802107dc130 (virt) @2107dc130 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972396+01:00 vnas kernel: [  163.520248] xhci_hcd 0000:00:14.0: @ffff8802107dc134 (virt) @2107dc134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972399+01:00 vnas kernel: [  163.520256] xhci_hcd 0000:00:14.0: @ffff8802107dc138 (virt) @2107dc138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972401+01:00 vnas kernel: [  163.520263] xhci_hcd 0000:00:14.0: @ffff8802107dc13c (virt) @2107dc13c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972403+01:00 vnas kernel: [  163.520270] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:20.972405+01:00 vnas kernel: [  163.520277] xhci_hcd 0000:00:14.0: @ffff8802107dc140 (virt) @2107dc140 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972408+01:00 vnas kernel: [  163.520284] xhci_hcd 0000:00:14.0: @ffff8802107dc144 (virt) @2107dc144 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:20.972410+01:00 vnas kernel: [  163.520292] xhci_hcd 0000:00:14.0: @ffff8802107dc148 (virt) @2107dc148 (dma) 0x211eb0001 - deq
2014-03-01T10:54:20.972412+01:00 vnas kernel: [  163.520299] xhci_hcd 0000:00:14.0: @ffff8802107dc150 (virt) @2107dc150 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:20.972415+01:00 vnas kernel: [  163.520306] xhci_hcd 0000:00:14.0: @ffff8802107dc154 (virt) @2107dc154 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972417+01:00 vnas kernel: [  163.520314] xhci_hcd 0000:00:14.0: @ffff8802107dc158 (virt) @2107dc158 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972420+01:00 vnas kernel: [  163.520321] xhci_hcd 0000:00:14.0: @ffff8802107dc15c (virt) @2107dc15c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972422+01:00 vnas kernel: [  163.520329] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:20.972490+01:00 vnas kernel: [  163.520724] xhci_hcd 0000:00:14.0: Completed config ep cmd
2014-03-01T10:54:20.972493+01:00 vnas kernel: [  163.520754] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
2014-03-01T10:54:20.972495+01:00 vnas kernel: [  163.520761] xhci_hcd 0000:00:14.0: Output context after successful config ep cmd:
2014-03-01T10:54:20.972498+01:00 vnas kernel: [  163.520768] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:20.972500+01:00 vnas kernel: [  163.520777] xhci_hcd 0000:00:14.0: @ffff880211eb7000 (virt) @211eb7000 (dma) 0x48300004 - dev_info
2014-03-01T10:54:20.972504+01:00 vnas kernel: [  163.520785] xhci_hcd 0000:00:14.0: @ffff880211eb7004 (virt) @211eb7004 (dma) 0x010000 - dev_info2
2014-03-01T10:54:20.972506+01:00 vnas kernel: [  163.520793] xhci_hcd 0000:00:14.0: @ffff880211eb7008 (virt) @211eb7008 (dma) 0x000000 - tt_info
2014-03-01T10:54:20.972508+01:00 vnas kernel: [  163.520800] xhci_hcd 0000:00:14.0: @ffff880211eb700c (virt) @211eb700c (dma) 0x1800000c - dev_state
2014-03-01T10:54:20.972511+01:00 vnas kernel: [  163.520808] xhci_hcd 0000:00:14.0: @ffff880211eb7010 (virt) @211eb7010 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972513+01:00 vnas kernel: [  163.520816] xhci_hcd 0000:00:14.0: @ffff880211eb7014 (virt) @211eb7014 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972516+01:00 vnas kernel: [  163.520823] xhci_hcd 0000:00:14.0: @ffff880211eb7018 (virt) @211eb7018 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972518+01:00 vnas kernel: [  163.520839] xhci_hcd 0000:00:14.0: @ffff880211eb701c (virt) @211eb701c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:20.972521+01:00 vnas kernel: [  163.520860] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:20.972523+01:00 vnas kernel: [  163.520881] xhci_hcd 0000:00:14.0: @ffff880211eb7020 (virt) @211eb7020 (dma) 0x000001 - ep_info
2014-03-01T10:54:20.972562+01:00 vnas kernel: [  163.520892] xhci_hcd 0000:00:14.0: @ffff880211eb7024 (virt) @211eb7024 (dma) 0x400026 - ep_info2
2014-03-01T10:54:20.972565+01:00 vnas kernel: [  163.520900] xhci_hcd 0000:00:14.0: @ffff880211eb7028 (virt) @211eb7028 (dma) 0x211c76831 - deq
2014-03-01T10:54:20.972567+01:00 vnas kernel: [  163.520907] xhci_hcd 0000:00:14.0: @ffff880211eb7030 (virt) @211eb7030 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972570+01:00 vnas kernel: [  163.520914] xhci_hcd 0000:00:14.0: @ffff880211eb7034 (virt) @211eb7034 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972573+01:00 vnas kernel: [  163.520921] xhci_hcd 0000:00:14.0: @ffff880211eb7038 (virt) @211eb7038 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972575+01:00 vnas kernel: [  163.520930] xhci_hcd 0000:00:14.0: @ffff880211eb703c (virt) @211eb703c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972578+01:00 vnas kernel: [  163.520952] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:20.972602+01:00 vnas kernel: [  163.520963] xhci_hcd 0000:00:14.0: @ffff880211eb7040 (virt) @211eb7040 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.972605+01:00 vnas kernel: [  163.520971] xhci_hcd 0000:00:14.0: @ffff880211eb7044 (virt) @211eb7044 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.972607+01:00 vnas kernel: [  163.520978] xhci_hcd 0000:00:14.0: @ffff880211eb7048 (virt) @211eb7048 (dma) 0x000000 - deq
2014-03-01T10:54:20.972610+01:00 vnas kernel: [  163.520994] xhci_hcd 0000:00:14.0: @ffff880211eb7050 (virt) @211eb7050 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.972627+01:00 vnas kernel: [  163.521005] xhci_hcd 0000:00:14.0: @ffff880211eb7054 (virt) @211eb7054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.972629+01:00 vnas kernel: [  163.521013] xhci_hcd 0000:00:14.0: @ffff880211eb7058 (virt) @211eb7058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.972638+01:00 vnas kernel: [  163.521027] xhci_hcd 0000:00:14.0: @ffff880211eb705c (virt) @211eb705c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.972649+01:00 vnas kernel: [  163.521038] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:20.972660+01:00 vnas kernel: [  163.521049] xhci_hcd 0000:00:14.0: @ffff880211eb7060 (virt) @211eb7060 (dma) 0x0a0001 - ep_info
2014-03-01T10:54:20.972672+01:00 vnas kernel: [  163.521060] xhci_hcd 0000:00:14.0: @ffff880211eb7064 (virt) @211eb7064 (dma) 0x01003e - ep_info2
2014-03-01T10:54:20.973272+01:00 vnas kernel: [  163.521072] xhci_hcd 0000:00:14.0: @ffff880211eb7068 (virt) @211eb7068 (dma) 0x2109b0001 - deq
2014-03-01T10:54:20.973280+01:00 vnas kernel: [  163.521083] xhci_hcd 0000:00:14.0: @ffff880211eb7070 (virt) @211eb7070 (dma) 0x010001 - tx_info
2014-03-01T10:54:20.973283+01:00 vnas kernel: [  163.521091] xhci_hcd 0000:00:14.0: @ffff880211eb7074 (virt) @211eb7074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973286+01:00 vnas kernel: [  163.521098] xhci_hcd 0000:00:14.0: @ffff880211eb7078 (virt) @211eb7078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973288+01:00 vnas kernel: [  163.521105] xhci_hcd 0000:00:14.0: @ffff880211eb707c (virt) @211eb707c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973290+01:00 vnas kernel: [  163.521112] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:20.973293+01:00 vnas kernel: [  163.521119] xhci_hcd 0000:00:14.0: @ffff880211eb7080 (virt) @211eb7080 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.973295+01:00 vnas kernel: [  163.521126] xhci_hcd 0000:00:14.0: @ffff880211eb7084 (virt) @211eb7084 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.973298+01:00 vnas kernel: [  163.521133] xhci_hcd 0000:00:14.0: @ffff880211eb7088 (virt) @211eb7088 (dma) 0x000000 - deq
2014-03-01T10:54:20.973300+01:00 vnas kernel: [  163.521140] xhci_hcd 0000:00:14.0: @ffff880211eb7090 (virt) @211eb7090 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.973303+01:00 vnas kernel: [  163.521147] xhci_hcd 0000:00:14.0: @ffff880211eb7094 (virt) @211eb7094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973305+01:00 vnas kernel: [  163.521155] xhci_hcd 0000:00:14.0: @ffff880211eb7098 (virt) @211eb7098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973308+01:00 vnas kernel: [  163.521162] xhci_hcd 0000:00:14.0: @ffff880211eb709c (virt) @211eb709c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973310+01:00 vnas kernel: [  163.521169] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:20.973313+01:00 vnas kernel: [  163.521176] xhci_hcd 0000:00:14.0: @ffff880211eb70a0 (virt) @211eb70a0 (dma) 0x000001 - ep_info
2014-03-01T10:54:20.973315+01:00 vnas kernel: [  163.521183] xhci_hcd 0000:00:14.0: @ffff880211eb70a4 (virt) @211eb70a4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:20.973317+01:00 vnas kernel: [  163.521191] xhci_hcd 0000:00:14.0: @ffff880211eb70a8 (virt) @211eb70a8 (dma) 0x2109b0801 - deq
2014-03-01T10:54:20.973320+01:00 vnas kernel: [  163.521198] xhci_hcd 0000:00:14.0: @ffff880211eb70b0 (virt) @211eb70b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.973322+01:00 vnas kernel: [  163.521205] xhci_hcd 0000:00:14.0: @ffff880211eb70b4 (virt) @211eb70b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973324+01:00 vnas kernel: [  163.521213] xhci_hcd 0000:00:14.0: @ffff880211eb70b8 (virt) @211eb70b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973327+01:00 vnas kernel: [  163.521220] xhci_hcd 0000:00:14.0: @ffff880211eb70bc (virt) @211eb70bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973330+01:00 vnas kernel: [  163.521227] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:20.973332+01:00 vnas kernel: [  163.521234] xhci_hcd 0000:00:14.0: @ffff880211eb70c0 (virt) @211eb70c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.973334+01:00 vnas kernel: [  163.521241] xhci_hcd 0000:00:14.0: @ffff880211eb70c4 (virt) @211eb70c4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.973337+01:00 vnas kernel: [  163.521248] xhci_hcd 0000:00:14.0: @ffff880211eb70c8 (virt) @211eb70c8 (dma) 0x000000 - deq
2014-03-01T10:54:20.973339+01:00 vnas kernel: [  163.521255] xhci_hcd 0000:00:14.0: @ffff880211eb70d0 (virt) @211eb70d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.973341+01:00 vnas kernel: [  163.521262] xhci_hcd 0000:00:14.0: @ffff880211eb70d4 (virt) @211eb70d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973344+01:00 vnas kernel: [  163.521271] xhci_hcd 0000:00:14.0: @ffff880211eb70d8 (virt) @211eb70d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973347+01:00 vnas kernel: [  163.521281] xhci_hcd 0000:00:14.0: @ffff880211eb70dc (virt) @211eb70dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973349+01:00 vnas kernel: [  163.521287] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:20.973352+01:00 vnas kernel: [  163.521294] xhci_hcd 0000:00:14.0: @ffff880211eb70e0 (virt) @211eb70e0 (dma) 0x030001 - ep_info
2014-03-01T10:54:20.973354+01:00 vnas kernel: [  163.521301] xhci_hcd 0000:00:14.0: @ffff880211eb70e4 (virt) @211eb70e4 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:20.973357+01:00 vnas kernel: [  163.521309] xhci_hcd 0000:00:14.0: @ffff880211eb70e8 (virt) @211eb70e8 (dma) 0x21154e401 - deq
2014-03-01T10:54:20.973359+01:00 vnas kernel: [  163.521316] xhci_hcd 0000:00:14.0: @ffff880211eb70f0 (virt) @211eb70f0 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:20.973362+01:00 vnas kernel: [  163.521323] xhci_hcd 0000:00:14.0: @ffff880211eb70f4 (virt) @211eb70f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973364+01:00 vnas kernel: [  163.521330] xhci_hcd 0000:00:14.0: @ffff880211eb70f8 (virt) @211eb70f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973367+01:00 vnas kernel: [  163.521338] xhci_hcd 0000:00:14.0: @ffff880211eb70fc (virt) @211eb70fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973369+01:00 vnas kernel: [  163.521344] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:20.973372+01:00 vnas kernel: [  163.521351] xhci_hcd 0000:00:14.0: @ffff880211eb7100 (virt) @211eb7100 (dma) 0x000000 - ep_info
2014-03-01T10:54:20.973374+01:00 vnas kernel: [  163.521358] xhci_hcd 0000:00:14.0: @ffff880211eb7104 (virt) @211eb7104 (dma) 0x000000 - ep_info2
2014-03-01T10:54:20.973377+01:00 vnas kernel: [  163.521365] xhci_hcd 0000:00:14.0: @ffff880211eb7108 (virt) @211eb7108 (dma) 0x000000 - deq
2014-03-01T10:54:20.973379+01:00 vnas kernel: [  163.521372] xhci_hcd 0000:00:14.0: @ffff880211eb7110 (virt) @211eb7110 (dma) 0x000000 - tx_info
2014-03-01T10:54:20.973382+01:00 vnas kernel: [  163.521379] xhci_hcd 0000:00:14.0: @ffff880211eb7114 (virt) @211eb7114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973384+01:00 vnas kernel: [  163.521387] xhci_hcd 0000:00:14.0: @ffff880211eb7118 (virt) @211eb7118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973387+01:00 vnas kernel: [  163.521394] xhci_hcd 0000:00:14.0: @ffff880211eb711c (virt) @211eb711c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973389+01:00 vnas kernel: [  163.521401] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:20.973392+01:00 vnas kernel: [  163.521408] xhci_hcd 0000:00:14.0: @ffff880211eb7120 (virt) @211eb7120 (dma) 0x000001 - ep_info
2014-03-01T10:54:20.973394+01:00 vnas kernel: [  163.521415] xhci_hcd 0000:00:14.0: @ffff880211eb7124 (virt) @211eb7124 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:20.973396+01:00 vnas kernel: [  163.521423] xhci_hcd 0000:00:14.0: @ffff880211eb7128 (virt) @211eb7128 (dma) 0x211eb0001 - deq
2014-03-01T10:54:20.973399+01:00 vnas kernel: [  163.521430] xhci_hcd 0000:00:14.0: @ffff880211eb7130 (virt) @211eb7130 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:20.973401+01:00 vnas kernel: [  163.521440] xhci_hcd 0000:00:14.0: @ffff880211eb7134 (virt) @211eb7134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:20.973403+01:00 vnas kernel: [  163.521447] xhci_hcd 0000:00:14.0: @ffff880211eb7138 (virt) @211eb7138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:20.973406+01:00 vnas kernel: [  163.521455] xhci_hcd 0000:00:14.0: @ffff880211eb713c (virt) @211eb713c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:20.973408+01:00 vnas kernel: [  163.521490] xhci_hcd 0000:00:14.0: Cached old ring, 1 ring cached
2014-03-01T10:54:20.973410+01:00 vnas kernel: [  163.521511] xhci_hcd 0000:00:14.0: Cached old ring, 2 rings cached
2014-03-01T10:54:20.973412+01:00 vnas kernel: [  163.521531] xhci_hcd 0000:00:14.0: Cached old ring, 3 rings cached
2014-03-01T10:54:20.973415+01:00 vnas kernel: [  163.521550] xhci_hcd 0000:00:14.0: Cached old ring, 4 rings cached
2014-03-01T10:54:20.974169+01:00 vnas kernel: [  163.521891] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
2014-03-01T10:54:20.974178+01:00 vnas kernel: [  163.521899] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
2014-03-01T10:54:20.974181+01:00 vnas kernel: [  163.521906] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
2014-03-01T10:54:20.974184+01:00 vnas kernel: [  163.521913] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
2014-03-01T10:54:20.974187+01:00 vnas kernel: [  163.522254] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:20.974189+01:00 vnas kernel: [  163.522272] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 4 segments
2014-03-01T10:54:20.974192+01:00 vnas kernel: [  163.522318] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:20.974195+01:00 vnas kernel: [  163.522330] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 8 segments
2014-03-01T10:54:21.065771+01:00 vnas kernel: [  163.613967] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:21.065813+01:00 vnas kernel: [  163.613984] xhci_hcd 0000:00:14.0: Giveback URB ffff880035d04600, len = 10, expected = 512, status = -121
2014-03-01T10:54:21.465223+01:00 vnas kernel: [  164.012370] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880211c07000
2014-03-01T10:54:21.465254+01:00 vnas kernel: [  164.012384] xhci_hcd 0000:00:14.0: drop ep 0x81, slot id 11, new drop flags = 0x8, new add flags = 0x0, new slot info = 0x8300003
2014-03-01T10:54:21.465258+01:00 vnas kernel: [  164.012389] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880211c07000
2014-03-01T10:54:21.465261+01:00 vnas kernel: [  164.012395] xhci_hcd 0000:00:14.0: drop ep 0x82, slot id 11, new drop flags = 0x28, new add flags = 0x0, new slot info = 0x8300003
2014-03-01T10:54:21.465263+01:00 vnas kernel: [  164.012399] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880211c07000
2014-03-01T10:54:21.465266+01:00 vnas kernel: [  164.012403] xhci_hcd 0000:00:14.0: drop ep 0x83, slot id 11, new drop flags = 0xa8, new add flags = 0x0, new slot info = 0x8300003
2014-03-01T10:54:21.465268+01:00 vnas kernel: [  164.012407] xhci_hcd 0000:00:14.0: xhci_drop_endpoint called for udev ffff880211c07000
2014-03-01T10:54:21.465270+01:00 vnas kernel: [  164.012412] xhci_hcd 0000:00:14.0: drop ep 0x84, slot id 11, new drop flags = 0x2a8, new add flags = 0x0, new slot info = 0x8300003
2014-03-01T10:54:21.465273+01:00 vnas kernel: [  164.012431] xhci_hcd 0000:00:14.0: add ep 0x81, slot id 11, new drop flags = 0x2a8, new add flags = 0x8, new slot info = 0x18300003
2014-03-01T10:54:21.465276+01:00 vnas kernel: [  164.012438] xhci_hcd 0000:00:14.0: add ep 0x82, slot id 11, new drop flags = 0x2a8, new add flags = 0x28, new slot info = 0x28300003
2014-03-01T10:54:21.465278+01:00 vnas kernel: [  164.012445] xhci_hcd 0000:00:14.0: add ep 0x83, slot id 11, new drop flags = 0x2a8, new add flags = 0xa8, new slot info = 0x38300003
2014-03-01T10:54:21.465280+01:00 vnas kernel: [  164.012453] xhci_hcd 0000:00:14.0: add ep 0x84, slot id 11, new drop flags = 0x2a8, new add flags = 0x2a8, new slot info = 0x48300003
2014-03-01T10:54:21.465286+01:00 vnas kernel: [  164.012458] xhci_hcd 0000:00:14.0: xhci_check_bandwidth called for udev ffff880211c07000
2014-03-01T10:54:21.465312+01:00 vnas kernel: [  164.012461] xhci_hcd 0000:00:14.0: New Input Control Context:
2014-03-01T10:54:21.465315+01:00 vnas kernel: [  164.012467] xhci_hcd 0000:00:14.0: @ffff8800cfd62000 (virt) @cfd62000 (dma) 0x0002a8 - drop flags
2014-03-01T10:54:21.465317+01:00 vnas kernel: [  164.012471] xhci_hcd 0000:00:14.0: @ffff8800cfd62004 (virt) @cfd62004 (dma) 0x0002a9 - add flags
2014-03-01T10:54:21.465320+01:00 vnas kernel: [  164.012476] xhci_hcd 0000:00:14.0: @ffff8800cfd62008 (virt) @cfd62008 (dma) 0x000000 - rsvd2[0]
2014-03-01T10:54:21.465322+01:00 vnas kernel: [  164.012480] xhci_hcd 0000:00:14.0: @ffff8800cfd6200c (virt) @cfd6200c (dma) 0x000000 - rsvd2[1]
2014-03-01T10:54:21.465325+01:00 vnas kernel: [  164.012484] xhci_hcd 0000:00:14.0: @ffff8800cfd62010 (virt) @cfd62010 (dma) 0x000000 - rsvd2[2]
2014-03-01T10:54:21.465339+01:00 vnas kernel: [  164.012488] xhci_hcd 0000:00:14.0: @ffff8800cfd62014 (virt) @cfd62014 (dma) 0x000000 - rsvd2[3]
2014-03-01T10:54:21.465341+01:00 vnas kernel: [  164.012492] xhci_hcd 0000:00:14.0: @ffff8800cfd62018 (virt) @cfd62018 (dma) 0x000000 - rsvd2[4]
2014-03-01T10:54:21.465343+01:00 vnas kernel: [  164.012495] xhci_hcd 0000:00:14.0: @ffff8800cfd6201c (virt) @cfd6201c (dma) 0x000000 - rsvd2[5]
2014-03-01T10:54:21.465345+01:00 vnas kernel: [  164.012499] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:21.465347+01:00 vnas kernel: [  164.012503] xhci_hcd 0000:00:14.0: @ffff8800cfd62020 (virt) @cfd62020 (dma) 0x48300003 - dev_info
2014-03-01T10:54:21.465350+01:00 vnas kernel: [  164.012507] xhci_hcd 0000:00:14.0: @ffff8800cfd62024 (virt) @cfd62024 (dma) 0x010000 - dev_info2
2014-03-01T10:54:21.465352+01:00 vnas kernel: [  164.012511] xhci_hcd 0000:00:14.0: @ffff8800cfd62028 (virt) @cfd62028 (dma) 0x000000 - tt_info
2014-03-01T10:54:21.465354+01:00 vnas kernel: [  164.012515] xhci_hcd 0000:00:14.0: @ffff8800cfd6202c (virt) @cfd6202c (dma) 0x000000 - dev_state
2014-03-01T10:54:21.465357+01:00 vnas kernel: [  164.012519] xhci_hcd 0000:00:14.0: @ffff8800cfd62030 (virt) @cfd62030 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465359+01:00 vnas kernel: [  164.012523] xhci_hcd 0000:00:14.0: @ffff8800cfd62034 (virt) @cfd62034 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465361+01:00 vnas kernel: [  164.012527] xhci_hcd 0000:00:14.0: @ffff8800cfd62038 (virt) @cfd62038 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465363+01:00 vnas kernel: [  164.012531] xhci_hcd 0000:00:14.0: @ffff8800cfd6203c (virt) @cfd6203c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:21.465365+01:00 vnas kernel: [  164.012536] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:21.465368+01:00 vnas kernel: [  164.012540] xhci_hcd 0000:00:14.0: @ffff8800cfd62040 (virt) @cfd62040 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465370+01:00 vnas kernel: [  164.012544] xhci_hcd 0000:00:14.0: @ffff8800cfd62044 (virt) @cfd62044 (dma) 0x400026 - ep_info2
2014-03-01T10:54:21.465373+01:00 vnas kernel: [  164.012548] xhci_hcd 0000:00:14.0: @ffff8800cfd62048 (virt) @cfd62048 (dma) 0x3580c431 - deq
2014-03-01T10:54:21.465375+01:00 vnas kernel: [  164.012552] xhci_hcd 0000:00:14.0: @ffff8800cfd62050 (virt) @cfd62050 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465378+01:00 vnas kernel: [  164.012556] xhci_hcd 0000:00:14.0: @ffff8800cfd62054 (virt) @cfd62054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465380+01:00 vnas kernel: [  164.012560] xhci_hcd 0000:00:14.0: @ffff8800cfd62058 (virt) @cfd62058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465383+01:00 vnas kernel: [  164.012564] xhci_hcd 0000:00:14.0: @ffff8800cfd6205c (virt) @cfd6205c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465385+01:00 vnas kernel: [  164.012568] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:21.465388+01:00 vnas kernel: [  164.012572] xhci_hcd 0000:00:14.0: @ffff8800cfd62060 (virt) @cfd62060 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465390+01:00 vnas kernel: [  164.012576] xhci_hcd 0000:00:14.0: @ffff8800cfd62064 (virt) @cfd62064 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.465393+01:00 vnas kernel: [  164.012580] xhci_hcd 0000:00:14.0: @ffff8800cfd62068 (virt) @cfd62068 (dma) 0x000000 - deq
2014-03-01T10:54:21.465395+01:00 vnas kernel: [  164.012584] xhci_hcd 0000:00:14.0: @ffff8800cfd62070 (virt) @cfd62070 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465398+01:00 vnas kernel: [  164.012588] xhci_hcd 0000:00:14.0: @ffff8800cfd62074 (virt) @cfd62074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465400+01:00 vnas kernel: [  164.012592] xhci_hcd 0000:00:14.0: @ffff8800cfd62078 (virt) @cfd62078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465403+01:00 vnas kernel: [  164.012596] xhci_hcd 0000:00:14.0: @ffff8800cfd6207c (virt) @cfd6207c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465406+01:00 vnas kernel: [  164.012600] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:21.465408+01:00 vnas kernel: [  164.012604] xhci_hcd 0000:00:14.0: @ffff8800cfd62080 (virt) @cfd62080 (dma) 0x0a0000 - ep_info
2014-03-01T10:54:21.465410+01:00 vnas kernel: [  164.012607] xhci_hcd 0000:00:14.0: @ffff8800cfd62084 (virt) @cfd62084 (dma) 0x01003e - ep_info2
2014-03-01T10:54:21.465413+01:00 vnas kernel: [  164.012611] xhci_hcd 0000:00:14.0: @ffff8800cfd62088 (virt) @cfd62088 (dma) 0x21014f801 - deq
2014-03-01T10:54:21.465415+01:00 vnas kernel: [  164.012615] xhci_hcd 0000:00:14.0: @ffff8800cfd62090 (virt) @cfd62090 (dma) 0x010001 - tx_info
2014-03-01T10:54:21.465417+01:00 vnas kernel: [  164.012619] xhci_hcd 0000:00:14.0: @ffff8800cfd62094 (virt) @cfd62094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465419+01:00 vnas kernel: [  164.012623] xhci_hcd 0000:00:14.0: @ffff8800cfd62098 (virt) @cfd62098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465422+01:00 vnas kernel: [  164.012627] xhci_hcd 0000:00:14.0: @ffff8800cfd6209c (virt) @cfd6209c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465424+01:00 vnas kernel: [  164.012631] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:21.465427+01:00 vnas kernel: [  164.012635] xhci_hcd 0000:00:14.0: @ffff8800cfd620a0 (virt) @cfd620a0 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465429+01:00 vnas kernel: [  164.012639] xhci_hcd 0000:00:14.0: @ffff8800cfd620a4 (virt) @cfd620a4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.465432+01:00 vnas kernel: [  164.012643] xhci_hcd 0000:00:14.0: @ffff8800cfd620a8 (virt) @cfd620a8 (dma) 0x000000 - deq
2014-03-01T10:54:21.465434+01:00 vnas kernel: [  164.012646] xhci_hcd 0000:00:14.0: @ffff8800cfd620b0 (virt) @cfd620b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465437+01:00 vnas kernel: [  164.012650] xhci_hcd 0000:00:14.0: @ffff8800cfd620b4 (virt) @cfd620b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465439+01:00 vnas kernel: [  164.012654] xhci_hcd 0000:00:14.0: @ffff8800cfd620b8 (virt) @cfd620b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465442+01:00 vnas kernel: [  164.012658] xhci_hcd 0000:00:14.0: @ffff8800cfd620bc (virt) @cfd620bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465444+01:00 vnas kernel: [  164.012662] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:21.465447+01:00 vnas kernel: [  164.012666] xhci_hcd 0000:00:14.0: @ffff8800cfd620c0 (virt) @cfd620c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465449+01:00 vnas kernel: [  164.012670] xhci_hcd 0000:00:14.0: @ffff8800cfd620c4 (virt) @cfd620c4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:21.465452+01:00 vnas kernel: [  164.012674] xhci_hcd 0000:00:14.0: @ffff8800cfd620c8 (virt) @cfd620c8 (dma) 0x35ffd401 - deq
2014-03-01T10:54:21.465454+01:00 vnas kernel: [  164.012678] xhci_hcd 0000:00:14.0: @ffff8800cfd620d0 (virt) @cfd620d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465456+01:00 vnas kernel: [  164.012682] xhci_hcd 0000:00:14.0: @ffff8800cfd620d4 (virt) @cfd620d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465459+01:00 vnas kernel: [  164.012686] xhci_hcd 0000:00:14.0: @ffff8800cfd620d8 (virt) @cfd620d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465462+01:00 vnas kernel: [  164.012690] xhci_hcd 0000:00:14.0: @ffff8800cfd620dc (virt) @cfd620dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465464+01:00 vnas kernel: [  164.012694] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:21.465467+01:00 vnas kernel: [  164.012698] xhci_hcd 0000:00:14.0: @ffff8800cfd620e0 (virt) @cfd620e0 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465469+01:00 vnas kernel: [  164.012702] xhci_hcd 0000:00:14.0: @ffff8800cfd620e4 (virt) @cfd620e4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.465471+01:00 vnas kernel: [  164.012706] xhci_hcd 0000:00:14.0: @ffff8800cfd620e8 (virt) @cfd620e8 (dma) 0x000000 - deq
2014-03-01T10:54:21.465474+01:00 vnas kernel: [  164.012709] xhci_hcd 0000:00:14.0: @ffff8800cfd620f0 (virt) @cfd620f0 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465476+01:00 vnas kernel: [  164.012713] xhci_hcd 0000:00:14.0: @ffff8800cfd620f4 (virt) @cfd620f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465479+01:00 vnas kernel: [  164.012717] xhci_hcd 0000:00:14.0: @ffff8800cfd620f8 (virt) @cfd620f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465482+01:00 vnas kernel: [  164.012721] xhci_hcd 0000:00:14.0: @ffff8800cfd620fc (virt) @cfd620fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465560+01:00 vnas kernel: [  164.012725] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:21.465563+01:00 vnas kernel: [  164.012729] xhci_hcd 0000:00:14.0: @ffff8800cfd62100 (virt) @cfd62100 (dma) 0x030000 - ep_info
2014-03-01T10:54:21.465565+01:00 vnas kernel: [  164.012733] xhci_hcd 0000:00:14.0: @ffff8800cfd62104 (virt) @cfd62104 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:21.465568+01:00 vnas kernel: [  164.012737] xhci_hcd 0000:00:14.0: @ffff8800cfd62108 (virt) @cfd62108 (dma) 0xd0cf1001 - deq
2014-03-01T10:54:21.465570+01:00 vnas kernel: [  164.012740] xhci_hcd 0000:00:14.0: @ffff8800cfd62110 (virt) @cfd62110 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:21.465573+01:00 vnas kernel: [  164.012744] xhci_hcd 0000:00:14.0: @ffff8800cfd62114 (virt) @cfd62114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465575+01:00 vnas kernel: [  164.012748] xhci_hcd 0000:00:14.0: @ffff8800cfd62118 (virt) @cfd62118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465577+01:00 vnas kernel: [  164.012752] xhci_hcd 0000:00:14.0: @ffff8800cfd6211c (virt) @cfd6211c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465579+01:00 vnas kernel: [  164.012756] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:21.465582+01:00 vnas kernel: [  164.012760] xhci_hcd 0000:00:14.0: @ffff8800cfd62120 (virt) @cfd62120 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465584+01:00 vnas kernel: [  164.012764] xhci_hcd 0000:00:14.0: @ffff8800cfd62124 (virt) @cfd62124 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.465587+01:00 vnas kernel: [  164.012767] xhci_hcd 0000:00:14.0: @ffff8800cfd62128 (virt) @cfd62128 (dma) 0x000000 - deq
2014-03-01T10:54:21.465590+01:00 vnas kernel: [  164.012771] xhci_hcd 0000:00:14.0: @ffff8800cfd62130 (virt) @cfd62130 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.465592+01:00 vnas kernel: [  164.012775] xhci_hcd 0000:00:14.0: @ffff8800cfd62134 (virt) @cfd62134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465594+01:00 vnas kernel: [  164.012779] xhci_hcd 0000:00:14.0: @ffff8800cfd62138 (virt) @cfd62138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465596+01:00 vnas kernel: [  164.012783] xhci_hcd 0000:00:14.0: @ffff8800cfd6213c (virt) @cfd6213c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465599+01:00 vnas kernel: [  164.012787] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:21.465601+01:00 vnas kernel: [  164.012790] xhci_hcd 0000:00:14.0: @ffff8800cfd62140 (virt) @cfd62140 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.465603+01:00 vnas kernel: [  164.012794] xhci_hcd 0000:00:14.0: @ffff8800cfd62144 (virt) @cfd62144 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:21.465606+01:00 vnas kernel: [  164.012798] xhci_hcd 0000:00:14.0: @ffff8800cfd62148 (virt) @cfd62148 (dma) 0xd0cf1801 - deq
2014-03-01T10:54:21.465608+01:00 vnas kernel: [  164.012802] xhci_hcd 0000:00:14.0: @ffff8800cfd62150 (virt) @cfd62150 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:21.465610+01:00 vnas kernel: [  164.012806] xhci_hcd 0000:00:14.0: @ffff8800cfd62154 (virt) @cfd62154 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.465612+01:00 vnas kernel: [  164.012810] xhci_hcd 0000:00:14.0: @ffff8800cfd62158 (virt) @cfd62158 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.465614+01:00 vnas kernel: [  164.012815] xhci_hcd 0000:00:14.0: @ffff8800cfd6215c (virt) @cfd6215c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.465616+01:00 vnas kernel: [  164.012820] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:21.465618+01:00 vnas kernel: [  164.013224] xhci_hcd 0000:00:14.0: Completed config ep cmd
2014-03-01T10:54:21.466974+01:00 vnas kernel: [  164.014088] xhci_hcd 0000:00:14.0: Successful Endpoint Configure command
2014-03-01T10:54:21.466982+01:00 vnas kernel: [  164.014097] xhci_hcd 0000:00:14.0: Output context after successful config ep cmd:
2014-03-01T10:54:21.466985+01:00 vnas kernel: [  164.014103] xhci_hcd 0000:00:14.0: Slot Context:
2014-03-01T10:54:21.466988+01:00 vnas kernel: [  164.014111] xhci_hcd 0000:00:14.0: @ffff8800cfd64000 (virt) @cfd64000 (dma) 0x48300003 - dev_info
2014-03-01T10:54:21.466991+01:00 vnas kernel: [  164.014118] xhci_hcd 0000:00:14.0: @ffff8800cfd64004 (virt) @cfd64004 (dma) 0x010000 - dev_info2
2014-03-01T10:54:21.466994+01:00 vnas kernel: [  164.014125] xhci_hcd 0000:00:14.0: @ffff8800cfd64008 (virt) @cfd64008 (dma) 0x000000 - tt_info
2014-03-01T10:54:21.466996+01:00 vnas kernel: [  164.014132] xhci_hcd 0000:00:14.0: @ffff8800cfd6400c (virt) @cfd6400c (dma) 0x1800000b - dev_state
2014-03-01T10:54:21.466999+01:00 vnas kernel: [  164.014140] xhci_hcd 0000:00:14.0: @ffff8800cfd64010 (virt) @cfd64010 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467002+01:00 vnas kernel: [  164.014147] xhci_hcd 0000:00:14.0: @ffff8800cfd64014 (virt) @cfd64014 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467004+01:00 vnas kernel: [  164.014154] xhci_hcd 0000:00:14.0: @ffff8800cfd64018 (virt) @cfd64018 (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467007+01:00 vnas kernel: [  164.014161] xhci_hcd 0000:00:14.0: @ffff8800cfd6401c (virt) @cfd6401c (dma) 0x000000 - rsvd[3]
2014-03-01T10:54:21.467009+01:00 vnas kernel: [  164.014168] xhci_hcd 0000:00:14.0: IN Endpoint 00 Context (ep_index 00):
2014-03-01T10:54:21.467012+01:00 vnas kernel: [  164.014175] xhci_hcd 0000:00:14.0: @ffff8800cfd64020 (virt) @cfd64020 (dma) 0x000001 - ep_info
2014-03-01T10:54:21.467014+01:00 vnas kernel: [  164.014183] xhci_hcd 0000:00:14.0: @ffff8800cfd64024 (virt) @cfd64024 (dma) 0x400026 - ep_info2
2014-03-01T10:54:21.467017+01:00 vnas kernel: [  164.014190] xhci_hcd 0000:00:14.0: @ffff8800cfd64028 (virt) @cfd64028 (dma) 0x3580c431 - deq
2014-03-01T10:54:21.467019+01:00 vnas kernel: [  164.014198] xhci_hcd 0000:00:14.0: @ffff8800cfd64030 (virt) @cfd64030 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467022+01:00 vnas kernel: [  164.014206] xhci_hcd 0000:00:14.0: @ffff8800cfd64034 (virt) @cfd64034 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467024+01:00 vnas kernel: [  164.014214] xhci_hcd 0000:00:14.0: @ffff8800cfd64038 (virt) @cfd64038 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467027+01:00 vnas kernel: [  164.014221] xhci_hcd 0000:00:14.0: @ffff8800cfd6403c (virt) @cfd6403c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467029+01:00 vnas kernel: [  164.014231] xhci_hcd 0000:00:14.0: OUT Endpoint 01 Context (ep_index 01):
2014-03-01T10:54:21.467032+01:00 vnas kernel: [  164.014238] xhci_hcd 0000:00:14.0: @ffff8800cfd64040 (virt) @cfd64040 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.467034+01:00 vnas kernel: [  164.014245] xhci_hcd 0000:00:14.0: @ffff8800cfd64044 (virt) @cfd64044 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.467037+01:00 vnas kernel: [  164.014253] xhci_hcd 0000:00:14.0: @ffff8800cfd64048 (virt) @cfd64048 (dma) 0x000000 - deq
2014-03-01T10:54:21.467039+01:00 vnas kernel: [  164.014260] xhci_hcd 0000:00:14.0: @ffff8800cfd64050 (virt) @cfd64050 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467042+01:00 vnas kernel: [  164.014267] xhci_hcd 0000:00:14.0: @ffff8800cfd64054 (virt) @cfd64054 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467044+01:00 vnas kernel: [  164.014274] xhci_hcd 0000:00:14.0: @ffff8800cfd64058 (virt) @cfd64058 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467047+01:00 vnas kernel: [  164.014285] xhci_hcd 0000:00:14.0: ep 0x82 - asked for 512 bytes, 502 bytes untransferred
2014-03-01T10:54:21.467049+01:00 vnas kernel: [  164.014289] xhci_hcd 0000:00:14.0: @ffff8800cfd6405c (virt) @cfd6405c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467052+01:00 vnas kernel: [  164.014297] xhci_hcd 0000:00:14.0: IN Endpoint 01 Context (ep_index 02):
2014-03-01T10:54:21.467054+01:00 vnas kernel: [  164.014304] xhci_hcd 0000:00:14.0: @ffff8800cfd64060 (virt) @cfd64060 (dma) 0x0a0001 - ep_info
2014-03-01T10:54:21.467057+01:00 vnas kernel: [  164.014310] xhci_hcd 0000:00:14.0: @ffff8800cfd64064 (virt) @cfd64064 (dma) 0x01003e - ep_info2
2014-03-01T10:54:21.467075+01:00 vnas kernel: [  164.014316] xhci_hcd 0000:00:14.0: @ffff8800cfd64068 (virt) @cfd64068 (dma) 0x21014f801 - deq
2014-03-01T10:54:21.467078+01:00 vnas kernel: [  164.014323] xhci_hcd 0000:00:14.0: @ffff8800cfd64070 (virt) @cfd64070 (dma) 0x010001 - tx_info
2014-03-01T10:54:21.467080+01:00 vnas kernel: [  164.014329] xhci_hcd 0000:00:14.0: @ffff8800cfd64074 (virt) @cfd64074 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467083+01:00 vnas kernel: [  164.014335] xhci_hcd 0000:00:14.0: @ffff8800cfd64078 (virt) @cfd64078 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467085+01:00 vnas kernel: [  164.014342] xhci_hcd 0000:00:14.0: @ffff8800cfd6407c (virt) @cfd6407c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467088+01:00 vnas kernel: [  164.014347] xhci_hcd 0000:00:14.0: OUT Endpoint 02 Context (ep_index 03):
2014-03-01T10:54:21.467090+01:00 vnas kernel: [  164.014353] xhci_hcd 0000:00:14.0: @ffff8800cfd64080 (virt) @cfd64080 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.467093+01:00 vnas kernel: [  164.014359] xhci_hcd 0000:00:14.0: @ffff8800cfd64084 (virt) @cfd64084 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.467095+01:00 vnas kernel: [  164.014365] xhci_hcd 0000:00:14.0: @ffff8800cfd64088 (virt) @cfd64088 (dma) 0x000000 - deq
2014-03-01T10:54:21.467098+01:00 vnas kernel: [  164.014371] xhci_hcd 0000:00:14.0: @ffff8800cfd64090 (virt) @cfd64090 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467100+01:00 vnas kernel: [  164.014377] xhci_hcd 0000:00:14.0: @ffff8800cfd64094 (virt) @cfd64094 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467103+01:00 vnas kernel: [  164.014383] xhci_hcd 0000:00:14.0: @ffff8800cfd64098 (virt) @cfd64098 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467105+01:00 vnas kernel: [  164.014389] xhci_hcd 0000:00:14.0: @ffff8800cfd6409c (virt) @cfd6409c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467108+01:00 vnas kernel: [  164.014395] xhci_hcd 0000:00:14.0: IN Endpoint 02 Context (ep_index 04):
2014-03-01T10:54:21.467110+01:00 vnas kernel: [  164.014401] xhci_hcd 0000:00:14.0: @ffff8800cfd640a0 (virt) @cfd640a0 (dma) 0x000001 - ep_info
2014-03-01T10:54:21.467112+01:00 vnas kernel: [  164.014407] xhci_hcd 0000:00:14.0: @ffff8800cfd640a4 (virt) @cfd640a4 (dma) 0x000028 - ep_info2
2014-03-01T10:54:21.467115+01:00 vnas kernel: [  164.014413] xhci_hcd 0000:00:14.0: @ffff8800cfd640a8 (virt) @cfd640a8 (dma) 0x35ffd401 - deq
2014-03-01T10:54:21.467117+01:00 vnas kernel: [  164.014419] xhci_hcd 0000:00:14.0: @ffff8800cfd640b0 (virt) @cfd640b0 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467120+01:00 vnas kernel: [  164.014425] xhci_hcd 0000:00:14.0: @ffff8800cfd640b4 (virt) @cfd640b4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467123+01:00 vnas kernel: [  164.014431] xhci_hcd 0000:00:14.0: @ffff8800cfd640b8 (virt) @cfd640b8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467125+01:00 vnas kernel: [  164.014437] xhci_hcd 0000:00:14.0: @ffff8800cfd640bc (virt) @cfd640bc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467128+01:00 vnas kernel: [  164.014443] xhci_hcd 0000:00:14.0: OUT Endpoint 03 Context (ep_index 05):
2014-03-01T10:54:21.467130+01:00 vnas kernel: [  164.014452] xhci_hcd 0000:00:14.0: @ffff8800cfd640c0 (virt) @cfd640c0 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.467133+01:00 vnas kernel: [  164.014458] xhci_hcd 0000:00:14.0: @ffff8800cfd640c4 (virt) @cfd640c4 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.467135+01:00 vnas kernel: [  164.014464] xhci_hcd 0000:00:14.0: @ffff8800cfd640c8 (virt) @cfd640c8 (dma) 0x000000 - deq
2014-03-01T10:54:21.467138+01:00 vnas kernel: [  164.014470] xhci_hcd 0000:00:14.0: @ffff8800cfd640d0 (virt) @cfd640d0 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467140+01:00 vnas kernel: [  164.014476] xhci_hcd 0000:00:14.0: @ffff8800cfd640d4 (virt) @cfd640d4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467143+01:00 vnas kernel: [  164.014483] xhci_hcd 0000:00:14.0: @ffff8800cfd640d8 (virt) @cfd640d8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467145+01:00 vnas kernel: [  164.014489] xhci_hcd 0000:00:14.0: @ffff8800cfd640dc (virt) @cfd640dc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467148+01:00 vnas kernel: [  164.014495] xhci_hcd 0000:00:14.0: IN Endpoint 03 Context (ep_index 06):
2014-03-01T10:54:21.467150+01:00 vnas kernel: [  164.014501] xhci_hcd 0000:00:14.0: @ffff8800cfd640e0 (virt) @cfd640e0 (dma) 0x030001 - ep_info
2014-03-01T10:54:21.467153+01:00 vnas kernel: [  164.014507] xhci_hcd 0000:00:14.0: @ffff8800cfd640e4 (virt) @cfd640e4 (dma) 0xc40028 - ep_info2
2014-03-01T10:54:21.467155+01:00 vnas kernel: [  164.014513] xhci_hcd 0000:00:14.0: @ffff8800cfd640e8 (virt) @cfd640e8 (dma) 0xd0cf1001 - deq
2014-03-01T10:54:21.467158+01:00 vnas kernel: [  164.014519] xhci_hcd 0000:00:14.0: @ffff8800cfd640f0 (virt) @cfd640f0 (dma) 0xc400c4 - tx_info
2014-03-01T10:54:21.467160+01:00 vnas kernel: [  164.014525] xhci_hcd 0000:00:14.0: @ffff8800cfd640f4 (virt) @cfd640f4 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467163+01:00 vnas kernel: [  164.014531] xhci_hcd 0000:00:14.0: @ffff8800cfd640f8 (virt) @cfd640f8 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467165+01:00 vnas kernel: [  164.014537] xhci_hcd 0000:00:14.0: @ffff8800cfd640fc (virt) @cfd640fc (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467168+01:00 vnas kernel: [  164.014543] xhci_hcd 0000:00:14.0: OUT Endpoint 04 Context (ep_index 07):
2014-03-01T10:54:21.467170+01:00 vnas kernel: [  164.014549] xhci_hcd 0000:00:14.0: @ffff8800cfd64100 (virt) @cfd64100 (dma) 0x000000 - ep_info
2014-03-01T10:54:21.467173+01:00 vnas kernel: [  164.014555] xhci_hcd 0000:00:14.0: @ffff8800cfd64104 (virt) @cfd64104 (dma) 0x000000 - ep_info2
2014-03-01T10:54:21.467175+01:00 vnas kernel: [  164.014561] xhci_hcd 0000:00:14.0: @ffff8800cfd64108 (virt) @cfd64108 (dma) 0x000000 - deq
2014-03-01T10:54:21.467178+01:00 vnas kernel: [  164.014567] xhci_hcd 0000:00:14.0: @ffff8800cfd64110 (virt) @cfd64110 (dma) 0x000000 - tx_info
2014-03-01T10:54:21.467180+01:00 vnas kernel: [  164.014573] xhci_hcd 0000:00:14.0: @ffff8800cfd64114 (virt) @cfd64114 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467182+01:00 vnas kernel: [  164.014579] xhci_hcd 0000:00:14.0: @ffff8800cfd64118 (virt) @cfd64118 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467185+01:00 vnas kernel: [  164.014585] xhci_hcd 0000:00:14.0: @ffff8800cfd6411c (virt) @cfd6411c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467187+01:00 vnas kernel: [  164.014591] xhci_hcd 0000:00:14.0: IN Endpoint 04 Context (ep_index 08):
2014-03-01T10:54:21.467191+01:00 vnas kernel: [  164.014597] xhci_hcd 0000:00:14.0: @ffff8800cfd64120 (virt) @cfd64120 (dma) 0x000001 - ep_info
2014-03-01T10:54:21.467193+01:00 vnas kernel: [  164.014603] xhci_hcd 0000:00:14.0: @ffff8800cfd64124 (virt) @cfd64124 (dma) 0x3ac0028 - ep_info2
2014-03-01T10:54:21.467196+01:00 vnas kernel: [  164.014609] xhci_hcd 0000:00:14.0: @ffff8800cfd64128 (virt) @cfd64128 (dma) 0xd0cf1801 - deq
2014-03-01T10:54:21.467198+01:00 vnas kernel: [  164.014615] xhci_hcd 0000:00:14.0: @ffff8800cfd64130 (virt) @cfd64130 (dma) 0x3ac03ac - tx_info
2014-03-01T10:54:21.467201+01:00 vnas kernel: [  164.014621] xhci_hcd 0000:00:14.0: @ffff8800cfd64134 (virt) @cfd64134 (dma) 0x000000 - rsvd[0]
2014-03-01T10:54:21.467228+01:00 vnas kernel: [  164.014627] xhci_hcd 0000:00:14.0: @ffff8800cfd64138 (virt) @cfd64138 (dma) 0x000000 - rsvd[1]
2014-03-01T10:54:21.467230+01:00 vnas kernel: [  164.014634] xhci_hcd 0000:00:14.0: @ffff8800cfd6413c (virt) @cfd6413c (dma) 0x000000 - rsvd[2]
2014-03-01T10:54:21.467233+01:00 vnas kernel: [  164.014642] xhci_hcd 0000:00:14.0: Cached old ring, 1 ring cached
2014-03-01T10:54:21.467235+01:00 vnas kernel: [  164.014647] xhci_hcd 0000:00:14.0: Cached old ring, 2 rings cached
2014-03-01T10:54:21.467238+01:00 vnas kernel: [  164.014652] xhci_hcd 0000:00:14.0: Cached old ring, 3 rings cached
2014-03-01T10:54:21.467240+01:00 vnas kernel: [  164.014657] xhci_hcd 0000:00:14.0: Cached old ring, 4 rings cached
2014-03-01T10:54:21.467243+01:00 vnas kernel: [  164.014672] xhci_hcd 0000:00:14.0: Giveback URB ffff8802109619c0, len = 10, expected = 512, status = -121
2014-03-01T10:54:21.468118+01:00 vnas kernel: [  164.015434] xhci_hcd 0000:00:14.0: Endpoint 0x81 not halted, refusing to reset.
2014-03-01T10:54:21.468126+01:00 vnas kernel: [  164.015442] xhci_hcd 0000:00:14.0: Endpoint 0x82 not halted, refusing to reset.
2014-03-01T10:54:21.468129+01:00 vnas kernel: [  164.015448] xhci_hcd 0000:00:14.0: Endpoint 0x83 not halted, refusing to reset.
2014-03-01T10:54:21.468132+01:00 vnas kernel: [  164.015455] xhci_hcd 0000:00:14.0: Endpoint 0x84 not halted, refusing to reset.
2014-03-01T10:54:21.468134+01:00 vnas kernel: [  164.015808] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:21.468137+01:00 vnas kernel: [  164.015821] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 4 segments
2014-03-01T10:54:21.468139+01:00 vnas kernel: [  164.015867] xhci_hcd 0000:00:14.0: ERROR no room on ep ring, try ring expansion
2014-03-01T10:54:21.468142+01:00 vnas kernel: [  164.015886] xhci_hcd 0000:00:14.0: ring expansion succeed, now has 8 segments
2014-03-01T10:54:22.475162+01:00 vnas kernel: [  165.021291] xhci_hcd 0000:00:14.0: Cancel URB ffff880211540540, dev 1.2, ep 0x0, starting at offset 0x210a16710
2014-03-01T10:54:22.475204+01:00 vnas kernel: [  165.021303] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:22.517167+01:00 vnas kernel: [  165.063270] xhci_hcd 0000:00:14.0: Cancel URB ffff880211540480, dev 1.3, ep 0x0, starting at offset 0x3580c960
2014-03-01T10:54:22.517200+01:00 vnas kernel: [  165.063283] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:22.560124+01:00 vnas kernel: [  165.106240] xhci_hcd 0000:00:14.0: Cancel URB ffff880210daa180, dev 1.4, ep 0x0, starting at offset 0x211c76b10
2014-03-01T10:54:22.560158+01:00 vnas kernel: [  165.106253] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:26.867118+01:00 vnas kernel: [  169.410477] xhci_hcd 0000:00:14.0: Cancel URB ffff8802109619c0, dev 10.1, ep 0x1, starting at offset 0x211fe0170
2014-03-01T10:54:26.867146+01:00 vnas kernel: [  169.410490] xhci_hcd 0000:00:14.0: // Ding dong!
2014-03-01T10:54:27.481701+01:00 vnas kernel: [  170.024075] xhci_hcd 0000:00:14.0: xHCI host not responding to stop endpoint command.
2014-03-01T10:54:27.481725+01:00 vnas kernel: [  170.024085] xhci_hcd 0000:00:14.0: Assuming host is dying, halting host.
2014-03-01T10:54:27.481728+01:00 vnas kernel: [  170.024113] xhci_hcd 0000:00:14.0: // Halt the HC
2014-03-01T10:54:27.481731+01:00 vnas kernel: [  170.024124] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 1, ep index 0
2014-03-01T10:54:27.481733+01:00 vnas kernel: [  170.024129] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 1, ep index 2
2014-03-01T10:54:27.481735+01:00 vnas kernel: [  170.024141] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 6, ep index 0
2014-03-01T10:54:27.481737+01:00 vnas kernel: [  170.024146] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 6, ep index 2
2014-03-01T10:54:27.481977+01:00 vnas pcscd[2553]: 69633465 ifdwrapper.c:348:IFDStatusICC() Card not transacted: 612
2014-03-01T10:54:27.481739+01:00 vnas kernel: [  170.024151] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 6, ep index 3
2014-03-01T10:54:27.482055+01:00 vnas kernel: [  170.024157] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 7, ep index 0
2014-03-01T10:54:27.482089+01:00 vnas kernel: [  170.024162] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 7, ep index 2
2014-03-01T10:54:27.482093+01:00 vnas kernel: [  170.024171] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 7, ep index 3
2014-03-01T10:54:27.482095+01:00 vnas kernel: [  170.024175] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 7, ep index 6
2014-03-01T10:54:27.482097+01:00 vnas kernel: [  170.024180] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 7, ep index 7
2014-03-01T10:54:27.482099+01:00 vnas kernel: [  170.024184] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 8, ep index 0
2014-03-01T10:54:27.482102+01:00 vnas kernel: [  170.024188] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 8, ep index 2
2014-03-01T10:54:27.482104+01:00 vnas kernel: [  170.024194] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 9, ep index 0
2014-03-01T10:54:27.482107+01:00 vnas kernel: [  170.024198] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 9, ep index 2
2014-03-01T10:54:27.482109+01:00 vnas kernel: [  170.024204] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 10, ep index 0
2014-03-01T10:54:27.482111+01:00 vnas kernel: [  170.024232] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 10, ep index 2
2014-03-01T10:54:27.482113+01:00 vnas kernel: [  170.024240] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 10, ep index 4
2014-03-01T10:54:27.482115+01:00 vnas kernel: [  170.024248] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 10, ep index 6
2014-03-01T10:54:27.482118+01:00 vnas kernel: [  170.024257] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 10, ep index 8
2014-03-01T10:54:27.482120+01:00 vnas kernel: [  170.024266] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 11, ep index 0
2014-03-01T10:54:27.482122+01:00 vnas kernel: [  170.024287] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 11, ep index 2
2014-03-01T10:54:27.482125+01:00 vnas kernel: [  170.024296] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 11, ep index 4
2014-03-01T10:54:27.482127+01:00 vnas kernel: [  170.024305] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 11, ep index 6
2014-03-01T10:54:27.482129+01:00 vnas kernel: [  170.024312] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 11, ep index 8
2014-03-01T10:54:27.482131+01:00 vnas kernel: [  170.024343] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 12, ep index 0
2014-03-01T10:54:27.482134+01:00 vnas kernel: [  170.024361] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 12, ep index 2
2014-03-01T10:54:27.482136+01:00 vnas kernel: [  170.024371] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 12, ep index 4
2014-03-01T10:54:27.482139+01:00 vnas kernel: [  170.024378] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 12, ep index 6
2014-03-01T10:54:27.482141+01:00 vnas kernel: [  170.024386] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 12, ep index 8
2014-03-01T10:54:27.482143+01:00 vnas kernel: [  170.024411] em2884 #2: writing to i2c device at 0x52 failed (error=-5)
2014-03-01T10:54:27.482146+01:00 vnas kernel: [  170.024420] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 13, ep index 0
2014-03-01T10:54:27.482148+01:00 vnas kernel: [  170.024426] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 13, ep index 1
2014-03-01T10:54:27.482150+01:00 vnas kernel: [  170.024435] drxk: i2c write error at addr 0x29
2014-03-01T10:54:27.482153+01:00 vnas kernel: [  170.024437] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 13, ep index 4
2014-03-01T10:54:27.482155+01:00 vnas kernel: [  170.024442] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 13, ep index 6
2014-03-01T10:54:27.482157+01:00 vnas kernel: [  170.024447] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 0
2014-03-01T10:54:27.482160+01:00 vnas kernel: [  170.024451] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 2
2014-03-01T10:54:27.482162+01:00 vnas kernel: [  170.024456] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 3
2014-03-01T10:54:27.482164+01:00 vnas kernel: [  170.024461] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 4
2014-03-01T10:54:27.482167+01:00 vnas kernel: [  170.024466] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 5
2014-03-01T10:54:27.482169+01:00 vnas kernel: [  170.024471] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 14, ep index 6
2014-03-01T10:54:27.482171+01:00 vnas kernel: [  170.024476] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 15, ep index 0
2014-03-01T10:54:27.482174+01:00 vnas kernel: [  170.024481] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 15, ep index 1
2014-03-01T10:54:27.482176+01:00 vnas kernel: [  170.024485] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 15, ep index 2
2014-03-01T10:54:27.482178+01:00 vnas kernel: [  170.024490] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 16, ep index 0
2014-03-01T10:54:27.482181+01:00 vnas kernel: [  170.024495] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 16, ep index 1
2014-03-01T10:54:27.482183+01:00 vnas kernel: [  170.024500] xhci_hcd 0000:00:14.0: Killing URBs for slot ID 16, ep index 2
2014-03-01T10:54:27.482185+01:00 vnas kernel: [  170.024507] drxk: write_block: i2c write error at addr 0x831ffd
2014-03-01T10:54:27.482187+01:00 vnas kernel: [  170.024510] xhci_hcd 0000:00:14.0: Calling usb_hc_died()
2014-03-01T10:54:27.482190+01:00 vnas kernel: [  170.024515] xhci_hcd 0000:00:14.0: HC died; cleaning up
2014-03-01T10:54:27.482192+01:00 vnas kernel: [  170.024535] xhci_hcd 0000:00:14.0: xHCI host controller is dead.
2014-03-01T10:54:27.482220+01:00 vnas kernel: [  170.024727] em2884 #1: writing to i2c device at 0x52 failed (error=-19)
2014-03-01T10:54:27.482222+01:00 vnas kernel: [  170.024734] drxk: i2c write error at addr 0x29
2014-03-01T10:54:27.482225+01:00 vnas kernel: [  170.024739] usb 1-1: USB disconnect, device number 2
2014-03-01T10:54:27.482226+01:00 vnas kernel: [  170.024745] usb 1-1.2: USB disconnect, device number 10
2014-03-01T10:54:27.482228+01:00 vnas kernel: [  170.024751] drxk: write_block: i2c write error at addr 0x831ffd
2014-03-01T10:54:27.482230+01:00 vnas kernel: [  170.024956] em2884 #0: Disconnecting em2884 #0
2014-03-01T10:54:27.482815+01:00 vnas pcscd[2553]: 00000024 eventhandler.c:303:EHStatusHandlerThread() Error communicating to: SCR3310 Smart Card Reader [CCID Interface] (21120519102521) 00 00
2014-03-01T10:54:27.483926+01:00 vnas kernel: [  170.024962] em2884 #0: Closing audio extension
2014-03-01T10:54:27.483944+01:00 vnas kernel: [  170.025884] em2884 #0: Closing DVB extension<4>[  170.026559] em2884 #2: writing to i2c device at 0x52 failed (error=-19)

--------------090705050402050609060408--

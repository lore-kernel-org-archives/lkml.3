Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3BRKGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:06:53 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49004 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3BRKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:06:50 -0500
Message-ID: <5121FD36.3010200@suse.cz>
Date: Mon, 18 Feb 2013 11:06:46 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5qYSBOw7x0emVs?= <Anja@nuetzel-hh.de>,
        Jeff Mahoney <jeffm@suse.com>
CC: mmarek@suse.cz, =?UTF-8?B?RGlldGVyIE7DvHR6ZWw=?= <Dieter@nuetzel-hh.de>,
        stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [regression] openSUSE 12.2 stable kernel 3.7.8-1 big USB 2.0
 slowdown
References: <1458272.gbZiDy4Yrx@sonja.nuetzel-hh.de>
In-Reply-To: <1458272.gbZiDy4Yrx@sonja.nuetzel-hh.de>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 06:25 AM, Anja Nützel wrote:
> Maybe it startet with 3.7.7.
> I could copy several MB onto my USB 2.0 sticks with 3.7.6. (I think).
> Even with full speed.
> 
> With openSUSE 12.2 DVD (kernel 3.4.x) it works OK, too.
> 
> Now it degrates to 12 mbits (full-speed USB only).

This is an upstream 3.7.7 stable regression, I think. Some of these
patches perhaps:
d7da098 USB: EHCI: fix for leaking isochronous data
caa891a USB: storage: optimize to match the Huawei USB storage devices
and support new switch command
08b4bfd USB: storage: Define a new macro for USB storage match rules
390077b usb: Using correct way to clear usb3.0 device's remote wakeup
feature.
93dffb7 USB: EHCI: fix bug in scheduling periodic split transfers
bf79379 USB: EHCI: fix timer bug affecting port resume
d01875f USB: EHCI: unlink one async QH at a time
269ef9f USB: EHCI: remove ASS/PSS polling timeout

Alan, any ideas?

> [  149.841080] usb 1-2: reset high-speed USB device number 2 using ehci_hcd
> [  164.975034] usb 1-2: device descriptor read/64, error -110
> [  180.211088] usb 1-2: device descriptor read/64, error -110
> [  180.414090] usb 1-2: reset high-speed USB device number 2 using ehci_hcd
> [  195.549130] usb 1-2: device descriptor read/64, error -110
> [  210.786107] usb 1-2: device descriptor read/64, error -110
> [  210.989099] usb 1-2: reset high-speed USB device number 2 using ehci_hcd
> [  215.054357] fuse init (API version 7.20)
> [  221.414068] usb 1-2: device not accepting address 2, error -110
> [  221.516098] usb 1-2: reset high-speed USB device number 2 using ehci_hcd
> [  231.941092] usb 1-2: device not accepting address 2, error -110
> [  231.941154] usb 1-2: USB disconnect, device number 2
> [  231.941266] scsi 8:0:0:0: Device offlined - not ready after error recovery
> [  232.045092] usb 1-2: new high-speed USB device number 12 using ehci_hcd
> [  247.182104] usb 1-2: device descriptor read/64, error -110
> [  262.421087] usb 1-2: device descriptor read/64, error -110
> [  262.624089] usb 1-2: new high-speed USB device number 13 using ehci_hcd
> [  277.762086] usb 1-2: device descriptor read/64, error -110
> [  292.997072] usb 1-2: device descriptor read/64, error -110
> [  293.200071] usb 1-2: new high-speed USB device number 14 using ehci_hcd
> [  303.625026] usb 1-2: device not accepting address 14, error -110
> [  303.727048] usb 1-2: new high-speed USB device number 15 using ehci_hcd
> [  314.150028] usb 1-2: device not accepting address 15, error -110
> [  314.150065] hub 1-0:1.0: unable to enumerate USB device on port 2
> [  314.388051] usb 2-2: new full-speed USB device number 2 using uhci_hcd
> [  314.634992] usb 2-2: not running at top speed; connect to a high speed hub
> [  314.666036] usb 2-2: New USB device found, idVendor=058f, idProduct=6387
> [  314.666045] usb 2-2: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=3
> [  314.666050] usb 2-2: Product: Rainbow Line
> [  314.666053] usb 2-2: Manufacturer: Intenso
> [  314.666056] usb 2-2: SerialNumber: 47ADF5F1
> [  314.668554] scsi11 : usb-storage 2-2:1.0
> [  315.674834] scsi 11:0:0:0: Direct-Access     Intenso  Rainbow Line     8.07 
> PQ: 0 ANSI: 2
> [  315.677205] sd 11:0:0:0: Attached scsi generic sg8 type 0
> [  315.686865] sd 11:0:0:0: [sdh] 15949824 512-byte logical blocks: (8.16 
> GB/7.60 GiB)
> [  315.689873] sd 11:0:0:0: [sdh] Write Protect is off
> [  315.689886] sd 11:0:0:0: [sdh] Mode Sense: 03 00 00 00
> [  315.692870] sd 11:0:0:0: [sdh] No Caching mode page present
> [  315.692881] sd 11:0:0:0: [sdh] Assuming drive cache: write through
> [  315.711737] sd 11:0:0:0: [sdh] No Caching mode page present
> [  315.711748] sd 11:0:0:0: [sdh] Assuming drive cache: write through
> [  315.985072]  sdh: sdh1
> [  316.880344] sd 11:0:0:0: [sdh] No Caching mode page present
> [  316.880356] sd 11:0:0:0: [sdh] Assuming drive cache: write through
> [  316.880363] sd 11:0:0:0: [sdh] Attached SCSI removable disk
> 
> 
> [    0.000000] Linux version 3.7.8-1-desktop (geeko@buildhost) (gcc version 
> 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT 
> Fri Feb 15 14:56:20 UTC 2013 (2fa96bd)
> 
> [    0.954063] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.954143] ehci_hcd 0000:00:10.4: EHCI Host Controller
> [    0.954155] ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus 
> number 1
> [    0.954274] ehci_hcd 0000:00:10.4: irq 21, io mem 0xdfffbc00
> [    0.960024] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
> [    0.960092] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.960096] usb usb1: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    0.960100] usb usb1: Product: EHCI Host Controller
> [    0.960103] usb usb1: Manufacturer: Linux 3.7.8-1-desktop ehci_hcd
> [    0.960106] usb usb1: SerialNumber: 0000:00:10.4
> [    0.960376] hub 1-0:1.0: USB hub found
> [    0.960389] hub 1-0:1.0: 8 ports detected
> [    0.960644] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.960685] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.960744] uhci_hcd 0000:00:10.0: UHCI Host Controller
> [    0.960755] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus 
> number 2
> [    0.960797] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000c000
> [    0.960876] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.960880] usb usb2: New USB device strings: Mfr=3, Product=2, 
> SerialNumber=1
> [    0.960884] usb usb2: Product: UHCI Host Controller
> [    0.960887] usb usb2: Manufacturer: Linux 3.7.8-1-desktop uhci_hcd
> [    0.960890] usb usb2: SerialNumber: 0000:00:10.0
> [    0.961218] hub 2-0:1.0: USB hub found
> [    0.961232] hub 2-0:1.0: 2 ports detected
> 
> Sonja /home/anja# lsmod |grep usb
> usb_storage            47841  0 
> 
> Sonja /home/anja# modprobe -l | grep hcd
> kernel/drivers/scsi/ufs/ufshcd.ko
> kernel/drivers/usb/host/whci/whci-hcd.ko
> kernel/drivers/usb/host/oxu210hp-hcd.ko
> kernel/drivers/usb/host/isp116x-hcd.ko
> kernel/drivers/usb/host/isp1362-hcd.ko
> kernel/drivers/usb/host/xhci-hcd.ko
> kernel/drivers/usb/host/sl811-hcd.ko
> kernel/drivers/usb/host/u132-hcd.ko
> kernel/drivers/usb/host/r8a66597-hcd.ko
> kernel/drivers/usb/host/bcma-hcd.ko
> kernel/drivers/usb/host/ssb-hcd.ko
> kernel/drivers/staging/usbip/vhci-hcd.ko
> 
> Sonja /home/anja# lspci 
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host 
> Bridge (rev 80)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237/VX700 PCI Bridge
> 00:0b.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA 
> Controller (rev 02)
> 00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8169 PCI 
> Gigabit Ethernet Controller (rev 10)
> 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID 
> Controller (rev 80)
> 00:0f.1 IDE interface: VIA Technologies, Inc. 
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:10.0 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 81)
> 00:10.1 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 81)
> 00:10.2 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 81)
> 00:10.3 USB controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 81)
> 00:10.4 USB controller: VIA Technologies, Inc. USB 2.0 (rev 86)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
> [KT600/K8T800/K8T890 South]
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 
> AC97 Audio Controller (rev 60)
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 78)
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV730 
> Pro AGP [Radeon HD 4600 Series]
> 
> /home/anja> lsusb
> Bus 002 Device 002: ID 058f:6387 Alcor Micro Corp. Transcend JetFlash Flash 
> Drive
> Bus 003 Device 002: ID 0951:1607 Kingston Technology DataTraveler 100
> Bus 004 Device 002: ID 04a9:220d Canon, Inc. CanoScan N670U/N676U/LiDE 20
> Bus 005 Device 002: ID 058f:6362 Alcor Micro Corp. Flash Card Reader/Writer
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> /home/anja> lsusb -t
> 4-1:1.0: No such file or directory
> /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 2: Dev 2, If 0, Class=stor., Driver=usb-storage, 12M
> /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 1: Dev 2, If 0, Class=vend., Driver=, 12M
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 1: Dev 2, If 0, Class=stor., Driver=usb-storage, 12M
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>     |__ Port 2: Dev 2, If 0, Class=stor., Driver=usb-storage, 12M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
> 
> Thanks,
> 	Dieter
> 


-- 
js
suse labs

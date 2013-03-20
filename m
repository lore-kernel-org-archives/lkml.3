Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab3CTS4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:56:32 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:38401 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757712Ab3CTS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:56:29 -0400
Message-ID: <514A0658.8080403@fold.natur.cuni.cz>
Date: Wed, 20 Mar 2013 19:56:24 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
CC: Oliver Neukum <oneukum@suse.de>, Michal Marek <mmarek@suse.cz>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
References: <s5h38vqjhk6.wl%tiwai@suse.de> <514A02E2.9030700@fold.natur.cuni.cz>
In-Reply-To: <514A02E2.9030700@fold.natur.cuni.cz>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Mokrejs wrote:
> Hi Takashi,
>   would you please describe your test system in more detail? How
> about 'lspci -tv'? And 'lsusb -v' of the broken device?
> 
> 1. For me on Dell Vostro 3550 with a SandyBridge chip doing all SATA+USB2+ExpressCardSlot:
> 
> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
> 00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
> 00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
> 00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 (rev b5) (prog-if 00 [Normal decode])
> 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
> 00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
> 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 06)
> 09:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030 [Rainbow Peak] (rev 34)
> 0b:00.0 USB controller: Texas Instruments TUSB73x0 SuperSpeed USB 3.0 xHCI Host Controller (rev 02) (prog-if 30 [XHCI])
> 11:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
> #
> 
> If I have Realtek MediaCardReader enabled in BIOS, no card in it, coldboot, and hot
> insert an ExpressCard into the slot, the Realtek MediaCardReader pops up in dmesg as
> a new PCI device. How about you?

Err, not PCI device as I said, sorry, but gets re-detected as a USB device:

[    4.220009] hub 2-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
[    4.291831] usb 2-1.6: new high-speed USB device number 5 using ehci_hcd
[    4.409353] usb 2-1.6: default language 0x0409
[    4.414740] usb 2-1.6: udev 5, busnum 2, minor = 132
[    4.414745] usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
[    4.414858] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.414967] usb 2-1.6: Product: USB2.0-CRW
[    4.415069] usb 2-1.6: Manufacturer: Generic
[    4.415172] usb 2-1.6: SerialNumber: 20090516388200000
[    4.416956] usb 2-1.6: usb_probe_device
[    4.416962] usb 2-1.6: configuration #1 chosen from 1 choice
[    4.419477] usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
[    4.424094] usb-storage 2-1.6:1.0: usb_probe_interface
[    4.424103] usb-storage 2-1.6:1.0: usb_probe_interface - got id
[    4.424276] ums-realtek 2-1.6:1.0: usb_probe_interface
[    4.424279] ums-realtek 2-1.6:1.0: usb_probe_interface - got id
[    4.440838] scsi6 : usb-storage 2-1.6:1.0

cut

[  222.748820] pci 0000:11:00.0: [1095:3132] type 00 class 0x018000
[  222.748865] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x0000007f 64bit]
[  222.748898] pci 0000:11:00.0: reg 18: [mem 0x00000000-0x00003fff 64bit]
[  222.748919] pci 0000:11:00.0: reg 20: [io  0x0000-0x007f]
[  222.748960] pci 0000:11:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[  222.749095] pci 0000:11:00.0: supports D1 D2
[  222.769438] pci 0000:11:00.0: BAR 6: assigned [mem 0xf0000000-0xf007ffff pref]
[  222.769442] pci 0000:11:00.0: BAR 2: assigned [mem 0xf6c00000-0xf6c03fff 64bit]
[  222.769464] pci 0000:11:00.0: BAR 2: set to [mem 0xf6c00000-0xf6c03fff 64bit] (PCI address [0xf6c00000-0xf6c03fff])
[  222.769466] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c04000-0xf6c0407f 64bit]
[  222.769487] pci 0000:11:00.0: BAR 0: set to [mem 0xf6c04000-0xf6c0407f 64bit] (PCI address [0xf6c04000-0xf6c0407f])
[  222.769489] pci 0000:11:00.0: BAR 4: assigned [io  0xc000-0xc07f]
[  222.769496] pci 0000:11:00.0: BAR 4: set to [io  0xc000-0xc07f] (PCI address [0xc000-0xc07f])
[  222.891588] sata_sil24 0000:11:00.0: version 1.1
[  222.891606] sata_sil24 0000:11:00.0: enabling device (0100 -> 0103)
[  222.891766] sata_sil24 0000:11:00.0: enabling bus mastering
[  222.894206] scsi7 : sata_sil24
[  222.894813] scsi8 : sata_sil24
[  222.895288] ata7: SATA max UDMA/100 host m128@0xf6c04000 port 0xf6c00000 irq 19
[  222.895291] ata8: SATA max UDMA/100 host m128@0xf6c04000 port 0xf6c02000 irq 19
[  223.337591] sata_sil24 0000:11:00.0: PME# disabled
[  225.323870] ata7: SATA link down (SStatus FFFFFFFF SControl FFFFFFFF)

[  225.326709] sata_sil24: IRQ status == 0xffffffff, PCI fault or device removal?
[  232.184580] pci 0000:11:00.0: [1095:3132] type 00 class 0x018000
[  232.184624] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x0000007f 64bit]
[  232.184655] pci 0000:11:00.0: reg 18: [mem 0x00000000-0x00003fff 64bit]
[  232.184675] pci 0000:11:00.0: reg 20: [io  0x0000-0x007f]
[  232.184714] pci 0000:11:00.0: reg 30: [mem 0x00000000-0x0007ffff pref]
[  232.184828] pci 0000:11:00.0: supports D1 D2
[  232.206000] pci 0000:11:00.0: BAR 6: assigned [mem 0xf0000000-0xf007ffff pref]
[  232.206005] pci 0000:11:00.0: BAR 2: assigned [mem 0xf6c00000-0xf6c03fff 64bit]
[  232.206026] pci 0000:11:00.0: BAR 2: set to [mem 0xf6c00000-0xf6c03fff 64bit] (PCI address [0xf6c00000-0xf6c03fff])
[  232.206028] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c04000-0xf6c0407f 64bit]
[  232.206048] pci 0000:11:00.0: BAR 0: set to [mem 0xf6c04000-0xf6c0407f 64bit] (PCI address [0xf6c04000-0xf6c0407f])
[  232.206050] pci 0000:11:00.0: BAR 4: assigned [io  0xc000-0xc07f]
[  232.206057] pci 0000:11:00.0: BAR 4: set to [io  0xc000-0xc07f] (PCI address [0xc000-0xc07f])
[  232.207155] sata_sil24 0000:11:00.0: enabling device (0100 -> 0103)
[  232.207369] sata_sil24 0000:11:00.0: enabling bus mastering
[  232.210324] scsi9 : sata_sil24
[  232.211226] scsi10 : sata_sil24
[  232.211830] ata9: SATA max UDMA/100 host m128@0xf6c04000 port 0xf6c00000 irq 19
[  232.211834] ata10: SATA max UDMA/100 host m128@0xf6c04000 port 0xf6c02000 irq 19
[  232.855586] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 1
[  232.855803] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 2
[  232.855904] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 3
[  232.856028] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 4
[  232.856153] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 5
[  232.856278] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 6
[  232.856403] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 7
[  232.856528] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 8
[  232.856652] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 9
[  232.856742] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 10
[  232.856857] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 11
[  232.856981] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 12
[  232.857105] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 13
[  232.857230] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 14
[  232.857355] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 15
[  232.857480] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 16
[  232.857605] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 17
[  232.857729] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 18
[  232.857854] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 19
[  232.857979] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 20
[  232.858104] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 21
[  232.858229] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 22
[  232.858353] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 23
[  232.858478] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 24
[  232.858603] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 25
[  232.858728] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 26
[  232.858853] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 27
[  232.858977] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 28
[  232.859103] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 29
[  232.859227] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 30
[  232.859352] ehci_hcd 0000:00:1d.0: detected XactErr len 0/13 retry 31
[  232.859477] ehci_hcd 0000:00:1d.0: devpath 1.6 ep2in 3strikes
[  232.873452] hub 2-1:1.0: logical disconnect on port 6
[  232.873747] hub 2-1:1.0: state 7 ports 8 chg 0040 evt 0000
[  232.874190] hub 2-1:1.0: port 6, status 0100, change 0001, 12 Mb/s
[  232.874201] usb 2-1.6: USB disconnect, device number 5
[  232.874207] usb 2-1.6: unregistering device
[  232.874213] usb 2-1.6: unregistering interface 2-1.6:1.0
[  232.895911] usb 2-1.6: usb_disable_device nuking all URBs
[  233.052586] hub 2-1:1.0: debounce: port 6: total 100ms stable 100ms status 0x100
[  234.290521] ata9: SATA link down (SStatus 0 SControl 0)
[  279.413768] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0040
[  279.414305] hub 2-1:1.0: port 6, status 0101, change 0001, 12 Mb/s
[  279.573458] hub 2-1:1.0: debounce: port 6: total 100ms stable 100ms status 0x101
[  279.653215] usb 2-1.6: new high-speed USB device number 8 using ehci_hcd
[  279.850803] usb 2-1.6: default language 0x0409
[  279.856648] usb 2-1.6: udev 8, busnum 2, minor = 135
[  279.856651] usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
[  279.856653] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  279.856654] usb 2-1.6: Product: USB2.0-CRW
[  279.856656] usb 2-1.6: Manufacturer: Generic
[  279.856657] usb 2-1.6: SerialNumber: 20090516388200000
[  279.857242] usb 2-1.6: usb_probe_device
[  279.857244] usb 2-1.6: configuration #1 chosen from 1 choice
[  279.859632] usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
[  279.863384] usb-storage 2-1.6:1.0: usb_probe_interface
[  279.863387] usb-storage 2-1.6:1.0: usb_probe_interface - got id
[  279.863442] ums-realtek 2-1.6:1.0: usb_probe_interface
[  279.863443] ums-realtek 2-1.6:1.0: usb_probe_interface - got id
[  279.879716] scsi11 : usb-storage 2-1.6:1.0


The trigger is the eSATA card, unlike two other (USB3 and Firewire) express cards I have. Probably
the culprit is the SATA thing or a broken sata_sil24 driver.

> 
> My card does NOT show in lspci (maybe because I never plugged in a data card into it) but does show in lsusb:
> 
> Bus 002 Device 005: ID 0bda:0138 Realtek Semiconductor Corp. RTS5138 Card Reader Controller
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0 
>   bDeviceProtocol         0 
>   bMaxPacketSize0        64
>   idVendor           0x0bda Realtek Semiconductor Corp.
>   idProduct          0x0138 RTS5138 Card Reader Controller
>   bcdDevice           38.82
>   iManufacturer           1 Generic
>   iProduct                2 USB2.0-CRW
>   iSerial                 3 20090516388200000
> 

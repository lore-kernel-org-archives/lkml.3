Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaDNNyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:54:40 -0400
Received: from www84.your-server.de ([213.133.104.84]:58250 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDNNyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:54:38 -0400
Date: Mon, 14 Apr 2014 15:54:27 +0200
Message-ID: <20140414155427.Horde.393VF6FGDx8A_BhIWLfNWQ1@webmail.your-server.de>
From: stefani@seibold.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, sarah.a.sharp@linux.intel.com,
        andreas.brief@rohde-schwarz.com
Subject: Re: Missing USB XHCI and EHCI reset for kexec
References: <Pine.LNX.4.44L0.1404132213290.24243-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1404132213290.24243-100000@netrider.rowland.org>
User-Agent: Internet Messaging Program (IMP) H5 (6.1.7)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 From Alan Stern <stern@rowland.harvard.edu>:

> On Sun, 13 Apr 2014, Stefani Seibold wrote:
>
>> When executing a kexec kernel on a PowerPC board the new started kernel
>> will not find already enumerated USB devices due a missing reset on the
>> USB bus.
>
> How do you know the problem is caused by a missing reset?
>

A "echo 1 >/sys/bus/pci/drivers/ehci-pci/0000\:00\:17.2/reset" will  
solve this for kernel 3.10. So i thought this is a reset problem.

But i have now a kernel 3.14 running on my PowerPC device and this  
have a different behavour. After a couple of minutes the USB device  
will appear again.

> Can you post the dmesg log from the kexec-ed kernel, with
> CONFIG_USB_DEBUG enabled?
>

Here is the log for a 3.14 which CONFIG_USB_DEBUG enabled:

<6>[    1.753647] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    1.760316] ehci-pci: EHCI PCI platform driver
<6>[    1.765012] ehci-pci 0000:00:17.2: EHCI Host Controller
<6>[    1.770408] ehci-pci 0000:00:17.2: new USB bus registered,  
assigned bus number 1
<6>[    1.778348] ehci-pci 0000:00:17.2: irq 22, io mem 0xc0006800
<6>[    1.795144] ehci-pci 0000:00:17.2: USB 2.0 started, EHCI 1.00
<6>[    1.801139] usb usb1: New USB device found, idVendor=1d6b,  
idProduct=0002
<6>[    1.807993] usb usb1: New USB device strings: Mfr=3, Product=2,  
SerialNumber=1
<6>[    1.815247] usb usb1: Product: EHCI Host Controller
<6>[    1.820157] usb usb1: Manufacturer: Linux 3.14.0 ehci_hcd
<6>[    1.825586] usb usb1: SerialNumber: 0000:00:17.2
<6>[    1.831022] hub 1-0:1.0: USB hub found
<6>[    1.834914] hub 1-0:1.0: 5 ports detected
<6>[    1.839972] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    1.846277] ohci-pci: OHCI PCI platform driver
<6>[    1.850911] ohci-pci 0000:00:17.0: OHCI PCI host controller
<6>[    1.856617] ohci-pci 0000:00:17.0: new USB bus registered,  
assigned bus number 2
<6>[    1.864420] ohci-pci 0000:00:17.0: irq 20, io mem 0xc0004000
<6>[    1.953518] usb usb2: New USB device found, idVendor=1d6b,  
idProduct=0001
<6>[    1.960376] usb usb2: New USB device strings: Mfr=3, Product=2,  
SerialNumber=1
<6>[    1.967631] usb usb2: Product: OHCI PCI host controller
<6>[    1.972887] usb usb2: Manufacturer: Linux 3.14.0 ohci_hcd
<6>[    1.978315] usb usb2: SerialNumber: 0000:00:17.0
<6>[    1.983802] hub 2-0:1.0: USB hub found
<6>[    1.987695] hub 2-0:1.0: 3 ports detected
<6>[    1.992395] ohci-pci 0000:00:17.1: OHCI PCI host controller
<6>[    1.998116] ohci-pci 0000:00:17.1: new USB bus registered,  
assigned bus number 3
<6>[    2.005935] ohci-pci 0000:00:17.1: irq 21, io mem 0xc0005000
<6>[    2.097535] usb usb3: New USB device found, idVendor=1d6b,  
idProduct=0001
<6>[    2.104391] usb usb3: New USB device strings: Mfr=3, Product=2,  
SerialNumber=1
<6>[    2.111641] usb usb3: Product: OHCI PCI host controller
<6>[    2.116895] usb usb3: Manufacturer: Linux 3.14.0 ohci_hcd
<6>[    2.122321] usb usb3: SerialNumber: 0000:00:17.1
<6>[    2.127802] hub 3-0:1.0: USB hub found
<6>[    2.131691] hub 3-0:1.0: 2 ports detected
<6>[    2.136956] Freescale High-Speed USB SOC Device Controller  
driver (Apr 20, 2007)
<6>[    2.145437] mousedev: PS/2 mouse device common for all mice
<6>[    2.151211] usb 1-2: new high-speed USB device number 2 using ehci-pci
<6>[    2.157893] i2c /dev entries driver
<6>[    2.162013] mpc-i2c fef03000.i2c: timeout 1000000 us
<6>[    2.181749] rtc-rs5c372 0-0032: rs5c372a found, 24hr, driver version 0.6
<6>[    2.212713] rtc-rs5c372 0-0032: rtc core: registered rtc-rs5c372 as rtc0
<6>[    2.219904] mpc-i2c fef03100.i2c: timeout 1000000 us
<6>[    2.226165] usbcore: registered new interface driver usbhid
<6>[    2.231835] usbhid: USB HID core driver
<6>[    2.235868] rsfrontp: using key table SMBV (117)
<6>[    2.240747] usbcore: registered new interface driver rsfrontp
<6>[    2.246601] rsfrontp: R&S USB HID Frontpanel driver (v1.2)
<6>[    2.252254] usbcore: registered new interface driver rsknop
<6>[    2.257912] rsknop: R&S USB HID Knop support (v1.4)
<6>[    2.263093] TCP: cubic registered
<6>[    2.266475] NET: Registered protocol family 17
<6>[    2.278216] rtc-rs5c372 0-0032: setting system clock to  
2014-04-13 15:46:52 UTC (1397404012)
<6>[    2.294464] Freeing unused kernel memory: 968K (c03c3000 - c04b5000)
<6>[    2.308009] usb 1-2: New USB device found, idVendor=0424, idProduct=2514
<6>[    2.318509] usb 1-2: New USB device strings: Mfr=0, Product=0,  
SerialNumber=0
<6>[    2.327340] hub 1-2:1.0: USB hub found
<6>[    2.331579] hub 1-2:1.0: 4 ports detected
<6>[    2.707176] usb 1-4: new high-speed USB device number 4 using ehci-pci
<3>[   17.823176] usb 1-4: device descriptor read/64, error -110
<3>[   33.043207] usb 1-4: device descriptor read/64, error -110
<6>[   33.263185] usb 1-4: new high-speed USB device number 5 using ehci-pci
<3>[   48.379210] usb 1-4: device descriptor read/64, error -110
<3>[   63.607205] usb 1-4: device descriptor read/64, error -110
<6>[   63.827191] usb 1-4: new high-speed USB device number 6 using ehci-pci
<3>[   68.851401] usb 1-4: device descriptor read/8, error -110
<3>[   73.975374] usb 1-4: device descriptor read/8, error -110
<6>[   74.203206] usb 1-4: new high-speed USB device number 7 using ehci-pci
<3>[   79.231446] usb 1-4: device descriptor read/8, error -110
<3>[   84.359422] usb 1-4: device descriptor read/8, error -110
<3>[   84.475224] hub 1-0:1.0: unable to enumerate USB device on port 4
<6>[   84.795211] usb 2-2: new full-speed USB device number 2 using ohci-pci
<6>[   85.016582] usb 2-2: New USB device found, idVendor=0451, idProduct=2036
<6>[   85.023394] usb 2-2: New USB device strings: Mfr=0, Product=1,  
SerialNumber=0
<6>[   85.030572] usb 2-2: Product: General Purpose USB Hub
<6>[   85.043722] hub 2-2:1.0: USB hub found
<6>[   85.049569] hub 2-2:1.0: 2 ports detected
<6>[   85.367220] usb 3-2: new full-speed USB device number 2 using ohci-pci
<3>[  100.555212] usb 3-2: device descriptor read/64, error -110
<3>[  115.847196] usb 3-2: device descriptor read/64, error -110
<6>[  116.131178] usb 3-2: new full-speed USB device number 3 using ohci-pci
<3>[  131.311178] usb 3-2: device descriptor read/64, error -110
<3>[  146.595209] usb 3-2: device descriptor read/64, error -110
<6>[  146.887192] usb 3-2: new full-speed USB device number 4 using ohci-pci
<3>[  151.915584] usb 3-2: device descriptor read/8, error -110
<3>[  157.039436] usb 3-2: device descriptor read/8, error -110
<6>[  157.323180] usb 3-2: new full-speed USB device number 5 using ohci-pci
<3>[  162.352239] usb 3-2: device descriptor read/8, error -110
<3>[  167.484079] usb 3-2: device descriptor read/8, error -110
<3>[  167.591236] hub 3-0:1.0: unable to enumerate USB device on port 2
<6>[  167.936921] usb 2-2.1: new full-speed USB device number 3 using ohci-pci
<6>[  168.067890] usb 2-2.1: New USB device found, idVendor=076b,  
idProduct=a021
<6>[  168.074871] usb 2-2.1: New USB device strings: Mfr=1, Product=2,  
SerialNumber=0
<6>[  168.082226] usb 2-2.1: Product: Smart Card Reader
<6>[  168.086963] usb 2-2.1: Manufacturer: USB
<6>[  168.172893] usb 2-2.2: new low-speed USB device number 4 using ohci-pci
<6>[  168.300839] usb 2-2.2: New USB device found, idVendor=0aad,  
idProduct=0024
<6>[  168.307823] usb 2-2.2: New USB device strings: Mfr=1, Product=2,  
SerialNumber=0
<6>[  168.315180] usb 2-2.2: Product: FrontPanel USB Keyboard
<6>[  168.320436] usb 2-2.2: Manufacturer: Rohde&Schwarz
<6>[  168.337895] input: Rohde&Schwarz FrontPanel USB Keyboard as  
/devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input0
<6>[  168.360988] input: Rohde&Schwarz FrontPanel USB Keyboard as  
/devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.1/input/input1

This is the output of lsusb:

Bus 001 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 001 Device 004: ID 0928:0007 Oxford Semiconductor, Ltd
Bus 002 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 003: ID 076b:a021 OmniKey AG CCID Smart Card Reader
Bus 002 Device 004: ID 0aad:0024 Rohde & Schwarz GmbH & Co. KG

My old kernel 3.4 does not show this problem. Since kernel 3.10 i need  
to reset to ehci-pci device when kexec. But this workaround does not  
work any longer on kernel 3.14.

-Stefani



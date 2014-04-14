Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaDNOtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:49:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42553 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754367AbaDNOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:49:14 -0400
Date: Mon, 14 Apr 2014 10:49:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: stefani@seibold.net
cc: linux-usb <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, <sarah.a.sharp@linux.intel.com>,
        <andreas.brief@rohde-schwarz.com>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
In-Reply-To: <20140414155427.Horde.393VF6FGDx8A_BhIWLfNWQ1@webmail.your-server.de>
Message-ID: <Pine.LNX.4.44L0.1404141035540.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 stefani@seibold.net wrote:

> 
>  From Alan Stern <stern@rowland.harvard.edu>:
> 
> > On Sun, 13 Apr 2014, Stefani Seibold wrote:
> >
> >> When executing a kexec kernel on a PowerPC board the new started kernel
> >> will not find already enumerated USB devices due a missing reset on the
> >> USB bus.
> >
> > How do you know the problem is caused by a missing reset?
> >
> 
> A "echo 1 >/sys/bus/pci/drivers/ehci-pci/0000\:00\:17.2/reset" will  
> solve this for kernel 3.10. So i thought this is a reset problem.

All that means is the problem can be fixed by adding a reset.  It
doesn't mean that the problem was caused by a missing reset.

> But i have now a kernel 3.14 running on my PowerPC device and this  
> have a different behavour. After a couple of minutes the USB device  
> will appear again.
> 
> > Can you post the dmesg log from the kexec-ed kernel, with
> > CONFIG_USB_DEBUG enabled?
> >
> 
> Here is the log for a 3.14 which CONFIG_USB_DEBUG enabled:

> <6>[    2.308009] usb 1-2: New USB device found, idVendor=0424, idProduct=2514
> <6>[    2.318509] usb 1-2: New USB device strings: Mfr=0, Product=0,  
> SerialNumber=0
> <6>[    2.327340] hub 1-2:1.0: USB hub found
> <6>[    2.331579] hub 1-2:1.0: 4 ports detected

This device worked okay.

> <6>[    2.707176] usb 1-4: new high-speed USB device number 4 using ehci-pci
> <3>[   17.823176] usb 1-4: device descriptor read/64, error -110
> <3>[   33.043207] usb 1-4: device descriptor read/64, error -110
> <6>[   33.263185] usb 1-4: new high-speed USB device number 5 using ehci-pci
> <3>[   48.379210] usb 1-4: device descriptor read/64, error -110
> <3>[   63.607205] usb 1-4: device descriptor read/64, error -110
> <6>[   63.827191] usb 1-4: new high-speed USB device number 6 using ehci-pci
> <3>[   68.851401] usb 1-4: device descriptor read/8, error -110
> <3>[   73.975374] usb 1-4: device descriptor read/8, error -110
> <6>[   74.203206] usb 1-4: new high-speed USB device number 7 using ehci-pci
> <3>[   79.231446] usb 1-4: device descriptor read/8, error -110
> <3>[   84.359422] usb 1-4: device descriptor read/8, error -110
> <3>[   84.475224] hub 1-0:1.0: unable to enumerate USB device on port 4

Is this the problem you are referring to?

> <6>[   84.795211] usb 2-2: new full-speed USB device number 2 using ohci-pci
> <6>[   85.016582] usb 2-2: New USB device found, idVendor=0451, idProduct=2036
> <6>[   85.023394] usb 2-2: New USB device strings: Mfr=0, Product=1,  
> SerialNumber=0
> <6>[   85.030572] usb 2-2: Product: General Purpose USB Hub
> <6>[   85.043722] hub 2-2:1.0: USB hub found
> <6>[   85.049569] hub 2-2:1.0: 2 ports detected
> <6>[   85.367220] usb 3-2: new full-speed USB device number 2 using ohci-pci
> <3>[  100.555212] usb 3-2: device descriptor read/64, error -110
> <3>[  115.847196] usb 3-2: device descriptor read/64, error -110
> <6>[  116.131178] usb 3-2: new full-speed USB device number 3 using ohci-pci
> <3>[  131.311178] usb 3-2: device descriptor read/64, error -110
> <3>[  146.595209] usb 3-2: device descriptor read/64, error -110
> <6>[  146.887192] usb 3-2: new full-speed USB device number 4 using ohci-pci
> <3>[  151.915584] usb 3-2: device descriptor read/8, error -110
> <3>[  157.039436] usb 3-2: device descriptor read/8, error -110
> <6>[  157.323180] usb 3-2: new full-speed USB device number 5 using ohci-pci
> <3>[  162.352239] usb 3-2: device descriptor read/8, error -110
> <3>[  167.484079] usb 3-2: device descriptor read/8, error -110
> <3>[  167.591236] hub 3-0:1.0: unable to enumerate USB device on port 2

And this?

> <6>[  167.936921] usb 2-2.1: new full-speed USB device number 3 using ohci-pci
> <6>[  168.067890] usb 2-2.1: New USB device found, idVendor=076b,  
> idProduct=a021
> <6>[  168.074871] usb 2-2.1: New USB device strings: Mfr=1, Product=2,  
> SerialNumber=0
> <6>[  168.082226] usb 2-2.1: Product: Smart Card Reader
> <6>[  168.086963] usb 2-2.1: Manufacturer: USB
> <6>[  168.172893] usb 2-2.2: new low-speed USB device number 4 using ohci-pci
> <6>[  168.300839] usb 2-2.2: New USB device found, idVendor=0aad,  
> idProduct=0024
> <6>[  168.307823] usb 2-2.2: New USB device strings: Mfr=1, Product=2,  
> SerialNumber=0
> <6>[  168.315180] usb 2-2.2: Product: FrontPanel USB Keyboard
> <6>[  168.320436] usb 2-2.2: Manufacturer: Rohde&Schwarz
> <6>[  168.337895] input: Rohde&Schwarz FrontPanel USB Keyboard as  
> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.0/input/input0
> <6>[  168.360988] input: Rohde&Schwarz FrontPanel USB Keyboard as  
> /devices/pci0000:00/0000:00:17.0/usb2/2-2/2-2.2/2-2.2:1.1/input/input1

Since some devices work and some don't, maybe part of the problem lies 
in the particular devices.

> This is the output of lsusb:
> 
> Bus 001 Device 002: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
> Bus 001 Device 004: ID 0928:0007 Oxford Semiconductor, Ltd
> Bus 002 Device 002: ID 0451:2036 Texas Instruments, Inc. TUSB2036 Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 003: ID 076b:a021 OmniKey AG CCID Smart Card Reader
> Bus 002 Device 004: ID 0aad:0024 Rohde & Schwarz GmbH & Co. KG
> 
> My old kernel 3.4 does not show this problem. Since kernel 3.10 i need  
> to reset to ehci-pci device when kexec. But this workaround does not  
> work any longer on kernel 3.14.

Have you tried bisecting between 3.4 and 3.10 to find which commit 
caused the behavior to change?

What about if you just do:

	rmmod ehci-pci
	modprobe ehci-pci

Alan Stern


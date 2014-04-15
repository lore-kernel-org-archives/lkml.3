Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaDOTHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:07:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:54340 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaDOTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:07:16 -0400
Message-ID: <1397588786.21892.4.camel@vger.seibold.net>
Subject: Re: Missing USB XHCI and EHCI reset for kexec
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        andreas.brief@rohde-schwarz.com
Date: Tue, 15 Apr 2014 21:06:26 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404151448390.1310-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404151448390.1310-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 15.04.2014, 15:02 -0400 schrieb Alan Stern:
> On Tue, 15 Apr 2014, Stefani Seibold wrote:
> 
> > I did a unbind and bind of the ehci-pci and ohci-pci, after this i got
> > the following dmesg log:
> > 
> > ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> > ehci-pci: EHCI PCI platform driver
> > ehci-pci 0000:00:17.2: EHCI Host Controller
> > ehci-pci 0000:00:17.2: new USB bus registered, assigned bus number 1
> > ehci-pci 0000:00:17.2: irq 22, io mem 0xc0006800
> > ehci-pci 0000:00:17.2: USB 2.0 started, EHCI 1.00
> > hub 1-0:1.0: USB hub found
> > hub 1-0:1.0: 5 ports detected
> > ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> > ohci_hcd 0000:00:17.0: OHCI Host Controller
> > ohci_hcd 0000:00:17.0: new USB bus registered, assigned bus number 2
> > ohci_hcd 0000:00:17.0: irq 20, io mem 0xc0004000
> > hub 2-0:1.0: USB hub found
> > hub 2-0:1.0: 3 ports detected
> > ohci_hcd 0000:00:17.1: OHCI Host Controller
> > ohci_hcd 0000:00:17.1: new USB bus registered, assigned bus number 3
> > ohci_hcd 0000:00:17.1: irq 21, io mem 0xc0005000
> > hub 3-0:1.0: USB hub found
> > hub 3-0:1.0: 2 ports detected
> ...
> > usbcore: registered new interface driver USB-SATA-storage
> > USB SATA Mass Storage support registered.
> > usb 1-4: new high-speed USB device number 4 using ehci-pci
> > xxxx: ports detected
> 
> What driver is this?  I've never heard of USB-SATA-storage.
> 

This is a special embedded USB SATA driver written by me. It is mostly a
fork of the usb-storage driver but handle only one vendor and product ID
and does switch on a port bit. On the other side this vendor and product
ID is black listed in the regular usb-storage driver. 

> > ohci_hcd 0000:00:17.0: remove, state 1
> > usb usb2: USB disconnect, device number 1
> > usb 2-2: USB disconnect, device number 2
> > usb 2-2.1: USB disconnect, device number 3
> > usb 2-2.2: USB disconnect, device number 4
> > ohci_hcd 0000:00:17.0: USB bus 2 deregistered
> > ohci_hcd 0000:00:17.1: remove, state 1
> > usb usb3: USB disconnect, device number 1
> > ohci_hcd 0000:00:17.1: USB bus 3 deregistered
> > ehci-pci 0000:00:17.2: remove, state 1
> > usb usb1: USB disconnect, device number 1
> > usb 1-2: USB disconnect, device number 2
> > usb 1-4: USB disconnect, device number 4
> > ehci-pci 0000:00:17.2: USB bus 1 deregistered
> > ohci_hcd 0000:00:17.0: OHCI Host Controller
> > ohci_hcd 0000:00:17.0: new USB bus registered, assigned bus number 1
> > ohci_hcd 0000:00:17.0: irq 20, io mem 0xc0004000
> > hub 1-0:1.0: USB hub found
> > hub 1-0:1.0: 3 ports detected
> > ohci_hcd 0000:00:17.1: OHCI Host Controller
> > ohci_hcd 0000:00:17.1: new USB bus registered, assigned bus number 2
> > ohci_hcd 0000:00:17.1: irq 21, io mem 0xc0005000
> > hub 2-0:1.0: USB hub found
> > hub 2-0:1.0: 2 ports detected
> > ehci-pci 0000:00:17.2: EHCI Host Controller
> > ehci-pci 0000:00:17.2: new USB bus registered, assigned bus number 3
> > ehci-pci 0000:00:17.2: irq 22, io mem 0xc0006800
> > ehci-pci 0000:00:17.2: USB 2.0 started, EHCI 1.00
> > hub 3-0:1.0: USB hub found
> > hub 3-0:1.0: 5 ports detected
> > hub 1-0:1.0: USB hub found
> > hub 1-0:1.0: 3 ports detected
> > hub 2-0:1.0: USB hub found
> > hub 2-0:1.0: 2 ports detected
> > usb 3-2: new high-speed USB device number 2 using ehci-pci
> > hub 3-2:1.0: USB hub found
> > hub 3-2:1.0: 4 ports detected
> > usb 3-4: new high-speed USB device number 4 using ehci-pci
> > usb 3-4: device descriptor read/64, error -110
> > usb 3-4: device descriptor read/64, error -110
> > usb 3-4: new high-speed USB device number 5 using ehci-pci
> > usb 3-4: device descriptor read/64, error -110
> > usb 3-4: device descriptor read/64, error -110
> > usb 3-4: new high-speed USB device number 6 using ehci-pci
> > usb 3-4: device descriptor read/8, error -110
> > usb 3-4: device descriptor read/8, error -110
> > usb 3-4: new high-speed USB device number 7 using ehci-pci
> > usb 3-4: device descriptor read/8, error -110
> > usb 3-4: device descriptor read/8, error -110
> > hub 3-0:1.0: unable to enumerate USB device on port 4
> > usb 1-2: new full-speed USB device number 2 using ohci_hcd
> > hub 1-2:1.0: USB hub found
> > hub 1-2:1.0: 2 ports detected
> > usb 2-2: new full-speed USB device number 2 using ohci_hcd
> > usb 2-2: device descriptor read/64, error -110
> > usb 2-2: device descriptor read/64, error -110
> > usb 2-2: new full-speed USB device number 3 using ohci_hcd
> > usb 2-2: device descriptor read/64, error -110
> > usb 2-2: device descriptor read/64, error -110
> > usb 2-2: new full-speed USB device number 4 using ohci_hcd
> > usb 2-2: device descriptor read/8, error -110
> > usb 2-2: device descriptor read/8, error -110
> > usb 2-2: new full-speed USB device number 5 using ohci_hcd
> > usb 2-2: device descriptor read/8, error -110
> > usb 2-2: device descriptor read/8, error -110
> > hub 2-0:1.0: unable to enumerate USB device on port 2
> > usb 1-2.1: new full-speed USB device number 3 using ohci_hcd
> > usb 1-2.2: new low-speed USB device number 4 using ohci_hcd
> > input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb1/1-2/1-2.2/1-2.2:1.0/input/input2
> > input: Rohde&Schwarz FrontPanel USB Keyboard as /devices/pci0000:00/0000:00:17.0/usb1/1-2/1-2.2/1-2.2:1.1/input/input3
> 
> So two devices failed to initialize after the drivers were rebound: 3-4 
> and 2-2.  We know that 3-4 was the mass-storage device, but I can't 
> tell from this log what 2-2 was.  
> 
> > As you can see there is a difference between the USB port detected
> > during the boot phase and after the unbind/bind:
> > 
> > hub 1-0:1.0: 5 ports detected
> > hub 2-0:1.0: 3 ports detected
> > hub 3-0:1.0: 2 ports detected
> > hub 1-2:1.0: 4 ports detected
> > hub 2-2:1.0: 2 ports detected
> > 
> > echo 0000:00:17.0 >/sys/bus/pci/drivers/ohci-pci/unbind
> > echo 0000:00:17.1 >/sys/bus/pci/drivers/ohci-pci/unbind
> > echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/unbind
> > 
> > echo 0000:00:17.0 >/sys/bus/pci/drivers/ohci-pci/bind
> > echo 0000:00:17.1 >/sys/bus/pci/drivers/ohci-pci/bind
> > echo 0000:00:17.2 >/sys/bus/pci/drivers/ehci-pci/bind
> > 
> > hub 1-0:1.0: 3 ports detected
> > hub 2-0:1.0: 2 ports detected
> > hub 3-0:1.0: 5 ports detected
> > hub 1-0:1.0: 3 ports detected
> > hub 2-0:1.0: 2 ports detected
> > hub 3-2:1.0: 4 ports detected
> > hub 1-2:1.0: 2 ports detected
> > 
> > This was kernel 3.10, but i get similar results for 3.14
> 
> Of course.  This is because you rebound the drivers in a different 
> order from the binding during boot.  During boot, the EHCI controller 
> (17.2) was assigned to bus 1, and the two OHCI controllers (17.0 and 
> 17.2) were assigned to buses 2 and 3.
> 
> But when you rebound the drivers, you did 17.0 and 17.1 first, so they 
> were assigned to buses 1 and 2.  Then 17.2 was assigned to bus 3.  If 
> you had bound 17.2 and then 17.0 and 17.1, you would have gotten the 
> same results as during boot.
> 
> I can't tell why the two devices failed to initialize.  Can you plug
> either of them into an x86-based computer and see if it shows the same
> behavior there?
> 
> Alan Stern
> 



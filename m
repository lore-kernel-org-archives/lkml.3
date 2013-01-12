Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3ALRhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 12:37:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:44595 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753746Ab3ALRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 12:37:34 -0500
Date: Sat, 12 Jan 2013 12:37:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alex Riesen <raa.lkml@gmail.com>
cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301121232510.32458-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2013, Alex Riesen wrote:

> On Fri, Jan 11, 2013 at 10:04 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> > Hi,
> >
> > the USB stick (an Cruzer Titanium 2GB) was not recognized at any of
> > the USB ports of this system (an System76 lemu4 laptop, XHCI device)
> > after it was removed. If I attempt to insert it again in any of the
> > ports (one of the two USB3, or the USB2) the led on the stick lights
> > up shortly and if off again. There is no media detection messages in
> > the dmesg output, only that from the first time:

To make testing simpler, use only the USB-2 ports.  The xHCI driver is 
not as mature as the EHCI driver.

> >  usb 1-1.2: new high-speed USB device number 3 using ehci-pci
> >  usb 1-1.2: New USB device found, idVendor=0781, idProduct=5408
> >  usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >  usb 1-1.2: Product: U3 Titanium
> >  usb 1-1.2: Manufacturer: SanDisk Corporation
> >  usb 1-1.2: SerialNumber: 0000187A3A60F1E9
> >  scsi6 : usb-storage 1-1.2:1.0
> >  io scheduler deadline registered (default)
> >  usb 1-1.2: USB disconnect, device number 3
> >
> > The kernel is v3.8-rc3. I never had this problem in 3.7. I could almost
> > reproduce the problem later in a simplified setup (init=/bin/bash) on
> > USB3 ports by inserting and removing the stick quickly. Almost - because
> > the USB3 ports recovered after some time, while the USB2 port never
> > experienced the problem.

For testing, use a kernel with CONFIG_USB_DEBUG and CONFIG_PRINTK_TIME 
enabled.  Do the following:

After a normal boot, run "dmesg -C" to clear the log buffer.

Then plug in the stick.  After a couple of seconds, type Alt-SysRq-W.

Then unplug the stick.  After a couple of seconds, type Alt-SysRq-W 
again.

Then collect the output from dmesg and post it.

> One more detail: I usually use the "noop" elevator. That time it was
> the "deadline". And I just reproduced it easily with "deadline".

I doubt the elevator has anything to do with this.

Alan Stern


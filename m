Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3APPAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:00:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60064 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751405Ab3APPAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:00:48 -0500
Date: Wed, 16 Jan 2013 10:00:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Woody Suwalski <terraluna977@gmail.com>
cc: Andreas Mohr <andi@lisas.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
In-Reply-To: <50F62BEC.4060602@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301160955450.1704-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Woody Suwalski wrote:

> > Another important change is that the EHCI driver is now split into two
> > modules.  That can slow down loading and affect the timing.
> >
> > Alan Stern
> >
> My testcase is a live initramfs + squash root.
> The boot logic is as stable as can be - unchanged since 2.6.2x kernels.
> And it was working fine till 3.8-rc1.
> 
> The modules are insmoded in a fixed order:
> usb-common, usbcore, xhci-hcd, ehci-hcd, uhci-hcd, ohci-hcd, usbhid, 
> usb_storage,...

But apparently you don't insmod ehci-pci.  That could cause problems, 
if your EHCI controller is PCI-based.

> If all USB is built as modules - I get read errors from USB drives when 
> accessing squash image, boot fails.

What read errors?  What is the cause of these errors?

> If usb-common and usbcore are built in, system seems to crawl with a 
> very slow USB, but boots. That could be caused by timing between hcd 
> modules.

Do have a dmesg log with timestamps so we can see where things go slow?  
I suggest enabling CONFIG_PRINTK_TIME and CONFIG_USB_DEBUG.  You might
even want CONFIG_USB_STORAGE_DEBUG, although that often logs too much
information.

> If usb-common, usbcore and ehci-hcd are built-in, all works OK like 
> "before 3.8".

What about ehci-pci?

> I was testing on machines  without xhci or ohci hardware, so these 
> drivers probably are not playing any role.
> I have retried initramfs with a 1s sleep between insmods to verify if it 
> is timing - still the same read errors - so the main issue is _not_ timing.
> The read errors problem is 100% reproducible for me, the blocks where 
> read fails are not fixed - every (failed) boot errors start appearing in 
> a bit different location.
> Just selecting a differently - configured  kernel image makes the boot 
> work, so it is not a problem of squash image, USB drive, squashfs driver.

Without knowing what these read errors are, it's hard to say anything 
about them.

Alan Stern


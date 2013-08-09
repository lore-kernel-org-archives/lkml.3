Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab3HITfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:35:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56266 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758318Ab3HITfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:35:05 -0400
Date: Fri, 9 Aug 2013 15:35:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Richter <richter@rus.uni-stuttgart.de>
cc: linux@brodo.de, <linux-kernel@vger.kernel.org>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <52054306.20500@rus.uni-stuttgart.de>
Message-ID: <Pine.LNX.4.44L0.1308091533480.1405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Thomas Richter wrote:

> On 09.08.2013 19:46, Alan Stern wrote:
> > On Fri, 9 Aug 2013, Thomas Richter wrote:
> >
> >> Hi Alan, hi Dominik,
> >>
> >> maybe you want me to help out a bit - I'm having trouble getting a
> >> Delock PCMCIA to USB-2 adapter to work under linux, with strange
> >> behavior in some situations. The trouble is that while I can *read* via
> >> fast (usb 2.0) transfers from the port, an ehci-triggered write just
> >> locks up (it does not Oops, though) and I'm pretty much stuck narrowing
> >> down the problem.
> >
> > The best way to start will be to enable CONFIG_USB_DEBUG in your kernel
> > and post the dmesg log.  Also post a usbmon trace showing what happens
> > when you try to write something.
> 
> Will try and report back, thanks. I've bisected it down in the meantime 
> to a change from 2.6.31.6 to 2.6.32.6. Interestingly, this is very much 
> the same time when the udev userland changed. It works with 2.6.31.6 old 
> udev, but not with 2.6.36.2, new udev.

Can't you use the new udev with the old kernel?

> Probably the handover from full speed to USB 2.0 got broken?

The handover goes the other way, from EHCI to OHCI.

> Note that this laptop has now both uhci (legacy) and ohci (as by the 
> pcmcia card, as companion of the ehci) chips, which probably adds to the 
> problem.

That should not make any difference.

Alan Stern


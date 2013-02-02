Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab3BBPaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:30:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53615 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab3BBPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:30:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Feb 2013 16:30:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Einon <mark.einon@gmail.com>, Peter Hurley <peter@hurleysoftware.com>,
        <linux1394-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
Message-ID: <20130202163030.7dc47112@stein>
In-Reply-To: <Pine.LNX.4.44L0.1302021010340.25931-100000@netrider.rowland.org>
References: <20130202160103.0ce1fc43@stein>
	<Pine.LNX.4.44L0.1302021010340.25931-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 02 Alan Stern wrote:
> On Sat, 2 Feb 2013, Stefan Richter wrote:
> 
> > On Feb 01 Mark Einon wrote:
> > > On 1 February 2013 21:09, Peter Hurley <peter@hurleysoftware.com> wrote:
> > > >>>> On Jan 29 Alan Stern wrote:
> > > >>>>> Why does the pci_suspend routine call free_irq() at all?  As far as I 
> > > >>>>> know, it's not supposed to do that.  Won't the device continue to use 
> > > >>>>> the same IRQ after it is resumed?
> > 
> > As far as I can tell, it happened to be done that way as a side effect of
> > how the probe() and resume() methods share code.  It has remained like
> > this since the initial implementation:
> > http://git.kernel.org/linus/2aef469a35a2
> 
> At one point, quite a few years ago, Linus complained about drivers the 
> release IRQs during suspend only to reacquire them during resume.  A 
> little refactoring should be able to separate out resource 
> acquisition/release (done only during probe and remove) from activation 
> and shutdown (also done during resume and suspend).
> 
> > Still, at this point I would like to learn whether .suspend() followed
> > by .remove() is a valid order of sequence which drivers must support
> > before I prepare myself to get comfortable with a refactoring of
> > firewire-ohci's .probe()/.resume()/suspend()/remove().  Obviously, so far
> > my assumption was that a successful .suspend() can only ever be followed
> > by .resume().
> 
> It depends on the subsystem.  Some subsystems do have suspend -> remove
> transitions and others don't.  In general, it's a good idea for drivers
> to be prepared for removal while the system is asleep.  Presumably any
> hot-unpluggable bus (which includes most of the important buses these
> days) would have to support it.

OK, thank you.  In this case we are of course dealing with the pci
subsystem (and with PCI/ CardBus/ PCI Express/ ExpressCard attached
hardware).  Maybe I should have addressed my question to linux-pci
instead of linux-pm; however, if this is the general expectation,
then I too prefer firewire-ohci to be able to handle it even if the pci
subsystem wouldn't require it presently (which now sounds unlikely).
-- 
Stefan Richter
-=====-===-= --=- ---=-
http://arcgraph.de/sr/

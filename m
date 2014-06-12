Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaFLONA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:13:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42523 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756009AbaFLOM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:12:57 -0400
Date: Thu, 12 Jun 2014 10:12:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Chen <peter.chen@freescale.com>
cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
In-Reply-To: <20140612063104.GB18009@shlinux1.ap.freescale.net>
Message-ID: <Pine.LNX.4.44L0.1406121003370.1138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Peter Chen wrote:

> > Peter, correct me if this is wrong.  It sounds like you want to have a 
> > way for the user to control which gadget driver gets bound to which UDC 
> > driver when everything is compiled into the kernel, nothing is built 
> > as a separate module.  Is that the basic idea?
> 
> Yes, I know it can be done by gadget-configfs, but how about the user
> chooses other gadgets, eg: g_webcam, g_audio?
> 
> I forget to introduce the background of this topic, I have this issue
> when I implement gadget bus patch set.
> (http://www.spinics.net/lists/linux-usb/msg107797.html)
> The current behaviour for other gadgets is auto-binding, so I want
> to keep auto-binding at my gadget bus implementation, but manual-binding
> is also a feature we need to support for other gadgets, so I
> want auto-binding is the default binding way, and the user can switch
> the two binding ways, eg, module parameters or sys entry.
> 
> But if both udc driver and gadget driver are built in, the user can't
> let manual-binding work during the boot since the device-model will
> do probe, and do auto-binding.
> 
> My v1 patch set [3/4] do a tricky way to work around it, I would like to
> know if it can be supported by device model framework?

I think we can keep everything a lot simpler.  Let's agree that the old
non-composite gadget drivers (like g_ether, g_mass_storage, and so on)
should only be used one at a time.  That is, there should never be more
than one of them compiled into the kernel or loaded as a module, and 
they shouldn't be used if there is more than one unbound UDC.

If a user wants to work with more than one UDC or more than one gadget
driver then he should use function drivers with the configfs interface
(or functionfs or gadgetfs or whatever).

Does that seem reasonable?  It doesn't solve your problem so much as
declare it an unsupported case, but I don't think there is any
reasonable way to solve the problem without using something like
configfs.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFKT1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:27:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42700 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751335AbaFKT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:27:14 -0400
Date: Wed, 11 Jun 2014 15:27:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Peter Chen <peter.chen@freescale.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
In-Reply-To: <20140611191017.GA15120@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1406111520270.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Greg KH wrote:

> We can't break existing systems, so I don't understand the issue here.
> Just don't configure your kernel for a system you don't have / want,
> right?
> 
> > > > From what I read code, we can't implement above feature, but I may
> > > > be wrong, if you have some solutions, give me some hints please.
> > > > If there is no solution for above feature, do we agree with exporting
> > > > .drivers_autoprobe for bus driver or something similar?
> > > 
> > > I don't understand what you mean by this, care to show me with code?
> > 
> > I mean the individual bus driver can't change bus->p->drivers_autoprobe?
> > bus->p->drivers_autoprobe is handled at drivers/base/bus.c.
> > 
> > If the individual bus driver can change bus->p->drivers_autoprobe, we
> > can disable autoprobe (auto-binding) during booting.
> 
> No, that's a core only thing.

Peter, correct me if this is wrong.  It sounds like you want to have a 
way for the user to control which gadget driver gets bound to which UDC 
driver when everything is compiled into the kernel, nothing is built 
as a separate module.  Is that the basic idea?

This shouldn't be a problem if you use configfs or libusbg.

Alan Stern


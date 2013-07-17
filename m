Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3GQPhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:37:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42280 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756147Ab3GQPhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:37:36 -0400
Date: Wed, 17 Jul 2013 11:37:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Rong Wang <wr011235813@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
In-Reply-To: <20130717132736.GA7614@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1307171134530.1555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Felipe Balbi wrote:

> On Wed, Jul 17, 2013 at 09:04:54PM +0800, Rong Wang wrote:
> > Hi Felipe,
> > 
> > On Wed, Jul 17, 2013 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > Hi,
> > >
> > > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> > >> > The question is since we default GADGET, so the g_mass_storage.ko is
> > >> > installed early but connecting to a host PC
> > >> > is randomly, But the udev has no idea when a host PC connects our device.
> > >> >
> > >> > So we consider it's reasonable to let the udev know the GADGET device state.
> > >> > Is there any alternative to our question?
> > >>
> > >> I thought we already export events for gadget device states, have you
> > >> looked for them?  I can't dig through the code at the moment, but this
> > >> seems like a pretty common issue...
> > >>
> > >> Felipe, any ideas?
> > >
> > > we already expose that in sysfs. IIRC udev can act on sysfs changes,
> > > no ?
> > 
> > I do not know if udev can polling sysfs file content change. I'll study this.
> > 
> > But the change is triggered by calling usb_gadget_set_state, and I find
> > composite framework do not call this. Then we should do this common work
> > in every udc driver?
> 
> yes. Only the UDC driver knows when the controller is moving among those
> states.

Not quite.  Only the gadget driver knows when the transition between 
ADDRESS and CONFIGURED occurs.  This should be added to composite.c.

Alan Stern


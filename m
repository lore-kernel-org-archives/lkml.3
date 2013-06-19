Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3FSScE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:32:04 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54373 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776Ab3FSScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:32:02 -0400
X-Sasl-enc: P32yZDdKUhM/WHACERj4hYhYgYFe+qDThZADk1vZCPpk 1371666714
Date: Wed, 19 Jun 2013 11:32:31 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Hannes Weisbach <hannes_weisbach@gmx.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lp: implement proper detach function for parport_driver
 lp
Message-ID: <20130619183231.GA7684@kroah.com>
References: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net>
 <20130603210816.GA22677@kroah.com>
 <1EA8660C-5E07-42FC-91D4-7924BE87D5D7@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1EA8660C-5E07-42FC-91D4-7924BE87D5D7@gmx.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 07:04:51PM +0200, Hannes Weisbach wrote:
> >> Signed-off-by: Hannes Weisbach <hannes_weisbach@gmx.net>
> >> ---
> >> Granted, for normal parport drivers this is usually not an issue,
> >> because the device does not go away. However, I am currently writing a
> >> Linux device driver for a USB to parallel port converter [0] and
> >> therefore need proper detaching. Additionally, the wrong ref count
> >> keeps me from simply rmmod my driver and insmod a new version while
> >> developing and testing.
> > 
> > Really?  We already have a usb to parallel port driver in the kernel
> > tree that seems to work just fine.
> 
> >  It's been there since the 2.3 kernel
> > days, so either it has the same problem, or your driver is doing
> > something odd.
> 
> Do you mean the USB Printer class driver for pseudo parallel port
> adapters?  They don't use the char/lp.c printer driver.  (Or I didn't
> see it).  I'm writing a driver for USB2LPT [0], which gives you a real
> /dev/parportN-device in user space, with which you can do all the
> bit-twiddling like with a real parallel port.
> 
> Or do you mean USS720 (misc/uss720.c) and MOS7715 (serial/mos7720.c)
> drivers.

Yes, I mean these.

> They are doing what I am doing: translating whatever the
> user does on a /dev/parportN-node and sending device-specific commands
> over USB.  When they do parport_announce_port(), lp.c should also be
> initialized and they should have the same problem.

Why hasn't anyone reported that problem then?  Surely someone must use
these, they've been in the kernel tree for over a decade now.

> On second thought, my patch might not be optimal.  lp.c stores
> instance-structs in an array of size 8.  So after 8 re-plugs, lp.c
> will not instantiate any more printer devices.  I think I better go
> all the way and replace that array with a list, to have a proper
> solution.

Proper solutions are always good :)

thanks,

greg k-h

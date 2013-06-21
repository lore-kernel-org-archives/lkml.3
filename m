Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946067Ab3FUUpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:45:18 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59748 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945963Ab3FUUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:45:16 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 21 Jun 2013 13:45:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-kernel@vger.kernel.org, wokeswang@qnap.com
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
Message-ID: <20130621204518.GA9370@roeck-us.net>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
 <1371687272.30351.13.camel@heisenberg.scientia.net>
 <20130620025900.GA21820@kroah.com>
 <1371763706.5197.6.camel@fermat.scientia.net>
 <20130620214207.GA12922@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620214207.GA12922@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:42:07PM -0700, Greg KH wrote:
> On Thu, Jun 20, 2013 at 11:28:26PM +0200, Christoph Anton Mitterer wrote:
> > Hey Greg.
> > 
> > On Wed, 2013-06-19 at 19:59 -0700, Greg KH wrote:
> > > If you can dig the code out into a stand-alone form that I can make into
> > > a patch for the drivers/staging/ tree, I'll be glad to take it.
> > Well I don't think my kernel/hardware development skills are enough for
> > that... especially as Guenter already said that the code shouldn't be
> > part of hwmon/it87 ... but rather a separate gpio driver...
> 
> Fair enough.
> 
The best/cleanest option would be to have a mfd core driver for the IT87xx
variants and client drivers for hwmon, gpio, etc. Given that this might be
a bit complicated, another option would be to add gpio support into the
it87 driver itself. Unfortunately, I won't have time to do any of that.

What is worse is that the QNAP folks hacked the kernel all over the place.
There isn't just GPIO access added to the it87 driver (without using the gpio
subsystem), but platform initialization as well as code to access LEDs
and power buttonswere added to it as well. Overall they have hundreds of
patches on top of a 3.4.6 kernel. So we are not only talking about adding
support for the GPIO pins of IT87xx, and adding LED support as well as power
button handling on top of that, but about digging through a whole lot of
changes all over the place to find what is relevant.

The bad thing about it is really that many of the changes they made would be
beneficial to have in the upstream kernel, only it would probably take
man-years to clean it all up and get it there. Now the code isn't upstream,
they have a maintenance nightmare, and no one benefits from it :(.

Guenter

> > > Or, if
> > > you get a contact at QNAP, I'll be glad to help out there as well
> > Well I've asked them again,... no reply so far.
> > The only direct contact I know (from the sources of their drivers) is
> > Wokes Wang, which I've CCed. Perhaps he can help.
> 
> That would be great.  Also, do you have a pointer to the git tree for
> the hardware again, I can't seem to find it.  I can dig through the tree
> to see if I can make something "self-contained", if you are willing to
> test it out.
> 
> thanks,
> 
> greg k-h
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaIJSfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:35:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIJSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:35:47 -0400
Date: Wed, 10 Sep 2014 11:33:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140910183341.GB15117@kroah.com>
References: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
 <20140908231733.GB23907@kroah.com>
 <20140909055615.GA10306@jtlinux>
 <20140910002635.GA2189@kroah.com>
 <20140910060723.GA3525@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910060723.GA3525@jtlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 08:07:24AM +0200, Johannes Thumshirn wrote:
> On Tue, Sep 09, 2014 at 05:26:35PM -0700, Greg Kroah-Hartman wrote:
> > On Tue, Sep 09, 2014 at 07:56:15AM +0200, Johannes Thumshirn wrote:
> > > On Mon, Sep 08, 2014 at 04:17:33PM -0700, Greg Kroah-Hartman wrote:
> > > > >
> > > > > @@ -118,6 +117,10 @@ static int align;
> > > > >  module_param(align, int, S_IRUGO);
> > > > >  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
> > > > >
> > > > > +static int rx_timeout;
> > > > > +module_param(rx_timeout, uint, S_IRUGO);
> > > > > +MODULE_PARM_DESC(rx_timeout, "RX timeout");
> > > >
> > > > Why add a module parameter?  Who will know to set this?  And to what
> > > > value?
> > > >
> > >
> > > There will be a user manual describing the parameter. It's like the rxlvl and
> > > txlvl parameters, you'll have to read the manual if you need other values than
> > > the default ones.
> >
> > Ugh, but module parameters are for all devices in the system of this
> > type, which is why we try not to have them at all anymore.
> >
> > And I don't like the other module parameters either :(
> >
> > But it's an odd-one-off driver, I guess we can live...
> 
> Just for my information, what would be the correct way to do these kinds of
> hardware specific settings? Sysfs? Debugfs? Custom ioctl()s (no struct file_operations,
> so probably not)?

For serial ports, odds are there is already some other way to do this
through a common interface...

But sysfs is a good way to go if you really need it, just document it
properly in Documentation/ABI/

thanks,

greg k-h

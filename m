Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaIJGKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 02:10:14 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.140]:34551 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbaIJGKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 02:10:10 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 02:10:10 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-180.messagelabs.com!1410329022!37883013!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 10 Sep 2014 08:03:43 +0200
Date: Wed, 10 Sep 2014 08:07:24 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140910060723.GA3525@jtlinux>
References: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
 <20140908231733.GB23907@kroah.com>
 <20140909055615.GA10306@jtlinux>
 <20140910002635.GA2189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910002635.GA2189@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:26:35PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Sep 09, 2014 at 07:56:15AM +0200, Johannes Thumshirn wrote:
> > On Mon, Sep 08, 2014 at 04:17:33PM -0700, Greg Kroah-Hartman wrote:
> > > >
> > > > @@ -118,6 +117,10 @@ static int align;
> > > >  module_param(align, int, S_IRUGO);
> > > >  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
> > > >
> > > > +static int rx_timeout;
> > > > +module_param(rx_timeout, uint, S_IRUGO);
> > > > +MODULE_PARM_DESC(rx_timeout, "RX timeout");
> > >
> > > Why add a module parameter?  Who will know to set this?  And to what
> > > value?
> > >
> >
> > There will be a user manual describing the parameter. It's like the rxlvl and
> > txlvl parameters, you'll have to read the manual if you need other values than
> > the default ones.
>
> Ugh, but module parameters are for all devices in the system of this
> type, which is why we try not to have them at all anymore.
>
> And I don't like the other module parameters either :(
>
> But it's an odd-one-off driver, I guess we can live...

Just for my information, what would be the correct way to do these kinds of
hardware specific settings? Sysfs? Debugfs? Custom ioctl()s (no struct file_operations,
so probably not)?

I guess we (and others) have a lot hardware that can be tweaked some way other
than what the framework supports and if module parameters aren't the way to go I
there must be some other way to configure this.

>
> > > And what about this driver working on old hardware, didn't you just
> > > break this?
> > >
> >
> > No. Currently the hardware is in a testing stage at only one customer and it is
> > an IP-Core inside a FPGA, so it can be (and already is) updated. So we can be
> > save to assume this is O.K.
>
> Ok, can you please resend this, it's gone from my queue now.

O.K. On the way.

Thanks,
Johannes

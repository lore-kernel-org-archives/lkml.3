Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaIJA0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:26:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47604 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaIJA0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:26:36 -0400
Date: Tue, 9 Sep 2014 17:26:35 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140910002635.GA2189@kroah.com>
References: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
 <20140908231733.GB23907@kroah.com>
 <20140909055615.GA10306@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909055615.GA10306@jtlinux>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 07:56:15AM +0200, Johannes Thumshirn wrote:
> On Mon, Sep 08, 2014 at 04:17:33PM -0700, Greg Kroah-Hartman wrote:
> > >
> > > @@ -118,6 +117,10 @@ static int align;
> > >  module_param(align, int, S_IRUGO);
> > >  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
> > >
> > > +static int rx_timeout;
> > > +module_param(rx_timeout, uint, S_IRUGO);
> > > +MODULE_PARM_DESC(rx_timeout, "RX timeout");
> >
> > Why add a module parameter?  Who will know to set this?  And to what
> > value?
> >
> 
> There will be a user manual describing the parameter. It's like the rxlvl and
> txlvl parameters, you'll have to read the manual if you need other values than
> the default ones.

Ugh, but module parameters are for all devices in the system of this
type, which is why we try not to have them at all anymore.

And I don't like the other module parameters either :(

But it's an odd-one-off driver, I guess we can live...

> > And what about this driver working on old hardware, didn't you just
> > break this?
> >
> 
> No. Currently the hardware is in a testing stage at only one customer and it is
> an IP-Core inside a FPGA, so it can be (and already is) updated. So we can be
> save to assume this is O.K.

Ok, can you please resend this, it's gone from my queue now.

greg k-h

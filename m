Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaIIFwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:52:45 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.106]:24460 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350AbaIIFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:52:43 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-193.messagelabs.com!1410241959!23742867!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 09 Sep 2014 07:52:40 +0200
Date: Tue, 9 Sep 2014 07:56:15 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: serial: men_z135_uart: Fix driver for changes in
 hardware
Message-ID: <20140909055615.GA10306@jtlinux>
References: <1409229140-14407-1-git-send-email-johannes.thumshirn@men.de>
 <20140908231733.GB23907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140908231733.GB23907@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 04:17:33PM -0700, Greg Kroah-Hartman wrote:
> >
> > @@ -118,6 +117,10 @@ static int align;
> >  module_param(align, int, S_IRUGO);
> >  MODULE_PARM_DESC(align, "Keep hardware FIFO write pointer aligned, default 0");
> >
> > +static int rx_timeout;
> > +module_param(rx_timeout, uint, S_IRUGO);
> > +MODULE_PARM_DESC(rx_timeout, "RX timeout");
>
> Why add a module parameter?  Who will know to set this?  And to what
> value?
>

There will be a user manual describing the parameter. It's like the rxlvl and
txlvl parameters, you'll have to read the manual if you need other values than
the default ones.


> And what about this driver working on old hardware, didn't you just
> break this?
>

No. Currently the hardware is in a testing stage at only one customer and it is
an IP-Core inside a FPGA, so it can be (and already is) updated. So we can be
save to assume this is O.K.

> thanks,
>
> greg k-h

Hope that helped.
Johannes

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaF3Qds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:33:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40810 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754188AbaF3Qdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:33:46 -0400
Date: Mon, 30 Jun 2014 12:33:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <julia.lawall@lip6.fr>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: host: ohci-tmio: Use managed interfaces for resource
 allocation
In-Reply-To: <alpine.DEB.2.10.1406301737020.3511@hadrien>
Message-ID: <Pine.LNX.4.44L0.1406301210500.1550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Julia Lawall wrote:

> > > @@ -215,30 +213,31 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
> > >
> > >  	spin_lock_init(&tmio->lock);
> > >
> > > -	tmio->ccr = ioremap(config->start, resource_size(config));
> > > +	tmio->ccr = devm_ioremap(&dev->dev, config->start,
> > > +				 resource_size(config));
> >
> > You should use devm_ioremap_resource() rather than devm_ioremap().
> 
> Even if there was no request_mem_region in the original code?

Hmmm, that does seem strange.

Looking at some of the other OHCI platform drivers, I see that one of
them (ohci-sa1111.c) calls request_mem_region without ioremap and two
of them (ohci-omap3.c, ohci-tmio.c) call ioremap without
request_mem_region.  (ohci-ppc-of.c also calls request_mem_region
without ioremap, but for a totally different reason.)

In the case of ohci-sa1111 this appears to be a platform-specific 
thing.  Are the other two simply buggy?

Alan Stern


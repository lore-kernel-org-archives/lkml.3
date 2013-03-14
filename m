Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab3CNPIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:08:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52475 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757702Ab3CNPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:08:52 -0400
Date: Thu, 14 Mar 2013 11:08:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, <gregkh@linuxfoundation.org>,
        <b-cousson@ti.com>, <mark.rutland@arm.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 11/12] USB: ehci-omap: Try to get PHY even if not in PHY
 mode
In-Reply-To: <20130314140832.GH26080@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1303141107420.1983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Felipe Balbi wrote:

> > >  		if (IS_ERR(phy) || !phy) {
> > > +			/* Don't bail out if PHY is not absolutely necessary */
> > > +			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
> > > +				continue;
> > > +
> > >  			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
> > >  			dev_err(dev, "Can't get PHY device for port %d: %d\n",
> > >  					i, ret);
> > 
> > Felipe, this is a strange interface.  Why do we sometimes get an 
> > error-pointer and sometimes get just NULL?  Why not always an 
> > error-pointer?
> 
> looks like we get NULL when PHY layer is disabled. Sounds like an
> oversight to me. Do you want to send a patch, or do I cook one and put
> yourself as Reported-by ?

You're more familiar with that code.  "Reported-by" is good enough for 
me.  :-)

Alan Stern


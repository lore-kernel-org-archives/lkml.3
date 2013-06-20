Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3FTRZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:25:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55210 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757339Ab3FTRZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:25:33 -0400
Date: Thu, 20 Jun 2013 13:25:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Chao Xie <xiechao.mail@gmail.com>, Roger Quadros <rogerq@ti.com>,
        Chao Xie <chao.xie@marvell.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] USB: initialize or shutdown PHY when add or remove
 host controller
In-Reply-To: <20130620121749.GF9817@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1306201319580.2063-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Felipe Balbi wrote:

> > In fact, the PHY setting and handling is related to platform or SOC,
> > and for different SOC they can
> > have same EHCI HCD but they PHY handling can be different.
> > Omap'a case is the example, and i think some other vendors may have
> > silimar cases.
> > From above point, It is better to leave the PHY initialization and
> > shutdown to be done by each echi-xxx driver.
> > 
> > So Alan and Felipe
> > What are your ideas about it?
> 
> If we have so many exceptions, then sure. But eventually, the common
> case should be added generically with a flag so that non-generic cases
> (like OMAP) can request to handle the PHY by themselves.
> 
> Alan ?

I don't have very strong feelings about this; Felipe has much more
experience with these things.

However, when the common case is added into the core, the simplest way
to indicate that the HCD wants to handle the PHY(s) by itself will be
to leave hcd->phy set to NULL or an ERR_PTR value.

One important thing that hasn't been pointed out yet: When we move
these calls into the core, the same patch must also remove those calls
from the glue drivers that currently do set hcd->phy.  And it must make
sure that the glue drivers which handle the PHY by themselves do not
set hcd->phy.

Alan Stern


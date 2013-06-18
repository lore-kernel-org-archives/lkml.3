Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3FRPSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:18:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45519 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932490Ab3FRPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:18:50 -0400
Date: Tue, 18 Jun 2013 11:18:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Roger Quadros <rogerq@ti.com>, Chao Xie <chao.xie@marvell.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <xiechao.mail@gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host
 controller
In-Reply-To: <20130618150050.GD10318@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1306181113390.1157-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Felipe Balbi wrote:

> yeah, Roger brought up a big problem with OMAP's EHCI depending on the
> mode so, at least for now, we should keep phy_get and, in case of EHCI
> OMAP, phy_init in the glue :-(
> 
> Roger has all the details, and they're also in the list archives, but
> basically, depending on the mode, PHY *must* be initialized at a
> particular point.

Right.  Which means the core shouldn't be involved, since the OMAP PHY
initialization has to be done at a non-standard time.  (Unless we 
decide to add a flag for this special case...)

> > Given that the glue module has to be responsible for getting the PHY,
> > it should also be responsible for error checking.  So the code added to
> > hcd.c doesn't need to apply an IS_ERR check; it can simply assume that
> > if hcd->phy is NULL then either there is no software-controllable PHY
> > or else the HCD doesn't want the core to manage it.
> 
> makes sense to me, add the requirement to:
> 
> if (IS_ERR(hcd->phy))
> 	hcd->phy = NULL;

Actually, in the IS_ERR case, most glue drivers just fail the probe.  
But for any that want to continue on, we would have to add this
requirement.

Alan Stern


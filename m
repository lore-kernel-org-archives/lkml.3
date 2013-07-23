Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320Ab3GWVOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:14:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758001Ab3GWVOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:14:21 -0400
Date: Tue, 23 Jul 2013 17:14:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomasz Figa <tomasz.figa@gmail.com>
cc: Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <broonie@kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
In-Reply-To: <1388978.Qc6sFy33oS@flatron>
Message-ID: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Tomasz Figa wrote:

> > If you want to keep the phy struct completely separate from the board
> > file, there's an easy way to do it.  Let's say the board file knows
> > about N different PHYs in the system.  Then you define an array of N
> > pointers to phys:
> > 
> > struct phy *(phy_address[N]);
> > 
> > In the platform data for both PHY j and its controller, store
> > &phy_address[j].  The PHY provider passes this cookie to phy_create:
> > 
> > 	cookie = pdev->dev.platform_data;
> > 	ret = phy_create(phy, cookie);
> > 
> > and phy_create simply stores: *cookie = phy.  The PHY consumer does
> > much the same the same thing:
> > 
> > 	cookie = pdev->dev.platform_data;
> > 	phy = phy_get(cookie);
> > 
> > phy_get returns *cookie if it isn't NULL, or an ERR_PTR otherwise.
> 
> OK, this can work. Again, just technically, because it's rather ugly.

There's no reason the phy_address things have to be arrays.  A separate
individual pointer for each PHY would work just as well.

> Where would you want to have those phy_address arrays stored? There are no 
> board files when booting with DT. Not even saying that you don't need to 
> use any hacky schemes like this when you have DT that nicely specifies 
> relations between devices.

If everybody agrees DT has a nice scheme for specifying relations
between devices, why not use that same scheme in the PHY core?

> Anyway, board file should not be considered as a method to exchange data 
> between drivers. It should be used only to pass data from it to drivers, 
> not the other way. Ideally all data in a board file should be marked as 
> const and __init and dropped after system initialization.

The phy_address things don't have to be defined or allocated in the 
board file; they could be set up along with the platform data.

In any case, this was simply meant to be a suggestion to show that it 
is relatively easy to do what you need without using name or ID 
strings.

Alan Stern


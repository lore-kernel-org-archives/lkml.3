Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab3GWRsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:48:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21240 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722Ab3GWRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:48:18 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-d4-51eec1dfd6b3
From: Tomasz Figa <t.figa@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        b.zolnierkie@samsung.com, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Date: Tue, 23 Jul 2013 19:48:11 +0200
Message-id: <19656720.FrnhefyPXl@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <20130723173710.GB28284@kroah.com>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <1446965.6APW5ZgLBW@amdc1227> <20130723173710.GB28284@kroah.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRzGebfv/fZNND9P9bZSc5SVkIeKeItI6aAfEaFXQV3UdEMN52FL
	SwsUjzmPKaJOy0PTZEmzaepUnDPRpVaShyx0puaFYaMcpuShdrjx7sfzfx6e5+JPsZ0zII+K
	jr0nksQKYvikHTGyMzR5Yk5nDPPv3XHH1apmEm+XDHLw6woVxGWlHSTWzaXisvnvJH5mcsc1
	Ax8gHta9gLhvqxPgjOcqEo/XfYK4oHaSxGNL+SR+n77CwblPFBysXpyCuC5bQWB94S+Ix7uq
	SZzf8gbiKkURgSs+9rJwfWMWG2sLWlh4+LPJXN2hJvDblRyIizfHSDxdngnxD102Ye7WsLCy
	awtg7cTVID6z+bcEMH/WSghGI5/lMFWPKyGjVuaSzMxUD8noKzYJRvu0mcO0KlKZCX06ZAoy
	jCRTtO3PVM1uAKawTQmYoekOFmNSe4Q63bQ7LxTFRCeJJH4X7thFzVUYiPglrwclOQqYBtb2
	ywCXQvRpNDirJm28F40ZVGa2o5zpBoA209MJy8GZlrFQztp9C5O0NzKlLVgDrnQoqlS+swbY
	tJKDhhtH2JaDC30R/cxasTJBH0HNfVUsCzvQPmh0oduqO9JHkbF9yaxTlBsdjIp/x1lkLu2H
	urNecmwjigDSGb5BW9YJbZQarIPYtCfq1ZZBG/sglWaIVQyc5Lts8l02+S5bLWArgZsoMSJe
	Gh4pPukrFYilibGRvhFxYjWwPc5aJ2gYPNcPaArw7R0S5MYwZyhIkiaL+wGi2HxXhwaeWXIQ
	CpJTRJK425LEGJG0H7AoLi8N6HSyA4n5YfOXeIfawXJ9nkbTJKcdxZ7eSFgTyD1uP/U0PElW
	P7rvS5BHNG9I+SqvbTntRnDtSFR1QJ/MK/Df3bMhGevC6ZBVvVp+bXWjazFhfc+AKbMYSQ+6
	5Lbqa291zdGXrxyLa5opf3iGMkE/Eeo5fD3P8BUmBDwKTjnFJ6RRggAftkQq+A/m12GsFgMA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 of July 2013 10:37:11 Greg KH wrote:
> On Tue, Jul 23, 2013 at 06:50:29PM +0200, Tomasz Figa wrote:
> > > Ick, no.  Why can't you just pass the pointer to the phy itself?  If
> > > you
> > > had a "priv" pointer to search from, then you could have just passed
> > > the
> > > original phy pointer in the first place, right?
> > 
> > IMHO it would be better if you provided some code example, but let's
> > try to check if I understood you correctly.
> 
> It's not my code that I want to have added, so I don't have to write
> examples, I just get to complain about the existing stuff :)

Still, I think that some small code snippets illustrating the idea are 
really helpful.

> > 8><--------------------------------------------------------------------
> > ----
> > 
> > [Board file]
> > 
> > static struct phy my_phy;
> > 
> > static struct platform_device phy_pdev = {
> > 
> > 	/* ... */
> > 	.platform_data = &my_phy;
> > 	/* ... */
> > 
> > };
> > 
> > static struct platform_device phy_pdev = {
> > 
> > 	/* ... */
> > 	.platform_data = &my_phy;
> > 	/* ... */
> > 
> > };
> > 
> > [Provider driver]
> > 
> > struct phy *phy = pdev->dev.platform_data;
> > 
> > ret = phy_create(phy);
> > 
> > [Consumer driver]
> > 
> > struct phy *phy = pdev->dev.platform_data;
> > 
> > ret = phy_get(&pdev->dev, phy);
> > 
> > -----------------------------------------------------------------------
> > -><8
> > 
> > Is this what you mean?
> 
> No.  Well, kind of.  What's wrong with using the platform data structure
> unique to the board to have the pointer?
> 
> For example (just randomly picking one), the ata-pxa driver would change
> include/linux/platform_data/ata-pxa.h to have a phy pointer in it:
> 
> struct phy;
> 
> struct  pata_pxa_pdata {
> 	/* PXA DMA DREQ<0:2> pin */
> 	uint32_t	dma_dreq;
> 	/* Register shift */
> 	uint32_t	reg_shift;
> 	/* IRQ flags */
> 	uint32_t	irq_flags;
> 	/* PHY */
> 	struct phy	*phy;
> };
> 
> Then, when you create the platform, set the phy* pointer with a call to
> phy_create().  Then you can use that pointer wherever that plaform data
> is available (i.e. whereever platform_data is at).

Hmm? So, do you suggest to call phy_create() from board file? What phy_ops 
struct and other hardware parameters would it take?

> > > The issue is that a string "name" is not going to scale at all, as it
> > > requires hard-coded information that will change over time (as the
> > > existing clock interface is already showing.)
> > 
> > I fully agree that a simple, single string will not scale even in some,
> > not so uncommon cases, but there is already a lot of existing lookup
> > solutions over the kernel and so there is no point in introducing
> > another one.
> I'm trying to get _rid_ of lookup "solutions" and just use a real
> pointer, as you should.  I'll go tackle those other ones after this one
> is taken care of, to show how the others should be handled as well.

There was a reason for introducing lookup solutions. The reason was that in 
board file there is no way to get a pointer to something that is going to be 
created much later in time. We don't do time travel ;-).

> > > Please just pass the real "phy" pointer around, that's what it is
> > > there
> > > for.  Your "board binding" logic/code should be able to handle this,
> > > as
> > > it somehow was going to do the same thing with a "name".
> > 
> > It's technically correct, but quality of this solution isn't really
> > nice, because it's a layering violation (at least if I understood what
> > you mean). This is because you need to have full definition of struct
> > phy in board file and a structure that is used as private data in PHY
> > core comes from platform code.
> 
> No, just a pointer, you don't need the "full" structure until you get to
> some .c code that actually manipulates the phy itself, for all other
> places, you are just dealing with a pointer and a structure you never
> reference.
> 
> Does that make more sense?

Well, to the point that I think I now understood your suggestion. 
Unfortunately the suggestion alone isn't really something that can be done, 
considering how driver core and generic frameworks work.

Best regards,
Tomasz


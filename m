Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3GWSAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:00:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793Ab3GWR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:59:59 -0400
Date: Tue, 23 Jul 2013 11:01:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
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
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130723180110.GA8688@kroah.com>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
 <20130723161846.GD2486@kroah.com>
 <1446965.6APW5ZgLBW@amdc1227>
 <20130723173710.GB28284@kroah.com>
 <20130723174456.GM9858@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723174456.GM9858@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 06:44:56PM +0100, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 10:37:11AM -0700, Greg KH wrote:
> > On Tue, Jul 23, 2013 at 06:50:29PM +0200, Tomasz Figa wrote:
> 
> > > I fully agree that a simple, single string will not scale even in some, not 
> > > so uncommon cases, but there is already a lot of existing lookup solutions 
> > > over the kernel and so there is no point in introducing another one.
> 
> > I'm trying to get _rid_ of lookup "solutions" and just use a real
> > pointer, as you should.  I'll go tackle those other ones after this one
> > is taken care of, to show how the others should be handled as well.
> 
> What are the problems you are seeing with doing things with lookups?

You don't "know" the id of the device you are looking up, due to
multiple devices being in the system (dynamic ids, look back earlier in
this thread for details about that.)

> Having to write platform data for everything gets old fast and the code
> duplication is pretty tedious...

Adding a single pointer is "tedious"?  Where is the "name" that you are
going to lookup going to come from?  That code doesn't write itself...

thanks,

greg k-h

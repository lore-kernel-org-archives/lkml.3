Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaFLQUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:20:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56128 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753027AbaFLQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:20:32 -0400
Date: Thu, 12 Jun 2014 17:20:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Drake <drake@endlessm.com>
Cc: t.figa@samsung.com, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Robin Holt <holt@sgi.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] Handle non-secure L2C initialization on Exynos4
Message-ID: <20140612162014.GA3705@n2100.arm.linux.org.uk>
References: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD8Lp46MbKZrCAMp+9T9LbWTB4uHRDdivhtjoQbkTyBbK48EgQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 02:38:49PM +0100, Daniel Drake wrote:
> From 2e67231f10ed0b05c2bacfdd05774fe21315d6da Mon Sep 17 00:00:00 2001
> From: Gu1 <gu1@aeroxteam.fr>
> Date: Mon, 21 Jan 2013 04:13:56 +0100
> Subject: [PATCH] ARM: EXYNOS: Add secure firmware support for l2x0 init
> 
> Conflicts:
> 	arch/arm/mm/cache-l2x0.c

For this patch... it's a big NAK because it's taking us right back down
the route of a totally fucked up cache-l2x0.c driver.

Why can't you people write stuff properly?  There's already another set
of patches on this mailing list which want to pass the virtual base
address of the l2x0 controller to l2c_write_sec() so that various
registers can be read back, because the platform's secure API can
only update several registers at the same time.

This is the same pattern that is revealed in this patch.  So, what
this means is that the l2c_write_sec API is wrong.  We need to come
up with a *replacement* API which allows the platforms to do this
kind of setup in a *clean* way, and stop creating rotten hacks like
this which just makes long term maintanence a nightmare.

So... please start doing stuff properly.  If you don't, you're going
to be getting more flames from me, especially if you start doing this
kind of hackery on code that I've been cleaning up to get rid of such
crap.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

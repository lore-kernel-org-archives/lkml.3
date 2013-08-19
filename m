Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3HSIms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:42:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56357 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3HSImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:42:47 -0400
Date: Mon, 19 Aug 2013 10:42:26 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/4] mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe
 to enable
Message-ID: <20130819084226.GB31036@pengutronix.de>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
 <1376302946-11534-3-git-send-email-s.hauer@pengutronix.de>
 <20130817201702.GD11210@norris.computersforpeace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130817201702.GD11210@norris.computersforpeace.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:36:03 up 19 days, 17:40, 41 users,  load average: 0.02, 0.08,
 0.16
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 01:17:02PM -0700, Brian Norris wrote:
> On Mon, Aug 12, 2013 at 12:22:24PM +0200, Sascha Hauer wrote:
> > This patch adds a flag to struct flash_info indicating that
> > fast_read is not supported. This now gives the following logic
> > when determing whether to enable fastread:
> > 
> > 1) enable fast_read if device node contains m25p,fast-read
> > 2) enable fast_read unconditionally if forced in Kconfig
> > 3) Disable fast_read if the chip does not support it
> 
> This logic is either unclear or incorrect.
> 
> > This makes enabling CONFIG_M25PXX_USE_FAST_READ a safe option
> > since we no longer enable the fast_read option unconditionally.
> 
> This statement seems to contradict 2 above, depending on the reading
> (how can 2 enable "unconditionally", yet CONFIG_..._FAST_READ "no longer
> enable[s] ... unconditionally"?).
> 
> The problem I have with this description is that it is assuming that
> 1, 2, and 3 are applied sequentially, so that later items in the
> sequence have higher precedence. So it's describing code ordering, not
> really logic. And statement 3 weakens the "unconditionally" of 2.
> 
> And to avoid simply complaining, I propose an alternative explanation:
> 
>   If the flash chip does not support fast_read, then disable it.
>   Otherwise:
>   1) enable fast_read if device node contains m25p,fast-read
>   2) enable fast_read if forced in Kconfig
> 
> If we correct this description, then:
> 
>   Acked-by: Brian Norris <computersforpeace@gmail.com>
> 
> I can edit the patch and push the whole thing if this is acceptable.

Yes, that would be great. Your explanation sounds better than mine.

> 
> One related question (not required for this series): do we even need
> Kconfig M25PXX_USE_FAST_READ any more? Are there any SPI controllers
> that can't use FAST_READ? Or perhaps if they have a slow clock, it's
> preferable to use normal read?
> 
> If there are no restrictions from the controller side, I think this
> NO_FR flag gives enough information to determine everything at runtime,
> not compile-time.

This M25PXX_USE_FAST_READ is a no-go for multiplatform Kernels and
should be removed. I have no idea though how we can do this without
risking regressions since we have no idea who intentionally disabled
this option. Maybe we just have to find out by removing it and waiting
for people to complain^B^B^Bsend patches.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

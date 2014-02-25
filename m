Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBYJh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:37:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56855 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbaBYJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:37:26 -0500
Date: Tue, 25 Feb 2014 09:37:23 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 3/3] mfd: arizona: Use new regmap features for manual
	register patch
Message-ID: <20140225093723.GE5438@opensource.wolfsonmicro.com>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1393011432-28909-3-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140224161042.GF15847@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224161042.GF15847@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:10:42PM +0000, Lee Jones wrote:
> > On the wm5102 the register patches are applied manually, rather than by
> > the regmap core. This application is wrapped in calls to
> > regcache_cache_bypass. However, this is dangerous as other threads may
> > be accessing the hardware at the same time as the pm_runtime operations
> > and if they do so during the period whilst cache_bypass is enabled those
> > writes will miss the cache when they shouldn't.
> > 
> > Apply the register patch using the new regmap_apply_patch function to
> > avoid this problem. Also remove the call to regcache_cache_bypass from
> > the hardware patch application as it is unneeded there and creates a
> > similar window for writes to miss the cache.
> > 
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c  |    4 ----
> >  drivers/mfd/wm5102-tables.c |   19 ++-----------------
> >  2 files changed, 2 insertions(+), 21 deletions(-)
> 
> Applied, thanks.

Apologies this patch depends on the previous patch I am still
working Mark's comments for. So this can't really be applied at
the moment.

Thanks,
Charles

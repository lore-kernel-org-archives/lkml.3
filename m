Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaEGPUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:20:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41124 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752072AbaEGPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:20:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+kKAaYETb04pKB/rtJfJzt
Date: Wed, 7 May 2014 08:20:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/26] ARM: OMAP: dmtimer: Add comments on OMAP1 clock
 framework
Message-ID: <20140507152004.GC9502@atomide.com>
References: <1398375849-6017-1-git-send-email-joelf@ti.com>
 <1398375849-6017-3-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398375849-6017-3-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140424 14:44]:
> OMAP1 doesn't support clock framework, add a comment where needed
> and correct a FIXME.

This is at least a wrong comment, the original comment seems right
to me.

Tony
 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/plat-omap/dmtimer.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index ecd3f97..f5a674c 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -142,8 +142,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
>  	int rc;
>  
>  	/*
> -	 * FIXME: OMAP1 devices do not use the clock framework for dmtimers so
> -	 * do not call clk_get() for these devices.
> +	 * Do not call clk_get() for OMAP1 due to no clock framework support.
>  	 */
>  	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
>  		timer->fclk = clk_get(&timer->pdev->dev, "fck");
> @@ -461,6 +460,7 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer)
>  	if (unlikely(!timer))
>  		return -EINVAL;
>  
> +	/* OMAP1 is not converted to clk framework so avoid clk_get_rate here */
>  	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
>  		rate = clk_get_rate(timer->fclk);
>  
> -- 
> 1.7.9.5
> 

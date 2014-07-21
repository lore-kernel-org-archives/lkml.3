Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaGULK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:10:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20318 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaGULK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:10:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+o8701im3lj6/F9y8kr+km
Date: Mon, 21 Jul 2014 04:09:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] ARM: OMAP2+: timer: Fix error message to not use
 hwmod structure
Message-ID: <20140721110902.GY18374@atomide.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
 <1398216429-4681-7-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398216429-4681-7-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140422 18:27]:
> oh->name is no longer used, correct the error message.

I guess this error is created by one of the patchs in this
series? So maybe fold it into the patch creating this error?

Regards,

Tony
 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap2/timer.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 4fcfd7a..519ccfd 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -331,8 +331,8 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>  	if (clk_get_parent(timer->fclk) != src) {
>  		r = clk_set_parent(timer->fclk, src);
>  		if (r < 0) {
> -			pr_warn("%s: %s cannot set source\n", __func__,
> -				oh->name);
> +			pr_warn("%s: cannot set timer's source\n", __func__);
> +			WARN_ON(1);
>  			clk_put(src);
>  			return r;
>  		}
> -- 
> 1.7.9.5
> 

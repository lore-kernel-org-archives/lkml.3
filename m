Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaGULI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:08:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47521 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754663AbaGULI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:08:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dU+jeGx+h5bSmv5NEaa8X
Date: Mon, 21 Jul 2014 04:07:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] ARM: OMAP2+: timer: Add comment on timer clk
 parenting
Message-ID: <20140721110730.GX18374@atomide.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
 <1398216429-4681-4-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398216429-4681-4-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140422 18:27]:
> Add a comment describing the state of system timer clock parenting.  The code
> following the comment should be deleted once all platforms can do DT boot, and
> specially should not be executed for DT platforms once we can specify default
> clock parents through DT.

I think we can do it already for DT based booting?

Regards,

Tony
 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap2/timer.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index f192a41..9fdff5b 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -313,6 +313,10 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>  	if (IS_ERR(timer->fclk))
>  		return PTR_ERR(timer->fclk);
>  
> +	/*
> +	 * Clock reparenting code, goes away for DT-boot atleast,
> +	 * once clock layer can do it through DT.
> +	 */
>  	src = clk_get(NULL, fck_source);
>  	if (IS_ERR(src))
>  		return PTR_ERR(src);
> -- 
> 1.7.9.5
> 

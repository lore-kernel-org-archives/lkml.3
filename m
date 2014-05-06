Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaEFAfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:35:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29660 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933005AbaEFAfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:35:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lWOhjykg5nJ9DgsVbal28
Date: Mon, 5 May 2014 17:35:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Oussama Ghorbel <ghorbel@pivasoftware.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: free use_gptimer_clksrc variable after boot
Message-ID: <20140506003520.GN25949@atomide.com>
References: <1397494170-3111-1-git-send-email-ghorbel@pivasoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397494170-3111-1-git-send-email-ghorbel@pivasoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oussama Ghorbel <ghorbel@pivasoftware.com> [140414 09:50]:
> The variable use_gptimer_clksrc is only used by two __init functions,
> So we can freely free it after boot.
> 
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>

Thanks applying into omap-for-v3.16/fixes-not-urgent.

Tony

> ---
>  arch/arm/mach-omap2/timer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 74044aa..d4a6abd 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -361,7 +361,7 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
>  
>  /* Clocksource code */
>  static struct omap_dm_timer clksrc;
> -static bool use_gptimer_clksrc;
> +static bool use_gptimer_clksrc __initdata;
>  
>  /*
>   * clocksource
> -- 
> 1.8.3.2
> 

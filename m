Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3CHTvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:51:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:24706 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755033Ab3CHTvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:51:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19syW6kh48R2Fx/vcLN6Kfq
Date: Fri, 8 Mar 2013 11:50:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] ARM: OMAP2+: Divorce from local timer API
Message-ID: <20130308195058.GH11806@atomide.com>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
 <1362614646-24113-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362614646-24113-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Boyd <sboyd@codeaurora.org> [130306 16:22]:
> Now that the TWD doesn't rely on the local timer API, OMAP can
> stop selecting it in Kconfig and relying on the config option to
> decide if it should call smp_twd functions.
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-omap2/Kconfig | 1 -
>  arch/arm/mach-omap2/timer.c | 7 -------
>  2 files changed, 8 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 49ac3df..6e1f871 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -88,7 +88,6 @@ config ARCH_OMAP4
>  	select CACHE_L2X0
>  	select CPU_V7
>  	select HAVE_SMP
> -	select LOCAL_TIMERS if SMP
>  	select OMAP_INTERCONNECT
>  	select PL310_ERRATA_588369
>  	select PL310_ERRATA_727915
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 2bdd4cf..c00a8f8 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -587,7 +587,6 @@ OMAP_SYS_GP_TIMER_INIT(3_am33xx, 1, OMAP4_MPU_SOURCE, "ti,timer-alwon",
>  #ifdef CONFIG_ARCH_OMAP4
>  OMAP_SYS_32K_TIMER_INIT(4, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
>  			2, OMAP4_MPU_SOURCE);
> -#ifdef CONFIG_LOCAL_TIMERS
>  static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
>  void __init omap4_local_timer_init(void)
>  {
> @@ -606,12 +605,6 @@ void __init omap4_local_timer_init(void)
>  			pr_err("twd_local_timer_register failed %d\n", err);
>  	}
>  }
> -#else /* CONFIG_LOCAL_TIMERS */
> -void __init omap4_local_timer_init(void)
> -{
> -	omap4_sync32k_timer_init();
> -}
> -#endif /* CONFIG_LOCAL_TIMERS */
>  #endif /* CONFIG_ARCH_OMAP4 */
>  
>  #ifdef CONFIG_SOC_OMAP5
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

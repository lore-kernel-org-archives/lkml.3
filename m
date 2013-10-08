Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3JHRl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:41:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27937 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755554Ab3JHRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:41:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19L3lNT52zrilIfIDaVijPF
Date: Tue, 8 Oct 2013 10:41:49 -0700
From: Tony Lindgren <tony@atomide.com>
To: Simon Barth <simon.pe.barth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-omap2: board-generic: fix undefined symbol
Message-ID: <20131008174149.GB8313@atomide.com>
References: <5253C759.5020406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5253C759.5020406@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Simon Barth <simon.pe.barth@gmail.com> [131008 01:58]:
> Since dra7 reuses the  function 'omap5_realtime_timer_init' in
> arch/arm/mach-omap2/board-generic.c as timer init function, it has to be
> built for this SoC as well.

Thanks applying into omap-for-v3.12/fixes.

Regards,

Tony
 
> Signed-off-by: Simon Barth <Simon.Pe.Barth@gmail.com>
> ---
>  arch/arm/mach-omap2/timer.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index fa74a06..ead48fa 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -628,7 +628,7 @@ void __init omap4_local_timer_init(void)
>  #endif /* CONFIG_HAVE_ARM_TWD */
>  #endif /* CONFIG_ARCH_OMAP4 */
> 
> -#ifdef CONFIG_SOC_OMAP5
> +#if defined(CONFIG_SOC_OMAP5) || defined(CONFIG_SOC_DRA7XX)
>  void __init omap5_realtime_timer_init(void)
>  {
>  	omap4_sync32k_timer_init();
> @@ -636,7 +636,7 @@ void __init omap5_realtime_timer_init(void)
> 
>  	clocksource_of_init();
>  }
> -#endif /* CONFIG_SOC_OMAP5 */
> +#endif /* CONFIG_SOC_OMAP5 || CONFIG_SOC_DRA7XX */
> 
>  /**
>   * omap_timer_init - build and register timer device with an
> -- 
> 1.7.9.5

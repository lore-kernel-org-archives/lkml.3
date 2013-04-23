Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3DWV0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:26:17 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19955 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3DWV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:26:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19y8e6MqVWfHOsHeQLyeg3r
Date: Tue, 23 Apr 2013 14:26:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: remove unused variable
Message-ID: <20130423212607.GL10155@atomide.com>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
 <201304232323.27751.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304232323.27751.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [130423 14:28]:
> ARM: OMAP: remove unused variable
>     
> Commit 0583fe478a7 "ARM: convert arm/arm64 arch timer to use CLKSRC_OF init"
> has left the omap5_realtime_timer_init() function with a stale variable and
> broken whitespace. This fixes both.
>     
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I've applied this patch on top of the timer cleanup series

OK thanks.

Tony
 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index 7dd6453..686e498 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -618,12 +618,10 @@ OMAP_SYS_32K_TIMER_INIT(5, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
>  			2, OMAP4_MPU_SOURCE);
>  void __init omap5_realtime_timer_init(void)
>  {
> -	int err;
> -
>  	omap5_sync32k_timer_init();
>  	realtime_counter_init();
>  
> -        clocksource_of_init();
> +	clocksource_of_init();
>  }
>  #endif /* CONFIG_SOC_OMAP5 */
>  

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab3GPPsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:48:43 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37400 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab3GPPsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:48:42 -0400
Message-ID: <51E56B54.1010800@linaro.org>
Date: Tue, 16 Jul 2013 17:48:36 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/7] ARM: at91/tc/clocksource: replace clk_enable/disable
 with clk_prepare_enable/disable_unprepare.
References: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com> <1373987114-24009-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1373987114-24009-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 05:05 PM, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---

This patch is part of a series and the recipients are also Thomas and
John (clocksource maintainers).

Is this patch going through Nicolas's tree or Thomas's tree ?

Thanks
  -- Daniel

>  drivers/clocksource/tcb_clksrc.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index 8a61872..229c019 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -100,7 +100,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>  			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
>  		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
>  		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
> -		clk_disable(tcd->clk);
> +		clk_disable_unprepare(tcd->clk);
>  	}
>  
>  	switch (m) {
> @@ -109,7 +109,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>  	 * of oneshot, we get lower overhead and improved accuracy.
>  	 */
>  	case CLOCK_EVT_MODE_PERIODIC:
> -		clk_enable(tcd->clk);
> +		clk_prepare_enable(tcd->clk);
>  
>  		/* slow clock, count up to RC, then irq and restart */
>  		__raw_writel(timer_clock
> @@ -126,7 +126,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>  		break;
>  
>  	case CLOCK_EVT_MODE_ONESHOT:
> -		clk_enable(tcd->clk);
> +		clk_prepare_enable(tcd->clk);
>  
>  		/* slow clock, count up to RC, then irq and stop */
>  		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
> @@ -275,7 +275,7 @@ static int __init tcb_clksrc_init(void)
>  	pdev = tc->pdev;
>  
>  	t0_clk = tc->clk[0];
> -	clk_enable(t0_clk);
> +	clk_prepare_enable(t0_clk);
>  
>  	/* How fast will we be counting?  Pick something over 5 MHz.  */
>  	rate = (u32) clk_get_rate(t0_clk);
> @@ -313,7 +313,7 @@ static int __init tcb_clksrc_init(void)
>  		/* tclib will give us three clocks no matter what the
>  		 * underlying platform supports.
>  		 */
> -		clk_enable(tc->clk[1]);
> +		clk_prepare_enable(tc->clk[1]);
>  		/* setup both channel 0 & 1 */
>  		tcb_setup_dual_chan(tc, best_divisor_idx);
>  	}
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3FTHdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:33:12 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:27691 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3FTHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:33:09 -0400
Message-ID: <51C2B02F.5080902@atmel.com>
Date: Thu, 20 Jun 2013 09:33:03 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] ARM: at91/tc/clocksource: replace clk_enable/disable
 with clk_prepare_enable/disable_unprepare.
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com> <1371640400-9399-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1371640400-9399-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/2013 13:13, Boris BREZILLON :
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/clocksource/tcb_clksrc.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
> index 8a61872..229c019 100644
> --- a/drivers/clocksource/tcb_clksrc.c
> +++ b/drivers/clocksource/tcb_clksrc.c
> @@ -100,7 +100,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>   			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
>   		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
>   		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
> -		clk_disable(tcd->clk);
> +		clk_disable_unprepare(tcd->clk);
>   	}
>
>   	switch (m) {
> @@ -109,7 +109,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>   	 * of oneshot, we get lower overhead and improved accuracy.
>   	 */
>   	case CLOCK_EVT_MODE_PERIODIC:
> -		clk_enable(tcd->clk);
> +		clk_prepare_enable(tcd->clk);
>
>   		/* slow clock, count up to RC, then irq and restart */
>   		__raw_writel(timer_clock
> @@ -126,7 +126,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
>   		break;
>
>   	case CLOCK_EVT_MODE_ONESHOT:
> -		clk_enable(tcd->clk);
> +		clk_prepare_enable(tcd->clk);
>
>   		/* slow clock, count up to RC, then irq and stop */
>   		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
> @@ -275,7 +275,7 @@ static int __init tcb_clksrc_init(void)
>   	pdev = tc->pdev;
>
>   	t0_clk = tc->clk[0];
> -	clk_enable(t0_clk);
> +	clk_prepare_enable(t0_clk);
>
>   	/* How fast will we be counting?  Pick something over 5 MHz.  */
>   	rate = (u32) clk_get_rate(t0_clk);
> @@ -313,7 +313,7 @@ static int __init tcb_clksrc_init(void)
>   		/* tclib will give us three clocks no matter what the
>   		 * underlying platform supports.
>   		 */
> -		clk_enable(tc->clk[1]);
> +		clk_prepare_enable(tc->clk[1]);
>   		/* setup both channel 0 & 1 */
>   		tcb_setup_dual_chan(tc, best_divisor_idx);
>   	}
>


-- 
Nicolas Ferre

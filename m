Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KPNfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 08:35:13 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42954 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KPNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 08:35:06 -0500
Message-ID: <52877484.3080507@gmail.com>
Date: Sat, 16 Nov 2013 14:35:00 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] clocksource: orion: Switch to sched_clock_register()
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org> <1384559315-18699-5-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1384559315-18699-5-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 12:48 AM, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks!

> ---
>   drivers/clocksource/time-orion.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/time-orion.c b/drivers/clocksource/time-orion.c
> index 9c7f018..2006622 100644
> --- a/drivers/clocksource/time-orion.c
> +++ b/drivers/clocksource/time-orion.c
> @@ -53,7 +53,7 @@ EXPORT_SYMBOL(orion_timer_ctrl_clrset);
>   /*
>    * Free-running clocksource handling.
>    */
> -static u32 notrace orion_read_sched_clock(void)
> +static u64 notrace orion_read_sched_clock(void)
>   {
>   	return ~readl(timer_base + TIMER0_VAL);
>   }
> @@ -135,7 +135,7 @@ static void __init orion_timer_init(struct device_node *np)
>   	clocksource_mmio_init(timer_base + TIMER0_VAL, "orion_clocksource",
>   			      clk_get_rate(clk), 300, 32,
>   			      clocksource_mmio_readl_down);
> -	setup_sched_clock(orion_read_sched_clock, 32, clk_get_rate(clk));
> +	sched_clock_register(orion_read_sched_clock, 32, clk_get_rate(clk));
>
>   	/* setup timer1 as clockevent timer */
>   	if (setup_irq(irq, &orion_clkevt_irq))
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3KSN52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:57:28 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42676 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3KSN51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:57:27 -0500
Message-ID: <528B6E49.9020104@linaro.org>
Date: Tue, 19 Nov 2013 14:57:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 3/4] clocksource: sun4i: Switch to sched_clock_register()
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org> <1384559315-18699-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1384559315-18699-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2013 12:48 AM, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface. While we're here, mark the sched_clock function as
> notrace to prevent ftrace recursion crashes.
>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Hi Maxime,

could you have look to this patch ?

Thanks
  -- Daniel

>   drivers/clocksource/sun4i_timer.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> index 2fb4695..932d685 100644
> --- a/drivers/clocksource/sun4i_timer.c
> +++ b/drivers/clocksource/sun4i_timer.c
> @@ -138,7 +138,7 @@ static struct irqaction sun4i_timer_irq = {
>   	.dev_id = &sun4i_clockevent,
>   };
>
> -static u32 sun4i_timer_sched_read(void)
> +static u64 notrace sun4i_timer_sched_read(void)
>   {
>   	return ~readl(timer_base + TIMER_CNTVAL_REG(1));
>   }
> @@ -170,7 +170,7 @@ static void __init sun4i_timer_init(struct device_node *node)
>   	       TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
>   	       timer_base + TIMER_CTL_REG(1));
>
> -	setup_sched_clock(sun4i_timer_sched_read, 32, rate);
> +	sched_clock_register(sun4i_timer_sched_read, 32, rate);
>   	clocksource_mmio_init(timer_base + TIMER_CNTVAL_REG(1), node->name,
>   			      rate, 300, 32, clocksource_mmio_readl_down);


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


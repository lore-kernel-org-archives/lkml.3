Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaAQKFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:05:25 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50729 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAQKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:05:22 -0500
Message-ID: <52D90060.5020104@linaro.org>
Date: Fri, 17 Jan 2014 11:05:20 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ingo Molnar <mingo@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] clocksource: timer-sun5i: Switch to sched_clock_register()
References: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1389922686-6249-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 02:38 AM, Stephen Boyd wrote:
> The 32 bit sched_clock interface supports 64 bits since 3.13-rc1.
> Upgrade to the 64 bit function to allow us to remove the 32 bit
> registration interface.
>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Cc'in Ingo because this is simple enough to probably just apply to timers/core

Hi Stephen,

I applied your patch in my tree for 3.15.

Thanks
   -- Daniel

>   drivers/clocksource/timer-sun5i.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
> index bddc52233d2a..deebcd6469fc 100644
> --- a/drivers/clocksource/timer-sun5i.c
> +++ b/drivers/clocksource/timer-sun5i.c
> @@ -136,7 +136,7 @@ static struct irqaction sun5i_timer_irq = {
>   	.dev_id = &sun5i_clockevent,
>   };
>
> -static u32 sun5i_timer_sched_read(void)
> +static u64 sun5i_timer_sched_read(void)
>   {
>   	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
>   }
> @@ -166,7 +166,7 @@ static void __init sun5i_timer_init(struct device_node *node)
>   	writel(TIMER_CTL_ENABLE | TIMER_CTL_RELOAD,
>   	       timer_base + TIMER_CTL_REG(1));
>
> -	setup_sched_clock(sun5i_timer_sched_read, 32, rate);
> +	sched_clock_register(sun5i_timer_sched_read, 32, rate);
>   	clocksource_mmio_init(timer_base + TIMER_CNTVAL_LO_REG(1), node->name,
>   			      rate, 340, 32, clocksource_mmio_readl_down);
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


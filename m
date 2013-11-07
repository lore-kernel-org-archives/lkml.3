Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3KGKRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:17:34 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49670 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3KGKRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:17:32 -0500
Message-ID: <527B68B9.9060701@linaro.org>
Date: Thu, 07 Nov 2013 11:17:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH 1/2] clockevent: sun4i: Fill the irq field in the clockevent
 structure
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com> <1382699771-4396-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382699771-4396-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 01:16 PM, Maxime Ripard wrote:
> The clock event structure irq field was not filled previously to the
> interrupt we're using.
>
> This was resulting in the timer not being used at all when using a
> configuration with SMP enabled on a system with several CPUs, and with
> the cpumask set to the cpu_possible_mask.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to my tree for 3.14

> ---
>   drivers/clocksource/sun4i_timer.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> index 2fb4695..a7f492e 100644
> --- a/drivers/clocksource/sun4i_timer.c
> +++ b/drivers/clocksource/sun4i_timer.c
> @@ -188,6 +188,7 @@ static void __init sun4i_timer_init(struct device_node *node)
>   	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
>
>   	sun4i_clockevent.cpumask = cpumask_of(0);
> +	sun4i_clockevent.irq = irq;
>
>   	clockevents_config_and_register(&sun4i_clockevent, rate,
>   					TIMER_SYNC_TICKS, 0xffffffff);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


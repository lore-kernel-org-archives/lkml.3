Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3KGKTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:19:48 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42863 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3KGKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:19:45 -0500
Message-ID: <527B693D.9010304@linaro.org>
Date: Thu, 07 Nov 2013 11:19:41 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH 2/2] clocksource: sun4i: change CPU mask to cpu_possible_mask
References: <1382699771-4396-1-git-send-email-maxime.ripard@free-electrons.com> <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382699771-4396-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 01:16 PM, Maxime Ripard wrote:
> The interrupt for the timer is a shared processor interrupt, so any CPU
> found in the system can handle it. Switch to our cpumask to
> cpu_possible_mask instead of cpumask_of(0).
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to my tree for 3.14

Thanks !

sidenote: did you look at the CLOCK_EVT_FEAT_DYNIRQ flag ? It may reduce 
the number of wakeup for your system.

> ---
>   drivers/clocksource/sun4i_timer.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
> index a7f492e..6a76b4e 100644
> --- a/drivers/clocksource/sun4i_timer.c
> +++ b/drivers/clocksource/sun4i_timer.c
> @@ -187,7 +187,7 @@ static void __init sun4i_timer_init(struct device_node *node)
>   	val = readl(timer_base + TIMER_IRQ_EN_REG);
>   	writel(val | TIMER_IRQ_EN(0), timer_base + TIMER_IRQ_EN_REG);
>
> -	sun4i_clockevent.cpumask = cpumask_of(0);
> +	sun4i_clockevent.cpumask = cpu_possible_mask;
>   	sun4i_clockevent.irq = irq;
>
>   	clockevents_config_and_register(&sun4i_clockevent, rate,
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbbARSlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:41:01 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:64243 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbbARSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:41:00 -0500
Message-ID: <54BBFE38.5000204@linaro.org>
Date: Sun, 18 Jan 2015 19:40:56 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clocksource: sun5i: Switch to request_irq
References: <1420976410-7826-1-git-send-email-maxime.ripard@free-electrons.com> <1420976410-7826-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1420976410-7826-2-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2015 12:40 PM, Maxime Ripard wrote:
> The current code uses setup_irq, while it could perfectly use the much simpler
> request_irq. Switch to that.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>   drivers/clocksource/timer-sun5i.c | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/clocksource/timer-sun5i.c b/drivers/clocksource/timer-sun5i.c
> index 02268448dc85..738853873a3b 100644
> --- a/drivers/clocksource/timer-sun5i.c
> +++ b/drivers/clocksource/timer-sun5i.c
> @@ -130,13 +130,6 @@ static irqreturn_t sun5i_timer_interrupt(int irq, void *dev_id)
>   	return IRQ_HANDLED;
>   }
>
> -static struct irqaction sun5i_timer_irq = {
> -	.name = "sun5i_timer0",
> -	.flags = IRQF_TIMER | IRQF_IRQPOLL,
> -	.handler = sun5i_timer_interrupt,
> -	.dev_id = &sun5i_clockevent,
> -};
> -
>   static u64 sun5i_timer_sched_read(void)
>   {
>   	return ~readl(timer_base + TIMER_CNTVAL_LO_REG(1));
> @@ -178,7 +171,8 @@ static void __init sun5i_timer_init(struct device_node *node)
>
>   	ticks_per_jiffy = DIV_ROUND_UP(rate, HZ);
>
> -	ret = setup_irq(irq, &sun5i_timer_irq);
> +	ret = request_irq(irq, sun5i_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
> +			  "sun5i_timer", &sun5i_clockevent);

Is the timer name change done in purpose ?

>   	if (ret)
>   		pr_warn("failed to setup irq %d\n", irq);
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


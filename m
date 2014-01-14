Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaANIkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:40:18 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39932 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaANIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:40:14 -0500
Message-ID: <52D4F7EA.6060200@linaro.org>
Date: Tue, 14 Jan 2014 09:40:10 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: arch_timer: Set dynamic irq affinity on
 mmio clockevent
References: <1389048977-13502-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1389048977-13502-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 11:56 PM, Stephen Boyd wrote:
> Set the CLOCK_EVT_FEAT_DYNIRQ flag on the memory mapped
> clockevent so that we save power by waking up the CPU with the
> next event when this timer is used in broadcast mode.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>   drivers/clocksource/arm_arch_timer.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 95fb944e15ee..57e823c44d2a 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -277,6 +277,7 @@ static void __arch_timer_setup(unsigned type,
>   			clk->set_next_event = arch_timer_set_next_event_phys;
>   		}
>   	} else {
> +		clk->features |= CLOCK_EVT_FEAT_DYNIRQ;
>   		clk->name = "arch_mem_timer";
>   		clk->rating = 400;
>   		clk->cpumask = cpu_all_mask;
>

Applied in my tree for 3.15.

I am curious how much you saved in your current scenario. Did you had 
time to do some rough measurements ?

Thanks
   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


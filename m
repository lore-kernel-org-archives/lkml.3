Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaDOMgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:36:10 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48211 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaDOMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:35:34 -0400
Message-ID: <534D27AB.7070109@linaro.org>
Date: Tue, 15 Apr 2014 14:35:55 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de,
        shawn.guo@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: vf_pit_timer: fix pit_read_sched_clock
References: <1397558929-12123-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1397558929-12123-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:48 PM, Xiubo Li wrote:
> The pit_read_sched_clock mean to getting the current counter value,
> and the vf pit timer is a down count timer, this should return
> the counter value or the cycles elapsed.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   drivers/clocksource/vf_pit_timer.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
> index 02821b0..a918bc4 100644
> --- a/drivers/clocksource/vf_pit_timer.c
> +++ b/drivers/clocksource/vf_pit_timer.c
> @@ -54,7 +54,7 @@ static inline void pit_irq_acknowledge(void)
>
>   static u64 pit_read_sched_clock(void)
>   {
> -	return __raw_readl(clksrc_base + PITCVAL);
> +	return ~__raw_readl(clksrc_base + PITCVAL);
>   }
>
>   static int __init pit_clocksource_init(unsigned long rate)
>

Hi Xiubo,

thanks for the patch but this has already been fixed [1] and is 
available in the timers/urgent branch.

Thanks

   -- Daniel

[1] 
https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=timers/urgent&id=224aa3ed45c8735ae02bb2ecca002409fa6aa772
-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


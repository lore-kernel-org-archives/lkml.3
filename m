Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3LJSxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:53:37 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:48768 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3LJSxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:53:35 -0500
Message-ID: <52A76329.7070704@linaro.org>
Date: Tue, 10 Dec 2013 19:53:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: dinguyen@altera.com, dinh.linux@gmail.com, mingo@kernel.org,
        tglx@linutronix.de
CC: jamie@jamieiles.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de
Subject: Re: [PATCHv5 1/2] clocksource: dw_apb_timer_of: Fix read_sched_clock
References: <1386691678-29618-1-git-send-email-dinguyen@altera.com>
In-Reply-To: <1386691678-29618-1-git-send-email-dinguyen@altera.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 05:07 PM, dinguyen@altera.com wrote:
> From: Dinh Nguyen <dinguyen@altera.com>
>
> The read_sched_clock should return the ~value because the clock is a
> countdown implementation. read_sched_clock() should be the same as
>   __apbt_read_clocksource().
>
> Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
> ---
> v5: Split up into 2 patches
> v4: Simplify the fix by simply returning ~__raw_readl(sched_io_base)
> v3: Use APBTMR_N_CURRENT_VALUE define in read_sched_clock()
> v2: Maintain backwards compatibility for "dw-apb-timer-sp" and
>        "dw-apb-timer-osc".
> ---
>   drivers/clocksource/dw_apb_timer_of.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> index 45ba8ae..b29d7cd 100644
> --- a/drivers/clocksource/dw_apb_timer_of.c
> +++ b/drivers/clocksource/dw_apb_timer_of.c
> @@ -108,7 +108,7 @@ static void __init add_clocksource(struct device_node *source_timer)
>
>   static u64 read_sched_clock(void)
>   {
> -	return __raw_readl(sched_io_base);
> +	return ~__raw_readl(sched_io_base);
>   }

Dinh,

I dropped the patch moving the macro definitions as it is not applied 
for urgent and I assume it is not needed for the 3.14 as there are no 
more patches depending on it.

   -- Daniel

>   static const struct of_device_id sptimer_ids[] __initconst = {
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaLPLOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:14:44 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41649 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaLPLOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:14:42 -0500
Message-ID: <54901420.50403@linaro.org>
Date: Tue, 16 Dec 2014 12:14:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-sh@vger.kernel.org, horms@verge.net.au, geert@linux-m68k.org,
        laurent.pinchart@ideasonboard.com, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP
 broadcast
References: <20141216094854.22639.69181.sendpatchset@w520>
In-Reply-To: <20141216094854.22639.69181.sendpatchset@w520>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:48 AM, Magnus Damm wrote:
> From: Magnus Damm <damm+renesas@opensource.se>
>
> Update the TMU driver to use cpu_possible_mask as cpumask to make
> r8a7779 SMP work as expected with or without the ARM TWD timer.
>
> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>

Applied as a 3.18 fix.

Thanks !

   -- Daniel

ps: May I suggest to use the CLOCK_EVT_FEAT_DYNIRQ flag for this driver ?

> ---
>
>   drivers/clocksource/sh_tmu.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 0001/drivers/clocksource/sh_tmu.c
> +++ work/drivers/clocksource/sh_tmu.c	2014-12-16 17:49:49.000000000 +0900
> @@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(s
>   	ced->features = CLOCK_EVT_FEAT_PERIODIC;
>   	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
>   	ced->rating = 200;
> -	ced->cpumask = cpumask_of(0);
> +	ced->cpumask = cpu_possible_mask;
>   	ced->set_next_event = sh_tmu_clock_event_next;
>   	ced->set_mode = sh_tmu_clock_event_mode;
>   	ced->suspend = sh_tmu_clock_event_suspend;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


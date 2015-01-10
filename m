Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbbAJCGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:06:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbbAJCG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:06:29 -0500
Message-ID: <54B08923.3070709@codeaurora.org>
Date: Fri, 09 Jan 2015 18:06:27 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/10] clocksource: Add max_cycles to clocksource structure
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org> <1420850068-27828-5-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1420850068-27828-5-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:34 PM, John Stultz wrote:
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index abcafaa..9b54cb9 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -178,7 +178,7 @@ struct clocksource {
>  #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
>  	struct arch_clocksource_data archdata;
>  #endif
> -
> +	u64 max_cycles;

Nitpick: Update kernel-doc for new field?

>  	const char *name;
>  	struct list_head list;
>  	int rating;
> @@ -291,7 +291,8 @@ extern struct clocksource * __init clocksource_default_clock(void);
> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> index c794b84..2910f00 100644
> --- a/kernel/time/sched_clock.c
> +++ b/kernel/time/sched_clock.c
> @@ -126,7 +126,7 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
>  	new_mask = CLOCKSOURCE_MASK(bits);
>  
>  	/* calculate how many ns until we risk wrapping */
> -	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
> +	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask, 0);

Should be NULL instead of 0? Otherwise I think sparse would complain.

Otherwise:

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


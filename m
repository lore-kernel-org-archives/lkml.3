Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbbAJCCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:02:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbbAJCCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 21:02:07 -0500
Message-ID: <54B0881D.9090004@codeaurora.org>
Date: Fri, 09 Jan 2015 18:02:05 -0800
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
Subject: Re: [PATCH 10/10] clocksource: Add some debug info about clocksources
 being registered
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org> <1420850068-27828-11-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1420850068-27828-11-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:34 PM, John Stultz wrote:
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 9a0b951..c641aa7 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -770,6 +770,10 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
>  						 cs->maxadj, cs->mask,
>  						 &cs->max_cycles);
> +
> +	pr_info("clocksource %s: mask: 0x%llx max_cycles: 0x%llx, max_idle_ns: %lld ns\n",
> +			cs->name, cs->mask, cs->max_cycles, cs->max_idle_ns);

Is this intentionally info level? Or was it supposed to be debug level
per $subject?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project


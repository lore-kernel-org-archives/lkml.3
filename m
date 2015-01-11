Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbbAKLrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:47:31 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58949 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbAKLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:47:30 -0500
Date: Sun, 11 Jan 2015 12:47:25 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] clocksource: Remove clocksource_max_deferment()
Message-ID: <20150111114724.GE4467@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-4-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420850068-27828-4-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series added:

+	/* Return 50% of the actual maximum, so we can detect bad values */
+	max_nsecs >>= 1;

and then...

On Fri, Jan 09, 2015 at 04:34:21PM -0800, John Stultz wrote:
> @@ -760,7 +746,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  		cs->maxadj = clocksource_max_adjustment(cs);
>  	}
>  
> -	cs->max_idle_ns = clocksource_max_deferment(cs);
> +	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
> +						 cs->maxadj, cs->mask);
>  }
>  EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>  
> @@ -807,7 +794,8 @@ int clocksource_register(struct clocksource *cs)
>  		cs->name);
>  
>  	/* calculate max idle time permitted for this clocksource */
> -	cs->max_idle_ns = clocksource_max_deferment(cs);
> +	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
> +						 cs->maxadj, cs->mask);

... the whole world's maximum idle time is artificially reduced by
half in order to catch some rare HW bug?  Not a very green solution.

Thanks,
Richard

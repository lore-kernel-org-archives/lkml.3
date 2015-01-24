Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbbAXRfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:35:22 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52793 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbbAXRfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:35:20 -0500
Date: Sat, 24 Jan 2015 18:35:15 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/12] time: Add infrastructure to cap clocksource reads
 to the max_cycles value
Message-ID: <20150124173514.GA4784@localhost.localdomain>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
 <1421971767-17707-7-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421971767-17707-7-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:09:21PM -0800, John Stultz wrote:
> +static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
> +{
> +	cycle_t cycle_now, delta;
> +
> +	/* read clocksource */
> +	cycle_now = tkr->read(tkr->clock);
> +
> +	/* calculate the delta since the last update_wall_time */
> +	delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
> +
> +	/* Cap delta value to the max_cycles values to avoid mult overflows */
> +	if (unlikely(delta > tkr->clock->max_cycles))
> +		delta = tkr->clock->max_cycles;
> +
> +	return delta;
> +}
>  #else
>  #define timekeeping_check_update(x, y)
> +static inline cycle_t timekeeping_get_delta(struct tk_read_base *tkr)
> +{
> +	/* calculate the delta since the last update_wall_time */
> +	return clocksource_delta(tkr->read(tkr->clock), tkr->cycle_last,
> +								tkr->mask);

Coding style is strange here.  It would look nicer it were like the
debug version, above.

> +}
>  #endif

Series looks fine to me.

Acked-by: Richard Cochran <richardcochran@gmail.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbbAWO1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:27:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:47232 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:27:06 -0500
Date: Fri, 23 Jan 2015 15:27:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/12] time: Add debugging checks to warn if we see delays
Message-ID: <20150123142702.GA23123@twins.programming.kicks-ass.net>
References: <1421971767-17707-1-git-send-email-john.stultz@linaro.org>
 <1421971767-17707-6-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421971767-17707-6-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:09:20PM -0800, John Stultz wrote:
> +#ifdef CONFIG_DEBUG_TIMEKEEPING
> +static void timekeeping_check_update(struct timekeeper *tk, cycle_t offset)
> +{
> +
> +	cycle_t max_cycles = tk->tkr.clock->max_cycles;
> +	const char *name = tk->tkr.clock->name;
> +
> +	if (offset > max_cycles)
> +		printk_deferred("ERROR: cycle offset (%lld) is larger then"
> +			" allowed %s max_cycles (%lld)\n",
> +			offset, name, max_cycles);
> +	else if (offset > (max_cycles >> 1))
> +		printk_deferred("WARNING: cycle offset (%lld) is past"
> +			" the %s 50%% safety margin (%lld)\n",
> +			offset, name, max_cycles>>1);
> +}
> +#else
> +#define timekeeping_check_update(x, y)

static inline void timekeeping_check_update(struct timekeeper *tk, cycle_t offset) { }

Would preserve argument type checks. The only argument for using a macro
here would be to avoid evaluating the arguments, but that's not an issue
in this case afaict.

> +#endif

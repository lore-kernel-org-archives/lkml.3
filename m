Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaGSFCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:02:48 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61193 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaGSFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:02:47 -0400
Date: Sat, 19 Jul 2014 07:02:33 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140719050233.GA4408@netboy>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:43:39PM +0100, Pawel Moll wrote:
> 
> This code definitely needs more work and testing (I'm not 100%
> sure if the Kp and Ki I've picked for the proportional and
> integral terms are universal),

I wouldn't bet on it.

> but for now wanted to see
> if this approach makes any sense whatsoever.

You are reading sched_clock and mono-raw together every so
often. Really stupid question: Why not just place that information
into the trace buffer and let user space do the clock correction?

...

> +		/* Tune the cyc_to_ns formula */
> +		mult_adj = sign * (error >> 2) + (cd.error_int >> 2);

So Kp = Ki = 0.25? And did you say that the sample rate is 10/second?

I guess that, while this works well on your machine, it might not
always do so, depending on the mono-raw clock. Probably Kp/i need to
be tunable to a particular system. Even better would be to leave this
out of the kernel altogether.

Thanks,
Richard

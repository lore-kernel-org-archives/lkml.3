Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422946AbaGRTNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:13:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:46378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbaGRTNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:13:45 -0400
Date: Fri, 18 Jul 2014 21:13:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
Message-ID: <20140718191338.GF3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:43:39PM +0100, Pawel Moll wrote:
> This change is trying to make the sched clock "similar" to the
> monotonic raw one.
> 
> The main goal is to provide some kind of unification between time
> flow in kernel and in user space, mainly to achieve correlation
> between perf timestamps and clock_gettime(CLOCK_MONOTONIC_RAW).
> This has been suggested by Ingo and John during the latest
> discussion (of many, we tried custom ioctl, custom clock etc.)
> about this:
> 
> http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
> 
> For now I focused on the generic sched clock implementation,
> but similar approach can be applied elsewhere.
> 
> Initially I just wanted to copy epoch from monotonic to sched
> clock at update_clock(), but this can cause the sched clock
> going backwards in certain corner cases, eg. when the sched
> clock "increases faster" than the monotonic one. I believe
> it's a killer issue, but feel free to ridicule me if I worry
> too much :-)

But on hardware using generic sched_clock we use the exact same hardware
as the regular timekeeping, right?

So we could start off with the same offset/mult/shift and never deviate,
or is that a silly question?, I've never really looked at the generic
sched_clock stuff too closely.

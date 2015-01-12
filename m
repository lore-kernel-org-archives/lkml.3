Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbbALUaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:30:14 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:62510 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbALUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:30:12 -0500
Date: Mon, 12 Jan 2015 21:30:07 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
Message-ID: <20150112203006.GB4233@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
 <1420850068-27828-7-git-send-email-john.stultz@linaro.org>
 <20150111124146.GA15387@localhost.localdomain>
 <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLX2Th7-kEM1vQBJn5hnPTJ5ujg-Zx-aa-oOhP5cb=hXLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:54:50AM -0800, John Stultz wrote:
> On Sun, Jan 11, 2015 at 4:41 AM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > On Fri, Jan 09, 2015 at 04:34:24PM -0800, John Stultz wrote:
> >> When calculating the current delta since the last tick, we
> >> currently have no hard protections to prevent a multiplciation
> >> overflow from ocurring.
> >
> > This is just papering over the problem. The "hard protection" should
> > be having a tick scheduled before the range of the clock source is
> > exhausted.
> 
> So I disagree this is papering over the problem.
> 
> You say the tick should be scheduled before the clocksource wraps -
> but we have logic to do that.

Well that is a shame.  To my way of thinking, having a reliable
watchdog (clock readout) at half the period would be a real solution.
Yes, I do mean providing some sort of "soft real time" guarantee.

What is the use case here?  I thought we are trying to fix unreliable
clocks with random jumps.  It is hard to see how substituting
MAX_DURATION for RANDOM_JUMP_VALUE is helping to catch bad hardware.
 
> However there are many ways that can still go wrong.  Virtualization
> can delay interrupts for long periods of time,

fixable with some soft RT?

> the timer/irq code isn't the simplest and there can be bugs,

simplify and fix?

> or timer hardware itself can have issues.

for this we can have a compile time timer validation module, just like
we have for locks, mutexs, rcu, etc.

> The difficulty is that when something has gone wrong, the
> only thing we have to measure the problem may become corrupted.  And
> worse, once the timekeeping code is having problems,  that can result
> in bugs that manifest in all sorts of strange ways that are very
> difficult to debug (you can't trust your log timestamps, etc).

But this this patch make the timestamps trustworthy?  Not really.
 
Thanks,
Richard

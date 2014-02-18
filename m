Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaBRUxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:53:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:45797 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaBRUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:53:53 -0500
Date: Tue, 18 Feb 2014 21:53:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] sched_clock: Prevent callers from seeing half-updated
 data
In-Reply-To: <CALAqxLX4k4JcUGzVdv68w+4v0fg34G_qBiBhH07kyTssQ1jE1Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402182153350.4468@ionos.tec.linutronix.de>
References: <1392662736-7803-1-git-send-email-john.stultz@linaro.org> <1392662736-7803-2-git-send-email-john.stultz@linaro.org> <alpine.DEB.2.02.1402182119500.4468@ionos.tec.linutronix.de>
 <CALAqxLX4k4JcUGzVdv68w+4v0fg34G_qBiBhH07kyTssQ1jE1Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Feb 2014, John Stultz wrote:
> On Tue, Feb 18, 2014 at 12:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 17 Feb 2014, John Stultz wrote:
> >
> >> From: Stephen Boyd <sboyd@codeaurora.org>
> >>
> >> The generic sched_clock registration function was previously
> >> done lockless, due to the fact that it was expected to be called
> >> only once. However, now there are systems that may register
> >> multiple sched_clock sources, for which the lack of locking has
> >> casued problems:
> >>
> >> If two sched_clock sources are registered we may end up in a
> >> situation where a call to sched_clock() may be accessing the
> >> epoch cycle count for the old counter and the cycle count for the
> >> new counter. This can lead to confusing results where
> >> sched_clock() values jump and then are reset to 0 (due to the way
> >> the registration function forces the epoch_ns to be 0).
> >>
> >> Fix this by reorganizing the registration function to hold the
> >> seqlock for as short a time as possible while we update the
> >> clock_data structure for a new counter. We also put any
> >> accumulated time into epoch_ns instead of resetting the time to
> >> 0 so that the clock doesn't reset after each successful
> >> registration.
> >>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >
> > Peter ???
> 
> So this is the generic sched_clock work, which Peter really hasn't had
> much involvement with yet (mostly because its not yet generic enough
> to work with more then a few arches). But I included him in the CC
> since I think it would be good to have him following along.

Fair enough. I'll pick it up.

Thanks,

	tglx

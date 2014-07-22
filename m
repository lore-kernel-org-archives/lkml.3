Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaGVQsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:48:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46863 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755885AbaGVQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:48:06 -0400
Message-ID: <1406047681.25343.79.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 17:48:01 +0100
In-Reply-To: <20140722163437.GI3935@laptop>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <20140719050233.GA4408@netboy> <1406045849.25343.72.camel@hornet>
	 <20140722163437.GI3935@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 17:34 +0100, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 05:17:29PM +0100, Pawel Moll wrote:
> > With both Ingo and John showing preference towards the clock alignment,
> > so that's where I looked this time (I've already done custom perf
> > ioctls, posix clocks... don't really know how many different ways I've
> > tried).
> 
> So we should probably also talk about which clock to track, MONO has the
> advantage of making it far easier to trace clusters but has the
> disadvantage of stacked control loops with NTP adjusting MONO and us
> adjusting sched_clock.

John suggested (and I fully agree with him) MONO_RAW, as it is not
getting NTP-d. 

> And I would really prefer to pick 1 and not make it configurable.

Same here. One thing I keep in mind is the fact that userspace must be
able to say whether it can expect the correlation or not. "Not" being
either an architecture which sched_clock is not using the generic
solution (I'm sure there will be some) or "not" because of the
synchronisation failure. My idea so far was a debugfs file saying this
(or missing, which is a message on its own).

Pawel



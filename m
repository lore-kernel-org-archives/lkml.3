Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaGVQRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:17:32 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48483 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755382AbaGVQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:17:29 -0400
Message-ID: <1406045849.25343.72.camel@hornet>
Subject: Re: [RFC] sched_clock: Track monotonic raw clock
From: Pawel Moll <pawel.moll@arm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 17:17:29 +0100
In-Reply-To: <20140719050233.GA4408@netboy>
References: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
	 <20140719050233.GA4408@netboy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-19 at 06:02 +0100, Richard Cochran wrote:
> On Fri, Jul 18, 2014 at 06:43:39PM +0100, Pawel Moll wrote:
> > 
> > This code definitely needs more work and testing (I'm not 100%
> > sure if the Kp and Ki I've picked for the proportional and
> > integral terms are universal),
> 
> I wouldn't bet on it.

Yeah, I should have said: I'm 100% sure they are not universal.

> > but for now wanted to see
> > if this approach makes any sense whatsoever.
> 
> You are reading sched_clock and mono-raw together every so
> often. Really stupid question: Why not just place that information
> into the trace buffer and let user space do the clock correction?

That approach has been also discussed, last time in the mentioned
thread:

http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554
http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554

With both Ingo and John showing preference towards the clock alignment,
so that's where I looked this time (I've already done custom perf
ioctls, posix clocks... don't really know how many different ways I've
tried).

> ...
> 
> > +		/* Tune the cyc_to_ns formula */
> > +		mult_adj = sign * (error >> 2) + (cd.error_int >> 2);
> 
> So Kp = Ki = 0.25? And did you say that the sample rate is 10/second?
> 
> I guess that, while this works well on your machine, it might not
> always do so, depending on the mono-raw clock. Probably Kp/i need to
> be tunable to a particular system. Even better would be to leave this
> out of the kernel altogether.

My hope is that, given that time correlation is pretty "static" process
(the clock skew should be reasonable, otherwise the time source are
plainly rubbish), there will be a way of implementing this in a
self-tuning way. I may be proven wrong, but it seems like a noble thing
to try.

I fully agree that there is no place for manual PI regulator tuning in
the kernel.

Pawel


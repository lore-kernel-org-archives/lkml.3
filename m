Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843Ab3GPTWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:22:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319Ab3GPTV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:21:59 -0400
Date: Tue, 16 Jul 2013 21:21:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130716192145.GV17211@twins.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45E8B.705@linux.intel.com>
 <20130715210650.GF23818@dyad.programming.kicks-ass.net>
 <20130715211230.GG23818@dyad.programming.kicks-ass.net>
 <51E47D30.5030203@linux.intel.com>
 <20130716173848.GA22795@dyad.programming.kicks-ass.net>
 <51E5947F.4090109@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E5947F.4090109@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 11:44:15AM -0700, Arjan van de Ven wrote:
> the interaction is "using the scheduler data using the scheduler provided function".

I'm so not following.

> So I don't just want something that makes sense for todays Intel ;-)
> We need something that has an interface that makes sense, where the things
> that vary between chip generations/vendors are on the driver side
> of the interface, and the things that are generic concepts or generically
> enough useful are on the core side of the interface. Hardware has changed,
> and hardware will be changing for all vendors for as far as we can even see
> into the future, since power matters in the market a lot.
> This means we need a level of interface that has some chance of being useful
> for at least a while.
> 
> What frequency to run at is for me clearly a driver side thing since what
> goes into choosing a P state that may translate into a frequency is a hardware
> specific choice; the translation from "I need at least this much performance
> and be power efficient at that" to a hardware register write is very hardware specific.

Be that as it may, we still need to consider the ramifications of these
'mystserious arch specific actions'.

> Things like "I need more compute capacity" or "This is very performance critical" or
> "This is very latency critical" are a generic concepts.
> As is "behavior is now changed a lot in <this direction>" as a callback kind of thing.
> (just as "I no longer need it" is a generic concept to complement the first one)

That is what cpufreq would like of the scheduler; but isn't at all
sufficient to solve the problems the scheduler has with cpufreq. You
still only seem to see things one way.

Suppose a 2 cpu system, one cpu is running 3/4 throttle, the other is
running at half speed. Both cpus are equally utilized. A new task
comes on.

Where do we run it?

We need to know that there's head-room on the 1/2 speed cpu and should
crank its pace and place the task there.

Even without the new task; its not a 'balanced' situation, but it
appears that way because the cpu's are nearly equally utilized. Maybe if
we crank one cpu to the max it could run all tasks and have the other
cpu power gated. Or maybe they could both drop to 60% and run equal
loads.

We need feedback for these problems; but you're telling us new Intel
stuff can't really tell us much of anything :/

What I'm saying is; sure the cpufreq driver might have chip specific
magic but it very much needs to tell us things too we can't have it do
its own thing and not care.

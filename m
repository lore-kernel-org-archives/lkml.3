Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab3GPRkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:40:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44192 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3GPRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:40:19 -0400
Date: Tue, 16 Jul 2013 19:38:48 +0200
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
Message-ID: <20130716173848.GA22795@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45E8B.705@linux.intel.com>
 <20130715210650.GF23818@dyad.programming.kicks-ass.net>
 <20130715211230.GG23818@dyad.programming.kicks-ass.net>
 <51E47D30.5030203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E47D30.5030203@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:52:32PM -0700, Arjan van de Ven wrote:

> yeah ondemand does this, but ondemand is actually a pretty bad governor.
> not because of the sampling, but because of its algorithm.

Is it good for any class of hardware still out there? Or should the thing be
shot in the head?

You saying AMD patched the thing makes me confused; why would they patch a
piece of crap?

> HOWEVER, on modern CPUs, even many of the ARM ones, the frequency
> when you're idle is zero anyway regardless of what you as OS ask for.

Right, entire cores are power gated.

So power wise the voltage you run at is important; so for hardware where lower
frequencies allow lower voltage, does it still make sense to run the lowest
possible voltage such that there is still some idle time?

Or is the fact that you're running so much longer negating the power save from
the lower voltage?

> Every 10 (or 100) milliseconds, ondemand makes a new P state decision.
> It does this by asking the scheduler the time used, does a delta and
> ends up at a utilization %age which then goes into a formula.
> It's not that ondemand samples inbetween decision moments to see if the system
> is busy or not; the microaccounting that the scheduler does is used instead,
> and only at decision moments.

OK.. So up to now you've mostly said what you want of the scheduler to make a
better governor for the new Intel chips.

However a power aware scheduler/balancer needs to interact with the policy as a
whole; and I got confused by the fact that you never talked about
raising/lowering speeds. As said there's already a very 'fine' problem where
the cpufreq interacts with the utilization/runnable accounting we now do.

So we very much need to consider the entire stack; not just new hooks you want
to make it go fastest.

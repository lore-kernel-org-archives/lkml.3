Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564AbaD2KAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:00:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47790 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933516AbaD2KAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:00:21 -0400
Date: Tue, 29 Apr 2014 11:00:23 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
Message-ID: <20140429100023.GF2639@e103034-lin>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org>
 <20140428102819.GG27561@twins.programming.kicks-ass.net>
 <535E3673.8020606@linaro.org>
 <5275186.Hb1xxV4ZWO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5275186.Hb1xxV4ZWO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:11:47AM +0100, Rafael J. Wysocki wrote:
> On Monday, April 28, 2014 01:07:31 PM Daniel Lezcano wrote:

[...]

> > I'm really wondering if the cgroup couldn't be a good solution:
> > 
> > Amit pointed the conflict about the power vs performance with some 
> > applications. We want to have for example a game to run fast performance 
> > and some other application to save power.
> 
> You can't save power.
> 
> Power is the energy flow *rate*.  It's like speed, so how can you save it?
> 
> If you talk about saving in this context, please always talk about energy as
> well, because that's what we want to save.
> 
> This means that positioning power against performance doesn't make any sense
> whatsoever.  You could try to position energy efficiency (that is, the relative
> cost of doing work in terms of energy) against performance, but even that is
> questionable, because, as I said in one of the previous messages, what is good
> for performance is often good for energy efficiency too (think about race to
> idle for example).
> 
> In other words, you want to have a knob whose both ends may happen to mean
> the same thing.  Wouldn't that be a little odd?
> 
> In my opinion it would be much better to have a knob representing the current
> relative value of energy to the user (which may depend on things like whether
> or not the system is on battery etc) and meaning how far we need to go with
> energy saving efforts.

I agree, more or less. I think of performance and energy awareness as
optimization objectives. If we only care about performance we are
dealing with a single-objective optimization problem. We do what it
takes to get the best possible performance without considering energy at
all. Energy awareness is IMO as multi-objective optimization problem. We
want to save energy, but do so without sacrificing too much performance.
What "too much" is depends on the scenario (application).

Energy efficiency and performance are different objectives, but I agree
that the means to get better energy efficiency might be the same as
those to get better performance in some cases. IMO, energy awareness is
not a big switch to turn on specific scheduling mechanics (or other
mechnaics in the kernel) such as task packing and disabling expensive
DVFS states, it is about changing the scheduling optimization objective
to include energy in the scheduling decisions. That is, try to save
energy for the current scenario. That includes race to idle if that is
the best way for the particular application and platform/system
topology.

> 
> So if that knob is 0, we'll do things that are known-good for performance.
> If it is 1, we'll do some extra effort to save enery as well possibly at
> a small expense of performance if that's necessary.  If it is 100, we'll do
> all we can to save as much energy as possible without caring about performance
> at all.
> 
> And it doesn't even have to be scheduler-specific, it very well may be global.

I like the idea of knob representing the weight of energy awareness.
Whether it should be global, per task, or per cgroup I'm not sure about.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaFJLWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:22:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43671 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaFJLWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:22:18 -0400
Date: Tue, 10 Jun 2014 13:17:32 +0200
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610111732.GA30139@austad.us>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
 <20140610093943.GA6758@twins.programming.kicks-ass.net>
 <20140610100641.GB1581@e103034-lin>
 <20140610102353.GC6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610102353.GC6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:23:53PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 11:06:41AM +0100, Morten Rasmussen wrote:
> > How would you like to disable the energy stuff for users for whom
> > latency is everything?
> > 
> > I mean, we are adding some extra load/utilization tracking. While I
> > think we should do everything possible to minimize the overhead, I think
> > it is unrealistic to assume that it will be zero. Is a some extra 'if
> > (energy_enabled)' acceptable?
> > 
> > I'm open for other suggestions.
> 
> We have the jump-label stuff to do self modifying code ;-) The only
> thing we need to be careful with is data-layout.

Isn't this asking for trouble?

I do get the point of not introducing more make-ifdeffery, but I'm not
so sure the alternative is much better. Do we really want to spend time
tracing down bugs introduced via a self-modifying process in something
as central as the scheduler?

> So I'm _hoping_ we can do all this without more CONFIG knobs, because
> {PREEMPT*SMP*CGROUP^3*NUMA^2} is already entirely annoying to
> build and run test, not to mention that distro builds will have no other
> option than to enable everything anyhow.

True, but if that is the argument, how is adding this as a dynamic thing
any better, you still end up with a test-matrix of the same size?

Building a kernel isn't _that_ much work and it would make the
test-scripts all the much simpler to maintain if we don't have to rely
on some dynamic tweaking of the core.

Just sayin'

-- 
Henrik Austad

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaFJOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:41:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25658 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750808AbaFJOlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:41:02 -0400
Date: Tue, 10 Jun 2014 15:41:00 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Henrik Austad <henrik@austad.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [RFC PATCH 02/16] sched: Introduce CONFIG_SCHED_ENERGY
Message-ID: <20140610144100.GD1581@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-3-git-send-email-morten.rasmussen@arm.com>
 <20140608060316.GA18179@austad.us>
 <20140609102027.GA29593@e103034-lin>
 <20140610093943.GA6758@twins.programming.kicks-ass.net>
 <20140610100641.GB1581@e103034-lin>
 <20140610102353.GC6758@twins.programming.kicks-ass.net>
 <20140610112403.GC1581@e103034-lin>
 <20140610122435.GG6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610122435.GG6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 01:24:35PM +0100, Peter Zijlstra wrote:
> On Tue, Jun 10, 2014 at 12:24:03PM +0100, Morten Rasmussen wrote:
> > On Tue, Jun 10, 2014 at 11:23:53AM +0100, Peter Zijlstra wrote:
> > > On Tue, Jun 10, 2014 at 11:06:41AM +0100, Morten Rasmussen wrote:
> > > > How would you like to disable the energy stuff for users for whom
> > > > latency is everything?
> > > > 
> > > > I mean, we are adding some extra load/utilization tracking. While I
> > > > think we should do everything possible to minimize the overhead, I think
> > > > it is unrealistic to assume that it will be zero. Is a some extra 'if
> > > > (energy_enabled)' acceptable?
> > > > 
> > > > I'm open for other suggestions.
> > > 
> > > We have the jump-label stuff to do self modifying code ;-) The only
> > > thing we need to be careful with is data-layout.
> > 
> > Thanks. I can see that it is already used in for various bit in
> > kernel/sched/*. I didn't catch anything in Documentation/static-keys.txt
> > related to data-layout caveats. Is there some other
> > documentation/patches I should read before messing everything up? ;-)
> 
> So the data-layout was mostly referring to things like making sure that
> struct sched_avg doesn't end up straddling a cacheline somewhere by
> accident.
> 
> The most expensive part of the per-task accounting nonsense is the
> amount of memory we need to touch to do so, the actual instructions come
> second, unless of course we go put tons of divisions in there :-)

Make sense.

> BTW, are cachelines 64 bytes for you ARM people too?

Mostly yes, but as with a lot of other things on ARM it is
implementation defined. The cacheline sizes are probeable at runtime,
but for things where we don't know I think 64 bytes is the current
assumption.

Catalin or Will would be able to provide a more detailed answer.

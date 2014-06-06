Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaFFO35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:29:57 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:54922 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751321AbaFFO34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:29:56 -0400
Date: Fri, 6 Jun 2014 15:29:58 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606142958.GX29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140603114428.GY11096@twins.programming.kicks-ass.net>
 <20140604154227.GR29593@e103034-lin>
 <20140604161618.GQ30445@twins.programming.kicks-ass.net>
 <20140606131510.GV29593@e103034-lin>
 <20140606134303.GQ13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606134303.GQ13930@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:43:03PM +0100, Peter Zijlstra wrote:
> On Fri, Jun 06, 2014 at 02:15:10PM +0100, Morten Rasmussen wrote:
> > > > ARM TC2 has on-chip energy counters for counting energy consumed by the
> > > > A7 and A15 clusters. They are fairly accurate. 
> > > 
> > > Recent Intel chips have that too; they come packaged as:
> > > 
> > >   perf stat -a -e "power/energy-cores/" -- cmd
> > > 
> > > (through the perf_event_intel_rapl.c driver), It would be ideal if the
> > > ARM equivalent was available through a similar interface.
> > > 
> > > http://lwn.net/Articles/573602/
> > 
> > Nice. On ARM it is not mandatory to have energy counters and what they
> > actually measure if they are implemented is implementation dependent.
> > However, each vendor does extensive evaluation and characterization of
> > their implementation already, so I don't think would be a problem for
> > them to provide the numbers.
> 
> How is the ARM energy thing exposed? Through the regular PMU but with
> vendor specific events, or through a separate interface, entirely vendor
> specific?

There is an upstream hwmon driver for TC2 already with an easy to use
sysfs interface for all the energy counters. So it is somewhat vendor
specific at the moment unfortunately.

> In any case, would it be at all possible to nudge them to provide a
> 'driver' for this so that they can be more easily used?

I have raised it internally that unification on this front is needed. 

> > Some of the measurements could be automated. Others are hard to
> > automate as they require extensive knowledge about the platform. wakeup
> > energy, for example. You may need to do various tricks and hacks to
> > force the platform to use a specific idle-state so you know what you are
> > measuring.
> > 
> > I will add the TC2 recipe as a start and then see if my ugly scripts can
> > be turned into something generally useful.
> 
> Fair enough; I would prefer to have a situation where 'we' can validate
> whatever magic numbers the vendors provide for their hardware, or can
> generate numbers for hardware where the vendor is not interested.
> 
> But yes, publishing your hacks is a good first step at getting such a
> thing going, if we then further require everybody to use this 'tool' and
> improve if not suitable, we might end up with something useful ;-)

Fair plan ;-)

That said, vendors may want to provide slightly different numbers if
they do characterization based on workloads they care about rather than
sysbench or whatever 'we' end up using. The numbers will vary depending
on which workload(s) you use.

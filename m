Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaAHNdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:33:32 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35020 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755121AbaAHNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:33:29 -0500
Date: Wed, 8 Jan 2014 13:33:29 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140108133329.GL2936@e103034-lin>
References: <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
 <52CD0D12.6020108@linaro.org>
 <20140108083716.GA7572@laptop.programming.kicks-ass.net>
 <20140108125228.GJ2936@e103034-lin>
 <20140108130407.GE31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108130407.GE31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:04:07PM +0000, Peter Zijlstra wrote:
> On Wed, Jan 08, 2014 at 12:52:28PM +0000, Morten Rasmussen wrote:
> 
> > If I remember correctly, Alex used the rq runnable_avg_sum (in rq->avg)
> > for this. It is the most obvious choice, but it takes ages to reach
> > 100%.
> > 
> > #define LOAD_AVG_MAX_N 345
> > 
> > Worst case it takes 345 ms from the system is becomes fully utilized
> > after a long period of idle until the rq runnable_avg_sum reaches 100%.
> > 
> > An unweigthed version of cfs_rq->runnable_load_avg and blocked_load_avg
> > wouldn't have that delay.
> 
> Right.. not sure we want to involve blocked load on the utilization
> metric, but who knows maybe that does make sense.
> 
> But yes, we need unweighted runnable_avg.

I'm not sure about the blocked load either.

> 
> > Also, if we are changing the load balance behavior when all cpus are
> > fully utilized
> 
> We already have this tipping point. See all the has_capacity bits. But
> yes, it'd get more involved I suppose.

I'll have a look.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaAHNEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:04:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890AbaAHNEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:04:43 -0500
Date: Wed, 8 Jan 2014 14:04:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
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
Message-ID: <20140108130407.GE31570@twins.programming.kicks-ass.net>
References: <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
 <52CD0D12.6020108@linaro.org>
 <20140108083716.GA7572@laptop.programming.kicks-ass.net>
 <20140108125228.GJ2936@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108125228.GJ2936@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 12:52:28PM +0000, Morten Rasmussen wrote:

> If I remember correctly, Alex used the rq runnable_avg_sum (in rq->avg)
> for this. It is the most obvious choice, but it takes ages to reach
> 100%.
> 
> #define LOAD_AVG_MAX_N 345
> 
> Worst case it takes 345 ms from the system is becomes fully utilized
> after a long period of idle until the rq runnable_avg_sum reaches 100%.
> 
> An unweigthed version of cfs_rq->runnable_load_avg and blocked_load_avg
> wouldn't have that delay.

Right.. not sure we want to involve blocked load on the utilization
metric, but who knows maybe that does make sense.

But yes, we need unweighted runnable_avg.

> Also, if we are changing the load balance behavior when all cpus are
> fully utilized

We already have this tipping point. See all the has_capacity bits. But
yes, it'd get more involved I suppose.

> we may need to think about cases where the load is
> hovering around the saturation threshold. But I don't think that is
> important yet.

Yah.. I'm going to wait until we have a fail case that can give us
some guidance before really pondering this though :-)

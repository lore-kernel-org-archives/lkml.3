Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaAGUin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 15:38:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41083 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaAGUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 15:38:37 -0500
Date: Tue, 7 Jan 2014 21:37:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Alex Shi <alex.shi@linaro.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
Message-ID: <20140107203752.GC2480@laptop.programming.kicks-ass.net>
References: <20131217153809.GP21999@twins.programming.kicks-ass.net>
 <52B2F5D0.2050707@linaro.org>
 <20131220111926.GA11605@e103034-lin>
 <52BAF292.1070404@linaro.org>
 <20140102160404.GA3000@e103034-lin>
 <52CAB12B.4090701@linaro.org>
 <20140107125518.GE2936@e103034-lin>
 <20140107125930.GW31570@twins.programming.kicks-ass.net>
 <20140107131523.GX3694@twins.programming.kicks-ass.net>
 <20140107151632.GF2936@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107151632.GF2936@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:16:32PM +0000, Morten Rasmussen wrote:
> From a load perspective wouldn't it be better to pick the least loaded
> cpu in the group? It is not cheap to implement, but in theory it should
> give less balancing within the group later an less unfairness until it
> happens.

I tried that; see 04f733b4afac5dc93ae9b0a8703c60b87def491e for why it
doesn't work.

> Rotating the cpu is probably good enough for most cases and certainly
> easier to implement.

Indeed.

> The bias continues after they first round of load balance by the other
> cpus?

The cost, yes. Even when perfectly balanced, we still get to iterate the
entire machine computing s[gd]_lb_stats to find out we're good and don't
need to move tasks about.

> Pulling everything to one cpu is not ideal from a performance point of
> view. You loose some available cpu cycles until the balance settles.
> However, it is not easy to do better and maintain scalability at the
> same time.

Right, its part of the cost we pay for scaling better. And rotating this
cost around a bit would alleviate the obvious bias.



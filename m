Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaAGNAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:00:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaAGNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:00:33 -0500
Date: Tue, 7 Jan 2014 13:59:30 +0100
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
Message-ID: <20140107125930.GW31570@twins.programming.kicks-ass.net>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
 <1386061556-28233-5-git-send-email-alex.shi@linaro.org>
 <20131217141012.GG10134@e103034-lin>
 <20131217153809.GP21999@twins.programming.kicks-ass.net>
 <52B2F5D0.2050707@linaro.org>
 <20131220111926.GA11605@e103034-lin>
 <52BAF292.1070404@linaro.org>
 <20140102160404.GA3000@e103034-lin>
 <52CAB12B.4090701@linaro.org>
 <20140107125518.GE2936@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107125518.GE2936@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 12:55:18PM +0000, Morten Rasmussen wrote:
> My understanding is that should_we_balance() decides which cpu is
> eligible for doing the load balancing for a given domain (and the
> domains above). That is, only one cpu in a group is allowed to load
> balance between the local group and other groups. That cpu would
> therefore be reponsible for pulling enough load that the groups are
> balanced even if it means temporarily overloading itself. The other cpus
> in the group will take care of load balancing the extra load within the
> local group later.

Correct.

> I may have missed something, but I don't understand the reason for the
> performance improvements that you are reporting. I see better numbers
> for a few benchmarks, but I still don't understand why the code makes
> sense after the cleanup. If we don't understand why it works, we cannot
> be sure that it doesn't harm other benchmarks. There is always a chance
> that we miss something but, IMHO, not having any idea to begin with
> increases the chances for problems later significantly. So why not get
> to the bottom of the problem of cleaning up cpu_load?
> 
> Have you done more extensive benchmarking? Have you seen any regressions
> in other benchmarks?

I only remember hackbench numbers and that generally fares well with a
more aggressive balancer since it has no actual work to speak of the
migration penalty is very low and because there's a metric ton of tasks
the aggressive leveling makes for more coherent 'throughput'.

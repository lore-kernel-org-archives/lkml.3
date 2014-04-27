Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaD0Nte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 09:49:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63669 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843AbaD0Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 09:49:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU ConCurrency
Date: Sun, 27 Apr 2014 16:05:58 +0200
Message-ID: <2905301.LGC8T1pCHG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140425145334.GC2639@e103034-lin>
References: <20140424193004.GA2467@intel.com> <13348109.c4H00groOp@vostro.rjw.lan> <20140425145334.GC2639@e103034-lin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2014 03:53:34 PM Morten Rasmussen wrote:
> On Fri, Apr 25, 2014 at 01:19:46PM +0100, Rafael J. Wysocki wrote:

[...]

> > 
> > So in my opinion we need to figure out how to measure workloads while they are
> > running and then use that information to make load balancing decisions.
> > 
> > In principle, given the system's topology, task packing may lead to better
> > results for some workloads, but not necessarily for all of them.  So we need
> > a way to determine (a) whether or not task packing is an option at all in the
> > given system (that may change over time due to user policy changes etc.) and
> > if that is the case, then (b) if the current workload is eligible for task
> > packing.
> 
> I fully agree. My point was that there is more to task consolidation
> than just observing the degree of task parallelism. The system topology
> has a lot to say when deciding whether or not to pack. That was the
> motivation for proposing to have a power model for the system topology
> to help making that decision.

Agreed.

> We do already have some per-task metric available that may be useful for
> determining whether a workload is eligible for task packing. The
> load_avg_contrib gives us an indication of the tasks cpu utilization and
> we also count task wake-ups. If we tracked task wake-ups over time
> (right now we only have the sum) we should be able to reason about the
> number of wake-ups that a task causes. Lots of wake-ups and low
> load_avg_contrib would indicate the task power is likely to be dominated
> by the wake-up costs if it is placed on a cpu in a deep idle state.

Agreed too.

> I fully agree that measuring the workloads while they are running is the
> way to go. I'm just wondering if the proposed cpu concurrency measure
> is sufficient to make the task packing decision for all system
> topologies or if we need something that incorporates more system
> topology information. If the latter, we may want to roll it all into
> something like an energy_diff(src_cpu, dst_cpu, task) helper function
> for use in load-balancing decisions.

I think that the latter is the case.

For example, quite a lot may depend on how much cache is shared between
different CPU cores and what the cache hierarchy is in general.  Especially
if the workload fits into the cache entirely.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

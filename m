Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaBLPQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:16:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48859 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBLPQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:16:32 -0500
Date: Wed, 12 Feb 2014 15:16:26 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>, Preeti Murthy <preeti.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct rq
Message-ID: <20140212151626.GE28661@e102568-lin.cambridge.arm.com>
References: <20140131090230.GM5002@laptop.programming.kicks-ass.net>
 <52EB6F65.8050008@linux.vnet.ibm.com>
 <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <20140203125441.GD19029@e103034-lin>
 <52EFA9D3.1030601@linux.intel.com>
 <20140203145605.GL8874@twins.programming.kicks-ass.net>
 <52EFC12B.50704@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <52EFC12B.50704@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Feb 2014 15:16:27.0280 (UTC) FILETIME=[66455100:01CF2805]
X-MC-Unique: 114021215162807601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 04:17:47PM +0000, Arjan van de Ven wrote:

[...]

> >> 1) A latency driven one
> >> 2) A performance impact on
> >>
> >> first one is pretty much the exit latency related time, sort of a
> >> "expected time to first instruction" (currently menuidle has the
> >> 99.999% worst case number, which is not useful for this, but is a
> >> first approximation). This is obviously the dominating number for
> >> expected-short running tasks
> >>
> >> second on is more of a "is there any cache/TLB left or is it flushed"
> >> kind of metric. It's more tricky to compute, since what is the cost of
> >> an empty cache (or even a cache migration) after all....  .... but I
> >> suspect it's in part what the scheduler will care about more for
> >> expected-long  running tasks.
> >
> > Yeah, so currently we 'assume' cache hotness based on runtime; see
> > task_hot(). A hint that the CPU wiped its caches might help there.
> 
> if there's a simple api like
> 
> sched_cpu_cache_wiped(int llc)
> 
> that would be very nice for this; the menuidle side knows this
> for some cases and thus can just call it. This would be a very
> small and minimal change

What do you mean by "menuidle side knows this for some cases" ?
You mean you know that some C-state entries imply llc clean/invalidate ?

Thanks,
Lorenzo


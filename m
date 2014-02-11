Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaBKTrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:47:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaBKTri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:47:38 -0500
Date: Tue, 11 Feb 2014 20:47:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
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
Message-ID: <20140211194726.GA9987@twins.programming.kicks-ass.net>
References: <52EBBC23.8020603@linux.intel.com>
 <52EBC33A.6080101@linaro.org>
 <52EBC645.2040607@linux.intel.com>
 <alpine.LFD.2.11.1401311236470.2312@knanqh.ubzr>
 <20140203125441.GD19029@e103034-lin>
 <52EFA9D3.1030601@linux.intel.com>
 <20140203145605.GL8874@twins.programming.kicks-ass.net>
 <52EFC12B.50704@linux.intel.com>
 <20140211164136.GT27965@twins.programming.kicks-ass.net>
 <52FA59E2.1000802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA59E2.1000802@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 09:12:02AM -0800, Arjan van de Ven wrote:
> On 2/11/2014 8:41 AM, Peter Zijlstra wrote:
> >On Mon, Feb 03, 2014 at 08:17:47AM -0800, Arjan van de Ven wrote:
> >>On 2/3/2014 6:56 AM, Peter Zijlstra wrote:
> >>if there's a simple api like
> >>
> >>sched_cpu_cache_wiped(int llc)
> >>
> >>that would be very nice for this; the menuidle side knows this
> >>for some cases and thus can just call it. This would be a very
> >>small and minimal change
> >>
> >>* if you don't care about llc vs core local caches then that
> >>   parameter can go away
> >>
> >>* I assume this is also called for the local cpu... if not then we
> >>   need to add a cpu number argument
> >>
> >>* we can also call this from architecture code when wbinvd or the
> >>   arm equivalent is called etc
> >
> >A little something like so?
> >
> 
> is there value also in doing a cpu level cache flush?
> (cpu cache flush we know from the C state, for the llc cache flush we need to read an MSR
> on x86. Not insane expensive but not zero either)

L1 or L2? L1 is too small to really bother afaik and L2 is shared
between logical cpus so we'd need a mask there, not sure the generic
topology has that.

I'll have a quick peek later.

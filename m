Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3JPVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:55:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:5677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab3JPVzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:55:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,509,1378882800"; 
   d="scan'208";a="420252510"
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20131016065526.GB22509@gmail.com>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
	 <1380753493.11046.82.camel@schen9-DESK> <20131003073212.GC5775@gmail.com>
	 <1381186674.11046.105.camel@schen9-DESK> <20131009061551.GD7664@gmail.com>
	 <1381336441.11046.128.camel@schen9-DESK> <20131010075444.GD17990@gmail.com>
	 <1381882156.11046.178.camel@schen9-DESK> <20131016065526.GB22509@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Oct 2013 14:55:30 -0700
Message-ID: <1381960530.11046.200.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> It would be _really_ nice to stick this into tools/perf/bench/ as:
> 
> 	perf bench mem pagefaults
> 
> or so, with a number of parallelism and workload patterns. See 
> tools/perf/bench/numa.c for a couple of workload generators - although 
> those are not page fault intense.
> 
> So that future generations can run all these tests too and such.
> 
> > I compare the throughput where I have the complete rwsem patchset 
> > against vanilla and the case where I take out the optimistic spin patch.  
> > I have increased the run time by 10x from my pervious experiments and do 
> > 10 runs for each case.  The standard deviation is ~1.5% so any changes 
> > under 1.5% is statistically significant.
> > 
> > % change in throughput vs the vanilla kernel.
> > Threads	all	No-optspin
> > 1		+0.4%	-0.1%
> > 2		+2.0%	+0.2%
> > 3		+1.1%	+1.5%
> > 4		-0.5%	-1.4%
> > 5		-0.1%	-0.1%
> > 10		+2.2%	-1.2%
> > 20		+237.3%	-2.3%
> > 40		+548.1%	+0.3%
> 
> The tail is impressive. The early parts are important as well, but it's 
> really hard to tell the significance of the early portion without having 
> an sttdev column.
> 
> ( "perf stat --repeat N" will give you sttdev output, in handy percentage 
>   form. )

Quick naive question as I haven't hacked perf bench before.  
Now perf stat gives the statistics of the performance counter or events.
How do I get it to compute the stats of 
the throughput reported by perf bench?

Something like

perf stat -r 10 -- perf bench mm memset --iterations 10

doesn't quite give what I need.

Pointers appreciated.

Tim


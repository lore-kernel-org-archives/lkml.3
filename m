Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab3JJHp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:45:26 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62489 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab3JJHpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:45:20 -0400
Date: Thu, 10 Oct 2013 09:45:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010074516.GC17990@gmail.com>
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010062741.GA9999@gmail.com>
 <20131009233419.ea3d0b80.akpm@linux-foundation.org>
 <20131010072757.GB17990@gmail.com>
 <20131010003315.f49dacdf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010003315.f49dacdf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Oct 2013 09:27:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> 
> > > > Should be fairly straightforward to test: the sys_sched_getaffinity() 
> > > > and sys_sched_setaffinity() syscalls both make use of 
> > > > get_online_cpus()/put_online_cpus(), so a testcase frobbing affinities 
> > > > on N CPUs in parallel ought to demonstrate scalability improvements 
> > > > pretty nicely.
> > > 
> > > Well, an in-kernel microbenchmark which camps in a loop doing get/put 
> > > would measure this as well.
> > > 
> > > But neither approach answers the question "how useful is this patchset".
> > 
> > Even ignoring all the other reasons cited, sys_sched_getaffinity() / 
> > sys_sched_setaffinity() are prime time system calls, and as long as 
> > the patches are correct, speeding them up is worthwhile.
> 
> That I would not have guessed.  What's the use case for calling 
> get/set_affinity at high frequency?

I don't think high-freq usage is common (at all).

It could happen in AIM7-like workloads that start up a ton of binaries in 
parallel, which can easily create parallel sched_getaffinity() calls 
during process startup?

Thanks,

	Ingo

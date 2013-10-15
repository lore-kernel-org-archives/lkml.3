Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3JOJze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:55:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab3JOJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:55:33 -0400
Date: Tue, 15 Oct 2013 10:55:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, riel@redhat.com, aarcange@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/numa: Introduce migrate_swap()
Message-ID: <20131015095527.GH11028@suse.de>
References: <1381141781-10992-39-git-send-email-mgorman@suse.de>
 <tip-ac66f5477239ebd3c4e2cbf2f591ef387aa09884@git.kernel.org>
 <20131010181722.GO13848@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131010181722.GO13848@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:17:22PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 10:30:13AM -0700, tip-bot for Peter Zijlstra wrote:
> > sched/numa: Introduce migrate_swap()
> 
> Thanks to Rik for writing the Changelog!
> 
> ---
> From: Peter Zijlstra <peterz@infradead.org>
> Subject: sched: Fix race in migrate_swap_stop
> 
> There is a subtle race in migrate_swap, when task P, on CPU A, decides to swap
> places with task T, on CPU B.
> 
> Task P:
>   - call migrate_swap
> Task T:
>   - go to sleep, removing itself from the runqueue
> Task P:
>   - double lock the runqueues on CPU A & B
> Task T:
>   - get woken up, place itself on the runqueue of CPU C
> Task P:
>   - see that task T is on a runqueue, and pretend to remove it
>     from the runqueue on CPU B
> 
> Now CPUs B & C both have corrupted scheduler data structures.
> 
> This patch fixes it, by holding the pi_lock for both of the tasks
> involved in the migrate swap. This prevents task T from waking up,
> and placing itself onto another runqueue, until after migrate_swap
> has released all locks.
> 
> This means that, when migrate_swap checks, task T will be either
> on the runqueue where it was originally seen, or not on any
> runqueue at all. Migrate_swap deals correctly with of those cases.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Tested-by: Joe Mario <jmario@redhat.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs

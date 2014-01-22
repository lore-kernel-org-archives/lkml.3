Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaAVKZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:25:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50576 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaAVKZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:25:02 -0500
Date: Wed, 22 Jan 2014 11:24:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Bisected] qemu hangs on current git
Message-ID: <20140122102435.GH31570@twins.programming.kicks-ass.net>
References: <20140121215119.GA389@x4>
 <20140122085035.GA390@x4>
 <20140122093755.GA388@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122093755.GA388@x4>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:37:55AM +0100, Markus Trippelsdorf wrote:
> git bisect points to:
> 
> commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Nov 20 12:22:37 2013 +0100
> 
>     sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
> 

No idea why kvm would go funny on that, real hardware runs fine.

You're running a !PREEMPT kernel, right? Does the below make any
difference?

---
 include/linux/preempt.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 59749fc48328..de83b4eb1642 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -134,7 +134,6 @@ do { \
 #undef preempt_check_resched
 #endif
 
-#ifdef CONFIG_PREEMPT
 #define preempt_set_need_resched() \
 do { \
 	set_preempt_need_resched(); \
@@ -144,10 +143,6 @@ do { \
 	if (tif_need_resched()) \
 		set_preempt_need_resched(); \
 } while (0)
-#else
-#define preempt_set_need_resched() do { } while (0)
-#define preempt_fold_need_resched() do { } while (0)
-#endif
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaISUnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:43:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:43300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739AbaISUnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:43:16 -0400
Date: Fri, 19 Sep 2014 22:43:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 3/7] atomic: Silence nested-externs warnings
Message-ID: <20140919204303.GF2832@worktop.localdomain>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-4-git-send-email-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411140580-20909-4-git-send-email-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:29:36AM -0700, Jeff Kirsher wrote:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Silence the nested-externs warnings for these, as they are
> truly wanted.
> 

You're patching an old tree.

---
commit 2e39465abc4b7856a0ea6fcf4f6b4668bb5db877
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Aug 4 12:07:15 2014 +0200

    locking: Remove deprecated smp_mb__() barriers
    
    Its been a while and there are no in-tree users left, so remove the
    deprecated barriers.
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Chen, Gong <gong.chen@linux.intel.com>
    Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
    Cc: Joe Perches <joe@perches.com>
    Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    Cc: Theodore Ts'o <tytso@mit.edu>
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index fef3a80..5b08a85 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,42 +3,6 @@
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
 
-/*
- * Provide __deprecated wrappers for the new interface, avoid flag day changes.
- * We need the ugly external functions to break header recursion hell.
- */
-#ifndef smp_mb__before_atomic_inc
-static inline void __deprecated smp_mb__before_atomic_inc(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_atomic_inc
-static inline void __deprecated smp_mb__after_atomic_inc(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
-#ifndef smp_mb__before_atomic_dec
-static inline void __deprecated smp_mb__before_atomic_dec(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_atomic_dec
-static inline void __deprecated smp_mb__after_atomic_dec(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
 /**
  * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index cbc5833..be5fd38 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -32,26 +32,6 @@ extern unsigned long __sw_hweight64(__u64 w);
  */
 #include <asm/bitops.h>
 
-/*
- * Provide __deprecated wrappers for the new interface, avoid flag day changes.
- * We need the ugly external functions to break header recursion hell.
- */
-#ifndef smp_mb__before_clear_bit
-static inline void __deprecated smp_mb__before_clear_bit(void)
-{
-	extern void __smp_mb__before_atomic(void);
-	__smp_mb__before_atomic();
-}
-#endif
-
-#ifndef smp_mb__after_clear_bit
-static inline void __deprecated smp_mb__after_clear_bit(void)
-{
-	extern void __smp_mb__after_atomic(void);
-	__smp_mb__after_atomic();
-}
-#endif
-
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
 	     (bit) < (size);					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575..76c518c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -90,22 +90,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
-#ifdef smp_mb__before_atomic
-void __smp_mb__before_atomic(void)
-{
-	smp_mb__before_atomic();
-}
-EXPORT_SYMBOL(__smp_mb__before_atomic);
-#endif
-
-#ifdef smp_mb__after_atomic
-void __smp_mb__after_atomic(void)
-{
-	smp_mb__after_atomic();
-}
-EXPORT_SYMBOL(__smp_mb__after_atomic);
-#endif
-
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;

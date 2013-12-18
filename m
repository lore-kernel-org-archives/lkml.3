Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab3LRTPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:15:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3LRTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:15:39 -0500
Message-Id: <20131218191222.971162775@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 18 Dec 2013 20:08:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, VICTORK@il.ibm.com, oleg@redhat.com,
        anton@samba.org, benh@kernel.crashing.org, fweisbec@gmail.com,
        mathieu.desnoyers@polymtl.ca, michael@ellerman.id.au,
        mikey@neuling.org, linux@arm.linux.org.uk, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, tony.luck@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/4] arch: Move smp_mb__{before,after}_atomic_{inc,dec}.h into asm/atomic.h
References: <20131218190806.370008594@infradead.org>
Content-Disposition: inline; filename=peterz-arch-move-atomic-barriers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the barriers functions that depend on the atomic implementation
into the atomic implementation.

Acked-by: Vineet Gupta <vgupta@synopsys.com> [for arch/arc bits]
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arc/include/asm/atomic.h      |    5 +++++
 arch/arc/include/asm/barrier.h     |    5 -----
 arch/hexagon/include/asm/atomic.h  |    6 +++++-
 arch/hexagon/include/asm/barrier.h |    4 ----
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -190,6 +190,11 @@ static inline void atomic_clear_mask(uns
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 /**
  * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
--- a/arch/arc/include/asm/barrier.h
+++ b/arch/arc/include/asm/barrier.h
@@ -30,11 +30,6 @@
 #define smp_wmb()       barrier()
 #endif
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #define smp_read_barrier_depends()      do { } while (0)
 
 #endif
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -160,8 +160,12 @@ static inline int __atomic_add_unless(at
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, (v)) == 0)
 #define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
 
-
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 #endif
--- a/arch/hexagon/include/asm/barrier.h
+++ b/arch/hexagon/include/asm/barrier.h
@@ -29,10 +29,6 @@
 #define smp_read_barrier_depends()	barrier()
 #define smp_wmb()			barrier()
 #define smp_mb()			barrier()
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
 
 /*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
 #define set_mb(var, value) \



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaCSG5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:57:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53008 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbaCSG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:31 -0400
Message-Id: <20140319065204.692998745@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 17/31] arch,metag: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-metag-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the new barriers; as per the old versions the metag atomic
imply a full barrier.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/metag/include/asm/atomic.h  |    6 +-----
 arch/metag/include/asm/barrier.h |    3 +++
 arch/metag/include/asm/bitops.h  |    6 ------
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/arch/metag/include/asm/atomic.h
+++ b/arch/metag/include/asm/atomic.h
@@ -4,6 +4,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #if defined(CONFIG_METAG_ATOMICITY_IRQSOFF)
 /* The simple UP case. */
@@ -39,11 +40,6 @@
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif
 
 #define atomic_dec_if_positive(v)       atomic_sub_if_positive(1, v)
--- a/arch/metag/include/asm/barrier.h
+++ b/arch/metag/include/asm/barrier.h
@@ -97,4 +97,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #endif /* _ASM_METAG_BARRIER_H */
--- a/arch/metag/include/asm/bitops.h
+++ b/arch/metag/include/asm/bitops.h
@@ -5,12 +5,6 @@
 #include <asm/barrier.h>
 #include <asm/global_lock.h>
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #ifdef CONFIG_SMP
 /*
  * These functions are the basis of our bit ops.



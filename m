Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbaCSHGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:06:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbaCSG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:28 -0400
Message-Id: <20140319065204.369517899@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/31] arch,cris: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-cris-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cris fully relies on asm-generic/barrier.h, therefore its smp_mb() is
barrier(), thus we can use the default implementation that uses
smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/cris/include/asm/atomic.h |    7 +------
 arch/cris/include/asm/bitops.h |    9 ++-------
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -6,6 +6,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 #include <arch/atomic.h>
 
 /*
@@ -151,10 +152,4 @@ static inline int __atomic_add_unless(at
 	return ret;
 }
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()    barrier()
-#define smp_mb__after_atomic_dec()     barrier()
-#define smp_mb__before_atomic_inc()    barrier()
-#define smp_mb__after_atomic_inc()     barrier()
-
 #endif
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -21,6 +21,7 @@
 #include <arch/bitops.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * set_bit - Atomically set a bit in memory
@@ -42,7 +43,7 @@
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 
@@ -84,12 +85,6 @@ static inline int test_and_set_bit(int n
 	return retval;
 }
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()      barrier()
-#define smp_mb__after_clear_bit()       barrier()
-
 /**
  * test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear



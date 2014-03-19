Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaCSG43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:56:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaCSG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:26 -0400
Message-Id: <20140319065204.422709709@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 12/31] arch,frv: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-frv-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because:

arch/frv/include/asm/smp.h:#error SMP not supported

smp_mb() is barrier() and we can use the default implementation that
uses smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/frv/include/asm/atomic.h |    7 +------
 arch/frv/include/asm/bitops.h |    6 ------
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <asm/spr-regs.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -29,12 +30,6 @@
  * We do not have SMP systems, so we don't have to deal with that.
  */
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #define ATOMIC_INIT(i)		{ (i) }
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -25,12 +25,6 @@
 
 #include <asm-generic/bitops/ffz.h>
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
 static inline
 unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)



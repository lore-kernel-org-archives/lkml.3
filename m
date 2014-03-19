Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbaCSHB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:01:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52997 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065204.578288229@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 15/31] arch,m32r: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-m32r-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M32r uses asm-generic/barrier.h and its smp_mb() is barrier();
therefore we can use the generic versions which default to smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/m32r/include/asm/atomic.h |    7 +------
 arch/m32r/include/asm/bitops.h |    6 ++----
 2 files changed, 3 insertions(+), 10 deletions(-)

--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -13,6 +13,7 @@
 #include <asm/assembler.h>
 #include <asm/cmpxchg.h>
 #include <asm/dcache_clear.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -308,10 +309,4 @@ static __inline__ void atomic_set_mask(u
 	local_irq_restore(flags);
 }
 
-/* Atomic operations are already serializing on m32r */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif	/* _ASM_M32R_ATOMIC_H */
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -21,6 +21,7 @@
 #include <asm/byteorder.h>
 #include <asm/dcache_clear.h>
 #include <asm/types.h>
+#include <asm/barrier.h>
 
 /*
  * These have to be done with inline assembly: that way the bit-setting
@@ -73,7 +74,7 @@ static __inline__ void set_bit(int nr, v
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __inline__ void clear_bit(int nr, volatile void * addr)
@@ -103,9 +104,6 @@ static __inline__ void clear_bit(int nr,
 	local_irq_restore(flags);
 }
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 /**
  * change_bit - Toggle a bit in memory
  * @nr: Bit to clear



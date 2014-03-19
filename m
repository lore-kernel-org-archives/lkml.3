Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaCSHAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:00:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53000 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbaCSG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:30 -0400
Message-Id: <20140319065205.319240141@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 29/31] arch,xtensa: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-xtensa-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xtensa SMP has ll/sc which is fully serializing, therefore its exising
smp_mb__{before,after}_clear_bit() appear unduly heavy.

Implement the new barriers are barrier().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/xtensa/include/asm/atomic.h  |    7 +------
 arch/xtensa/include/asm/barrier.h |    3 +++
 arch/xtensa/include/asm/bitops.h  |    4 +---
 3 files changed, 5 insertions(+), 9 deletions(-)

--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -19,6 +19,7 @@
 #ifdef __KERNEL__
 #include <asm/processor.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
@@ -387,12 +388,6 @@ static inline void atomic_set_mask(unsig
 #endif
 }
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@ -13,6 +13,9 @@
 #define rmb() barrier()
 #define wmb() mb()
 
+#define smp_mb__before_atomic()		barrier()
+#define smp_mb__after_atomic()		barrier()
+
 #include <asm-generic/barrier.h>
 
 #endif /* _XTENSA_SYSTEM_H */
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -21,9 +21,7 @@
 
 #include <asm/processor.h>
 #include <asm/byteorder.h>
-
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops/non-atomic.h>
 



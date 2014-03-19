Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbaCSHHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:07:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52946 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaCSG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:27 -0400
Message-Id: <20140319065204.202765358@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 08/31] arch,avr32: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-avr32-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AVR32's mb() implementation is a compiler barrier(), therefore it all
doesn't matter, fully rely on whatever asm-generic/barrier.h
generates.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/avr32/include/asm/atomic.h |    5 -----
 arch/avr32/include/asm/bitops.h |    9 ++-------
 2 files changed, 2 insertions(+), 12 deletions(-)

--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -183,9 +183,4 @@ static inline int atomic_sub_if_positive
 
 #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /*  __ASM_AVR32_ATOMIC_H */
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -13,12 +13,7 @@
 #endif
 
 #include <asm/byteorder.h>
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 /*
  * set_bit - Atomically set a bit in memory
@@ -67,7 +62,7 @@ static inline void set_bit(int nr, volat
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void clear_bit(int nr, volatile void * addr)



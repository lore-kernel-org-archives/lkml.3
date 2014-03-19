Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaCSHAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:00:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53002 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaCSG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:30 -0400
Message-Id: <20140319065204.641081549@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 16/31] arch,m68k: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-m68k-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k uses asm-generic/barrier.h and its smp_mb() is barrier(),
therefore we can use the generic versions that use smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/m68k/include/asm/atomic.h |    8 +-------
 arch/m68k/include/asm/bitops.h |    7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -209,11 +210,4 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __ARCH_M68K_ATOMIC __ */
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -13,6 +13,7 @@
 #endif
 
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 /*
  *	Bit access functions vary across the ColdFire and 68k families.
@@ -67,12 +68,6 @@ static inline void bfset_mem_set_bit(int
 #define __set_bit(nr, vaddr)	set_bit(nr, vaddr)
 
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 static inline void bclr_reg_clear_bit(int nr, volatile unsigned long *vaddr)
 {
 	char *p = (char *)vaddr + (nr ^ 31) / 8;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbaCSHDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:03:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065205.111621099@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 25/31] arch,sh: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-sh-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH can use the asm-generic/barrier.h implementation since that uses
smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/sh/include/asm/atomic.h |    6 +-----
 arch/sh/include/asm/bitops.h |    7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
@@ -62,9 +63,4 @@ static inline int __atomic_add_unless(at
 	return c;
 }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* __ASM_SH_ATOMIC_H */
--- a/arch/sh/include/asm/bitops.h
+++ b/arch/sh/include/asm/bitops.h
@@ -9,6 +9,7 @@
 
 /* For __swab32 */
 #include <asm/byteorder.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_GUSA_RB
 #include <asm/bitops-grb.h>
@@ -22,12 +23,6 @@
 #include <asm-generic/bitops/non-atomic.h>
 #endif
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-
 #ifdef CONFIG_SUPERH32
 static inline unsigned long ffz(unsigned long word)
 {



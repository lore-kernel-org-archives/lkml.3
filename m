Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaCSHCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:02:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52992 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065204.904890744@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 21/31] arch,parisc: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-parisc-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parisc fully relies on asm-generic/barrier.h, therefore its smp_mb()
is barrier and the default implementation suffices.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/parisc/include/asm/atomic.h |    6 +-----
 arch/parisc/include/asm/bitops.h |    4 +---
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -143,11 +144,6 @@ static __inline__ int __atomic_add_unles
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #ifdef CONFIG_64BIT
 
 #define ATOMIC64_INIT(i) { (i) }
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <asm/types.h>		/* for BITS_PER_LONG/SHIFT_PER_LONG */
 #include <asm/byteorder.h>
+#include <asm/barrier.h>
 #include <linux/atomic.h>
 
 /*
@@ -19,9 +20,6 @@
 #define CHOP_SHIFTCOUNT(x) (((unsigned long) (x)) & (BITS_PER_LONG - 1))
 
 
-#define smp_mb__before_clear_bit()      smp_mb()
-#define smp_mb__after_clear_bit()       smp_mb()
-
 /* See http://marc.theaimsgroup.com/?t=108826637900003 for discussion
  * on use of volatile and __*_bit() (set/clear/change):
  *	*_bit() want use of volatile.



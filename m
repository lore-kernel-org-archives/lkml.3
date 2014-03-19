Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbaCSG4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:56:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52917 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbaCSG41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:27 -0400
Message-Id: <20140319065203.995303943@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/31] arch,alpha: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-alpha-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Alpha ll/sc primitives do not imply any sort of barrier; therefore
the smp_mb__{before,after} should be a full barrier. This is the
default from asm-generic/barrier.h and therefore just remove the
current definitions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/atomic.h |    5 -----
 arch/alpha/include/asm/bitops.h |    3 ---
 2 files changed, 8 deletions(-)

--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -292,9 +292,4 @@ static inline long atomic64_dec_if_posit
 #define atomic_dec(v) atomic_sub(1,(v))
 #define atomic64_dec(v) atomic64_sub(1,(v))
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* _ALPHA_ATOMIC_H */
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -53,9 +53,6 @@ __set_bit(unsigned long nr, volatile voi
 	*m |= 1 << (nr & 31);
 }
 
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-
 static inline void
 clear_bit(unsigned long nr, volatile void * addr)
 {



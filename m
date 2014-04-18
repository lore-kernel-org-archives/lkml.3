Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaDRNRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:17:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaDRNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:10:42 -0400
Date: Fri, 18 Apr 2014 06:10:06 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-s5dvosrb7qhvpmtaffwfn0zg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,m68k: Convert smp_mb__*()
Git-Commit-ID: 2db56e8606016e33903c64feaed989ffecd66a1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2db56e8606016e33903c64feaed989ffecd66a1b
Gitweb:     http://git.kernel.org/tip/2db56e8606016e33903c64feaed989ffecd66a1b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:37 +0200

arch,m68k: Convert smp_mb__*()

m68k uses asm-generic/barrier.h and its smp_mb() is barrier(),
therefore we can use the generic versions that use smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-s5dvosrb7qhvpmtaffwfn0zg@git.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-m68k@lists.linux-m68k.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/m68k/include/asm/atomic.h | 8 +-------
 arch/m68k/include/asm/bitops.h | 7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index f4e32de..5569521 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -209,11 +210,4 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
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
diff --git a/arch/m68k/include/asm/bitops.h b/arch/m68k/include/asm/bitops.h
index c6baa91..b4a9b0d 100644
--- a/arch/m68k/include/asm/bitops.h
+++ b/arch/m68k/include/asm/bitops.h
@@ -13,6 +13,7 @@
 #endif
 
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 /*
  *	Bit access functions vary across the ColdFire and 68k families.
@@ -67,12 +68,6 @@ static inline void bfset_mem_set_bit(int nr, volatile unsigned long *vaddr)
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

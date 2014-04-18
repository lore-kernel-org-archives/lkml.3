Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaDRNJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:09:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaDRNJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:47 -0400
Date: Fri, 18 Apr 2014 06:09:15 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-n296g51yzdu5ru1vp7mccxmf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,frv: Convert smp_mb__*()
Git-Commit-ID: d038c0e8380fa8cae049bee8d81a5672cd159013
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

Commit-ID:  d038c0e8380fa8cae049bee8d81a5672cd159013
Gitweb:     http://git.kernel.org/tip/d038c0e8380fa8cae049bee8d81a5672cd159013
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:34 +0200

arch,frv: Convert smp_mb__*()

Because:

arch/frv/include/asm/smp.h:#error SMP not supported

smp_mb() is barrier() and we can use the default implementation that
uses smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-n296g51yzdu5ru1vp7mccxmf@git.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/frv/include/asm/atomic.h | 7 +------
 arch/frv/include/asm/bitops.h | 6 ------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index b86329d..f6c3a16 100644
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
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index 57bf85d..96de220 100644
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

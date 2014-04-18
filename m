Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaDRNMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:12:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaDRNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:12:33 -0400
Date: Fri, 18 Apr 2014 06:12:02 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2z962by2ppzcd984ybw2mwdw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,sh: Convert smp_mb__*()
Git-Commit-ID: 603228bcb8da90f8f8a5cdd8de74178f6c3e7e13
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

Commit-ID:  603228bcb8da90f8f8a5cdd8de74178f6c3e7e13
Gitweb:     http://git.kernel.org/tip/603228bcb8da90f8f8a5cdd8de74178f6c3e7e13
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:44 +0200

arch,sh: Convert smp_mb__*()

SH can use the asm-generic/barrier.h implementation since that uses
smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-2z962by2ppzcd984ybw2mwdw@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sh/include/asm/atomic.h | 6 +-----
 arch/sh/include/asm/bitops.h | 7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index f4c1c20..f57b8a6 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
@@ -62,9 +63,4 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* __ASM_SH_ATOMIC_H */
diff --git a/arch/sh/include/asm/bitops.h b/arch/sh/include/asm/bitops.h
index ea8706d..fc8e652 100644
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

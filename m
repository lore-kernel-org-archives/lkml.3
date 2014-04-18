Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaDRNPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:15:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaDRNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:12:43 -0400
Date: Fri, 18 Apr 2014 06:11:10 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-mxs4aubiyesi79v8xx53093q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, jejb@parisc-linux.org, tglx@linutronix.de,
        deller@gmx.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,parisc: Convert smp_mb__*()
Git-Commit-ID: e4a65e9d395feee195f1219d708e9eb2a2d4b583
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

Commit-ID:  e4a65e9d395feee195f1219d708e9eb2a2d4b583
Gitweb:     http://git.kernel.org/tip/e4a65e9d395feee195f1219d708e9eb2a2d4b583
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:41 +0200

arch,parisc: Convert smp_mb__*()

parisc fully relies on asm-generic/barrier.h, therefore its smp_mb()
is barrier and the default implementation suffices.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-mxs4aubiyesi79v8xx53093q@git.kernel.org
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/parisc/include/asm/atomic.h | 6 +-----
 arch/parisc/include/asm/bitops.h | 4 +---
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 472886c..0be2db2 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -143,11 +144,6 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #ifdef CONFIG_64BIT
 
 #define ATOMIC64_INIT(i) { (i) }
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 8c9b631..3f9406d 100644
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

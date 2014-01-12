Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaALSoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:44:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaALSoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:44:08 -0500
Date: Sun, 12 Jan 2014 10:43:31 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-1de7da377bd880ff23917f78924d0e908329d978@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20131213150640.786183683@infradead.org>
References: <20131213150640.786183683@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] arch: Move smp_mb__{before,after}_atomic_{inc,
 dec}.h into asm/atomic.h
Git-Commit-ID: 1de7da377bd880ff23917f78924d0e908329d978
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:43:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1de7da377bd880ff23917f78924d0e908329d978
Gitweb:     http://git.kernel.org/tip/1de7da377bd880ff23917f78924d0e908329d978
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 8 Nov 2013 12:01:59 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:37:14 +0100

arch: Move smp_mb__{before,after}_atomic_{inc,dec}.h into asm/atomic.h

Move the barriers functions that depend on the atomic implementation
into the atomic implementation.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Vineet Gupta <vgupta@synopsys.com> [for arch/arc bits]
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20131213150640.786183683@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arc/include/asm/atomic.h      | 5 +++++
 arch/arc/include/asm/barrier.h     | 5 -----
 arch/hexagon/include/asm/atomic.h  | 6 +++++-
 arch/hexagon/include/asm/barrier.h | 4 ----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 83f03ca..03e494f 100644
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -190,6 +190,11 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 /**
  * __atomic_add_unless - add unless the number is a given value
  * @v: pointer of type atomic_t
diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
index f6cb7c4..c32245c 100644
--- a/arch/arc/include/asm/barrier.h
+++ b/arch/arc/include/asm/barrier.h
@@ -30,11 +30,6 @@
 #define smp_wmb()       barrier()
 #endif
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #define smp_read_barrier_depends()      do { } while (0)
 
 #endif
diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index 8a64ff2..7aae4cb 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -160,8 +160,12 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, (v)) == 0)
 #define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
 
-
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 #endif
diff --git a/arch/hexagon/include/asm/barrier.h b/arch/hexagon/include/asm/barrier.h
index 1041a8e..4e863da 100644
--- a/arch/hexagon/include/asm/barrier.h
+++ b/arch/hexagon/include/asm/barrier.h
@@ -29,10 +29,6 @@
 #define smp_read_barrier_depends()	barrier()
 #define smp_wmb()			barrier()
 #define smp_mb()			barrier()
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
 
 /*  Set a value and use a memory barrier.  Used by the scheduler somewhere.  */
 #define set_mb(var, value) \

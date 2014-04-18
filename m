Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaDRNKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaDRNKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:10:02 -0400
Date: Fri, 18 Apr 2014 06:09:28 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-87irqrrbgizeojjfdqhypud3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, vgupta@synopsys.com, tglx@linutronix.de,
        rkuo@codeaurora.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,hexagon: Convert smp_mb__*()
Git-Commit-ID: 94cf42f823bc904305b0ee93a09bcd51ba380497
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

Commit-ID:  94cf42f823bc904305b0ee93a09bcd51ba380497
Gitweb:     http://git.kernel.org/tip/94cf42f823bc904305b0ee93a09bcd51ba380497
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:35 +0200

arch,hexagon: Convert smp_mb__*()

Hexagon uses asm-gemeric/barrier.h and its smp_mb() is barrier().
Therefore we can use the default implementation that uses smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-87irqrrbgizeojjfdqhypud3@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-hexagon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/hexagon/include/asm/atomic.h | 6 +-----
 arch/hexagon/include/asm/bitops.h | 4 +---
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index 17dc637..de916b1 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -24,6 +24,7 @@
 
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
@@ -176,9 +177,4 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_inc_return(v) (atomic_add_return(1, v))
 #define atomic_dec_return(v) (atomic_sub_return(1, v))
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif
diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index 9b1e4af..5e4a59b 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -25,12 +25,10 @@
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
 #include <asm/atomic.h>
+#include <asm/barrier.h>
 
 #ifdef __KERNEL__
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 /*
  * The offset calculations for these are based on BITS_PER_LONG == 32
  * (i.e. I get to shift by #5-2 (32 bits per long, 4 bytes per access),

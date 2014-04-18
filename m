Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaDRNGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:06:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaDRNGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:06:13 -0400
Date: Fri, 18 Apr 2014 06:05:23 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8gow97a7mapmnec0pvf729pj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, hskinnemoen@gmail.com, tglx@linutronix.de,
        egtvedt@samfundet.no
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, hskinnemoen@gmail.com, tglx@linutronix.de,
        egtvedt@samfundet.no
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,avr32: Convert smp_mb__*()
Git-Commit-ID: 710adaa913169d7183cdf0de41c2a349101ff615
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

Commit-ID:  710adaa913169d7183cdf0de41c2a349101ff615
Gitweb:     http://git.kernel.org/tip/710adaa913169d7183cdf0de41c2a349101ff615
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:33 +0200

arch,avr32: Convert smp_mb__*()

AVR32's mb() implementation is a compiler barrier(), therefore it all
doesn't matter, fully rely on whatever asm-generic/barrier.h
generates.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-8gow97a7mapmnec0pvf729pj@git.kernel.org
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/avr32/include/asm/atomic.h | 5 -----
 arch/avr32/include/asm/bitops.h | 9 ++-------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 6140727..0780f3f 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -183,9 +183,4 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 
 #define atomic_dec_if_positive(v) atomic_sub_if_positive(1, v)
 
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /*  __ASM_AVR32_ATOMIC_H */
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index ebe7ad3..910d537 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -13,12 +13,7 @@
 #endif
 
 #include <asm/byteorder.h>
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 /*
  * set_bit - Atomically set a bit in memory
@@ -67,7 +62,7 @@ static inline void set_bit(int nr, volatile void * addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void clear_bit(int nr, volatile void * addr)

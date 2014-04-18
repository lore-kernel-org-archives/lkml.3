Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaDRNFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:05:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaDRNFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:05:05 -0400
Date: Fri, 18 Apr 2014 06:04:25 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-iacwfd15lq3ta2v7jut747r7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,alpha: Convert smp_mb__*()
  to the asm-generic primitives
Git-Commit-ID: 6ae11028a62b2f82ee283392a84f33da599a81e7
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

Commit-ID:  6ae11028a62b2f82ee283392a84f33da599a81e7
Gitweb:     http://git.kernel.org/tip/6ae11028a62b2f82ee283392a84f33da599a81e7
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Mar 2014 17:11:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:31 +0200

arch,alpha: Convert smp_mb__*() to the asm-generic primitives

The Alpha ll/sc primitives do not imply any sort of barrier; therefore
the smp_mb__{before,after} should be a full barrier. This is the
default from asm-generic/barrier.h and therefore just remove the
current definitions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-iacwfd15lq3ta2v7jut747r7@git.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/atomic.h | 5 -----
 arch/alpha/include/asm/bitops.h | 3 ---
 2 files changed, 8 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 78b03ef..ed60a1e 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -292,9 +292,4 @@ static inline long atomic64_dec_if_positive(atomic64_t *v)
 #define atomic_dec(v) atomic_sub(1,(v))
 #define atomic64_dec(v) atomic64_sub(1,(v))
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* _ALPHA_ATOMIC_H */
diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index a19ba5e..4bdfbd4 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -53,9 +53,6 @@ __set_bit(unsigned long nr, volatile void * addr)
 	*m |= 1 << (nr & 31);
 }
 
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-
 static inline void
 clear_bit(unsigned long nr, volatile void * addr)
 {

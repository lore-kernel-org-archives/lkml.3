Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaHNRTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:19:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHNRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:19:41 -0400
Date: Thu, 14 Aug 2014 10:18:34 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        jesse.brandeburg@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        jesse.brandeburg@intel.com
In-Reply-To: <20140508135851.768177189@infradead.org>
References: <20140508135851.768177189@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/arch] locking,x86: Kill atomic_or_long()
Git-Commit-ID: f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3
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

Commit-ID:  f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3
Gitweb:     http://git.kernel.org/tip/f6b4ecee0eb7bfa66ae8d5652105ed4da53209a3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 23 Apr 2014 17:02:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Aug 2014 12:48:02 +0200

locking,x86: Kill atomic_or_long()

There are no users, kill it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140508135851.768177189@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/atomic.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 6dd1c7d..bf20c81 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -219,21 +219,6 @@ static inline short int atomic_inc_short(short int *v)
 	return *v;
 }
 
-#ifdef CONFIG_X86_64
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-#endif
-
 /* These are x86-specific, used by some header files */
 #define atomic_clear_mask(mask, addr)				\
 	asm volatile(LOCK_PREFIX "andl %0,%1"			\

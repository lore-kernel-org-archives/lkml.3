Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaDRNMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:12:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaDRNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:11:51 -0400
Date: Fri, 18 Apr 2014 06:10:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-sxgxgqag9tond4kji07d22oh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, jonas@southpole.se
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, jonas@southpole.se
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,openrisc: Convert smp_mb__*()
Git-Commit-ID: 0f5c6f9e18e14b4ebd83dd08e81ca8143d43de28
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

Commit-ID:  0f5c6f9e18e14b4ebd83dd08e81ca8143d43de28
Gitweb:     http://git.kernel.org/tip/0f5c6f9e18e14b4ebd83dd08e81ca8143d43de28
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:40 +0200

arch,openrisc: Convert smp_mb__*()

Openrisc fully relies on asm-generic/barrier.h and therefore its
smp_mb() is barrier().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-sxgxgqag9tond4kji07d22oh@git.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux@lists.openrisc.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/openrisc/include/asm/bitops.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/openrisc/include/asm/bitops.h b/arch/openrisc/include/asm/bitops.h
index 2c64f22..3003cda 100644
--- a/arch/openrisc/include/asm/bitops.h
+++ b/arch/openrisc/include/asm/bitops.h
@@ -27,14 +27,7 @@
 
 #include <linux/irqflags.h>
 #include <linux/compiler.h>
-
-/*
- * clear_bit may not imply a memory barrier
- */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
+#include <asm/barrier.h>
 
 #include <asm/bitops/__ffs.h>
 #include <asm-generic/bitops/ffz.h>

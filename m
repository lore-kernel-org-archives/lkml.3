Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaDRNMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:12:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbaDRNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:12:33 -0400
Date: Fri, 18 Apr 2014 06:11:50 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-4mv9svf28lnotjpfuza8urh8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, liqin.linux@gmail.com,
        peterz@infradead.org, lennox.wu@gmail.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liqin.linux@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, lennox.wu@gmail.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,score: Convert smp_mb__*()
Git-Commit-ID: 57aa6a76864dfbb5450728199c37c02f401586ec
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

Commit-ID:  57aa6a76864dfbb5450728199c37c02f401586ec
Gitweb:     http://git.kernel.org/tip/57aa6a76864dfbb5450728199c37c02f401586ec
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:43 +0200

arch,score: Convert smp_mb__*()

score fully relies on asm-generic/barrier.h, so it can use its default
implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Link: http://lkml.kernel.org/n/tip-4mv9svf28lnotjpfuza8urh8@git.kernel.org
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/score/include/asm/bitops.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/score/include/asm/bitops.h b/arch/score/include/asm/bitops.h
index a304096..c1bf8d6 100644
--- a/arch/score/include/asm/bitops.h
+++ b/arch/score/include/asm/bitops.h
@@ -2,12 +2,7 @@
 #define _ASM_SCORE_BITOPS_H
 
 #include <asm/byteorder.h> /* swab32 */
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops.h>
 #include <asm-generic/bitops/__fls.h>

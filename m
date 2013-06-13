Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3FMMVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31977 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab3FMMVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:30 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 08/10] metag/traps: Mark die() as __noreturn to match the declaration.
Date: Thu, 13 Jun 2013 13:19:39 +0100
Message-ID: <1371125981-5184-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/bug.h | 4 ++--
 arch/metag/kernel/traps.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/metag/include/asm/bug.h b/arch/metag/include/asm/bug.h
index d04b48c..9f8967f 100644
--- a/arch/metag/include/asm/bug.h
+++ b/arch/metag/include/asm/bug.h
@@ -6,7 +6,7 @@
 struct pt_regs;
 
 extern const char *trap_name(int trapno);
-extern void die(const char *str, struct pt_regs *regs, long err,
-		unsigned long addr) __attribute__ ((noreturn));
+extern void __noreturn die(const char *str, struct pt_regs *regs, long err,
+		unsigned long addr);
 
 #endif
diff --git a/arch/metag/kernel/traps.c b/arch/metag/kernel/traps.c
index 2ceeaae..a7051de 100644
--- a/arch/metag/kernel/traps.c
+++ b/arch/metag/kernel/traps.c
@@ -87,8 +87,8 @@ const char *trap_name(int trapno)
 
 static DEFINE_SPINLOCK(die_lock);
 
-void die(const char *str, struct pt_regs *regs, long err,
-	 unsigned long addr)
+void __noreturn die(const char *str, struct pt_regs *regs,
+		    long err, unsigned long addr)
 {
 	static int die_counter;
 
-- 
1.8.1.2



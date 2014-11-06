Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaKFWvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:51:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaKFWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 073/162] ARC: Update order of registers in KGDB to match GDB 7.5
Date: Thu,  6 Nov 2014 14:35:37 -0800
Message-Id: <1415313426-9622-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Kolesov <Anton.Kolesov@synopsys.com>

commit ebc0c74e76cec9c4dd860eb0ca1c0b39dc63c482 upstream.

Order of registers has changed in GDB moving from 6.8 to 7.5. This patch
updates KGDB to work properly with GDB 7.5, though makes it incompatible
with 6.8.

Signed-off-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arc/include/asm/kgdb.h | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arc/include/asm/kgdb.h b/arch/arc/include/asm/kgdb.h
index b65fca7..fea9316 100644
--- a/arch/arc/include/asm/kgdb.h
+++ b/arch/arc/include/asm/kgdb.h
@@ -19,7 +19,7 @@
  * register API yet */
 #undef DBG_MAX_REG_NUM
 
-#define GDB_MAX_REGS		39
+#define GDB_MAX_REGS		87
 
 #define BREAK_INSTR_SIZE	2
 #define CACHE_FLUSH_IS_SAFE	1
@@ -33,23 +33,27 @@ static inline void arch_kgdb_breakpoint(void)
 
 extern void kgdb_trap(struct pt_regs *regs);
 
-enum arc700_linux_regnums {
+/* This is the numbering of registers according to the GDB. See GDB's
+ * arc-tdep.h for details.
+ *
+ * Registers are ordered for GDB 7.5. It is incompatible with GDB 6.8. */
+enum arc_linux_regnums {
 	_R0		= 0,
 	_R1, _R2, _R3, _R4, _R5, _R6, _R7, _R8, _R9, _R10, _R11, _R12, _R13,
 	_R14, _R15, _R16, _R17, _R18, _R19, _R20, _R21, _R22, _R23, _R24,
 	_R25, _R26,
-	_BTA		= 27,
-	_LP_START	= 28,
-	_LP_END		= 29,
-	_LP_COUNT	= 30,
-	_STATUS32	= 31,
-	_BLINK		= 32,
-	_FP		= 33,
-	__SP		= 34,
-	_EFA		= 35,
-	_RET		= 36,
-	_ORIG_R8	= 37,
-	_STOP_PC	= 38
+	_FP		= 27,
+	__SP		= 28,
+	_R30		= 30,
+	_BLINK		= 31,
+	_LP_COUNT	= 60,
+	_STOP_PC	= 64,
+	_RET		= 64,
+	_LP_START	= 65,
+	_LP_END		= 66,
+	_STATUS32	= 67,
+	_ECR		= 76,
+	_BTA		= 82,
 };
 
 #else
-- 
1.9.1


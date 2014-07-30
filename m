Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaG3VoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:44:18 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:44064 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaG3Vmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:42:49 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz, linux-alpha@vger.kernel.org
Subject: [PATCH 2/2] alpha: Add sched_set/getattr and renameat2 syscalls
Date: Wed, 30 Jul 2014 11:42:32 -1000
Message-Id: <1406756552-23864-3-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406756552-23864-1-git-send-email-rth@twiddle.net>
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/unistd.h      | 2 +-
 arch/alpha/include/uapi/asm/unistd.h | 3 +++
 arch/alpha/kernel/systbls.S          | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index f2c9440..c509d30 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -3,7 +3,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define NR_SYSCALLS			508
+#define NR_SYSCALLS			511
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
index 53ae7bb..d214a035 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -469,5 +469,8 @@
 #define __NR_process_vm_writev		505
 #define __NR_kcmp			506
 #define __NR_finit_module		507
+#define __NR_sched_setattr		508
+#define __NR_sched_getattr		509
+#define __NR_renameat2			510
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index dca9b3f..2478971 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -526,6 +526,9 @@ sys_call_table:
 	.quad sys_process_vm_writev		/* 505 */
 	.quad sys_kcmp
 	.quad sys_finit_module
+	.quad sys_sched_setattr
+	.quad sys_sched_getattr
+	.quad sys_renameat2			/* 510 */
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.9.3


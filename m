Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246AbaGYAwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 20:52:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:57600 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900AbaGYAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 20:52:04 -0400
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Matt Turner <mattst88@gmail.com>
Subject: [PATCH 1/2] alpha: Wire up sched_setattr, sched_getattr, and renameat2 syscalls.
Date: Thu, 24 Jul 2014 17:53:53 -0700
Message-Id: <1406249634-27136-1-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Cree <mcree@orcon.net.nz>

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Matt Turner <mattst88@gmail.com>
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
1.8.5.5


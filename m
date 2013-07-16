Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab3GPRHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:07:46 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:58926 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3GPRFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:17 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 1/7] alpha: Add kcmp and finit_module syscalls
Date: Tue, 16 Jul 2013 10:04:34 -0700
Message-Id: <1373994280-12047-2-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/unistd.h      | 3 +--
 arch/alpha/include/uapi/asm/unistd.h | 2 ++
 arch/alpha/kernel/systbls.S          | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 43baee1..f2c9440 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -3,8 +3,7 @@
 
 #include <uapi/asm/unistd.h>
 
-
-#define NR_SYSCALLS			506
+#define NR_SYSCALLS			508
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
index 801d28b..53ae7bb 100644
--- a/arch/alpha/include/uapi/asm/unistd.h
+++ b/arch/alpha/include/uapi/asm/unistd.h
@@ -467,5 +467,7 @@
 #define __NR_sendmmsg			503
 #define __NR_process_vm_readv		504
 #define __NR_process_vm_writev		505
+#define __NR_kcmp			506
+#define __NR_finit_module		507
 
 #endif /* _UAPI_ALPHA_UNISTD_H */
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index 4284ec7..dca9b3f 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -524,6 +524,8 @@ sys_call_table:
 	.quad sys_sendmmsg
 	.quad sys_process_vm_readv
 	.quad sys_process_vm_writev		/* 505 */
+	.quad sys_kcmp
+	.quad sys_finit_module
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.8.1.4


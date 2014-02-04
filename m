Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaBDUQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:16:09 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:47187 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaBDUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:16:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] m68k: Wire up sched_setattr and sched_getattr
Date: Tue,  4 Feb 2014 21:15:54 +0100
Message-Id: <1391544954-7422-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
References: <1391544954-7422-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h      |    2 +-
 arch/m68k/include/uapi/asm/unistd.h |    2 ++
 arch/m68k/kernel/syscalltable.S     |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 014f288fc813..9d38b73989eb 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		349
+#define NR_syscalls		351
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index 625f321001dc..b932dd470041 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -354,5 +354,7 @@
 #define __NR_process_vm_writev	346
 #define __NR_kcmp		347
 #define __NR_finit_module	348
+#define __NR_sched_setattr	349
+#define __NR_sched_getattr	350
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 3f04ea0ab802..b6223dc41d82 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -369,4 +369,6 @@ ENTRY(sys_call_table)
 	.long sys_process_vm_writev
 	.long sys_kcmp
 	.long sys_finit_module
+	.long sys_sched_setattr
+	.long sys_sched_getattr		/* 350 */
 
-- 
1.7.9.5


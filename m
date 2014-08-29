Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaH2QIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:08:14 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:43477 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaH2QIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:08:11 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k: Wire up getrandom
Date: Fri, 29 Aug 2014 18:08:02 +0200
Message-Id: <1409328483-8460-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h      | 2 +-
 arch/m68k/include/uapi/asm/unistd.h | 1 +
 arch/m68k/kernel/syscalltable.S     | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 1fcdd344c7ad..fbf8792f4179 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		352
+#define NR_syscalls		353
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index 9cd82fbc7817..e906e3c1542e 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -357,5 +357,6 @@
 #define __NR_sched_setattr	349
 #define __NR_sched_getattr	350
 #define __NR_renameat2		351
+#define __NR_getrandom		352
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 501e10212789..9307b488ce14 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -372,4 +372,5 @@ ENTRY(sys_call_table)
 	.long sys_sched_setattr
 	.long sys_sched_getattr		/* 350 */
 	.long sys_renameat2
+	.long sys_getrandom
 
-- 
1.9.1


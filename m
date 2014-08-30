Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaH3DhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:37:20 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:37076 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaH3DhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:37:17 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anton Blanchard <anton@samba.org>, Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org (open list:LINUX FOR POWERPC...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] powerpc: Wire up three syscalls
Date: Fri, 29 Aug 2014 23:36:25 -0400
Message-Id: <1409369788-22563-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see that the three syscalls seccomp, getrandom and memfd_create are not wired
because of which we get a warning while compilation.

So I wired them up in this patch. What else needs to be done? I tried the
memfd_test after compiling this kernel, but it is failing. What am I missing for
this to work? Any advice is really appreciated! :)

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/powerpc/include/asm/systbl.h      | 3 +++
 arch/powerpc/include/asm/unistd.h      | 2 +-
 arch/powerpc/include/uapi/asm/unistd.h | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 542bc0f..7d8a600 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -362,3 +362,6 @@ SYSCALL(ni_syscall) /* sys_kcmp */
 SYSCALL_SPU(sched_setattr)
 SYSCALL_SPU(sched_getattr)
 SYSCALL_SPU(renameat2)
+SYSCALL_SPU(seccomp)
+SYSCALL_SPU(getrandom)
+SYSCALL_SPU(memfd_create)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 5ce5552..4e9af3f 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define __NR_syscalls		358
+#define __NR_syscalls		361
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
index 2d526f7..0688fc0 100644
--- a/arch/powerpc/include/uapi/asm/unistd.h
+++ b/arch/powerpc/include/uapi/asm/unistd.h
@@ -380,5 +380,8 @@
 #define __NR_sched_setattr	355
 #define __NR_sched_getattr	356
 #define __NR_renameat2		357
+#define __NR_seccomp		358
+#define __NR_getrandom		359
+#define __NR_memfd_create	360
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
-- 
2.1.0


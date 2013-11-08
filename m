Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab3KHCeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:34:03 -0500
Received: from intranet.asianux.com ([58.214.24.6]:44713 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3KHCd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:33:57 -0500
X-Spam-Score: -100.8
Message-ID: <527C4E10.4070408@asianux.com>
Date: Fri, 08 Nov 2013 10:36:00 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Jonas Bonn <jonas@southpole.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: arc: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installler.sh").

And be sure of all "endif" append (or have correct) related comment.

Also reserve guard macro in empty file, since some of "usr/include/*"
header files may check guard macro to know whether content related
header file.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/include/uapi/asm/byteorder.h  |    6 +++---
 arch/arc/include/uapi/asm/cachectl.h   |    6 +++---
 arch/arc/include/uapi/asm/elf.h        |    2 +-
 arch/arc/include/uapi/asm/setup.h      |    9 +++++++--
 arch/arc/include/uapi/asm/sigcontext.h |    6 +++---
 arch/arc/include/uapi/asm/signal.h     |    6 +++---
 arch/arc/include/uapi/asm/swab.h       |    6 +++---
 arch/arc/include/uapi/asm/unistd.h     |    4 ++++
 8 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/arc/include/uapi/asm/byteorder.h b/arch/arc/include/uapi/asm/byteorder.h
index 9da71d4..859fde2 100644
--- a/arch/arc/include/uapi/asm/byteorder.h
+++ b/arch/arc/include/uapi/asm/byteorder.h
@@ -6,8 +6,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __ASM_ARC_BYTEORDER_H
-#define __ASM_ARC_BYTEORDER_H
+#ifndef _UAPI__ASM_ARC_BYTEORDER_H
+#define _UAPI__ASM_ARC_BYTEORDER_H
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #include <linux/byteorder/big_endian.h>
@@ -15,4 +15,4 @@
 #include <linux/byteorder/little_endian.h>
 #endif
 
-#endif /* ASM_ARC_BYTEORDER_H */
+#endif /* _UAPI__ASM_ARC_BYTEORDER_H */
diff --git a/arch/arc/include/uapi/asm/cachectl.h b/arch/arc/include/uapi/asm/cachectl.h
index 51c73f0..2437fc6 100644
--- a/arch/arc/include/uapi/asm/cachectl.h
+++ b/arch/arc/include/uapi/asm/cachectl.h
@@ -6,8 +6,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __ARC_ASM_CACHECTL_H
-#define __ARC_ASM_CACHECTL_H
+#ifndef _UAPI__ARC_ASM_CACHECTL_H
+#define _UAPI__ARC_ASM_CACHECTL_H
 
 /*
  * ARC ABI flags defined for Android's finegrained cacheflush requirements
@@ -25,4 +25,4 @@
 #define DCACHE	CF_D_FLUSH
 #define BCACHE	(CF_I_INV | CF_D_FLUSH)
 
-#endif
+#endif /* _UAPI__ARC_ASM_CACHECTL_H */
diff --git a/arch/arc/include/uapi/asm/elf.h b/arch/arc/include/uapi/asm/elf.h
index 0f99ac8..4e82dc6 100644
--- a/arch/arc/include/uapi/asm/elf.h
+++ b/arch/arc/include/uapi/asm/elf.h
@@ -23,4 +23,4 @@ typedef unsigned long elf_fpregset_t;
 
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 
-#endif
+#endif /* _UAPI__ASM_ARC_ELF_H */
diff --git a/arch/arc/include/uapi/asm/setup.h b/arch/arc/include/uapi/asm/setup.h
index a6d4e44..09a8df7 100644
--- a/arch/arc/include/uapi/asm/setup.h
+++ b/arch/arc/include/uapi/asm/setup.h
@@ -1,6 +1,11 @@
 /*
  * setup.h is part of userspace header ABI so UAPI scripts have to generate it
  * even if there's nothing to export - causing empty <uapi/asm/setup.h>
- * However to prevent "patch" from discarding it we add this placeholder
- * comment
+ *
+ * And some user programs may check guard macro to know whether content related
+ * header file (e.g. some of "/usr/include/ *" header files check guard macro),
+ * so recommend to still reserve guard macro in empty file.
  */
+#ifndef _UAPI__ASM_ARC_SETUP_H
+#define _UAPI__ASM_ARC_SETUP_H
+#endif /* _UAPI__ASM_ARC_SETUP_H */
diff --git a/arch/arc/include/uapi/asm/sigcontext.h b/arch/arc/include/uapi/asm/sigcontext.h
index 9678a11..b2063ff 100644
--- a/arch/arc/include/uapi/asm/sigcontext.h
+++ b/arch/arc/include/uapi/asm/sigcontext.h
@@ -6,8 +6,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef _ASM_ARC_SIGCONTEXT_H
-#define _ASM_ARC_SIGCONTEXT_H
+#ifndef _UAPI_ASM_ARC_SIGCONTEXT_H
+#define _UAPI_ASM_ARC_SIGCONTEXT_H
 
 #include <asm/ptrace.h>
 
@@ -19,4 +19,4 @@ struct sigcontext {
 	struct user_regs_struct regs;
 };
 
-#endif /* _ASM_ARC_SIGCONTEXT_H */
+#endif /* _UAPI_ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/include/uapi/asm/signal.h b/arch/arc/include/uapi/asm/signal.h
index fad62f7..f212d83 100644
--- a/arch/arc/include/uapi/asm/signal.h
+++ b/arch/arc/include/uapi/asm/signal.h
@@ -8,8 +8,8 @@
  * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
  */
 
-#ifndef _ASM_ARC_SIGNAL_H
-#define _ASM_ARC_SIGNAL_H
+#ifndef _UAPI_ASM_ARC_SIGNAL_H
+#define _UAPI_ASM_ARC_SIGNAL_H
 
 /*
  * This is much needed for ARC sigreturn optimization.
@@ -24,4 +24,4 @@
 
 #include <asm-generic/signal.h>
 
-#endif /* _ASM_ARC_SIGNAL_H */
+#endif /* _UAPI_ASM_ARC_SIGNAL_H */
diff --git a/arch/arc/include/uapi/asm/swab.h b/arch/arc/include/uapi/asm/swab.h
index 095599a..7237a21 100644
--- a/arch/arc/include/uapi/asm/swab.h
+++ b/arch/arc/include/uapi/asm/swab.h
@@ -13,8 +13,8 @@
  *  -Hardware assisted single cycle bswap (Use Case of ARC custom instrn)
  */
 
-#ifndef __ASM_ARC_SWAB_H
-#define __ASM_ARC_SWAB_H
+#ifndef _UAPI__ASM_ARC_SWAB_H
+#define _UAPI__ASM_ARC_SWAB_H
 
 #include <linux/types.h>
 
@@ -95,4 +95,4 @@
 #define __SWAB_64_THRU_32__
 #endif
 
-#endif
+#endif /* _UAPI__ASM_ARC_SWAB_H */
diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 6f30484..109f32c 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -7,6 +7,8 @@
  */
 
 /******** no-legacy-syscalls-ABI *******/
+#ifndef _UAPI_ASM_ARC_UNISTD_H
+#define _UAPI_ASM_ARC_UNISTD_H
 
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
@@ -32,3 +34,5 @@ __SYSCALL(__NR_arc_gettls, sys_arc_gettls)
 /* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
 #define __NR_sysfs		(__NR_arch_specific_syscall + 3)
 __SYSCALL(__NR_sysfs, sys_sysfs)
+
+#endif /* _UAPI_ASM_ARC_UNISTD_H */
-- 
1.7.7.6

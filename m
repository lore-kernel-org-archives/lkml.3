Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3KQKaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 05:30:35 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53395 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3KQKac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 05:30:32 -0500
Message-ID: <52889AC5.9000806@gmail.com>
Date: Sun, 17 Nov 2013 18:30:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: msalter@redhat.com, a-jacquiot@ti.com, viro@zeniv.linux.org.uk
CC: linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: c6x: uapi: be sure of "_UAPI" prefix for all guard
 macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For all uapi headers, need use "_UAPI" prefix for its guard macro
(which will be stripped by "scripts/headers_installer.sh").

Also be sure that all files have their guard macros.

Also be sure that all "#endif" are followed with correct comments.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/c6x/include/uapi/asm/byteorder.h  | 6 +++---
 arch/c6x/include/uapi/asm/ptrace.h     | 1 +
 arch/c6x/include/uapi/asm/sigcontext.h | 7 +++----
 arch/c6x/include/uapi/asm/swab.h       | 6 +++---
 arch/c6x/include/uapi/asm/unistd.h     | 4 ++++
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/c6x/include/uapi/asm/byteorder.h b/arch/c6x/include/uapi/asm/byteorder.h
index 166038d..43f98aa 100644
--- a/arch/c6x/include/uapi/asm/byteorder.h
+++ b/arch/c6x/include/uapi/asm/byteorder.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_C6X_BYTEORDER_H
-#define _ASM_C6X_BYTEORDER_H
+#ifndef _UAPI_ASM_C6X_BYTEORDER_H
+#define _UAPI_ASM_C6X_BYTEORDER_H
 
 #include <asm/types.h>
 
@@ -9,4 +9,4 @@
 #include <linux/byteorder/little_endian.h>
 #endif /* _BIG_ENDIAN */
 
-#endif /* _ASM_BYTEORDER_H */
+#endif /* _UAPI_ASM_C6X_BYTEORDER_H */
diff --git a/arch/c6x/include/uapi/asm/ptrace.h b/arch/c6x/include/uapi/asm/ptrace.h
index cc0a4d9..e4bbe62 100644
--- a/arch/c6x/include/uapi/asm/ptrace.h
+++ b/arch/c6x/include/uapi/asm/ptrace.h
@@ -160,4 +160,5 @@ struct pt_regs {
 };
 
 #endif /* __ASSEMBLY__ */
+
 #endif /* _UAPI_ASM_C6X_PTRACE_H */
diff --git a/arch/c6x/include/uapi/asm/sigcontext.h b/arch/c6x/include/uapi/asm/sigcontext.h
index eb702f3..1fb30e9 100644
--- a/arch/c6x/include/uapi/asm/sigcontext.h
+++ b/arch/c6x/include/uapi/asm/sigcontext.h
@@ -8,9 +8,8 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
-#ifndef _ASM_C6X_SIGCONTEXT_H
-#define _ASM_C6X_SIGCONTEXT_H
-
+#ifndef _UAPI_ASM_C6X_SIGCONTEXT_H
+#define _UAPI_ASM_C6X_SIGCONTEXT_H
 
 struct sigcontext {
 	unsigned long  sc_mask;		/* old sigmask */
@@ -77,4 +76,4 @@ struct sigcontext {
 	unsigned long  sc_pc;
 };
 
-#endif /* _ASM_C6X_SIGCONTEXT_H */
+#endif /* _UAPI_ASM_C6X_SIGCONTEXT_H */
diff --git a/arch/c6x/include/uapi/asm/swab.h b/arch/c6x/include/uapi/asm/swab.h
index fd4bb05..58b738b 100644
--- a/arch/c6x/include/uapi/asm/swab.h
+++ b/arch/c6x/include/uapi/asm/swab.h
@@ -6,8 +6,8 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
-#ifndef _ASM_C6X_SWAB_H
-#define _ASM_C6X_SWAB_H
+#ifndef _UAPI_ASM_C6X_SWAB_H
+#define _UAPI_ASM_C6X_SWAB_H
 
 static inline __attribute_const__ __u16 __c6x_swab16(__u16 val)
 {
@@ -51,4 +51,4 @@ static inline __attribute_const__ __u32 __c6x_swahb32(__u32 val)
 #define __arch_swahw32 __c6x_swahw32
 #define __arch_swahb32 __c6x_swahb32
 
-#endif /* _ASM_C6X_SWAB_H */
+#endif /* _UAPI_ASM_C6X_SWAB_H */
diff --git a/arch/c6x/include/uapi/asm/unistd.h b/arch/c6x/include/uapi/asm/unistd.h
index e7d09a6..ec6aebb 100644
--- a/arch/c6x/include/uapi/asm/unistd.h
+++ b/arch/c6x/include/uapi/asm/unistd.h
@@ -13,6 +13,8 @@
  *   NON INFRINGEMENT.	See the GNU General Public License for
  *   more details.
  */
+#ifndef _UAPI_ASM_C6X_UNISTD_H
+#define _UAPI_ASM_C6X_UNISTD_H
 
 #define __ARCH_WANT_SYS_CLONE
 
@@ -22,3 +24,5 @@
 /* C6X-specific syscalls. */
 #define __NR_cache_sync	(__NR_arch_specific_syscall + 0)
 __SYSCALL(__NR_cache_sync, sys_cache_sync)
+
+#endif /* _UAPI_ASM_C6X_UNISTD_H */
-- 
1.7.11.7

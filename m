Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3KSLTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:19:23 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:44590 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3KSLTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:19:19 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RESEND] asm/types.h: Remove include/asm-generic/int-l64.h
Date: Tue, 19 Nov 2013 12:19:15 +0100
Message-Id: <1384859955-27837-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376996476-12027-2-git-send-email-geert@linux-m68k.org>
References: <1376996476-12027-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now all 64-bit architectures have been converted to int-ll64.h, we can
remove int-l64.h in kernelspace.

For backwards compatibility, alpha, ia64, mips64, and powerpc64 still use
int-l64.h in userspace.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is the (reworked for UAPI) non-documentation part of more than two
year old "asm/types.h: All architectures use int-ll64.h in kernelspace"
(https://lkml.org/lkml/2011/8/13/104)

Since <asm/types.h> (from include/uapi/asm-generic/types.h) is used for
both kernel and user space, include/asm-generic/int-ll64.h cannot just
become include/asm-generic/types.h, as Arnd suggested.

 include/asm-generic/int-l64.h    |   49 --------------------------------------
 include/uapi/asm-generic/types.h |    3 +--
 2 files changed, 1 insertion(+), 51 deletions(-)
 delete mode 100644 include/asm-generic/int-l64.h

diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
deleted file mode 100644
index 27d4ec0dfce0..000000000000
--- a/include/asm-generic/int-l64.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * asm-generic/int-l64.h
- *
- * Integer declarations for architectures which use "long"
- * for 64-bit types.
- */
-#ifndef _ASM_GENERIC_INT_L64_H
-#define _ASM_GENERIC_INT_L64_H
-
-#include <uapi/asm-generic/int-l64.h>
-
-
-#ifndef __ASSEMBLY__
-
-typedef signed char s8;
-typedef unsigned char u8;
-
-typedef signed short s16;
-typedef unsigned short u16;
-
-typedef signed int s32;
-typedef unsigned int u32;
-
-typedef signed long s64;
-typedef unsigned long u64;
-
-#define S8_C(x)  x
-#define U8_C(x)  x ## U
-#define S16_C(x) x
-#define U16_C(x) x ## U
-#define S32_C(x) x
-#define U32_C(x) x ## U
-#define S64_C(x) x ## L
-#define U64_C(x) x ## UL
-
-#else /* __ASSEMBLY__ */
-
-#define S8_C(x)  x
-#define U8_C(x)  x
-#define S16_C(x) x
-#define U16_C(x) x
-#define S32_C(x) x
-#define U32_C(x) x
-#define S64_C(x) x
-#define U64_C(x) x
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_GENERIC_INT_L64_H */
diff --git a/include/uapi/asm-generic/types.h b/include/uapi/asm-generic/types.h
index bd39806013b5..a3877926b0d4 100644
--- a/include/uapi/asm-generic/types.h
+++ b/include/uapi/asm-generic/types.h
@@ -1,8 +1,7 @@
 #ifndef _ASM_GENERIC_TYPES_H
 #define _ASM_GENERIC_TYPES_H
 /*
- * int-ll64 is used practically everywhere now,
- * so use it as a reasonable default.
+ * int-ll64 is used everywhere now.
  */
 #include <asm-generic/int-ll64.h>
 
-- 
1.7.9.5


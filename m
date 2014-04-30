Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbaD3Jzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:55:36 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36081 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448AbaD3Jze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:55:34 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v8 1/8] ftrace: make CALLER_ADDRx macros more generic
Date: Wed, 30 Apr 2014 18:54:29 +0900
Message-Id: <1398851676-16389-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most archs with HAVE_ARCH_CALLER_ADDR have the almost same definitions
of CALLER_ADDRx(n), and so put them into linux/ftrace.h.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm/include/asm/ftrace.h      |   10 +---------
 arch/blackfin/include/asm/ftrace.h |   11 +----------
 arch/parisc/include/asm/ftrace.h   |   10 +---------
 arch/sh/include/asm/ftrace.h       |   10 +---------
 arch/xtensa/include/asm/ftrace.h   |   14 ++++----------
 include/linux/ftrace.h             |   34 ++++++++++++++++++----------------
 6 files changed, 26 insertions(+), 63 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index f89515a..eb577f4 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -52,15 +52,7 @@ extern inline void *return_address(unsigned int level)
 
 #endif
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_addr(n) return_address(n)
 
 #endif /* ifndef __ASSEMBLY__ */
 
diff --git a/arch/blackfin/include/asm/ftrace.h b/arch/blackfin/include/asm/ftrace.h
index 8a02950..2f1c3c2 100644
--- a/arch/blackfin/include/asm/ftrace.h
+++ b/arch/blackfin/include/asm/ftrace.h
@@ -66,16 +66,7 @@ extern inline void *return_address(unsigned int level)
 
 #endif /* CONFIG_FRAME_POINTER */
 
-#define HAVE_ARCH_CALLER_ADDR
-
-/* inline function or macro may lead to unexpected result */
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/parisc/include/asm/ftrace.h b/arch/parisc/include/asm/ftrace.h
index 72c0faf..544ed8e 100644
--- a/arch/parisc/include/asm/ftrace.h
+++ b/arch/parisc/include/asm/ftrace.h
@@ -24,15 +24,7 @@ extern void return_to_handler(void);
 
 extern unsigned long return_address(unsigned int);
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 return_address(1)
-#define CALLER_ADDR2 return_address(2)
-#define CALLER_ADDR3 return_address(3)
-#define CALLER_ADDR4 return_address(4)
-#define CALLER_ADDR5 return_address(5)
-#define CALLER_ADDR6 return_address(6)
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/sh/include/asm/ftrace.h b/arch/sh/include/asm/ftrace.h
index 13e9966..e79fb6e 100644
--- a/arch/sh/include/asm/ftrace.h
+++ b/arch/sh/include/asm/ftrace.h
@@ -40,15 +40,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 /* arch/sh/kernel/return_address.c */
 extern void *return_address(unsigned int);
 
-#define HAVE_ARCH_CALLER_ADDR
-
-#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#define CALLER_ADDR1 ((unsigned long)return_address(1))
-#define CALLER_ADDR2 ((unsigned long)return_address(2))
-#define CALLER_ADDR3 ((unsigned long)return_address(3))
-#define CALLER_ADDR4 ((unsigned long)return_address(4))
-#define CALLER_ADDR5 ((unsigned long)return_address(5))
-#define CALLER_ADDR6 ((unsigned long)return_address(6))
+#define ftrace_return_address(n) return_address(n)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/xtensa/include/asm/ftrace.h b/arch/xtensa/include/asm/ftrace.h
index 736b9d2..6c6d9a9 100644
--- a/arch/xtensa/include/asm/ftrace.h
+++ b/arch/xtensa/include/asm/ftrace.h
@@ -12,24 +12,18 @@
 
 #include <asm/processor.h>
 
-#define HAVE_ARCH_CALLER_ADDR
 #ifndef __ASSEMBLY__
-#define CALLER_ADDR0 ({ unsigned long a0, a1; \
+#define ftrace_return_address0 ({ unsigned long a0, a1; \
 		__asm__ __volatile__ ( \
 			"mov %0, a0\n" \
 			"mov %1, a1\n" \
 			: "=r"(a0), "=r"(a1)); \
 		MAKE_PC_FROM_RA(a0, a1); })
+
 #ifdef CONFIG_FRAME_POINTER
 extern unsigned long return_address(unsigned level);
-#define CALLER_ADDR1 return_address(1)
-#define CALLER_ADDR2 return_address(2)
-#define CALLER_ADDR3 return_address(3)
-#else /* CONFIG_FRAME_POINTER */
-#define CALLER_ADDR1 (0)
-#define CALLER_ADDR2 (0)
-#define CALLER_ADDR3 (0)
-#endif /* CONFIG_FRAME_POINTER */
+#define ftrace_return_address(n) return_address(n)
+#endif
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9212b01..18f1ae7 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -614,25 +614,27 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifndef HAVE_ARCH_CALLER_ADDR
+/* All archs should have this, but we define it for consistency */
+#ifndef ftrace_return_address0
+# define ftrace_return_address0 __builtin_return_address(0)
+#endif
+
+/* Archs may use other ways for ADDR1 and beyond */
+#ifndef ftrace_return_address
 # ifdef CONFIG_FRAME_POINTER
-#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
-#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
-#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
-#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
-#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
+#  define ftrace_return_address(n) __builtin_return_address(n)
 # else
-#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-#  define CALLER_ADDR1 0UL
-#  define CALLER_ADDR2 0UL
-#  define CALLER_ADDR3 0UL
-#  define CALLER_ADDR4 0UL
-#  define CALLER_ADDR5 0UL
-#  define CALLER_ADDR6 0UL
+#  define ftrace_return_address(n) 0UL
 # endif
-#endif /* ifndef HAVE_ARCH_CALLER_ADDR */
+#endif
+
+#define CALLER_ADDR0 ((unsigned long)ftrace_return_address0)
+#define CALLER_ADDR1 ((unsigned long)ftrace_return_address(1))
+#define CALLER_ADDR2 ((unsigned long)ftrace_return_address(2))
+#define CALLER_ADDR3 ((unsigned long)ftrace_return_address(3))
+#define CALLER_ADDR4 ((unsigned long)ftrace_return_address(4))
+#define CALLER_ADDR5 ((unsigned long)ftrace_return_address(5))
+#define CALLER_ADDR6 ((unsigned long)ftrace_return_address(6))
 
 #ifdef CONFIG_IRQSOFF_TRACER
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
-- 
1.7.9.5


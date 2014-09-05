Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaIEXTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:19:13 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41013 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaIEXTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:19:12 -0400
From: behanw@converseincode.com
To: ard.biesheuvel@linaro.org, kim.phillips@freescale.com,
        linus.walleij@linaro.org, linux@arm.linux.org.uk
Cc: David.Woodhouse@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH] arm: LLVMLinux: Provide __aeabi_* symbols which are needed for clang
Date: Fri,  5 Sep 2014 16:18:41 -0700
Message-Id: <1409959121-12630-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

These symbols are required when compiling the Linux kernel for arch ARM with
clang.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm/lib/Makefile |  4 ++++
 arch/arm/lib/eabi.c   | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 arch/arm/lib/eabi.c

diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index 0573faa..b585fcf 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -15,6 +15,10 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
 		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
 		   call_with_stack.o bswapsdi2.o
 
+ifeq ($(COMPILER),clang)
+lib-y += eabi.o
+endif
+
 mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
 
 # the code in uaccess.S is not preemption safe and
diff --git a/arch/arm/lib/eabi.c b/arch/arm/lib/eabi.c
new file mode 100644
index 0000000..41b27b2
--- /dev/null
+++ b/arch/arm/lib/eabi.c
@@ -0,0 +1,32 @@
+/*
+ *  linux/lib/eabi.c
+ *
+ *  Copyright (C) 2012  Mark Charlebois
+ */
+
+/*
+ * EABI routines
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/export.h>
+
+void __aeabi_memcpy(void *dest, const void *src, size_t n)
+{
+	(void)memcpy(dest, src, n);
+}
+EXPORT_SYMBOL(__aeabi_memcpy);
+
+void __aeabi_memmove(void *dest, const void *src, size_t n)
+{
+	(void)memmove(dest, src, n);
+}
+EXPORT_SYMBOL(__aeabi_memmove);
+
+void __aeabi_memset(void *s, size_t n, int c)
+{
+	(void)memset(s, c, n);
+}
+EXPORT_SYMBOL(__aeabi_memset);
-- 
1.9.1


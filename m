Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaIEXXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:23:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34899 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIEXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:23:28 -0400
From: behanw@converseincode.com
To: catalin.marinas@arm.com, will.deacon@arm.com, zhichang.yuan@linaro.org
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are needed for clang
Date: Fri,  5 Sep 2014 16:23:14 -0700
Message-Id: <1409959394-14936-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

These symbols are required when compiling the Linux kernel for arch ARM64 with
clang.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/lib/Makefile |  4 ++++
 arch/arm64/lib/eabi.c   | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 arch/arm64/lib/eabi.c

diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index d98d3e3..0d3407c 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -3,3 +3,7 @@ lib-y		:= bitops.o clear_user.o delay.o copy_from_user.o	\
 		   clear_page.o memchr.o memcpy.o memmove.o memset.o	\
 		   memcmp.o strcmp.o strncmp.o strlen.o strnlen.o	\
 		   strchr.o strrchr.o
+
+ifeq ($(COMPILER),clang)
+lib-y += eabi.o
+endif
diff --git a/arch/arm64/lib/eabi.c b/arch/arm64/lib/eabi.c
new file mode 100644
index 0000000..41b27b2
--- /dev/null
+++ b/arch/arm64/lib/eabi.c
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


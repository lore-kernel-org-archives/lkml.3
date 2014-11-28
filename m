Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaK1F1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:27:33 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35813 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaK1F1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:27:30 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v10 3/6] asm-generic: add generic seccomp.h for secure computing mode 1
Date: Fri, 28 Nov 2014 14:26:36 +0900
Message-Id: <1417152399-32717-4-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
References: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those values (__NR_seccomp_*) are used solely in secure_computing()
to identify mode 1 system calls. If compat system calls have different
syscall numbers, asm/seccomp.h may override them.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/asm-generic/seccomp.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 include/asm-generic/seccomp.h

diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
new file mode 100644
index 0000000..9fa1f65
--- /dev/null
+++ b/include/asm-generic/seccomp.h
@@ -0,0 +1,30 @@
+/*
+ * include/asm-generic/seccomp.h
+ *
+ * Copyright (C) 2014 Linaro Limited
+ * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_GENERIC_SECCOMP_H
+#define _ASM_GENERIC_SECCOMP_H
+
+#include <linux/unistd.h>
+
+#if defined(CONFIG_COMPAT) && !defined(__NR_seccomp_read_32)
+#define __NR_seccomp_read_32		__NR_read
+#define __NR_seccomp_write_32		__NR_write
+#define __NR_seccomp_exit_32		__NR_exit
+#define __NR_seccomp_sigreturn_32	__NR_rt_sigreturn
+#endif /* CONFIG_COMPAT && ! already defined */
+
+#define __NR_seccomp_read		__NR_read
+#define __NR_seccomp_write		__NR_write
+#define __NR_seccomp_exit		__NR_exit
+#ifndef __NR_seccomp_sigreturn
+#define __NR_seccomp_sigreturn		__NR_rt_sigreturn
+#endif
+
+#endif /* _ASM_GENERIC_SECCOMP_H */
-- 
1.7.9.5


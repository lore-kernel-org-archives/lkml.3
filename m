Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaCMKRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:17:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48069 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaCMKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:27 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com,
        arndb@arndb.de
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 1/3] asm-generic: Add generic seccomp.h for secure computing mode 1
Date: Thu, 13 Mar 2014 19:17:01 +0900
Message-Id: <1394705823-12465-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
 <1394705823-12465-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those values (__NR_seccomp_*) are used solely in secure_computing()
to identify mode 1 system calls. If compat system calls have different
syscall numbers, asm/seccomp.h may override them.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/asm-generic/seccomp.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 include/asm-generic/seccomp.h

diff --git a/include/asm-generic/seccomp.h b/include/asm-generic/seccomp.h
new file mode 100644
index 0000000..5e97022
--- /dev/null
+++ b/include/asm-generic/seccomp.h
@@ -0,0 +1,28 @@
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
+#include <asm-generic/unistd.h>
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
+#define __NR_seccomp_sigreturn		__NR_rt_sigreturn
+
+#endif /* _ASM_GENERIC_SECCOMP_H */
-- 
1.7.9.5


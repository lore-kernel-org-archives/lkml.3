Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3AXLTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:19:54 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42906 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3AXLKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:10:45 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 35/71] ARC: Last bits (stubs) to get to a running kernel with UART
Date: Thu, 24 Jan 2013 16:36:03 +0530
Message-ID: <1359025589-22277-20-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was part of port buildup strategy from Arnd to have a minimal kernel
at first and then add optional features (stacktracing, ptrace, smp,
kprobes, oprofile....)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/ptrace.c       |   26 ++++++++++++++++++++++++
 arch/arc/kernel/stacktrace.c   |   43 ++++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/troubleshoot.c |   17 +++++++++++++++
 3 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/kernel/ptrace.c
 create mode 100644 arch/arc/kernel/stacktrace.c
 create mode 100644 arch/arc/kernel/troubleshoot.c

diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
new file mode 100644
index 0000000..1cf944a
--- /dev/null
+++ b/arch/arc/kernel/ptrace.c
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ptrace.h>
+
+void ptrace_disable(struct task_struct *child)
+{
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	int ret = -EIO;
+	return ret;
+}
+
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return (const struct user_regset_view *)NULL;
+}
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
new file mode 100644
index 0000000..b9d1646
--- /dev/null
+++ b/arch/arc/kernel/stacktrace.c
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ptrace.h>
+#include <linux/export.h>
+
+/*-------------------------------------------------------------------------
+ *              APIs expected by various kernel sub-systems
+ *-------------------------------------------------------------------------
+ */
+
+noinline void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs)
+{
+	pr_info("\nStack Trace: NOT Available\n");
+}
+EXPORT_SYMBOL(show_stacktrace);
+
+/* Expected by sched Code */
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	show_stacktrace(tsk, NULL);
+}
+
+/* Expected by Rest of kernel code */
+void dump_stack(void)
+{
+	show_stacktrace(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
+
+/* Another API expected by schedular, shows up in "ps" as Wait Channel
+ * Ofcourse just returning schedule( ) would be pointless so unwind until
+ * the function is not in schedular code
+ */
+unsigned int get_wchan(struct task_struct *tsk)
+{
+	return 0;
+}
diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
new file mode 100644
index 0000000..80bfe2a
--- /dev/null
+++ b/arch/arc/kernel/troubleshoot.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ */
+
+#include <linux/ptrace.h>
+
+void show_regs(struct pt_regs *regs)
+{
+}
+
+void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
+			    unsigned long address, unsigned long cause_reg)
+{
+}
-- 
1.7.4.1


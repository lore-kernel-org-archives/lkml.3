Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3AVAzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:55:14 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46470 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab3AVAzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:55:13 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 1/4] tile: move declaration of sys_call_table to <asm/syscall.h>
Date: Mon, 21 Jan 2013 19:54:55 -0500
Message-Id: <1358816098-13070-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 22 Jan 2013 00:55:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When activating syscall tracing, kernel/trace/trace_syscalls.c doesn't
find sys_call_table because it includes <asm/syscall.h>, not
<asm/syscalls.h>. Also, looking at the other architectures, that is
probably where it should be.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/asm/syscall.h  |    6 ++++++
 arch/tile/include/asm/syscalls.h |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/tile/include/asm/syscall.h b/arch/tile/include/asm/syscall.h
index d35e0dc..9644b88 100644
--- a/arch/tile/include/asm/syscall.h
+++ b/arch/tile/include/asm/syscall.h
@@ -22,6 +22,12 @@
 #include <linux/err.h>
 #include <arch/abi.h>
 
+/* The array of function pointers for syscalls. */
+extern void *sys_call_table[];
+#ifdef CONFIG_COMPAT
+extern void *compat_sys_call_table[];
+#endif
+
 /*
  * Only the low 32 bits of orig_r0 are meaningful, so we return int.
  * This importantly ignores the high bits on 64-bit, so comparisons
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index 4c8462a..3b18317 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -24,12 +24,6 @@
 #include <linux/types.h>
 #include <linux/compat.h>
 
-/* The array of function pointers for syscalls. */
-extern void *sys_call_table[];
-#ifdef CONFIG_COMPAT
-extern void *compat_sys_call_table[];
-#endif
-
 /*
  * Note that by convention, any syscall which requires the current
  * register set takes an additional "struct pt_regs *" pointer; a
-- 
1.7.1


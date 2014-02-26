Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaBZBLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:11:09 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40669 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaBZBJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:38 -0500
From: behanw@converseincode.com
To: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, torvalds@linux-foundation.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 4/5] LLVMLinux: Add support for clang to compiler.h and new compiler-clang.h
Date: Tue, 25 Feb 2014 17:08:42 -0800
Message-Id: <1393376923-21892-5-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Add a compiler-clang.h file to add specific macros needed for compiling the
kernel with clang.

Initially the only override required is the macro for silencing the
compiler for a purposefully uninintialized variable.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 include/linux/compiler-clang.h | 12 ++++++++++++
 include/linux/compiler.h       |  7 +++++++
 2 files changed, 19 insertions(+)
 create mode 100644 include/linux/compiler-clang.h

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
new file mode 100644
index 0000000..d1e49d5
--- /dev/null
+++ b/include/linux/compiler-clang.h
@@ -0,0 +1,12 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
+#endif
+
+/* Some compiler specific definitions are overwritten here
+ * for Clang compiler
+ */
+
+#ifdef uninitialized_var
+#undef uninitialized_var
+#define uninitialized_var(x) x = *(&(x))
+#endif
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 2472740..ee7239e 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -63,6 +63,13 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # include <linux/compiler-intel.h>
 #endif
 
+/* Clang compiler defines __GNUC__. So we will overwrite implementations
+ * coming from above header files here
+ */
+#ifdef __clang__
+#include <linux/compiler-clang.h>
+#endif
+
 /*
  * Generic compiler-dependent macros required for kernel
  * build go below this comment. Actual compiler/compiler version
-- 
1.8.3.2


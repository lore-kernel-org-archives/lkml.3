Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbaIOWTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbaIOWTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 040/187] x86, espfix: Move espfix definitions into a separate header file
Date: Mon, 15 Sep 2014 15:07:30 -0700
Message-Id: <1410818997-9432-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e1fe9ed8d2a4937510d0d60e20705035c2609aea upstream.

Sparse warns that the percpu variables aren't declared before they are
defined.  Rather than hacking around it, move espfix definitions into
a proper header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/espfix.h | 16 ++++++++++++++++
 arch/x86/include/asm/setup.h  |  5 ++---
 arch/x86/kernel/espfix_64.c   |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/espfix.h

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
new file mode 100644
index 0000000..729051c
--- /dev/null
+++ b/arch/x86/include/asm/espfix.h
@@ -0,0 +1,16 @@
+#ifdef _ASM_X86_ESPFIX_H
+#define _ASM_X86_ESPFIX_H
+
+#ifdef CONFIG_X86_64
+
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
+
+extern void init_espfix_bsp(void);
+extern void init_espfix_ap(void);
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_ESPFIX_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index edfaf6a..c2003c0 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -62,11 +62,10 @@ extern void x86_ce4100_early_setup(void);
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
-extern void init_espfix_bsp(void);
-extern void init_espfix_ap(void);
-
 #ifndef _SETUP
 
+#include <asm/espfix.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 8a64da3..6afbb16 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -40,6 +40,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/setup.h>
+#include <asm/espfix.h>
 
 /*
  * Note: we only need 6*8 = 48 bytes for the espfix stack, but round
-- 
1.9.1


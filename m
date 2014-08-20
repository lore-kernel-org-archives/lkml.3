Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaHTMMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:12:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58878 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/104] x86, espfix: Move espfix definitions into a separate header file
Date: Wed, 20 Aug 2014 13:42:44 +0200
Message-Id: <24ebf77fa93bc2c5879f1d19973a78ecd1a8cfed.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e1fe9ed8d2a4937510d0d60e20705035c2609aea upstream.

Sparse warns that the percpu variables aren't declared before they are
defined.  Rather than hacking around it, move espfix definitions into
a proper header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/espfix.h | 16 ++++++++++++++++
 arch/x86/include/asm/setup.h  |  5 ++---
 arch/x86/kernel/espfix_64.c   |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/espfix.h

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
new file mode 100644
index 000000000000..729051c82b02
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
index 82bb2c8f13f1..ad1d8ec6719c 100644
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
index 8a64da36310f..6afbb16e9b79 100644
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
2.0.4


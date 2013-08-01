Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3HAXqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:46:33 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:50032 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3HAXqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:46:03 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] ARM: move shared uprobe/kprobe definitions into new include file
Date: Thu,  1 Aug 2013 19:45:50 -0400
Message-Id: <1375400753-3454-7-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
References: <1375400753-3454-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Separate the kprobe-only definitions from the definitions needed by
both kprobes and uprobes.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/kprobes.h | 17 +----------------
 arch/arm/include/asm/probes.h  | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index f82ec22..53b1a80 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -27,22 +27,7 @@
 #define flush_insn_slot(p)		do { } while (0)
 #define kretprobe_blacklist_size	0
 
-typedef u32 kprobe_opcode_t;
-
-struct kprobe;
-typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
-typedef unsigned long (kprobe_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
-typedef void (kprobe_insn_fn_t)(void);
-
-/* Architecture specific copy of original instruction. */
-struct arch_specific_insn {
-	kprobe_opcode_t			*insn;
-	kprobe_insn_handler_t		*insn_handler;
-	kprobe_check_cc			*insn_check_cc;
-	kprobe_insn_singlestep_t	*insn_singlestep;
-	kprobe_insn_fn_t		*insn_fn;
-};
+#include <asm/probes.h>
 
 struct prev_kprobe {
 	struct kprobe *kp;
diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
new file mode 100644
index 0000000..df46994
--- /dev/null
+++ b/arch/arm/include/asm/probes.h
@@ -0,0 +1,23 @@
+#ifndef _ASM_PROBES_H
+#define _ASM_PROBES_H
+
+#ifdef CONFIG_KPROBES
+typedef u32 kprobe_opcode_t;
+
+struct kprobe;
+typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
+typedef unsigned long (kprobe_check_cc)(unsigned long);
+typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
+typedef void (kprobe_insn_fn_t)(void);
+
+/* Architecture specific copy of original instruction. */
+struct arch_specific_insn {
+	kprobe_opcode_t			*insn;
+	kprobe_insn_handler_t		*insn_handler;
+	kprobe_check_cc			*insn_check_cc;
+	kprobe_insn_singlestep_t	*insn_singlestep;
+	kprobe_insn_fn_t		*insn_fn;
+};
+#endif
+
+#endif
-- 
1.8.1.2


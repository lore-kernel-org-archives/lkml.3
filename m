Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab3K0C63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:58:29 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:61443 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3K0Cxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:41 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/15] ARM: move shared uprobe/kprobe definitions into new include file
Date: Tue, 26 Nov 2013 21:53:21 -0500
Message-Id: <1385520814-10663-3-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Separate the kprobe-only definitions from the definitions needed by
both kprobes and uprobes.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/kprobes.h | 15 +--------------
 arch/arm/include/asm/probes.h  | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index f82ec22..30fc11b 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -28,21 +28,8 @@
 #define kretprobe_blacklist_size	0
 
 typedef u32 kprobe_opcode_t;
-
 struct kprobe;
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
index 0000000..21da148
--- /dev/null
+++ b/arch/arm/include/asm/probes.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_PROBES_H
+#define _ASM_PROBES_H
+
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
+
+#endif
-- 
1.8.1.2


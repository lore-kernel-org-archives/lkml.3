Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3K0C4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:56:36 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:33989 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3K0Cxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:55 -0500
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
Subject: [PATCH v3 10/15] ARM: Change more ARM kprobes symbol names to something more
Date: Tue, 26 Nov 2013 21:53:29 -0500
Message-Id: <1385520814-10663-11-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Change kprobe_emulate_none, kprobe_simulate_nop, and arm_kprobe_decode_init
function names to something more appropriate for code being shared
outside of the kprobes subsystem. Also, move the new arm_probes_decode_init
declaration out of the kprobes.h include file and into the probes.h include file.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/kernel/kprobes-arm.c   | 12 ++++++------
 arch/arm/kernel/kprobes-thumb.c | 10 +++++-----
 arch/arm/kernel/kprobes.c       |  2 +-
 arch/arm/kernel/kprobes.h       |  2 --
 arch/arm/kernel/probes.c        |  6 +++---
 arch/arm/kernel/probes.h        |  6 ++++--
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 1fe3a44..ccb10bc 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -302,10 +302,10 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t insn,
 }
 
 const union decode_item kprobes_arm_actions[] = {
-	[PROBES_EMULATE_NONE] = {.handler = kprobe_emulate_none},
-	[PROBES_SIMULATE_NOP] = {.handler = kprobe_simulate_nop},
-	[PROBES_PRELOAD_IMM] = {.handler = kprobe_simulate_nop},
-	[PROBES_PRELOAD_REG] = {.handler = kprobe_simulate_nop},
+	[PROBES_EMULATE_NONE] = {.handler = probes_emulate_none},
+	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
 	[PROBES_MRS] = {.handler = simulate_mrs},
 	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
@@ -326,8 +326,8 @@ const union decode_item kprobes_arm_actions[] = {
 	[PROBES_DATA_PROCESSING_IMM] = {
 		.handler = emulate_rd12rn16rm0rs8_rwflags},
 	[PROBES_MOV_HALFWORD] = {.handler = emulate_rd12rm0_noflags_nopc},
-	[PROBES_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_SEV] = {.handler = probes_emulate_none},
+	[PROBES_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_SATURATE] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
 	[PROBES_REV] = {.handler = emulate_rd12rm0_noflags_nopc},
 	[PROBES_MMI] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 4f30217..84b7152 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -612,8 +612,8 @@ const union decode_item kprobes_t16_actions[] = {
 	[PROBES_T16_SIGN_EXTEND] = {.handler = t16_emulate_loregs_rwflags},
 	[PROBES_T16_PUSH] = {.decoder = t16_decode_push},
 	[PROBES_T16_POP] = {.decoder = t16_decode_pop},
-	[PROBES_T16_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_T16_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_T16_SEV] = {.handler = probes_emulate_none},
+	[PROBES_T16_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_T16_IT] = {.decoder = t16_decode_it},
 	[PROBES_T16_CMP] = {.handler = t16_emulate_loregs_rwflags},
 	[PROBES_T16_ADDSUB] = {.handler = t16_emulate_loregs_noitrwflags},
@@ -643,12 +643,12 @@ const union decode_item kprobes_t32_actions[] = {
 	[PROBES_T32_MOVW] = {.handler = t32_emulate_rd8rn16_noflags},
 	[PROBES_T32_SAT] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_BITFIELD] = {.handler = t32_emulate_rd8rn16_noflags},
-	[PROBES_T32_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_T32_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_T32_SEV] = {.handler = probes_emulate_none},
+	[PROBES_T32_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_T32_MRS] = {.handler = t32_simulate_mrs},
 	[PROBES_T32_BRANCH_COND] = {.decoder = t32_decode_cond_branch},
 	[PROBES_T32_BRANCH] = {.handler = t32_simulate_branch},
-	[PROBES_T32_PLDI] = {.handler = kprobe_simulate_nop},
+	[PROBES_T32_PLDI] = {.handler = probes_simulate_nop},
 	[PROBES_T32_LDR_LIT] = {.handler = t32_simulate_ldr_literal},
 	[PROBES_T32_LDRSTR] = {.handler = t32_emulate_ldrstr},
 	[PROBES_T32_SIGN_EXTEND] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 19c55aa..31bc9b7 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -613,7 +613,7 @@ static struct undef_hook kprobes_arm_break_hook = {
 
 int __init arch_init_kprobes()
 {
-	arm_kprobe_decode_init();
+	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL
 	register_undef_hook(&kprobes_thumb16_break_hook);
 	register_undef_hook(&kprobes_thumb32_break_hook);
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index c8a8413..eba5a2f 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -56,8 +56,6 @@ enum kprobe_insn arm_kprobe_decode_insn(probes_opcode_t,
 
 #endif
 
-void __init arm_kprobe_decode_init(void);
-
 #include "probes.h"
 
 #endif /* _ARM_KERNEL_KPROBES_H */
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 36fafd2..c63b0f6 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -72,7 +72,7 @@ void __init test_alu_write_pc_interworking(void)
 #endif /* !test_alu_write_pc_interworking */
 
 
-void __init arm_kprobe_decode_init(void)
+void __init arm_probes_decode_init(void)
 {
 	find_str_pc_offset();
 	test_load_write_pc_interworking();
@@ -171,13 +171,13 @@ probes_check_cc * const probes_condition_checks[16] = {
 };
 
 
-void __kprobes kprobe_simulate_nop(probes_opcode_t opcode,
+void __kprobes probes_simulate_nop(probes_opcode_t opcode,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
 }
 
-void __kprobes kprobe_emulate_none(probes_opcode_t opcode,
+void __kprobes probes_emulate_none(probes_opcode_t opcode,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index e7c7a92..48ccbcb 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -22,6 +22,8 @@
 #include <linux/kprobes.h>
 #include "kprobes.h"
 
+void __init arm_probes_decode_init(void);
+
 #if __LINUX_ARM_ARCH__ >= 7
 
 /* str_pc_offset is architecturally defined from ARMv7 onwards */
@@ -129,9 +131,9 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
 }
 
 
-void __kprobes kprobe_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
+void __kprobes probes_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
-void __kprobes kprobe_emulate_none(probes_opcode_t, struct arch_specific_insn *,
+void __kprobes probes_emulate_none(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
 
 enum kprobe_insn __kprobes
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaAWUI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:08:27 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61898 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaAWUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:06:19 -0500
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
Subject: [PATCH v5 11/16] ARM: Rename the shared kprobes/uprobe return value enum
Date: Thu, 23 Jan 2014 15:05:54 -0500
Message-Id: <1390507559-4697-12-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Change the name of kprobes_insn to probes_insn so it can be shared between
kprobes and uprobes without confusion.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/kernel/kprobes-common.c |  2 +-
 arch/arm/kernel/kprobes-thumb.c  | 16 ++++++++--------
 arch/arm/kernel/kprobes.h        | 14 ++++----------
 arch/arm/kernel/probes-arm.c     |  2 +-
 arch/arm/kernel/probes-thumb.c   |  4 ++--
 arch/arm/kernel/probes.h         |  9 +++++++--
 6 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 0b489f9..dc3af4c 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -124,7 +124,7 @@ emulate_ldm_r3_15(probes_opcode_t insn,
 	load_write_pc(regs->ARM_pc, regs);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *h)
 {
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 0ec63f1..209d747 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -65,7 +65,7 @@ t32_simulate_cond_branch(probes_opcode_t insn,
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -141,11 +141,11 @@ t32_simulate_ldr_literal(probes_opcode_t insn,
 	regs->uregs[rt] = rtv;
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
-	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
+	enum probes_insn ret = kprobe_decode_ldmstm(insn, asi, d);
 
 	/* Fixup modified instruction to have halfwords in correct order...*/
 	insn = asi->insn[0];
@@ -401,7 +401,7 @@ t16_singlestep_it(probes_opcode_t insn,
 	t16_simulate_it(insn, asi, regs);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_it(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -419,7 +419,7 @@ t16_simulate_cond_branch(probes_opcode_t insn,
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -509,7 +509,7 @@ t16_emulate_hiregs(probes_opcode_t insn,
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_hiregs(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -537,7 +537,7 @@ t16_emulate_push(probes_opcode_t insn,
 		);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_push(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -590,7 +590,7 @@ t16_emulate_pop_pc(probes_opcode_t insn,
 	bx_write_pc(pc, regs);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 t16_decode_pop(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index e2ae4ed..3684fc9 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -30,28 +30,22 @@
 struct decode_header;
 union decode_action;
 
-enum kprobe_insn {
-	INSN_REJECTED,
-	INSN_GOOD,
-	INSN_GOOD_NO_SLOT
-};
-
-typedef enum kprobe_insn (kprobe_decode_insn_t)(probes_opcode_t,
+typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_specific_insn *,
 						const union decode_action *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
-enum kprobe_insn thumb16_kprobe_decode_insn(probes_opcode_t,
+enum probes_insn thumb16_kprobe_decode_insn(probes_opcode_t,
 					    struct arch_specific_insn *,
 					    const union decode_action *);
-enum kprobe_insn thumb32_kprobe_decode_insn(probes_opcode_t,
+enum probes_insn thumb32_kprobe_decode_insn(probes_opcode_t,
 					    struct arch_specific_insn *,
 					    const union decode_action *);
 
 #else /* !CONFIG_THUMB2_KERNEL */
 
-enum kprobe_insn arm_kprobe_decode_insn(probes_opcode_t,
+enum probes_insn arm_kprobe_decode_insn(probes_opcode_t,
 					struct arch_specific_insn *,
 					const union decode_action *);
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index f0c3720..d377cc4 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -721,7 +721,7 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  *   if the work was put into it, but low return considering they
  *   should also be very rare.
  */
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		       const union decode_action *actions)
 {
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index f954e14..9b04aeb 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -860,7 +860,7 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   const union decode_action *actions)
 {
@@ -870,7 +870,7 @@ thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 				  actions);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 thumb32_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   const union decode_action *actions)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 8ab2ff5..f990b05 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -136,7 +136,7 @@ void __kprobes probes_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
 void __kprobes probes_emulate_none(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *h);
 
@@ -311,7 +311,7 @@ union decode_item {
 	int			action;
 };
 
-typedef enum kprobe_insn (probes_custom_decode_t)(probes_opcode_t,
+typedef enum probes_insn (probes_custom_decode_t)(probes_opcode_t,
 						  struct arch_specific_insn *,
 						  struct decode_header *);
 
@@ -389,6 +389,11 @@ struct decode_or {
 #define DECODE_OR(_mask, _value)				\
 	DECODE_HEADER(DECODE_TYPE_OR, _mask, _value, 0)
 
+enum probes_insn {
+	INSN_REJECTED,
+	INSN_GOOD,
+	INSN_GOOD_NO_SLOT
+};
 
 struct decode_reject {
 	struct decode_header	header;
-- 
1.8.1.2


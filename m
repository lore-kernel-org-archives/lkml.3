Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaCGUN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:13:26 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48754 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaCGULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:11:40 -0500
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
Subject: [PATCH v7 11/15] ARM: Rename the shared kprobes/uprobe return value enum
Date: Fri,  7 Mar 2014 15:10:36 -0500
Message-Id: <1394223040-17129-12-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Change the name of kprobes_insn to probes_insn so it can be shared between
kprobes and uprobes without confusion.

Signed-off-by: David A. Long <dave.long@linaro.org>
Acked-by: Jon Medhurst <tixy@linaro.org>
---
 arch/arm/kernel/kprobes-common.c |  2 +-
 arch/arm/kernel/kprobes-thumb.c  | 16 ++++++++--------
 arch/arm/kernel/kprobes.h        | 14 ++++----------
 arch/arm/kernel/probes-arm.c     |  2 +-
 arch/arm/kernel/probes-thumb.c   |  4 ++--
 arch/arm/kernel/probes.h         |  9 +++++++--
 6 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 08b5560..f151e15 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -123,7 +123,7 @@ emulate_ldm_r3_15(probes_opcode_t insn,
 	load_write_pc(regs->ARM_pc, regs);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *h)
 {
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 2a73330..c271d5d 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -66,7 +66,7 @@ t32_simulate_cond_branch(probes_opcode_t insn,
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
@@ -142,11 +142,11 @@ t32_simulate_ldr_literal(probes_opcode_t insn,
 	regs->uregs[rt] = rtv;
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
-	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
+	enum probes_insn ret = kprobe_decode_ldmstm(insn, asi, d);
 
 	/* Fixup modified instruction to have halfwords in correct order...*/
 	insn = asi->insn[0];
@@ -402,7 +402,7 @@ t16_singlestep_it(probes_opcode_t insn,
 	t16_simulate_it(insn, asi, regs);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_it(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
@@ -420,7 +420,7 @@ t16_simulate_cond_branch(probes_opcode_t insn,
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
@@ -510,7 +510,7 @@ t16_emulate_hiregs(probes_opcode_t insn,
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_hiregs(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
@@ -538,7 +538,7 @@ t16_emulate_push(probes_opcode_t insn,
 		);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_push(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
 {
@@ -591,7 +591,7 @@ t16_emulate_pop_pc(probes_opcode_t insn,
 	bx_write_pc(pc, regs);
 }
 
-static enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_pop(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *d)
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
index 3357a07..a9439e6 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -723,7 +723,7 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  *   if the work was put into it, but low return considering they
  *   should also be very rare.
  */
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		       const union decode_action *actions)
 {
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index a15a79b..d23ef00 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -861,7 +861,7 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   const union decode_action *actions)
 {
@@ -871,7 +871,7 @@ thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 				  actions);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 thumb32_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   const union decode_action *actions)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index dedff8a..870282a 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -138,7 +138,7 @@ void __kprobes probes_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
 void __kprobes probes_emulate_none(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *h);
 
@@ -313,7 +313,7 @@ union decode_item {
 	int			action;
 };
 
-typedef enum kprobe_insn (probes_custom_decode_t)(probes_opcode_t,
+typedef enum probes_insn (probes_custom_decode_t)(probes_opcode_t,
 						  struct arch_specific_insn *,
 						  const struct decode_header *);
 
@@ -391,6 +391,11 @@ struct decode_or {
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


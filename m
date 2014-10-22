Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaJVLea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:34:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25528 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbaJVLeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:09 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 1/7] ARM: kprobes: replace 'union decode_action' to 'struct decode_action'
Date: Wed, 22 Oct 2014 19:31:59 +0800
Message-ID: <1413977525-51480-2-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is generated simply using:

 $ sed -i "s/union decode_action/struct decode_action/g" `grep decode_action * -rl`

Which allows futher expansion to decode_action.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/kernel/kprobes-arm.c   | 2 +-
 arch/arm/kernel/kprobes-thumb.c | 4 ++--
 arch/arm/kernel/kprobes.c       | 2 +-
 arch/arm/kernel/kprobes.h       | 8 ++++----
 arch/arm/kernel/probes-arm.c    | 2 +-
 arch/arm/kernel/probes-arm.h    | 2 +-
 arch/arm/kernel/probes-thumb.c  | 4 ++--
 arch/arm/kernel/probes-thumb.h  | 4 ++--
 arch/arm/kernel/probes.c        | 2 +-
 arch/arm/kernel/probes.h        | 4 ++--
 arch/arm/kernel/uprobes-arm.c   | 2 +-
 arch/arm/kernel/uprobes.h       | 2 +-
 12 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index ac300c6..6df9f1f 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -301,7 +301,7 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t insn,
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
+const struct decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_EMULATE_NONE] = {.handler = probes_emulate_none},
 	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 9495d7f..0672457 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -611,7 +611,7 @@ t16_decode_pop(probes_opcode_t insn, struct arch_probes_insn *asi,
 	return INSN_GOOD;
 }
 
-const union decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
+const struct decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
 	[PROBES_T16_ADD_SP] = {.handler = t16_simulate_add_sp_imm},
 	[PROBES_T16_CBZ] = {.handler = t16_simulate_cbz},
 	[PROBES_T16_SIGN_EXTEND] = {.handler = t16_emulate_loregs_rwflags},
@@ -634,7 +634,7 @@ const union decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
 	[PROBES_T16_BRANCH] = {.handler = t16_simulate_branch},
 };
 
-const union decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
+const struct decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
 	[PROBES_T32_LDMSTM] = {.decoder = t32_decode_ldmstm},
 	[PROBES_T32_LDRDSTRD] = {.handler = t32_emulate_ldrdstrd},
 	[PROBES_T32_TABLE_BRANCH] = {.handler = t32_simulate_table_branch},
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 6d64420..028159c 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -59,7 +59,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	unsigned long addr = (unsigned long)p->addr;
 	bool thumb;
 	kprobe_decode_insn_t *decode_insn;
-	const union decode_action *actions;
+	const struct decode_action *actions;
 	int is;
 
 	if (in_exception_text(addr))
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 9a2712e..34db1eb 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -36,16 +36,16 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_probes_insn *asi,
 typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_probes_insn *,
 						bool,
-						const union decode_action *);
+						const struct decode_action *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
-extern const union decode_action kprobes_t32_actions[];
-extern const union decode_action kprobes_t16_actions[];
+extern const struct decode_action kprobes_t32_actions[];
+extern const struct decode_action kprobes_t16_actions[];
 
 #else /* !CONFIG_THUMB2_KERNEL */
 
-extern const union decode_action kprobes_arm_actions[];
+extern const struct decode_action kprobes_arm_actions[];
 
 #endif
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 8eaef81..3d00aa7 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -725,7 +725,7 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  */
 enum probes_insn __kprobes
 arm_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		       bool emulate, const union decode_action *actions)
+		       bool emulate, const struct decode_action *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = probes_condition_checks[insn>>28];
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index ace6572..6ecc25a 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -68,6 +68,6 @@ extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
 		struct arch_probes_insn *, bool emulate,
-		const union decode_action *actions);
+		const struct decode_action *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 4131351..72aa217 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -863,7 +863,7 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-			   bool emulate, const union decode_action *actions)
+			   bool emulate, const struct decode_action *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
@@ -873,7 +873,7 @@ thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-			   bool emulate, const union decode_action *actions)
+			   bool emulate, const struct decode_action *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 7c6f6eb..2658d95 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -89,9 +89,9 @@ extern const union decode_item probes_decode_thumb16_table[];
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		bool emulate, const union decode_action *actions);
+		bool emulate, const struct decode_action *actions);
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		bool emulate, const union decode_action *actions);
+		bool emulate, const struct decode_action *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index a8ab540..ec030b8 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -388,7 +388,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		   const union decode_item *table, bool thumb,
-		   bool emulate, const union decode_action *actions)
+		   bool emulate, const struct decode_action *actions)
 {
 	const struct decode_header *h = (struct decode_header *)table;
 	const struct decode_header *next;
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index dba9f24..739c2a2 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -309,7 +309,7 @@ typedef enum probes_insn (probes_custom_decode_t)(probes_opcode_t,
 						  struct arch_probes_insn *,
 						  const struct decode_header *);
 
-union decode_action {
+struct decode_action {
 	probes_insn_handler_t	*handler;
 	probes_custom_decode_t	*decoder;
 };
@@ -402,6 +402,6 @@ probes_insn_handler_t probes_emulate_none;
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		const union decode_item *table, bool thumb, bool emulate,
-		const union decode_action *actions);
+		const struct decode_action *actions);
 
 #endif
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
index d3b655f..0c0f299 100644
--- a/arch/arm/kernel/uprobes-arm.c
+++ b/arch/arm/kernel/uprobes-arm.c
@@ -194,7 +194,7 @@ uprobe_decode_ldmstm(probes_opcode_t insn,
 	return INSN_GOOD;
 }
 
-const union decode_action uprobes_probes_actions[] = {
+const struct decode_action uprobes_probes_actions[] = {
 	[PROBES_EMULATE_NONE] = {.handler = probes_simulate_nop},
 	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/kernel/uprobes.h
index 1d0c12d..57b4373 100644
--- a/arch/arm/kernel/uprobes.h
+++ b/arch/arm/kernel/uprobes.h
@@ -30,6 +30,6 @@ enum probes_insn
 decode_pc_ro(probes_opcode_t insn, struct arch_probes_insn *asi,
 	     const struct decode_header *d);
 
-extern const union decode_action uprobes_probes_actions[];
+extern const struct decode_action uprobes_probes_actions[];
 
 #endif
-- 
1.8.4


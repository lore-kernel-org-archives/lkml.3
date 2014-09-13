Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaIMSbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:31:45 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:48938 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaIMSbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:31:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:1:2:41:69:334:355:368:369:379:541:800:960:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2898:2901:2904:3138:3139:3140:3141:3142:3165:3865:3867:3868:3870:4052:4250:4321:4605:5007:6119:6261:7875:7904:10004:10026:10226:10848:11026:11473:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:12679:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: joke16_e9a4d0115c3c
X-Filterd-Recvd-Size: 10835
From: Joe Perches <joe@perches.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] arm: Convert pr_warning to pr_warn
Date: Sat, 13 Sep 2014 11:31:12 -0700
Message-Id: <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1410632834.git.joe@perches.com>
References: <cover.1410632834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common pr_warn.

Other miscellanea:

o Coalesce formats
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/include/asm/syscall.h   |  8 ++++----
 arch/arm/kernel/atags_parse.c    |  2 +-
 arch/arm/kernel/hw_breakpoint.c  | 18 +++++++++---------
 arch/arm/kernel/irq.c            |  4 ++--
 arch/arm/kernel/perf_event_cpu.c |  4 ++--
 arch/arm/kernel/smp.c            |  2 +-
 arch/arm/kernel/unwind.c         | 24 ++++++++++++------------
 arch/arm/mm/idmap.c              |  2 +-
 arch/arm/mm/mmu.c                |  4 ++--
 9 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
index 4651f69..e86c985 100644
--- a/arch/arm/include/asm/syscall.h
+++ b/arch/arm/include/asm/syscall.h
@@ -63,8 +63,8 @@ static inline void syscall_get_arguments(struct task_struct *task,
 	if (i + n > SYSCALL_MAX_ARGS) {
 		unsigned long *args_bad = args + SYSCALL_MAX_ARGS - i;
 		unsigned int n_bad = n + i - SYSCALL_MAX_ARGS;
-		pr_warning("%s called with max args %d, handling only %d\n",
-			   __func__, i + n, SYSCALL_MAX_ARGS);
+		pr_warn("%s called with max args %d, handling only %d\n",
+			__func__, i + n, SYSCALL_MAX_ARGS);
 		memset(args_bad, 0, n_bad * sizeof(args[0]));
 		n = SYSCALL_MAX_ARGS - i;
 	}
@@ -88,8 +88,8 @@ static inline void syscall_set_arguments(struct task_struct *task,
 		return;
 
 	if (i + n > SYSCALL_MAX_ARGS) {
-		pr_warning("%s called with max args %d, handling only %d\n",
-			   __func__, i + n, SYSCALL_MAX_ARGS);
+		pr_warn("%s called with max args %d, handling only %d\n",
+			__func__, i + n, SYSCALL_MAX_ARGS);
 		n = SYSCALL_MAX_ARGS - i;
 	}
 
diff --git a/arch/arm/kernel/atags_parse.c b/arch/arm/kernel/atags_parse.c
index 7807ef5..528f8af2 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -130,7 +130,7 @@ static int __init parse_tag_cmdline(const struct tag *tag)
 	strlcat(default_command_line, tag->u.cmdline.cmdline,
 		COMMAND_LINE_SIZE);
 #elif defined(CONFIG_CMDLINE_FORCE)
-	pr_warning("Ignoring tag cmdline (using the default kernel command line)\n");
+	pr_warn("Ignoring tag cmdline (using the default kernel command line)\n");
 #else
 	strlcpy(default_command_line, tag->u.cmdline.cmdline,
 		COMMAND_LINE_SIZE);
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 4d963fb..b5b452f 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -113,8 +113,8 @@ static u32 read_wb_reg(int n)
 	GEN_READ_WB_REG_CASES(ARM_OP2_WVR, val);
 	GEN_READ_WB_REG_CASES(ARM_OP2_WCR, val);
 	default:
-		pr_warning("attempt to read from unknown breakpoint "
-				"register %d\n", n);
+		pr_warn("attempt to read from unknown breakpoint register %d\n",
+			n);
 	}
 
 	return val;
@@ -128,8 +128,8 @@ static void write_wb_reg(int n, u32 val)
 	GEN_WRITE_WB_REG_CASES(ARM_OP2_WVR, val);
 	GEN_WRITE_WB_REG_CASES(ARM_OP2_WCR, val);
 	default:
-		pr_warning("attempt to write to unknown breakpoint "
-				"register %d\n", n);
+		pr_warn("attempt to write to unknown breakpoint register %d\n",
+			n);
 	}
 	isb();
 }
@@ -292,7 +292,7 @@ int hw_breakpoint_slots(int type)
 	case TYPE_DATA:
 		return get_num_wrps();
 	default:
-		pr_warning("unknown slot type: %d\n", type);
+		pr_warn("unknown slot type: %d\n", type);
 		return 0;
 	}
 }
@@ -365,7 +365,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	}
 
 	if (i == max_slots) {
-		pr_warning("Can't find any breakpoint slot\n");
+		pr_warn("Can't find any breakpoint slot\n");
 		return -EBUSY;
 	}
 
@@ -417,7 +417,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 	}
 
 	if (i == max_slots) {
-		pr_warning("Can't find any breakpoint slot\n");
+		pr_warn("Can't find any breakpoint slot\n");
 		return;
 	}
 
@@ -894,8 +894,8 @@ static int debug_reg_trap(struct pt_regs *regs, unsigned int instr)
 {
 	int cpu = smp_processor_id();
 
-	pr_warning("Debug register access (0x%x) caused undefined instruction on CPU %d\n",
-		   instr, cpu);
+	pr_warn("Debug register access (0x%x) caused undefined instruction on CPU %d\n",
+		instr, cpu);
 
 	/* Set the error flag for this CPU and skip the faulting instruction. */
 	cpumask_set_cpu(cpu, &debug_err_mask);
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 0ef45ba..7c81ec4 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -188,8 +188,8 @@ void migrate_irqs(void)
 		raw_spin_unlock(&desc->lock);
 
 		if (affinity_broken && printk_ratelimit())
-			pr_warning("IRQ%u no longer affine to CPU%u\n", i,
-				smp_processor_id());
+			pr_warn("IRQ%u no longer affine to CPU%u\n",
+				i, smp_processor_id());
 	}
 
 	local_irq_restore(flags);
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index e6a6edb..101dbab 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -152,8 +152,8 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 			 * continue. Otherwise, continue without this interrupt.
 			 */
 			if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
-				pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
-					    irq, i);
+				pr_warn("unable to set irq affinity (irq=%d, cpu=%u)\n",
+					irq, i);
 				continue;
 			}
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index d19aea4..39c74a2 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -646,7 +646,7 @@ void smp_send_stop(void)
 		udelay(1);
 
 	if (num_online_cpus() > 1)
-		pr_warning("SMP: failed to stop secondary CPUs\n");
+		pr_warn("SMP: failed to stop secondary CPUs\n");
 }
 
 /*
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index caea23b..0bee233 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -157,7 +157,7 @@ static const struct unwind_idx *search_index(unsigned long addr,
 	if (likely(start->addr_offset <= addr_prel31))
 		return start;
 	else {
-		pr_warning("unwind: Unknown symbol address %08lx\n", addr);
+		pr_warn("unwind: Unknown symbol address %08lx\n", addr);
 		return NULL;
 	}
 }
@@ -225,7 +225,7 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	unsigned long ret;
 
 	if (ctrl->entries <= 0) {
-		pr_warning("unwind: Corrupt unwind table\n");
+		pr_warn("unwind: Corrupt unwind table\n");
 		return 0;
 	}
 
@@ -333,8 +333,8 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		insn = (insn << 8) | unwind_get_byte(ctrl);
 		mask = insn & 0x0fff;
 		if (mask == 0) {
-			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
-				   insn);
+			pr_warn("unwind: 'Refuse to unwind' instruction %04lx\n",
+				insn);
 			return -URC_FAILURE;
 		}
 
@@ -357,8 +357,8 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		unsigned long mask = unwind_get_byte(ctrl);
 
 		if (mask == 0 || mask & 0xf0) {
-			pr_warning("unwind: Spare encoding %04lx\n",
-			       (insn << 8) | mask);
+			pr_warn("unwind: Spare encoding %04lx\n",
+				(insn << 8) | mask);
 			return -URC_FAILURE;
 		}
 
@@ -370,7 +370,7 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 
 		ctrl->vrs[SP] += 0x204 + (uleb128 << 2);
 	} else {
-		pr_warning("unwind: Unhandled instruction %02lx\n", insn);
+		pr_warn("unwind: Unhandled instruction %02lx\n", insn);
 		return -URC_FAILURE;
 	}
 
@@ -403,7 +403,7 @@ int unwind_frame(struct stackframe *frame)
 
 	idx = unwind_find_idx(frame->pc);
 	if (!idx) {
-		pr_warning("unwind: Index not found %08lx\n", frame->pc);
+		pr_warn("unwind: Index not found %08lx\n", frame->pc);
 		return -URC_FAILURE;
 	}
 
@@ -422,8 +422,8 @@ int unwind_frame(struct stackframe *frame)
 		/* only personality routine 0 supported in the index */
 		ctrl.insn = &idx->insn;
 	else {
-		pr_warning("unwind: Unsupported personality routine %08lx in the index at %p\n",
-			   idx->insn, idx);
+		pr_warn("unwind: Unsupported personality routine %08lx in the index at %p\n",
+			idx->insn, idx);
 		return -URC_FAILURE;
 	}
 
@@ -435,8 +435,8 @@ int unwind_frame(struct stackframe *frame)
 		ctrl.byte = 1;
 		ctrl.entries = 1 + ((*ctrl.insn & 0x00ff0000) >> 16);
 	} else {
-		pr_warning("unwind: Unsupported personality routine %08lx at %p\n",
-			   *ctrl.insn, ctrl.insn);
+		pr_warn("unwind: Unsupported personality routine %08lx at %p\n",
+			*ctrl.insn, ctrl.insn);
 		return -URC_FAILURE;
 	}
 
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index c447ec7..e7a81ceb 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -27,7 +27,7 @@ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	if (pud_none_or_clear_bad(pud) || (pud_val(*pud) & L_PGD_SWAPPER)) {
 		pmd = pmd_alloc_one(&init_mm, addr);
 		if (!pmd) {
-			pr_warning("Failed to allocate identity pmd.\n");
+			pr_warn("Failed to allocate identity pmd.\n");
 			return;
 		}
 		/*
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 8348ed6..9f98cec 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -223,13 +223,13 @@ early_param("ecc", early_ecc);
 
 static int __init early_cachepolicy(char *p)
 {
-	pr_warning("cachepolicy kernel parameter not supported without cp15\n");
+	pr_warn("cachepolicy kernel parameter not supported without cp15\n");
 }
 early_param("cachepolicy", early_cachepolicy);
 
 static int __init noalign_setup(char *__unused)
 {
-	pr_warning("noalign kernel parameter not supported without cp15\n");
+	pr_warn("noalign kernel parameter not supported without cp15\n");
 }
 __setup("noalign", noalign_setup);
 
-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaDBAF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:05:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:64711 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaDBAFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,776,1389772800"; 
   d="scan'208";a="485176062"
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] asmlinkage, x86: Remove leftover extern __visible
Date: Wed,  2 Apr 2014 02:03:07 +0200
Message-Id: <1396396987-15621-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove the left over extern __visible Linus objected too.
They should be useless, as we only need the visible
on the actual definitions.

Mostly for x86, but one in export.h too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/checksum_64.h |  2 +-
 arch/x86/include/asm/hw_irq.h      | 16 ++++++++--------
 arch/x86/include/asm/irq.h         |  2 +-
 arch/x86/include/asm/kprobes.h     |  8 ++++----
 arch/x86/kernel/cpu/amd.c          |  2 +-
 arch/x86/power/hibernate_64.c      |  4 ++--
 arch/x86/xen/xen-ops.h             |  4 ++--
 include/linux/export.h             |  2 +-
 8 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/checksum_64.h b/arch/x86/include/asm/checksum_64.h
index e6fd8a0..9bfdc41 100644
--- a/arch/x86/include/asm/checksum_64.h
+++ b/arch/x86/include/asm/checksum_64.h
@@ -133,7 +133,7 @@ extern __wsum csum_partial(const void *buff, int len, __wsum sum);
 
 
 /* Do not call this directly. Use the wrappers below */
-extern __visible __wsum csum_partial_copy_generic(const void *src, const void *dst,
+extern __wsum csum_partial_copy_generic(const void *src, const void *dst,
 					int len, __wsum sum,
 					int *src_err_ptr, int *dst_err_ptr);
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 67d69b8..9eb067c 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -172,18 +172,18 @@ extern atomic_t irq_mis_count;
 extern void eisa_set_level_irq(unsigned int irq);
 
 /* SMP */
-extern __visible void smp_apic_timer_interrupt(struct pt_regs *);
-extern __visible void smp_spurious_interrupt(struct pt_regs *);
-extern __visible void smp_x86_platform_ipi(struct pt_regs *);
-extern __visible void smp_error_interrupt(struct pt_regs *);
+extern void smp_apic_timer_interrupt(struct pt_regs *);
+extern void smp_spurious_interrupt(struct pt_regs *);
+extern void smp_x86_platform_ipi(struct pt_regs *);
+extern void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
 extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
-extern __visible void smp_reschedule_interrupt(struct pt_regs *);
-extern __visible void smp_call_function_interrupt(struct pt_regs *);
-extern __visible void smp_call_function_single_interrupt(struct pt_regs *);
-extern __visible void smp_invalidate_interrupt(struct pt_regs *);
+extern void smp_reschedule_interrupt(struct pt_regs *);
+extern void smp_call_function_interrupt(struct pt_regs *);
+extern void smp_call_function_single_interrupt(struct pt_regs *);
+extern void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index cb6cfcd..201650d 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -34,7 +34,7 @@ extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
-extern __visible unsigned int do_IRQ(struct pt_regs *regs);
+extern unsigned int do_IRQ(struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 9454c16..8cdd2d8 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -49,10 +49,10 @@ typedef u8 kprobe_opcode_t;
 #define flush_insn_slot(p)	do { } while (0)
 
 /* optinsn template addresses */
-extern __visible kprobe_opcode_t optprobe_template_entry;
-extern __visible kprobe_opcode_t optprobe_template_val;
-extern __visible kprobe_opcode_t optprobe_template_call;
-extern __visible kprobe_opcode_t optprobe_template_end;
+extern kprobe_opcode_t optprobe_template_entry;
+extern kprobe_opcode_t optprobe_template_val;
+extern kprobe_opcode_t optprobe_template_call;
+extern kprobe_opcode_t optprobe_template_end;
 #define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..df131bf 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -65,7 +65,7 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
  *	performance at the same time..
  */
 
-extern __visible void vide(void);
+extern void vide(void);
 __asm__(".globl vide\n\t.align 4\nvide: ret");
 
 static void init_amd_k5(struct cpuinfo_x86 *c)
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 35e2bb6..d698d34 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -20,10 +20,10 @@
 #include <asm/suspend.h>
 
 /* References to section boundaries */
-extern __visible const void __nosave_begin, __nosave_end;
+extern const void __nosave_begin, __nosave_end;
 
 /* Defined in hibernate_asm_64.S */
-extern asmlinkage __visible int restore_image(void);
+extern asmlinkage int restore_image(void);
 
 /*
  * Address to jump to in the last phase of restore in order to get to the image
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 1cb6f4c..8f791de 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -106,8 +106,8 @@ static inline void __init xen_init_apic(void)
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
 	__visible ret name(__VA_ARGS__);	\
-	extern char name##_end[] __visible;	\
-	extern char name##_reloc[] __visible
+	extern char name##_end[];	\
+	extern char name##_reloc[]
 
 DECL_ASM(void, xen_irq_enable_direct, void);
 DECL_ASM(void, xen_irq_disable_direct, void);
diff --git a/include/linux/export.h b/include/linux/export.h
index 96e45ea..256fe5e 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -43,7 +43,7 @@ extern struct module __this_module;
 /* Mark the CRC weak since genksyms apparently decides not to
  * generate a checksums for some symbols */
 #define __CRC_SYMBOL(sym, sec)					\
-	extern __visible void *__crc_##sym __attribute__((weak));		\
+	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
 	__attribute__((section("___kcrctab" sec "+" #sym), unused))	\
-- 
1.8.5.2


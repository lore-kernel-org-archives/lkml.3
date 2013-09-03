Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3ICOj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:39:29 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:37820 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3ICOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:39:25 -0400
Date: Tue, 3 Sep 2013 16:39:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asmlinkage changes for v3.12
Message-ID: <20130903143921.GA28290@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asmlinkage-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asmlinkage-for-linus

   HEAD: eb86b5fd505cb97743d84226140cf247d91a2f03 x86/asmlinkage: Fix warning in xen asmlinkage change

As a preparation for Andi Kleen's LTO patchset (link time optimizations 
using GCC's -flto which build time optimization has steadily increased in 
quality over the past few years and might eventually be usable for the 
kernel too) this tree includes a handful of preparatory patches that make 
function calling convention annotations consistent again:

  - Mark every function without arguments (or 64bit only) that is used by
    assembly code with asmlinkage()

  - Mark every function with parameters or variables that is used by
    assembly code as __visible.

For the vanilla kernel this has documentation, consistency and 
debuggability advantages, for the time being.

out-of-topic modifications in x86-asmlinkage-for-linus:
-------------------------------------------------------
include/linux/printk.h             # b6c035d: x86, asmlinkage: Make dump_stack 
kernel/power/hibernate.c           # d6efc2f: x86, asmlinkage, power: Make vari
lib/dump_stack.c                   # b6c035d: x86, asmlinkage: Make dump_stack 

 Thanks,

	Ingo

------------------>
Andi Kleen (16):
      x86: Fix sys_call_table type in asm/syscall.h
      x86, asmlinkage: Change dotraplinkage into __visible on 32bit
      x86, asmlinkage: Make all interrupt handlers asmlinkage / __visible
      x86, asmlinkage: Make _*_start_kernel visible
      x86, asmlinkage: Make 32bit/64bit __switch_to visible
      x86, asmlinkage: Make various syscalls asmlinkage
      x86, asmlinkage: Make kprobes code visible and fix assembler code
      x86, asmlinkage: Make several variables used from assembler/linker script visible
      x86, asmlinkage: Make syscall tables visible
      x86, asmlinkage, apm: Make APM data structure used from assembler visible
      x86, asmlinkage, paravirt: Add __visible/asmlinkage to xen paravirt ops
      x86, asmlinkage: Make 64bit checksum functions visible
      x86, asmlinkage: Make dump_stack visible
      x86, asmlinkage, power: Make various symbols used by the suspend asm code visible
      x86, asmlinkage, vdso: Mark vdso variables __visible
      x86/asmlinkage: Fix warning in xen asmlinkage change


 arch/x86/include/asm/checksum_64.h    |   2 +-
 arch/x86/include/asm/hw_irq.h         | 120 ++++++++++++++++------------------
 arch/x86/include/asm/irq.h            |   2 +-
 arch/x86/include/asm/kprobes.h        |  10 +--
 arch/x86/include/asm/paravirt_types.h |   3 +-
 arch/x86/include/asm/pgtable.h        |   3 +-
 arch/x86/include/asm/processor.h      |   2 +-
 arch/x86/include/asm/setup.h          |   8 ++-
 arch/x86/include/asm/special_insns.h  |   2 +-
 arch/x86/include/asm/switch_to.h      |   4 +-
 arch/x86/include/asm/syscall.h        |   3 +-
 arch/x86/include/asm/syscalls.h       |   6 +-
 arch/x86/include/asm/traps.h          |   6 +-
 arch/x86/include/asm/vvar.h           |   2 +-
 arch/x86/kernel/apic/apic.c           |  12 ++--
 arch/x86/kernel/apm_32.c              |   2 +-
 arch/x86/kernel/cpu/amd.c             |   4 +-
 arch/x86/kernel/cpu/common.c          |   4 +-
 arch/x86/kernel/head32.c              |   2 +-
 arch/x86/kernel/head64.c              |   2 +-
 arch/x86/kernel/irq.c                 |   8 +--
 arch/x86/kernel/irq_work.c            |   4 +-
 arch/x86/kernel/kprobes/core.c        |   2 +-
 arch/x86/kernel/kprobes/opt.c         |   5 +-
 arch/x86/kernel/paravirt.c            |   4 +-
 arch/x86/kernel/process.c             |   2 +-
 arch/x86/kernel/process_32.c          |   2 +-
 arch/x86/kernel/process_64.c          |   4 +-
 arch/x86/kernel/setup.c               |   4 +-
 arch/x86/kernel/signal.c              |   6 +-
 arch/x86/kernel/smp.c                 |  12 ++--
 arch/x86/kernel/syscall_32.c          |   2 +-
 arch/x86/kernel/syscall_64.c          |   5 +-
 arch/x86/lib/usercopy_64.c            |   2 +-
 arch/x86/power/cpu.c                  |   8 +--
 arch/x86/power/hibernate_64.c         |  12 ++--
 arch/x86/xen/xen-ops.h                |  16 ++---
 include/linux/printk.h                |   2 +-
 kernel/power/hibernate.c              |   2 +-
 lib/dump_stack.c                      |   4 +-
 40 files changed, 149 insertions(+), 156 deletions(-)

diff --git a/arch/x86/include/asm/checksum_64.h b/arch/x86/include/asm/checksum_64.h
index 9bfdc41..e6fd8a0 100644
--- a/arch/x86/include/asm/checksum_64.h
+++ b/arch/x86/include/asm/checksum_64.h
@@ -133,7 +133,7 @@ extern __wsum csum_partial(const void *buff, int len, __wsum sum);
 
 
 /* Do not call this directly. Use the wrappers below */
-extern __wsum csum_partial_copy_generic(const void *src, const void *dst,
+extern __visible __wsum csum_partial_copy_generic(const void *src, const void *dst,
 					int len, __wsum sum,
 					int *src_err_ptr, int *dst_err_ptr);
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index e4ac559..92b3bae 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -26,56 +26,56 @@
 #include <asm/sections.h>
 
 /* Interrupt handlers registered during init_IRQ */
-extern void apic_timer_interrupt(void);
-extern void x86_platform_ipi(void);
-extern void kvm_posted_intr_ipi(void);
-extern void error_interrupt(void);
-extern void irq_work_interrupt(void);
-
-extern void spurious_interrupt(void);
-extern void thermal_interrupt(void);
-extern void reschedule_interrupt(void);
-
-extern void invalidate_interrupt(void);
-extern void invalidate_interrupt0(void);
-extern void invalidate_interrupt1(void);
-extern void invalidate_interrupt2(void);
-extern void invalidate_interrupt3(void);
-extern void invalidate_interrupt4(void);
-extern void invalidate_interrupt5(void);
-extern void invalidate_interrupt6(void);
-extern void invalidate_interrupt7(void);
-extern void invalidate_interrupt8(void);
-extern void invalidate_interrupt9(void);
-extern void invalidate_interrupt10(void);
-extern void invalidate_interrupt11(void);
-extern void invalidate_interrupt12(void);
-extern void invalidate_interrupt13(void);
-extern void invalidate_interrupt14(void);
-extern void invalidate_interrupt15(void);
-extern void invalidate_interrupt16(void);
-extern void invalidate_interrupt17(void);
-extern void invalidate_interrupt18(void);
-extern void invalidate_interrupt19(void);
-extern void invalidate_interrupt20(void);
-extern void invalidate_interrupt21(void);
-extern void invalidate_interrupt22(void);
-extern void invalidate_interrupt23(void);
-extern void invalidate_interrupt24(void);
-extern void invalidate_interrupt25(void);
-extern void invalidate_interrupt26(void);
-extern void invalidate_interrupt27(void);
-extern void invalidate_interrupt28(void);
-extern void invalidate_interrupt29(void);
-extern void invalidate_interrupt30(void);
-extern void invalidate_interrupt31(void);
-
-extern void irq_move_cleanup_interrupt(void);
-extern void reboot_interrupt(void);
-extern void threshold_interrupt(void);
-
-extern void call_function_interrupt(void);
-extern void call_function_single_interrupt(void);
+extern asmlinkage void apic_timer_interrupt(void);
+extern asmlinkage void x86_platform_ipi(void);
+extern asmlinkage void kvm_posted_intr_ipi(void);
+extern asmlinkage void error_interrupt(void);
+extern asmlinkage void irq_work_interrupt(void);
+
+extern asmlinkage void spurious_interrupt(void);
+extern asmlinkage void thermal_interrupt(void);
+extern asmlinkage void reschedule_interrupt(void);
+
+extern asmlinkage void invalidate_interrupt(void);
+extern asmlinkage void invalidate_interrupt0(void);
+extern asmlinkage void invalidate_interrupt1(void);
+extern asmlinkage void invalidate_interrupt2(void);
+extern asmlinkage void invalidate_interrupt3(void);
+extern asmlinkage void invalidate_interrupt4(void);
+extern asmlinkage void invalidate_interrupt5(void);
+extern asmlinkage void invalidate_interrupt6(void);
+extern asmlinkage void invalidate_interrupt7(void);
+extern asmlinkage void invalidate_interrupt8(void);
+extern asmlinkage void invalidate_interrupt9(void);
+extern asmlinkage void invalidate_interrupt10(void);
+extern asmlinkage void invalidate_interrupt11(void);
+extern asmlinkage void invalidate_interrupt12(void);
+extern asmlinkage void invalidate_interrupt13(void);
+extern asmlinkage void invalidate_interrupt14(void);
+extern asmlinkage void invalidate_interrupt15(void);
+extern asmlinkage void invalidate_interrupt16(void);
+extern asmlinkage void invalidate_interrupt17(void);
+extern asmlinkage void invalidate_interrupt18(void);
+extern asmlinkage void invalidate_interrupt19(void);
+extern asmlinkage void invalidate_interrupt20(void);
+extern asmlinkage void invalidate_interrupt21(void);
+extern asmlinkage void invalidate_interrupt22(void);
+extern asmlinkage void invalidate_interrupt23(void);
+extern asmlinkage void invalidate_interrupt24(void);
+extern asmlinkage void invalidate_interrupt25(void);
+extern asmlinkage void invalidate_interrupt26(void);
+extern asmlinkage void invalidate_interrupt27(void);
+extern asmlinkage void invalidate_interrupt28(void);
+extern asmlinkage void invalidate_interrupt29(void);
+extern asmlinkage void invalidate_interrupt30(void);
+extern asmlinkage void invalidate_interrupt31(void);
+
+extern asmlinkage void irq_move_cleanup_interrupt(void);
+extern asmlinkage void reboot_interrupt(void);
+extern asmlinkage void threshold_interrupt(void);
+
+extern asmlinkage void call_function_interrupt(void);
+extern asmlinkage void call_function_single_interrupt(void);
 
 #ifdef CONFIG_TRACING
 /* Interrupt handlers registered during init_IRQ */
@@ -172,22 +172,18 @@ extern atomic_t irq_mis_count;
 extern void eisa_set_level_irq(unsigned int irq);
 
 /* SMP */
-extern void smp_apic_timer_interrupt(struct pt_regs *);
-extern void smp_spurious_interrupt(struct pt_regs *);
-extern void smp_x86_platform_ipi(struct pt_regs *);
-extern void smp_error_interrupt(struct pt_regs *);
+extern __visible void smp_apic_timer_interrupt(struct pt_regs *);
+extern __visible void smp_spurious_interrupt(struct pt_regs *);
+extern __visible void smp_x86_platform_ipi(struct pt_regs *);
+extern __visible void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
 extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
-extern void smp_reschedule_interrupt(struct pt_regs *);
-extern void smp_call_function_interrupt(struct pt_regs *);
-extern void smp_call_function_single_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_32
-extern void smp_invalidate_interrupt(struct pt_regs *);
-#else
-extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
-#endif
+extern __visible void smp_reschedule_interrupt(struct pt_regs *);
+extern __visible void smp_call_function_interrupt(struct pt_regs *);
+extern __visible void smp_call_function_single_interrupt(struct pt_regs *);
+extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 57873be..0ea10f27 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -33,7 +33,7 @@ extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
 
-extern unsigned int do_IRQ(struct pt_regs *regs);
+extern __visible unsigned int do_IRQ(struct pt_regs *regs);
 
 /* Interrupt vector management */
 extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5a6d287..9454c16 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -49,10 +49,10 @@ typedef u8 kprobe_opcode_t;
 #define flush_insn_slot(p)	do { } while (0)
 
 /* optinsn template addresses */
-extern kprobe_opcode_t optprobe_template_entry;
-extern kprobe_opcode_t optprobe_template_val;
-extern kprobe_opcode_t optprobe_template_call;
-extern kprobe_opcode_t optprobe_template_end;
+extern __visible kprobe_opcode_t optprobe_template_entry;
+extern __visible kprobe_opcode_t optprobe_template_val;
+extern __visible kprobe_opcode_t optprobe_template_call;
+extern __visible kprobe_opcode_t optprobe_template_end;
 #define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
@@ -62,7 +62,7 @@ extern kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-void kretprobe_trampoline(void);
+asmlinkage void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0db1fca..0617ff2 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -387,7 +387,8 @@ extern struct pv_lock_ops pv_lock_ops;
 
 /* Simple instruction patching code. */
 #define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	extern const char start_##ops##_##name[] __visible,		\
+			  end_##ops##_##name[] __visible;		\
 	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
 
 unsigned paravirt_patch_nop(void);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 7dc305a..4e47659 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -22,7 +22,8 @@
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
+extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)]
+	__visible;
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
 extern spinlock_t pgd_lock;
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 24cf5ae..573c1ad 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -412,7 +412,7 @@ union irq_stack_union {
 	};
 };
 
-DECLARE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union);
+DECLARE_PER_CPU_FIRST(union irq_stack_union, irq_stack_union) __visible;
 DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..3475554 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -6,6 +6,8 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#include <linux/linkage.h>
+
 #ifdef __i386__
 
 #include <linux/pfn.h>
@@ -108,11 +110,11 @@ void *extend_brk(size_t size, size_t align);
 extern void probe_roms(void);
 #ifdef __i386__
 
-void __init i386_start_kernel(void);
+asmlinkage void __init i386_start_kernel(void);
 
 #else
-void __init x86_64_start_kernel(char *real_mode);
-void __init x86_64_start_reservations(char *real_mode_data);
+asmlinkage void __init x86_64_start_kernel(char *real_mode);
+asmlinkage void __init x86_64_start_reservations(char *real_mode_data);
 
 #endif /* __i386__ */
 #endif /* _SETUP */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 2f4d924..645cad2 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -101,7 +101,7 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
-extern void native_load_gs_index(unsigned);
+extern asmlinkage void native_load_gs_index(unsigned);
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/arch/x86/include/asm/switch_to.h b/arch/x86/include/asm/switch_to.h
index 4ec45b3..d7f3b3b 100644
--- a/arch/x86/include/asm/switch_to.h
+++ b/arch/x86/include/asm/switch_to.h
@@ -2,8 +2,8 @@
 #define _ASM_X86_SWITCH_TO_H
 
 struct task_struct; /* one of the stranger aspects of C forward declarations */
-struct task_struct *__switch_to(struct task_struct *prev,
-				struct task_struct *next);
+__visible struct task_struct *__switch_to(struct task_struct *prev,
+					   struct task_struct *next);
 struct tss_struct;
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss);
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 2e188d6..aea284b 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -20,7 +20,8 @@
 #include <asm/thread_info.h>	/* for TS_COMPAT */
 #include <asm/unistd.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 2917a64..592a6a6 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -24,7 +24,7 @@ asmlinkage long sys_iopl(unsigned int);
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
 /* kernel/signal.c */
-long sys_rt_sigreturn(void);
+asmlinkage long sys_rt_sigreturn(void);
 
 /* kernel/tls.c */
 asmlinkage long sys_set_thread_area(struct user_desc __user *);
@@ -34,7 +34,7 @@ asmlinkage long sys_get_thread_area(struct user_desc __user *);
 #ifdef CONFIG_X86_32
 
 /* kernel/signal.c */
-unsigned long sys_sigreturn(void);
+asmlinkage unsigned long sys_sigreturn(void);
 
 /* kernel/vm86_32.c */
 asmlinkage long sys_vm86old(struct vm86_struct __user *);
@@ -44,7 +44,7 @@ asmlinkage long sys_vm86(unsigned long, unsigned long);
 
 /* X86_64 only */
 /* kernel/process_64.c */
-long sys_arch_prctl(int, unsigned long);
+asmlinkage long sys_arch_prctl(int, unsigned long);
 
 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..7036cb6 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -6,11 +6,7 @@
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
-#ifdef CONFIG_X86_32
-#define dotraplinkage
-#else
-#define dotraplinkage asmlinkage
-#endif
+#define dotraplinkage __visible
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index de656ac..d76ac40 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -35,7 +35,7 @@
 
 #define DEFINE_VVAR(type, name)						\
 	type name							\
-	__attribute__((section(".vvar_" #name), aligned(16)))
+	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
 #define VVAR(name) (*vvaraddr_ ## name)
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index eca89c5..a7eb82d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -913,7 +913,7 @@ static void local_apic_timer_interrupt(void)
  * [ if a single-CPU system runs an SMP kernel then we call the local
  *   interrupt as well. Thus we cannot inline the local irq ... ]
  */
-void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
+__visible void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -932,7 +932,7 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
-void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
+__visible void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -1946,14 +1946,14 @@ static inline void __smp_spurious_interrupt(void)
 		"should never happen.\n", smp_processor_id());
 }
 
-void smp_spurious_interrupt(struct pt_regs *regs)
+__visible void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	__smp_spurious_interrupt();
 	exiting_irq();
 }
 
-void smp_trace_spurious_interrupt(struct pt_regs *regs)
+__visible void smp_trace_spurious_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
@@ -2002,14 +2002,14 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
 
 }
 
-void smp_error_interrupt(struct pt_regs *regs)
+__visible void smp_error_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	__smp_error_interrupt(regs);
 	exiting_irq();
 }
 
-void smp_trace_error_interrupt(struct pt_regs *regs)
+__visible void smp_trace_error_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	trace_error_apic_entry(ERROR_APIC_VECTOR);
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 53a4e27..3ab0343 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -392,7 +392,7 @@ static struct cpuidle_device apm_cpuidle_device;
 /*
  * Local variables
  */
-static struct {
+__visible struct {
 	unsigned long	offset;
 	unsigned short	segment;
 } apm_bios_entry;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f654ece..466e3d1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -66,8 +66,8 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
  *	performance at the same time..
  */
 
-extern void vide(void);
-__asm__(".align 4\nvide: ret");
+extern __visible void vide(void);
+__asm__(".globl vide\n\t.align 4\nvide: ret");
 
 static void init_amd_k5(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25eb274..2793d1f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1076,7 +1076,7 @@ struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
 				    (unsigned long) debug_idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
-		     irq_stack_union) __aligned(PAGE_SIZE);
+		     irq_stack_union) __aligned(PAGE_SIZE) __visible;
 
 /*
  * The following four percpu variables are hot.  Align current_task to
@@ -1093,7 +1093,7 @@ EXPORT_PER_CPU_SYMBOL(kernel_stack);
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
-DEFINE_PER_CPU(unsigned int, irq_count) = -1;
+DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 138463a..06f87be 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,7 +29,7 @@ static void __init i386_default_early_setup(void)
 	reserve_ebda_region();
 }
 
-void __init i386_start_kernel(void)
+asmlinkage void __init i386_start_kernel(void)
 {
 	sanitize_boot_params(&boot_params);
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 55b6761..1be8e43 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -137,7 +137,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3a8185c..22d0687 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -177,7 +177,7 @@ u64 arch_irq_stat(void)
  * SMP cross-CPU interrupts have their own specific
  * handlers).
  */
-unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
+__visible unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -215,7 +215,7 @@ void __smp_x86_platform_ipi(void)
 		x86_platform_ipi_callback();
 }
 
-void smp_x86_platform_ipi(struct pt_regs *regs)
+__visible void smp_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -229,7 +229,7 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
  */
-void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
+__visible void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
@@ -247,7 +247,7 @@ void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
 }
 #endif
 
-void smp_trace_x86_platform_ipi(struct pt_regs *regs)
+__visible void smp_trace_x86_platform_ipi(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 636a55e..1de84e3 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -22,14 +22,14 @@ static inline void __smp_irq_work_interrupt(void)
 	irq_work_run();
 }
 
-void smp_irq_work_interrupt(struct pt_regs *regs)
+__visible void smp_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_work_entering_irq();
 	__smp_irq_work_interrupt();
 	exiting_irq();
 }
 
-void smp_trace_irq_work_interrupt(struct pt_regs *regs)
+__visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 {
 	irq_work_entering_irq();
 	trace_irq_work_entry(IRQ_WORK_VECTOR);
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 211bce4..048852d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -661,7 +661,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 76dc6f0..2c1ac28 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -88,9 +88,7 @@ static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long v
 	*(unsigned long *)addr = val;
 }
 
-static void __used __kprobes kprobes_optinsn_template_holder(void)
-{
-	asm volatile (
+asm (
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -129,7 +127,6 @@ static void __used __kprobes kprobes_optinsn_template_holder(void)
 #endif
 			".global optprobe_template_end\n"
 			"optprobe_template_end:\n");
-}
 
 #define TMPL_MOVE_IDX \
 	((long)&optprobe_template_val - (long)&optprobe_template_entry)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index cd6de64..884aa40 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -324,7 +324,7 @@ struct pv_time_ops pv_time_ops = {
 	.steal_clock = native_steal_clock,
 };
 
-struct pv_irq_ops pv_irq_ops = {
+__visible struct pv_irq_ops pv_irq_ops = {
 	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
 	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
 	.irq_disable = __PV_IS_CALLEE_SAVE(native_irq_disable),
@@ -336,7 +336,7 @@ struct pv_irq_ops pv_irq_ops = {
 #endif
 };
 
-struct pv_cpu_ops pv_cpu_ops = {
+__visible struct pv_cpu_ops pv_cpu_ops = {
 	.cpuid = native_cpuid,
 	.get_debugreg = native_get_debugreg,
 	.set_debugreg = native_set_debugreg,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83369e5..c83516b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -36,7 +36,7 @@
  * section. Since TSS's are completely CPU-local, we want them
  * on exact cacheline boundaries, to eliminate cacheline ping-pong.
  */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
+__visible DEFINE_PER_CPU_SHARED_ALIGNED(struct tss_struct, init_tss) = INIT_TSS;
 
 #ifdef CONFIG_X86_64
 static DEFINE_PER_CPU(unsigned char, is_idle);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8adefc..884f98f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -247,7 +247,7 @@ EXPORT_SYMBOL_GPL(start_thread);
  * the task-switch, and shows up in ret_from_fork in entry.S,
  * for example.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread,
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 05646ba..bb1dc51 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -52,7 +52,7 @@
 
 asmlinkage extern void ret_from_fork(void);
 
-DEFINE_PER_CPU(unsigned long, old_rsp);
+asmlinkage DEFINE_PER_CPU(unsigned long, old_rsp);
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
@@ -274,7 +274,7 @@ void start_thread_ia32(struct pt_regs *regs, u32 new_ip, u32 new_sp)
  * Kprobes not supported here. Set the probe on schedule instead.
  * Function graph tracer not supported too.
  */
-__notrace_funcgraph struct task_struct *
+__visible __notrace_funcgraph struct task_struct *
 __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 {
 	struct thread_struct *prev = &prev_p->thread;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..dfa55af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -206,9 +206,9 @@ EXPORT_SYMBOL(boot_cpu_data);
 
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-unsigned long mmu_cr4_features;
+__visible unsigned long mmu_cr4_features;
 #else
-unsigned long mmu_cr4_features = X86_CR4_PAE;
+__visible unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
 /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cf91358..6a9acc6 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -533,7 +533,7 @@ static int x32_setup_rt_frame(struct ksignal *ksig,
  * Do a signal return; undo the signal stack.
  */
 #ifdef CONFIG_X86_32
-unsigned long sys_sigreturn(void)
+asmlinkage unsigned long sys_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct sigframe __user *frame;
@@ -562,7 +562,7 @@ badframe:
 }
 #endif /* CONFIG_X86_32 */
 
-long sys_rt_sigreturn(void)
+asmlinkage long sys_rt_sigreturn(void)
 {
 	struct pt_regs *regs = current_pt_regs();
 	struct rt_sigframe __user *frame;
@@ -728,7 +728,7 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void
+__visible void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 	user_exit();
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index cdaa347..7c3a5a6 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -256,7 +256,7 @@ static inline void __smp_reschedule_interrupt(void)
 	scheduler_ipi();
 }
 
-void smp_reschedule_interrupt(struct pt_regs *regs)
+__visible void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	__smp_reschedule_interrupt();
@@ -271,7 +271,7 @@ static inline void smp_entering_irq(void)
 	irq_enter();
 }
 
-void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+__visible void smp_trace_reschedule_interrupt(struct pt_regs *regs)
 {
 	/*
 	 * Need to call irq_enter() before calling the trace point.
@@ -295,14 +295,14 @@ static inline void __smp_call_function_interrupt(void)
 	inc_irq_stat(irq_call_count);
 }
 
-void smp_call_function_interrupt(struct pt_regs *regs)
+__visible void smp_call_function_interrupt(struct pt_regs *regs)
 {
 	smp_entering_irq();
 	__smp_call_function_interrupt();
 	exiting_irq();
 }
 
-void smp_trace_call_function_interrupt(struct pt_regs *regs)
+__visible void smp_trace_call_function_interrupt(struct pt_regs *regs)
 {
 	smp_entering_irq();
 	trace_call_function_entry(CALL_FUNCTION_VECTOR);
@@ -317,14 +317,14 @@ static inline void __smp_call_function_single_interrupt(void)
 	inc_irq_stat(irq_call_count);
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
+__visible void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
 	smp_entering_irq();
 	__smp_call_function_single_interrupt();
 	exiting_irq();
 }
 
-void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
+__visible void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 {
 	smp_entering_irq();
 	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
diff --git a/arch/x86/kernel/syscall_32.c b/arch/x86/kernel/syscall_32.c
index 147fcd4..e9bcd57 100644
--- a/arch/x86/kernel/syscall_32.c
+++ b/arch/x86/kernel/syscall_32.c
@@ -15,7 +15,7 @@ typedef asmlinkage void (*sys_call_ptr_t)(void);
 
 extern asmlinkage void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+__visible const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 5c7f8c2..4ac730b 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -4,6 +4,7 @@
 #include <linux/sys.h>
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
+#include <asm/syscall.h>
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
 
@@ -19,11 +20,9 @@
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
-
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
+asmlinkage const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 906fea3..c905e89 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(copy_in_user);
  * Since protection fault in copy_from/to_user is not a normal situation,
  * it is not necessary to optimize tail handling.
  */
-unsigned long
+__visible unsigned long
 copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
 {
 	char c;
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 1cf5b30..424f4c9 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -25,10 +25,10 @@
 #include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
-unsigned long saved_context_ebx;
-unsigned long saved_context_esp, saved_context_ebp;
-unsigned long saved_context_esi, saved_context_edi;
-unsigned long saved_context_eflags;
+__visible unsigned long saved_context_ebx;
+__visible unsigned long saved_context_esp, saved_context_ebp;
+__visible unsigned long saved_context_esi, saved_context_edi;
+__visible unsigned long saved_context_eflags;
 #endif
 struct saved_context saved_context;
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index a0fde91..304fca2 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -20,26 +20,26 @@
 #include <asm/suspend.h>
 
 /* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
+extern __visible const void __nosave_begin, __nosave_end;
 
 /* Defined in hibernate_asm_64.S */
-extern int restore_image(void);
+extern asmlinkage int restore_image(void);
 
 /*
  * Address to jump to in the last phase of restore in order to get to the image
  * kernel's text (this value is passed in the image header).
  */
-unsigned long restore_jump_address;
+unsigned long restore_jump_address __visible;
 
 /*
  * Value of the cr3 register from before the hibernation (this value is passed
  * in the image header).
  */
-unsigned long restore_cr3;
+unsigned long restore_cr3 __visible;
 
-pgd_t *temp_level4_pgt;
+pgd_t *temp_level4_pgt __visible;
 
-void *relocated_restore_code;
+void *relocated_restore_code __visible;
 
 static void *alloc_pgt_page(void *context)
 {
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 86782c5..95f8c61 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -105,9 +105,9 @@ static inline void __init xen_init_apic(void)
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-	ret name(__VA_ARGS__);			\
-	extern char name##_end[];		\
-	extern char name##_reloc[]		\
+	__visible ret name(__VA_ARGS__);	\
+	extern char name##_end[] __visible;	\
+	extern char name##_reloc[] __visible
 
 DECL_ASM(void, xen_irq_enable_direct, void);
 DECL_ASM(void, xen_irq_disable_direct, void);
@@ -115,11 +115,11 @@ DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 /* These are not functions, and cannot be called normally */
-void xen_iret(void);
-void xen_sysexit(void);
-void xen_sysret32(void);
-void xen_sysret64(void);
-void xen_adjust_exception_frame(void);
+__visible void xen_iret(void);
+__visible void xen_sysexit(void);
+__visible void xen_sysret32(void);
+__visible void xen_sysret64(void);
+__visible void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052..e6131a78 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -200,7 +200,7 @@ static inline void show_regs_print_info(const char *log_lvl)
 }
 #endif
 
-extern void dump_stack(void) __cold;
+extern asmlinkage void dump_stack(void) __cold;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..3085e62 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -39,7 +39,7 @@ static int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
-int in_suspend __nosavedata;
+__visible int in_suspend __nosavedata;
 
 enum {
 	HIBERNATION_INVALID,
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index c031541..f23b63f 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -23,7 +23,7 @@ static void __dump_stack(void)
 #ifdef CONFIG_SMP
 static atomic_t dump_lock = ATOMIC_INIT(-1);
 
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	int was_locked;
 	int old;
@@ -55,7 +55,7 @@ retry:
 	preempt_enable();
 }
 #else
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	__dump_stack();
 }

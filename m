Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaDARpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:45:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:9051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaDARpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,774,1389772800"; 
   d="scan'208";a="512517144"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] asmlinkage, x86: Add explicit __visible to arch/x86/*
Date: Tue,  1 Apr 2014 19:32:35 +0200
Message-Id: <1396373557-3387-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
References: <1396373557-3387-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

As requested by Linus add explicit __visible to the asmlinkage users.
This marks both functions visible to assembler and some functions
defined in assembler to make it clear to the  compiler that they
exist elsewhere.

Tree sweep for most of arch/x86/*

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/boot/compressed/misc.c          |   2 +-
 arch/x86/include/asm/hw_irq.h            | 102 +++++++++++++++----------------
 arch/x86/include/asm/kprobes.h           |   2 +-
 arch/x86/include/asm/kvm_host.h          |   2 +-
 arch/x86/include/asm/processor.h         |   2 +-
 arch/x86/include/asm/setup.h             |   6 +-
 arch/x86/include/asm/special_insns.h     |   2 +-
 arch/x86/include/asm/traps.h             |  56 ++++++++---------
 arch/x86/kernel/acpi/sleep.c             |   2 +-
 arch/x86/kernel/apic/io_apic.c           |   2 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   4 +-
 arch/x86/kernel/cpu/mcheck/threshold.c   |   4 +-
 arch/x86/kernel/head32.c                 |   2 +-
 arch/x86/kernel/head64.c                 |   2 +-
 arch/x86/kernel/process_32.c             |   4 +-
 arch/x86/kernel/process_64.c             |   4 +-
 arch/x86/kernel/smp.c                    |   2 +-
 arch/x86/kernel/traps.c                  |   8 +--
 arch/x86/kernel/vsmp_64.c                |   6 +-
 arch/x86/kvm/x86.c                       |   2 +-
 arch/x86/lguest/boot.c                   |   4 +-
 arch/x86/math-emu/errors.c               |  16 ++---
 arch/x86/platform/olpc/olpc-xo1-pm.c     |   2 +-
 arch/x86/power/hibernate_64.c            |   2 +-
 arch/x86/xen/enlighten.c                 |   2 +-
 arch/x86/xen/irq.c                       |   6 +-
 arch/x86/xen/setup.c                     |   2 +-
 27 files changed, 125 insertions(+), 125 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 196eaf3..8aa6d8b 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -389,7 +389,7 @@ static void parse_elf(void *output)
 	free(phdrs);
 }
 
-asmlinkage void *decompress_kernel(void *rmode, memptr heap,
+asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 67d69b8..eb8909c 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -26,56 +26,56 @@
 #include <asm/sections.h>
 
 /* Interrupt handlers registered during init_IRQ */
-extern asmlinkage void apic_timer_interrupt(void);
-extern asmlinkage void x86_platform_ipi(void);
-extern asmlinkage void kvm_posted_intr_ipi(void);
-extern asmlinkage void error_interrupt(void);
-extern asmlinkage void irq_work_interrupt(void);
-
-extern asmlinkage void spurious_interrupt(void);
-extern asmlinkage void thermal_interrupt(void);
-extern asmlinkage void reschedule_interrupt(void);
-
-extern asmlinkage void invalidate_interrupt(void);
-extern asmlinkage void invalidate_interrupt0(void);
-extern asmlinkage void invalidate_interrupt1(void);
-extern asmlinkage void invalidate_interrupt2(void);
-extern asmlinkage void invalidate_interrupt3(void);
-extern asmlinkage void invalidate_interrupt4(void);
-extern asmlinkage void invalidate_interrupt5(void);
-extern asmlinkage void invalidate_interrupt6(void);
-extern asmlinkage void invalidate_interrupt7(void);
-extern asmlinkage void invalidate_interrupt8(void);
-extern asmlinkage void invalidate_interrupt9(void);
-extern asmlinkage void invalidate_interrupt10(void);
-extern asmlinkage void invalidate_interrupt11(void);
-extern asmlinkage void invalidate_interrupt12(void);
-extern asmlinkage void invalidate_interrupt13(void);
-extern asmlinkage void invalidate_interrupt14(void);
-extern asmlinkage void invalidate_interrupt15(void);
-extern asmlinkage void invalidate_interrupt16(void);
-extern asmlinkage void invalidate_interrupt17(void);
-extern asmlinkage void invalidate_interrupt18(void);
-extern asmlinkage void invalidate_interrupt19(void);
-extern asmlinkage void invalidate_interrupt20(void);
-extern asmlinkage void invalidate_interrupt21(void);
-extern asmlinkage void invalidate_interrupt22(void);
-extern asmlinkage void invalidate_interrupt23(void);
-extern asmlinkage void invalidate_interrupt24(void);
-extern asmlinkage void invalidate_interrupt25(void);
-extern asmlinkage void invalidate_interrupt26(void);
-extern asmlinkage void invalidate_interrupt27(void);
-extern asmlinkage void invalidate_interrupt28(void);
-extern asmlinkage void invalidate_interrupt29(void);
-extern asmlinkage void invalidate_interrupt30(void);
-extern asmlinkage void invalidate_interrupt31(void);
-
-extern asmlinkage void irq_move_cleanup_interrupt(void);
-extern asmlinkage void reboot_interrupt(void);
-extern asmlinkage void threshold_interrupt(void);
-
-extern asmlinkage void call_function_interrupt(void);
-extern asmlinkage void call_function_single_interrupt(void);
+extern asmlinkage __visible void apic_timer_interrupt(void);
+extern asmlinkage __visible void x86_platform_ipi(void);
+extern asmlinkage __visible void kvm_posted_intr_ipi(void);
+extern asmlinkage __visible void error_interrupt(void);
+extern asmlinkage __visible void irq_work_interrupt(void);
+
+extern asmlinkage __visible void spurious_interrupt(void);
+extern asmlinkage __visible void thermal_interrupt(void);
+extern asmlinkage __visible void reschedule_interrupt(void);
+
+extern asmlinkage __visible void invalidate_interrupt(void);
+extern asmlinkage __visible void invalidate_interrupt0(void);
+extern asmlinkage __visible void invalidate_interrupt1(void);
+extern asmlinkage __visible void invalidate_interrupt2(void);
+extern asmlinkage __visible void invalidate_interrupt3(void);
+extern asmlinkage __visible void invalidate_interrupt4(void);
+extern asmlinkage __visible void invalidate_interrupt5(void);
+extern asmlinkage __visible void invalidate_interrupt6(void);
+extern asmlinkage __visible void invalidate_interrupt7(void);
+extern asmlinkage __visible void invalidate_interrupt8(void);
+extern asmlinkage __visible void invalidate_interrupt9(void);
+extern asmlinkage __visible void invalidate_interrupt10(void);
+extern asmlinkage __visible void invalidate_interrupt11(void);
+extern asmlinkage __visible void invalidate_interrupt12(void);
+extern asmlinkage __visible void invalidate_interrupt13(void);
+extern asmlinkage __visible void invalidate_interrupt14(void);
+extern asmlinkage __visible void invalidate_interrupt15(void);
+extern asmlinkage __visible void invalidate_interrupt16(void);
+extern asmlinkage __visible void invalidate_interrupt17(void);
+extern asmlinkage __visible void invalidate_interrupt18(void);
+extern asmlinkage __visible void invalidate_interrupt19(void);
+extern asmlinkage __visible void invalidate_interrupt20(void);
+extern asmlinkage __visible void invalidate_interrupt21(void);
+extern asmlinkage __visible void invalidate_interrupt22(void);
+extern asmlinkage __visible void invalidate_interrupt23(void);
+extern asmlinkage __visible void invalidate_interrupt24(void);
+extern asmlinkage __visible void invalidate_interrupt25(void);
+extern asmlinkage __visible void invalidate_interrupt26(void);
+extern asmlinkage __visible void invalidate_interrupt27(void);
+extern asmlinkage __visible void invalidate_interrupt28(void);
+extern asmlinkage __visible void invalidate_interrupt29(void);
+extern asmlinkage __visible void invalidate_interrupt30(void);
+extern asmlinkage __visible void invalidate_interrupt31(void);
+
+extern asmlinkage __visible void irq_move_cleanup_interrupt(void);
+extern asmlinkage __visible void reboot_interrupt(void);
+extern asmlinkage __visible void threshold_interrupt(void);
+
+extern asmlinkage __visible void call_function_interrupt(void);
+extern asmlinkage __visible void call_function_single_interrupt(void);
 
 #ifdef CONFIG_TRACING
 /* Interrupt handlers registered during init_IRQ */
@@ -177,7 +177,7 @@ extern __visible void smp_spurious_interrupt(struct pt_regs *);
 extern __visible void smp_x86_platform_ipi(struct pt_regs *);
 extern __visible void smp_error_interrupt(struct pt_regs *);
 #ifdef CONFIG_X86_IO_APIC
-extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
+extern asmlinkage __visible void smp_irq_move_cleanup_interrupt(void);
 #endif
 #ifdef CONFIG_SMP
 extern __visible void smp_reschedule_interrupt(struct pt_regs *);
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 9454c16..cd1d62c4 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -62,7 +62,7 @@ extern __visible kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-asmlinkage void kretprobe_trampoline(void);
+asmlinkage __visible void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fdf83af..ebddc85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1009,7 +1009,7 @@ enum {
  * reboot turns off virtualization while processes are running.
  * Trap the fault and ignore the instruction if that happens.
  */
-asmlinkage void kvm_spurious_fault(void);
+asmlinkage __visible void kvm_spurious_fault(void);
 
 #define ____kvm_handle_fault_on_reboot(insn, cleanup_insn)	\
 	"666: " insn "\n\t" \
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fdedd38..b4196bf 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -434,7 +434,7 @@ DECLARE_INIT_PER_CPU(irq_stack_union);
 
 DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
-extern asmlinkage void ignore_sysret(void);
+extern asmlinkage __visible void ignore_sysret(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index d62c9f8..39b5ddc 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -111,11 +111,11 @@ void *extend_brk(size_t size, size_t align);
 extern void probe_roms(void);
 #ifdef __i386__
 
-asmlinkage void __init i386_start_kernel(void);
+asmlinkage __visible void __init i386_start_kernel(void);
 
 #else
-asmlinkage void __init x86_64_start_kernel(char *real_mode);
-asmlinkage void __init x86_64_start_reservations(char *real_mode_data);
+asmlinkage __visible void __init x86_64_start_kernel(char *real_mode);
+asmlinkage __visible void __init x86_64_start_reservations(char *real_mode_data);
 
 #endif /* __i386__ */
 #endif /* _SETUP */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index e820c08..8c298b4 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -101,7 +101,7 @@ static inline void native_wbinvd(void)
 	asm volatile("wbinvd": : :"memory");
 }
 
-extern asmlinkage void native_load_gs_index(unsigned);
+extern asmlinkage __visible void native_load_gs_index(unsigned);
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 58d66fe..3e54856 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -8,37 +8,37 @@
 
 #define dotraplinkage __visible
 
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void xen_debug(void);
-asmlinkage void xen_int3(void);
-asmlinkage void xen_stack_segment(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
+asmlinkage __visible void divide_error(void);
+asmlinkage __visible void debug(void);
+asmlinkage __visible void nmi(void);
+asmlinkage __visible void int3(void);
+asmlinkage __visible void xen_debug(void);
+asmlinkage __visible void xen_int3(void);
+asmlinkage __visible void xen_stack_segment(void);
+asmlinkage __visible void overflow(void);
+asmlinkage __visible void bounds(void);
+asmlinkage __visible void invalid_op(void);
+asmlinkage __visible void device_not_available(void);
 #ifdef CONFIG_X86_64
-asmlinkage void double_fault(void);
+asmlinkage __visible void double_fault(void);
 #endif
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void async_page_fault(void);
-asmlinkage void spurious_interrupt_bug(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void alignment_check(void);
+asmlinkage __visible void coprocessor_segment_overrun(void);
+asmlinkage __visible void invalid_TSS(void);
+asmlinkage __visible void segment_not_present(void);
+asmlinkage __visible void stack_segment(void);
+asmlinkage __visible void general_protection(void);
+asmlinkage __visible void page_fault(void);
+asmlinkage __visible void async_page_fault(void);
+asmlinkage __visible void spurious_interrupt_bug(void);
+asmlinkage __visible void coprocessor_error(void);
+asmlinkage __visible void alignment_check(void);
 #ifdef CONFIG_X86_MCE
-asmlinkage void machine_check(void);
+asmlinkage __visible void machine_check(void);
 #endif /* CONFIG_X86_MCE */
-asmlinkage void simd_coprocessor_error(void);
+asmlinkage __visible void simd_coprocessor_error(void);
 
 #ifdef CONFIG_TRACING
-asmlinkage void trace_page_fault(void);
+asmlinkage __visible void trace_page_fault(void);
 #define trace_divide_error divide_error
 #define trace_bounds bounds
 #define trace_invalid_op invalid_op
@@ -68,7 +68,7 @@ dotraplinkage void do_segment_not_present(struct pt_regs *, long);
 dotraplinkage void do_stack_segment(struct pt_regs *, long);
 #ifdef CONFIG_X86_64
 dotraplinkage void do_double_fault(struct pt_regs *, long);
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
+asmlinkage __visible __kprobes struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
@@ -101,8 +101,8 @@ extern int panic_on_unrecovered_nmi;
 void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
-asmlinkage void smp_thermal_interrupt(void);
-asmlinkage void mce_threshold_interrupt(void);
+asmlinkage __visible void smp_thermal_interrupt(void);
+asmlinkage __visible void mce_threshold_interrupt(void);
 #endif
 
 /* Interrupts/Exceptions */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 3a2ae4c..3136820 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -31,7 +31,7 @@ static char temp_stack[4096];
  *
  * Wrapper around acpi_enter_sleep_state() to be called by assmebly.
  */
-acpi_status asmlinkage x86_acpi_enter_sleep_state(u8 state)
+acpi_status asmlinkage __visible x86_acpi_enter_sleep_state(u8 state)
 {
 	return acpi_enter_sleep_state(state);
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..d61b23e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2189,7 +2189,7 @@ void send_cleanup_vector(struct irq_cfg *cfg)
 	cfg->move_in_progress = 0;
 }
 
-asmlinkage void smp_irq_move_cleanup_interrupt(void)
+asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 3eec7de..1a2fb30 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -439,14 +439,14 @@ static inline void __smp_thermal_interrupt(void)
 	smp_thermal_vector();
 }
 
-asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+asmlinkage __visible void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	__smp_thermal_interrupt();
 	exiting_ack_irq();
 }
 
-asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
+asmlinkage __visible void smp_trace_thermal_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
 	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index fe6b1c8..7245980 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -24,14 +24,14 @@ static inline void __smp_threshold_interrupt(void)
 	mce_threshold_vector();
 }
 
-asmlinkage void smp_threshold_interrupt(void)
+asmlinkage __visible void smp_threshold_interrupt(void)
 {
 	entering_irq();
 	__smp_threshold_interrupt();
 	exiting_ack_irq();
 }
 
-asmlinkage void smp_trace_threshold_interrupt(void)
+asmlinkage __visible void smp_trace_threshold_interrupt(void)
 {
 	entering_irq();
 	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index c61a14a..d6c1b983 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,7 +29,7 @@ static void __init i386_default_early_setup(void)
 	reserve_ebda_region();
 }
 
-asmlinkage void __init i386_start_kernel(void)
+asmlinkage __visible void __init i386_start_kernel(void)
 {
 	sanitize_boot_params(&boot_params);
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 85126cc..068054f 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -137,7 +137,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
+asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0de43e9..07d35b2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -55,8 +55,8 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 
-asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
-asmlinkage void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
+asmlinkage __visible void ret_from_fork(void) __asm__("ret_from_fork");
+asmlinkage __visible void ret_from_kernel_thread(void) __asm__("ret_from_kernel_thread");
 
 /*
  * Return saved PC of a blocked thread.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..eae1f10 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -50,9 +50,9 @@
 #include <asm/debugreg.h>
 #include <asm/switch_to.h>
 
-asmlinkage extern void ret_from_fork(void);
+asmlinkage __visible extern void ret_from_fork(void);
 
-asmlinkage DEFINE_PER_CPU(unsigned long, old_rsp);
+__visible DEFINE_PER_CPU(unsigned long, old_rsp);
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 7c3a5a6..be8e1bd 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -168,7 +168,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-asmlinkage void smp_reboot_interrupt(void)
+asmlinkage __visible void smp_reboot_interrupt(void)
 {
 	ack_APIC_irq();
 	irq_enter();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..0fd7f57 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -71,7 +71,7 @@ gate_desc debug_idt_table[NR_VECTORS] __page_aligned_bss;
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
 
-asmlinkage int system_call(void);
+asmlinkage __visible int system_call(void);
 #endif
 
 /* Must be page-aligned because the real IDT is used in a fixmap. */
@@ -357,7 +357,7 @@ exit:
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage __visible __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 {
 	struct pt_regs *regs = eregs;
 	/* Did already sync */
@@ -601,11 +601,11 @@ do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 #endif
 }
 
-asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
+asmlinkage __visible void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
 
-asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
+asmlinkage __visible void __attribute__((weak)) smp_threshold_interrupt(void)
 {
 }
 
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a9..aeda81e 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -33,7 +33,7 @@
  * and vice versa.
  */
 
-asmlinkage unsigned long vsmp_save_fl(void)
+asmlinkage __visible unsigned long vsmp_save_fl(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -53,7 +53,7 @@ __visible void vsmp_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_restore_fl);
 
-asmlinkage void vsmp_irq_disable(void)
+asmlinkage __visible void vsmp_irq_disable(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -61,7 +61,7 @@ asmlinkage void vsmp_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_disable);
 
-asmlinkage void vsmp_irq_enable(void)
+asmlinkage __visible void vsmp_irq_enable(void)
 {
 	unsigned long flags = native_save_fl();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b85784..14fff15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -280,7 +280,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
-asmlinkage void kvm_spurious_fault(void)
+asmlinkage __visible void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
 	BUG();
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index ad1fb5f..aae9413 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -233,13 +233,13 @@ static void lguest_end_context_switch(struct task_struct *next)
  * flags word contains all kind of stuff, but in practice Linux only cares
  * about the interrupt flag.  Our "save_flags()" just returns that.
  */
-asmlinkage unsigned long lguest_save_fl(void)
+asmlinkage __visible unsigned long lguest_save_fl(void)
 {
 	return lguest_data.irq_enabled;
 }
 
 /* Interrupts go off... */
-asmlinkage void lguest_irq_disable(void)
+asmlinkage __visible void lguest_irq_disable(void)
 {
 	lguest_data.irq_enabled = 0;
 }
diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index a544908..9e6545f 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -302,7 +302,7 @@ static struct {
 	      0x242  in div_Xsig.S
  */
 
-asmlinkage void FPU_exception(int n)
+asmlinkage __visible void FPU_exception(int n)
 {
 	int i, int_type;
 
@@ -492,7 +492,7 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
 
 /* Invalid arith operation on Valid registers */
 /* Returns < 0 if the exception is unmasked */
-asmlinkage int arith_invalid(int deststnr)
+asmlinkage __visible int arith_invalid(int deststnr)
 {
 
 	EXCEPTION(EX_Invalid);
@@ -507,7 +507,7 @@ asmlinkage int arith_invalid(int deststnr)
 }
 
 /* Divide a finite number by zero */
-asmlinkage int FPU_divide_by_zero(int deststnr, u_char sign)
+asmlinkage __visible int FPU_divide_by_zero(int deststnr, u_char sign)
 {
 	FPU_REG *dest = &st(deststnr);
 	int tag = TAG_Valid;
@@ -539,7 +539,7 @@ int set_precision_flag(int flags)
 }
 
 /* This may be called often, so keep it lean */
-asmlinkage void set_precision_flag_up(void)
+asmlinkage __visible void set_precision_flag_up(void)
 {
 	if (control_word & CW_Precision)
 		partial_status |= (SW_Precision | SW_C1);	/* The masked response */
@@ -548,7 +548,7 @@ asmlinkage void set_precision_flag_up(void)
 }
 
 /* This may be called often, so keep it lean */
-asmlinkage void set_precision_flag_down(void)
+asmlinkage __visible void set_precision_flag_down(void)
 {
 	if (control_word & CW_Precision) {	/* The masked response */
 		partial_status &= ~SW_C1;
@@ -557,7 +557,7 @@ asmlinkage void set_precision_flag_down(void)
 		EXCEPTION(EX_Precision);
 }
 
-asmlinkage int denormal_operand(void)
+asmlinkage __visible int denormal_operand(void)
 {
 	if (control_word & CW_Denormal) {	/* The masked response */
 		partial_status |= SW_Denorm_Op;
@@ -568,7 +568,7 @@ asmlinkage int denormal_operand(void)
 	}
 }
 
-asmlinkage int arith_overflow(FPU_REG *dest)
+asmlinkage __visible int arith_overflow(FPU_REG *dest)
 {
 	int tag = TAG_Valid;
 
@@ -596,7 +596,7 @@ asmlinkage int arith_overflow(FPU_REG *dest)
 
 }
 
-asmlinkage int arith_underflow(FPU_REG *dest)
+asmlinkage __visible int arith_underflow(FPU_REG *dest)
 {
 	int tag = TAG_Valid;
 
diff --git a/arch/x86/platform/olpc/olpc-xo1-pm.c b/arch/x86/platform/olpc/olpc-xo1-pm.c
index ff0174d..a9acde7 100644
--- a/arch/x86/platform/olpc/olpc-xo1-pm.c
+++ b/arch/x86/platform/olpc/olpc-xo1-pm.c
@@ -75,7 +75,7 @@ static int xo1_power_state_enter(suspend_state_t pm_state)
 	return 0;
 }
 
-asmlinkage int xo1_do_sleep(u8 sleep_state)
+asmlinkage __visible int xo1_do_sleep(u8 sleep_state)
 {
 	void *pgd_addr = __va(read_cr3());
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 304fca2..35e2bb6 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -23,7 +23,7 @@
 extern __visible const void __nosave_begin, __nosave_end;
 
 /* Defined in hibernate_asm_64.S */
-extern asmlinkage int restore_image(void);
+extern asmlinkage __visible int restore_image(void);
 
 /*
  * Address to jump to in the last phase of restore in order to get to the image
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 201d09a..c34bfc4 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1515,7 +1515,7 @@ static void __init xen_pvh_early_guest_init(void)
 }
 
 /* First C function to be called on Xen boot */
-asmlinkage void __init xen_start_kernel(void)
+asmlinkage __visible void __init xen_start_kernel(void)
 {
 	struct physdev_set_iopl set_iopl;
 	int rc;
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 08f763d..a1207cb 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -23,7 +23,7 @@ void xen_force_evtchn_callback(void)
 	(void)HYPERVISOR_xen_version(0, NULL);
 }
 
-asmlinkage unsigned long xen_save_fl(void)
+asmlinkage __visible unsigned long xen_save_fl(void)
 {
 	struct vcpu_info *vcpu;
 	unsigned long flags;
@@ -63,7 +63,7 @@ __visible void xen_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
-asmlinkage void xen_irq_disable(void)
+asmlinkage __visible void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
 	   make sure we're don't switch CPUs between getting the vcpu
@@ -74,7 +74,7 @@ asmlinkage void xen_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
 
-asmlinkage void xen_irq_enable(void)
+asmlinkage __visible void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 0982233..5c95244 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -35,7 +35,7 @@
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
 #ifdef CONFIG_X86_64
-extern asmlinkage void nmi(void);
+extern asmlinkage __visible void nmi(void);
 #endif
 extern void xen_sysenter_target(void);
 extern void xen_syscall_target(void);
-- 
1.8.5.2


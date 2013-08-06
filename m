Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3HFVnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HFVnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:15 -0400
Date: Tue, 6 Aug 2013 14:43:04 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-1d9090e2fb32c84277cef6e72a21be7f78c929f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-4-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make all interrupt handlers asmlinkage / __visible
Git-Commit-ID: 1d9090e2fb32c84277cef6e72a21be7f78c929f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d9090e2fb32c84277cef6e72a21be7f78c929f4
Gitweb:     http://git.kernel.org/tip/1d9090e2fb32c84277cef6e72a21be7f78c929f4
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:37 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:23 -0700

x86, asmlinkage: Make all interrupt handlers asmlinkage / __visible

These handlers are all referenced from assembler stubs, so need
to be visible.

The handlers without arguments become asmlinkage, the others __visible
to not force regparms(0) on x86-32.

I put it all into a single patch, please let me know if you want
it it split up.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-4-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h | 120 ++++++++++++++++++++----------------------
 arch/x86/include/asm/irq.h    |   2 +-
 arch/x86/kernel/apic/apic.c   |  12 ++---
 arch/x86/kernel/irq.c         |   8 +--
 arch/x86/kernel/irq_work.c    |   4 +-
 arch/x86/kernel/smp.c         |  12 ++---
 6 files changed, 77 insertions(+), 81 deletions(-)

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

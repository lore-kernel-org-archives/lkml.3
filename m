Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966233AbaKLBwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:52:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966217AbaKLBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 020/123] x86, flags: Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED
Date: Wed, 12 Nov 2014 10:16:26 +0900
Message-Id: <20141112011719.933767723@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 1adfa76a95fe4444124a502f7cc858a39d5b8e01 upstream.

Bit 1 in the x86 EFLAGS is always set.  Name the macro something that
actually tries to explain what it is all about, rather than being a
tautology.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Link: http://lkml.kernel.org/n/tip-f10rx5vjjm6tfnt8o1wseb3v@git.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/uapi/asm/processor-flags.h |    2 +-
 arch/x86/kernel/entry_64.S                  |    2 +-
 arch/x86/kernel/process_32.c                |    2 +-
 arch/x86/kernel/process_64.c                |    2 +-
 arch/x86/kvm/vmx.c                          |    2 +-
 drivers/lguest/x86/core.c                   |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/uapi/asm/processor-flags.h
+++ b/arch/x86/include/uapi/asm/processor-flags.h
@@ -6,7 +6,7 @@
  * EFLAGS bits
  */
 #define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_BIT1	0x00000002 /* Bit 1 - always on */
+#define X86_EFLAGS_FIXED 0x00000002 /* Bit 1 - always on */
 #define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
 #define X86_EFLAGS_AF	0x00000010 /* Auxiliary carry Flag */
 #define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -366,7 +366,7 @@ ENDPROC(native_usergs_sysret64)
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
-	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_BIT1) /* eflags - interrupts on */
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED) /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq_cfi $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -147,7 +147,7 @@ int copy_thread(unsigned long clone_flag
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		p->fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -176,7 +176,7 @@ int copy_thread(unsigned long clone_flag
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		return 0;
 	}
 	*childregs = *current_pt_regs();
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -7949,7 +7949,7 @@ static void load_vmcs12_host_state(struc
 
 	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->host_rsp);
 	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->host_rip);
-	vmx_set_rflags(vcpu, X86_EFLAGS_BIT1);
+	vmx_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	/*
 	 * Note that calling vmx_set_cr0 is important, even if cr0 hasn't
 	 * actually changed, because it depends on the current state of
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -700,7 +700,7 @@ void lguest_arch_setup_regs(struct lg_cp
 	 * interrupts are enabled.  We always leave interrupts enabled while
 	 * running the Guest.
 	 */
-	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 
 	/*
 	 * The "Extended Instruction Pointer" register says where the Guest is



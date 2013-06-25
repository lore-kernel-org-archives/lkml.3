Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3FYWyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:54:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49239 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3FYWyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:54:49 -0400
Date: Tue, 25 Jun 2013 15:54:39 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-f10rx5vjjm6tfnt8o1wseb3v@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, flags:
  Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED
Git-Commit-ID: 1037acf062a3af5467bf6bcfdcf93ef989e5319b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 15:54:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1037acf062a3af5467bf6bcfdcf93ef989e5319b
Gitweb:     http://git.kernel.org/tip/1037acf062a3af5467bf6bcfdcf93ef989e5319b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 27 Apr 2013 16:10:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Jun 2013 15:50:04 -0700

x86, flags: Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED

Bit 1 in the x86 EFLAGS is always set.  Name the macro something that
actually tries to explain what it is all about, rather than being a
tautology.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-f10rx5vjjm6tfnt8o1wseb3v@git.kernel.org
---
 arch/x86/include/uapi/asm/processor-flags.h | 2 +-
 arch/x86/kernel/entry_64.S                  | 2 +-
 arch/x86/kernel/process_32.c                | 2 +-
 arch/x86/kernel/process_64.c                | 2 +-
 drivers/lguest/x86/core.c                   | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/processor-flags.h b/arch/x86/include/uapi/asm/processor-flags.h
index 54991a7..b16e6d2 100644
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
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7272089..5fe1fb2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -365,7 +365,7 @@ ENDPROC(native_usergs_sysret64)
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq_cfi %rax /* rsp */
 	CFI_REL_OFFSET	rsp,0
-	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_BIT1) /* eflags - interrupts on */
+	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED) /* eflags - interrupts on */
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq_cfi $__KERNEL_CS /* cs */
 	/*CFI_REL_OFFSET	cs,0*/
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7305f7d..0339f5c 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -147,7 +147,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		p->fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 355ae06..f99a242 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -176,7 +176,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 		childregs->bp = arg;
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
-		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 		return 0;
 	}
 	*childregs = *current_pt_regs();
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index f0a3347..5169239 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -700,7 +700,7 @@ void lguest_arch_setup_regs(struct lg_cpu *cpu, unsigned long start)
 	 * interrupts are enabled.  We always leave interrupts enabled while
 	 * running the Guest.
 	 */
-	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_BIT1;
+	regs->eflags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
 
 	/*
 	 * The "Extended Instruction Pointer" register says where the Guest is

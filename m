Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3HEWEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:04:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab3HEWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341516"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/16] x86, asmlinkage: Make various syscalls asmlinkage
Date: Mon,  5 Aug 2013 15:02:40 -0700
Message-Id: <1375740170-7446-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

FWIW I suspect sys_rt_sigreturn/sys_sigreturn should use
standard SYSCALL wrappers.  But I didn't do that change in this
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/syscalls.h | 6 +++---
 arch/x86/kernel/signal.c        | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

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
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cf91358..1dba45d 100644
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
-- 
1.8.3.1


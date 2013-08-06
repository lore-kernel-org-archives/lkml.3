Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3HFVnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3HFVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:43 -0400
Date: Tue, 6 Aug 2013 14:43:32 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-ff49103fdba59aa3f845ad2dcac0c26a9e4c5404@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-7-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-7-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make various syscalls asmlinkage
Git-Commit-ID: ff49103fdba59aa3f845ad2dcac0c26a9e4c5404
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff49103fdba59aa3f845ad2dcac0c26a9e4c5404
Gitweb:     http://git.kernel.org/tip/ff49103fdba59aa3f845ad2dcac0c26a9e4c5404
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:33 -0700

x86, asmlinkage: Make various syscalls asmlinkage

FWIW I suspect sys_rt_sigreturn/sys_sigreturn should use
standard SYSCALL wrappers.  But I didn't do that change in this
patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-7-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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

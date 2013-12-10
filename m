Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3LJLMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:12:10 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:34236 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3LJLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:12:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] m68k: Convert arch/m68k/mm/fault.c to pr_*()
Date: Tue, 10 Dec 2013 12:12:00 +0100
Message-Id: <1386673920-5670-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386673920-5670-1-git-send-email-geert@linux-m68k.org>
References: <1386673920-5670-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mm/fault.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index c7725f1de05d..2bd7487440c4 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -25,9 +25,8 @@ int send_fault_sig(struct pt_regs *regs)
 	siginfo.si_signo = current->thread.signo;
 	siginfo.si_code = current->thread.code;
 	siginfo.si_addr = (void *)current->thread.faddr;
-#ifdef DEBUG
-	printk("send_fault_sig: %p,%d,%d\n", siginfo.si_addr, siginfo.si_signo, siginfo.si_code);
-#endif
+	pr_debug("send_fault_sig: %p,%d,%d\n", siginfo.si_addr,
+		 siginfo.si_signo, siginfo.si_code);
 
 	if (user_mode(regs)) {
 		force_sig_info(siginfo.si_signo,
@@ -45,10 +44,10 @@ int send_fault_sig(struct pt_regs *regs)
 		 * terminate things with extreme prejudice.
 		 */
 		if ((unsigned long)siginfo.si_addr < PAGE_SIZE)
-			printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference");
+			pr_alert("Unable to handle kernel NULL pointer dereference");
 		else
-			printk(KERN_ALERT "Unable to handle kernel access");
-		printk(" at virtual address %p\n", siginfo.si_addr);
+			pr_alert("Unable to handle kernel access");
+		pr_cont(" at virtual address %p\n", siginfo.si_addr);
 		die_if_kernel("Oops", regs, 0 /*error_code*/);
 		do_exit(SIGKILL);
 	}
@@ -75,10 +74,8 @@ int do_page_fault(struct pt_regs *regs, unsigned long address,
 	int fault;
 	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
-#ifdef DEBUG
-	printk ("do page fault:\nregs->sr=%#x, regs->pc=%#lx, address=%#lx, %ld, %p\n",
+	pr_debug("do page fault:\nregs->sr=%#x, regs->pc=%#lx, address=%#lx, %ld, %p\n",
 		regs->sr, regs->pc, address, error_code, mm ? mm->pgd : NULL);
-#endif
 
 	/*
 	 * If we're in an interrupt or have no user
@@ -117,9 +114,7 @@ retry:
  * we can handle it..
  */
 good_area:
-#ifdef DEBUG
-	printk("do_page_fault: good_area\n");
-#endif
+	pr_debug("do_page_fault: good_area\n");
 	switch (error_code & 3) {
 		default:	/* 3: write, present */
 			/* fall through */
@@ -142,9 +137,7 @@ good_area:
 	 */
 
 	fault = handle_mm_fault(mm, vma, address, flags);
-#ifdef DEBUG
-	printk("handle_mm_fault returns %d\n",fault);
-#endif
+	pr_debug("handle_mm_fault returns %d\n", fault);
 
 	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 		return 0;
-- 
1.7.9.5


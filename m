Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaLGUEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:04:41 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50265 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaLGUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:04:40 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Anton Blanchard <anton@samba.org>, Christoph Lameter <cl@linux.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kernel: traps.c:  Remove unused function
Date: Sun,  7 Dec 2014 21:07:18 +0100
Message-Id: <1417982838-15588-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function vsx_assist_exception() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kernel/traps.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 0dc43f9..857e5f7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1707,21 +1707,6 @@ void altivec_assist_exception(struct pt_regs *regs)
 }
 #endif /* CONFIG_ALTIVEC */
 
-#ifdef CONFIG_VSX
-void vsx_assist_exception(struct pt_regs *regs)
-{
-	if (!user_mode(regs)) {
-		printk(KERN_EMERG "VSX assist exception in kernel mode"
-		       " at %lx\n", regs->nip);
-		die("Kernel VSX assist exception", regs, SIGILL);
-	}
-
-	flush_vsx_to_thread(current);
-	printk(KERN_INFO "VSX assist not supported at %lx\n", regs->nip);
-	_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
-}
-#endif /* CONFIG_VSX */
-
 #ifdef CONFIG_FSL_BOOKE
 void CacheLockingException(struct pt_regs *regs, unsigned long address,
 			   unsigned long error_code)
-- 
1.7.10.4


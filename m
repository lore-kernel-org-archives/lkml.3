Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3H1OTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:19:25 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:41153 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab3H1OTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:19:24 -0400
Date: Wed, 28 Aug 2013 16:19:17 +0200
Message-Id: <201308281419.r7SEJHS0012038@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/mpc8xx: Clearer Oops message for Software Emulation Exception
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the Oops message in case of Software Emulation Exception.
The existing message is quite confusing because it refers to FPU Emulation
while most often the issue is due to either a non supported instruction
(not necessarily FPU related) or a stale instruction due to HW issues.
The new message tries to be more generic in order to make the user understand
that the Oops is due to something wrong with an instruction, not necessarily
due to an FPU instruction.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur linux-3.11-rc6/arch/powerpc/kernel/traps.c linux/arch/powerpc/kernel/traps.c
--- linux-3.11-rc6/arch/powerpc/kernel/traps.c	2013-08-25 15:20:33.000000000 +0200
+++ linux/arch/powerpc/kernel/traps.c	2013-08-25 15:31:29.000000000 +0200
@@ -1476,7 +1476,8 @@
 
 	if (!user_mode(regs)) {
 		debugger(regs);
-		die("Kernel Mode Software FPU Emulation", regs, SIGFPE);
+		die("Kernel Mode Unimplemented Instruction or SW FPU Emulation",
+			regs, SIGFPE);
 	}
 
 #ifdef CONFIG_MATH_EMULATION

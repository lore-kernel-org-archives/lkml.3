Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab3IGJi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3IGJi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:38:56 -0400
From: Borislav Petkov <bp@suse.de>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] x86: Remove now-unused save_rest
Date: Sat,  7 Sep 2013 11:39:10 +0200
Message-Id: <1378546750-19727-1-git-send-email-bp@suse.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b3af11afe06a ("x86: get rid of pt_regs argument of iopl(2)") dropped
PTREGSCALL which was also the last user of save_rest. Drop that
now-unused function too.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/entry_64.S | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951a81e2..b077f4cc225a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -487,21 +487,6 @@ ENDPROC(native_usergs_sysret64)
 	TRACE_IRQS_OFF
 	.endm
 
-ENTRY(save_rest)
-	PARTIAL_FRAME 1 (REST_SKIP+8)
-	movq 5*8+16(%rsp), %r11	/* save return address */
-	movq_cfi rbx, RBX+16
-	movq_cfi rbp, RBP+16
-	movq_cfi r12, R12+16
-	movq_cfi r13, R13+16
-	movq_cfi r14, R14+16
-	movq_cfi r15, R15+16
-	movq %r11, 8(%rsp)	/* return address */
-	FIXUP_TOP_OF_STACK %r11, 16
-	ret
-	CFI_ENDPROC
-END(save_rest)
-
 /* save complete stack frame */
 	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
-- 
1.8.0


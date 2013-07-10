Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3GJSIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:08:12 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40704 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab3GJSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:08:10 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] x86/ia32: remove unused argument in macro
Date: Wed, 10 Jul 2013 23:34:28 +0530
Message-Id: <1373479468-7175-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3fe26fa (x86: get rid of pt_regs argument in sigreturn variants,
2012-11-12) changed the body of PTREGSCALL to drop arg, and updated the
callsites; unfortunately, it forgot to update the macro argument list,
leaving an unused argument.  Fix this.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Trivial.

 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 474dc1b..4299eb0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -452,7 +452,7 @@ ia32_badsys:
 
 	CFI_ENDPROC
 	
-	.macro PTREGSCALL label, func, arg
+	.macro PTREGSCALL label, func
 	ALIGN
 GLOBAL(\label)
 	leaq \func(%rip),%rax
-- 
1.8.3.2.736.g869de25


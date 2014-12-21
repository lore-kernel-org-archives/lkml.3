Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaLUOCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:02:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50318 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaLUOCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:02:30 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, fpu: Use a symbolic name for asm operand
Date: Sun, 21 Dec 2014 15:02:23 +0100
Message-Id: <1419170543-11393-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Fix up the else-case in fpu_fxsave() which seems like it has been
overlooked. Correct comment style in restore_fpu_checking() while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/fpu-internal.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e97622f57722..0dbc08282291 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -207,7 +207,7 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	if (config_enabled(CONFIG_X86_32))
 		asm volatile( "fxsave %[fx]" : [fx] "=m" (fpu->state->fxsave));
 	else if (config_enabled(CONFIG_AS_FXSAVEQ))
-		asm volatile("fxsaveq %0" : "=m" (fpu->state->fxsave));
+		asm volatile("fxsaveq %[fx]" : [fx] "=m" (fpu->state->fxsave));
 	else {
 		/* Using "rex64; fxsave %0" is broken because, if the memory
 		 * operand uses any extended registers for addressing, a second
@@ -290,9 +290,11 @@ static inline int fpu_restore_checking(struct fpu *fpu)
 
 static inline int restore_fpu_checking(struct task_struct *tsk)
 {
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. "m" is a random variable that should be in L1 */
+	/*
+	 * AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception is
+	 * pending. Clear the x87 state here by setting it to fixed values.
+	 * "m" is a random variable that should be in L1.
+	 */
 	if (unlikely(static_cpu_has_bug_safe(X86_BUG_FXSAVE_LEAK))) {
 		asm volatile(
 			"fnclex\n\t"
-- 
2.2.0.33.gc18b867


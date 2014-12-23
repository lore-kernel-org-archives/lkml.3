Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaLWJqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:46:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLWJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:46:07 -0500
Date: Tue, 23 Dec 2014 01:45:39 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-6ca7a8a15035add0a4f9b2fd658118d41dbeb20c@git.kernel.org>
Cc: hpa@zytor.com, bp@suse.de, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        bp@suse.de, torvalds@linux-foundation.org, hpa@zytor.com
In-Reply-To: <1419170543-11393-1-git-send-email-bp@alien8.de>
References: <1419170543-11393-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86/fpu: Use a symbolic name for asm operand
Git-Commit-ID: 6ca7a8a15035add0a4f9b2fd658118d41dbeb20c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ca7a8a15035add0a4f9b2fd658118d41dbeb20c
Gitweb:     http://git.kernel.org/tip/6ca7a8a15035add0a4f9b2fd658118d41dbeb20c
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 21 Dec 2014 15:02:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Dec 2014 10:41:12 +0100

x86/fpu: Use a symbolic name for asm operand

Fix up the else-case in fpu_fxsave() which seems like it has
been overlooked. Correct comment style in restore_fpu_checking()
while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1419170543-11393-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/fpu-internal.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index e97622f..0dbc082 100644
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

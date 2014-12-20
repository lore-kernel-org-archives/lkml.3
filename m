Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaLTQJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:09:33 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43006 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLTQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:09:31 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: um: tls_32.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:12:17 +0100
Message-Id: <1419091937-6536-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function needs_TLS_update() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/um/tls_32.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/arch/x86/um/tls_32.c b/arch/x86/um/tls_32.c
index 80ffa5b..587c4a2 100644
--- a/arch/x86/um/tls_32.c
+++ b/arch/x86/um/tls_32.c
@@ -125,31 +125,6 @@ out:
 }
 
 /*
- * Verify if we need to do a flush for the new process, i.e. if there are any
- * present desc's, only if they haven't been flushed.
- */
-static inline int needs_TLS_update(struct task_struct *task)
-{
-	int i;
-	int ret = 0;
-
-	for (i = GDT_ENTRY_TLS_MIN; i < GDT_ENTRY_TLS_MAX; i++) {
-		struct uml_tls_struct* curr =
-			&task->thread.arch.tls_array[i - GDT_ENTRY_TLS_MIN];
-
-		/*
-		 * Can't test curr->present, we may need to clear a descriptor
-		 * which had a value.
-		 */
-		if (curr->flushed)
-			continue;
-		ret = 1;
-		break;
-	}
-	return ret;
-}
-
-/*
  * On a newly forked process, the TLS descriptors haven't yet been flushed. So
  * we mark them as such and the first switch_to will do the job.
  */
-- 
1.7.10.4


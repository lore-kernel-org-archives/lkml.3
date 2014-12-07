Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaLGVEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:04:44 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37280 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaLGVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:04:43 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mn10300: kernel: traps.c:  Remove unused function
Date: Sun,  7 Dec 2014 22:07:20 +0100
Message-Id: <1417986440-16931-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function show_trace_task() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mn10300/kernel/traps.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index a7a987c..be67383 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -388,20 +388,6 @@ bad:
 }
 
 /*
- *
- */
-void show_trace_task(struct task_struct *tsk)
-{
-	unsigned long sp = tsk->thread.sp;
-
-	/* User space on another CPU? */
-	if ((sp ^ (unsigned long) tsk) & (PAGE_MASK << 1))
-		return;
-
-	show_trace((unsigned long *) sp);
-}
-
-/*
  * note the untimely death of part of the kernel
  */
 void die(const char *str, struct pt_regs *regs, enum exception_code code)
-- 
1.7.10.4


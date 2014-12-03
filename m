Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaLCVgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:36:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaLCVgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:36:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mce: Spell "panicked" correctly
Date: Wed,  3 Dec 2014 22:36:45 +0100
Message-Id: <1417642605-15730-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We need the additional "k" to make it a hard-c:
https://en.wiktionary.org/wiki/panicked

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index cfb16f631d52..d2c611699cd9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -292,10 +292,10 @@ static void print_mce(struct mce *m)
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
 
-static atomic_t mce_paniced;
+static atomic_t mce_panicked;
 
 static int fake_panic;
-static atomic_t mce_fake_paniced;
+static atomic_t mce_fake_panicked;
 
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
@@ -319,7 +319,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		/*
 		 * Make sure only one CPU runs in machine check panic
 		 */
-		if (atomic_inc_return(&mce_paniced) > 1)
+		if (atomic_inc_return(&mce_panicked) > 1)
 			wait_for_panic();
 		barrier();
 
@@ -327,7 +327,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		console_verbose();
 	} else {
 		/* Don't log too much for fake panic */
-		if (atomic_inc_return(&mce_fake_paniced) > 1)
+		if (atomic_inc_return(&mce_fake_panicked) > 1)
 			return;
 	}
 	/* First print corrected ones that are still unlogged */
@@ -744,7 +744,7 @@ static int mce_timed_out(u64 *t)
 	 * might have been modified by someone else.
 	 */
 	rmb();
-	if (atomic_read(&mce_paniced))
+	if (atomic_read(&mce_panicked))
 		wait_for_panic();
 	if (!mca_cfg.monarch_timeout)
 		goto out;
@@ -2568,7 +2568,7 @@ struct dentry *mce_get_debugfs_dir(void)
 static void mce_reset(void)
 {
 	cpu_missing = 0;
-	atomic_set(&mce_fake_paniced, 0);
+	atomic_set(&mce_fake_panicked, 0);
 	atomic_set(&mce_executing, 0);
 	atomic_set(&mce_callin, 0);
 	atomic_set(&global_nwo, 0);
-- 
2.0.0


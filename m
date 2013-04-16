Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3DPNw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:52:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3DPNw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:52:57 -0400
Date: Tue, 16 Apr 2013 06:51:57 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-55a36b65ee7107d6bb557c96fd202c4e90164542@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1365436666-9837-3-git-send-email-bp@alien8.de>
References: <1365436666-9837-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fold-in trivial check_config function
Git-Commit-ID: 55a36b65ee7107d6bb557c96fd202c4e90164542
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 06:52:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55a36b65ee7107d6bb557c96fd202c4e90164542
Gitweb:     http://git.kernel.org/tip/55a36b65ee7107d6bb557c96fd202c4e90164542
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 8 Apr 2013 17:57:44 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Tue, 16 Apr 2013 11:50:50 +0200

x86: Fold-in trivial check_config function

Fold it into its single call site. No functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1365436666-9837-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/bugs.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c59635e..4112be9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -81,21 +81,6 @@ static void __init check_fpu(void)
 	}
 }
 
-/*
- * Check whether we are able to run this kernel safely on SMP.
- *
- * - i386 is no longer supported.
- * - In order to run on anything without a TSC, we need to be
- *   compiled for a i486.
- */
-
-static void __init check_config(void)
-{
-	if (boot_cpu_data.x86 < 4)
-		panic("Kernel requires i486+ for 'invlpg' and other features");
-}
-
-
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
@@ -103,7 +88,17 @@ void __init check_bugs(void)
 	pr_info("CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
-	check_config();
+
+	/*
+	 * Check whether we are able to run this kernel safely on SMP.
+	 *
+	 * - i386 is no longer supported.
+	 * - In order to run on anything without a TSC, we need to be
+	 *   compiled for a i486.
+	 */
+	if (boot_cpu_data.x86 < 4)
+		panic("Kernel requires i486+ for 'invlpg' and other features");
+
 	init_utsname()->machine[1] =
 		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();

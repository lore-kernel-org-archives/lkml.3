Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936787Ab3DHP6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:58:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43452 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936677Ab3DHP6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:58:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/4] x86: Fold-in trivial check_config function
Date: Mon,  8 Apr 2013 17:57:44 +0200
Message-Id: <1365436666-9837-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
In-Reply-To: <1365436666-9837-1-git-send-email-bp@alien8.de>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Fold it into its single call site. No functionality change.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/bugs.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index efa24c0b7c43..03445346ee0a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -63,21 +63,6 @@ static void __init check_fpu(void)
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
@@ -85,7 +70,17 @@ void __init check_bugs(void)
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
-- 
1.8.2.135.g7b592fa


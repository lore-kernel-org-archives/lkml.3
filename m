Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3DOKvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:51:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44709 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3DOKvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:51:52 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>, David Daney <david.daney@cavium.com>
Subject: [PATCH] extable: Flip the sorting message
Date: Mon, 15 Apr 2013 12:51:49 +0200
Message-Id: <1366023109-12098-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.2.135.g7b592fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Now that we do sort the __extable at build time, we actually are
interested only in the case where we still do need to sort it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: David Daney <david.daney@cavium.com>
---
 kernel/extable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index fe35a634bf76..67460b93b1a1 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -41,10 +41,10 @@ u32 __initdata main_extable_sort_needed = 1;
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	if (main_extable_sort_needed)
+	if (main_extable_sort_needed) {
+		pr_notice("Sorting __ex_table...\n");
 		sort_extable(__start___ex_table, __stop___ex_table);
-	else
-		pr_notice("__ex_table already sorted, skipping sort\n");
+	}
 }
 
 /* Given an address, look for it in the exception tables. */
-- 
1.8.2.135.g7b592fa


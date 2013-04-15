Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3DOLnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 07:43:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3DOLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 07:43:38 -0400
Date: Mon, 15 Apr 2013 04:42:37 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-bec1b9e76353ecf05fac6a87f8e4102dfb618cd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1366023109-12098-1-git-send-email-bp@alien8.de>
References: <1366023109-12098-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] extable: Flip the sorting message
Git-Commit-ID: bec1b9e76353ecf05fac6a87f8e4102dfb618cd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 15 Apr 2013 04:42:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bec1b9e76353ecf05fac6a87f8e4102dfb618cd2
Gitweb:     http://git.kernel.org/tip/bec1b9e76353ecf05fac6a87f8e4102dfb618cd2
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 15 Apr 2013 12:51:49 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 15 Apr 2013 13:25:16 +0200

extable: Flip the sorting message

Now that we do sort the __extable at build time, we actually are
interested only in the case where we still do need to sort it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/1366023109-12098-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/extable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index fe35a63..67460b9 100644
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

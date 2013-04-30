Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3D3Htc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:49:32 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44633 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3D3Htb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:49:31 -0400
Date: Tue, 30 Apr 2013 09:49:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/asm updates for v3.10
Message-ID: <20130430074927.GA20521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: bec1b9e76353ecf05fac6a87f8e4102dfb618cd2 extable: Flip the sorting message

Small tweak to reduce kmsg boot time spam.

 out-of-topic modifications in x86-asm-for-linus:
 ------------------------------------------------
 kernel/extable.c                   # bec1b9e: extable: Flip the sorting message

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      extable: Flip the sorting message


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

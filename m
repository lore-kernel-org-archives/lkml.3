Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaEXGTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 02:19:08 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:6283 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaEXGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 02:19:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiALAJk5gFNXQ3g//2dsb2JhbABagwerDAQBAQEBAQEFAYM8lE6BAhd0gmYcIxiBAiQTiEYB2CGFVYh9hEcBA48/ijMBixeIEIM6Ow
Date: Sat, 24 May 2014 08:18:55 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/bug.c: convert printk to pr_foo()
Message-Id: <20140524081855.54cb27d56214c3ba3827ce7a@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Coalesce formats
-"WARNING:" prefix unchanged to keep bug format.
-printk(KERN_DEFAULT not converted.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/bug.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index 1686034..2e9f9bc 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -153,15 +153,13 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
-		printk(KERN_WARNING "------------[ cut here ]------------\n");
+		pr_warn("------------[ cut here ]------------\n");
 
 		if (file)
-			printk(KERN_WARNING "WARNING: at %s:%u\n",
-			       file, line);
+			pr_warn("WARNING: at %s:%u\n", file, line);
 		else
-			printk(KERN_WARNING "WARNING: at %p "
-			       "[verbose debug info unavailable]\n",
-			       (void *)bugaddr);
+			pr_warn("WARNING: at %p [verbose debug info unavailable]\n",
+				(void *)bugaddr);
 
 		print_modules();
 		show_regs(regs);
@@ -174,12 +172,10 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	printk(KERN_DEFAULT "------------[ cut here ]------------\n");
 
 	if (file)
-		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
-		       file, line);
+		pr_crit("kernel BUG at %s:%u!\n", file, line);
 	else
-		printk(KERN_CRIT "Kernel BUG at %p "
-		       "[verbose debug info unavailable]\n",
-		       (void *)bugaddr);
+		pr_crit("Kernel BUG at %p [verbose debug info unavailable]\n",
+			(void *)bugaddr);
 
 	return BUG_TRAP_TYPE_BUG;
 }
-- 
1.9.1

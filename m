Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170AbaEXHaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:30:55 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:12947 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbaEXHay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:30:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiALAD5KgFNXQ3g//2dsb2JhbABagwerDAQBAQEBAQEFAYM8lE6BAxd0gmYcIxiBAiQTiEYB2B+FVYh9hEcBA48/ijMBixeIEIM6Ow
Date: Sat, 24 May 2014 09:30:51 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe <joe@perches.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH V2] lib/bug.c: convert printk to pr_foo()
Message-Id: <20140524093051.37b63f94f2959280a4224267@skynet.be>
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
-define pr_fmt without prefix to avoid any default prefix update
(suggested by Joe Perches).

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: define pr_fmt without prefix

 lib/bug.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/lib/bug.c b/lib/bug.c
index 1686034..d1d7c78 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -37,6 +37,9 @@
 
     Jeremy Fitzhardinge <jeremy@goop.org> 2006
  */
+
+#define pr_fmt(fmt) fmt
+
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -153,15 +156,13 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 
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
@@ -174,12 +175,10 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
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


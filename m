Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaLTUTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:19:31 -0500
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:35094 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751000AbaLTUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:19:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3870:5007:6261:8607:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13095:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat63_6fe5e236b6d17
X-Filterd-Recvd-Size: 2220
Message-ID: <1419106766.25129.29.camel@perches.com>
Subject: [PATCH] printk: Correct timeout comment, neaten MODULE_PARM_DESC
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2014 12:19:26 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten the MODULE_PARAM_DESC message.
Use 30 seconds in the comment for the zap console locks timeout.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d..c06df7d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -935,8 +935,8 @@ static int __init ignore_loglevel_setup(char *str)
 
 early_param("ignore_loglevel", ignore_loglevel_setup);
 module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(ignore_loglevel, "ignore loglevel setting, to"
-	"print all kernel messages to the console.");
+MODULE_PARM_DESC(ignore_loglevel,
+		 "ignore loglevel setting (prints all kernel messages to the console)");
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
@@ -1419,16 +1419,16 @@ static void call_console_drivers(int level, const char *text, size_t len)
 }
 
 /*
- * Zap console related locks when oopsing. Only zap at most once
- * every 10 seconds, to leave time for slow consoles to print a
- * full oops.
+ * Zap console related locks when oopsing.
+ * To leave time for slow consoles to print a full oops,
+ * only zap at most once every 30 seconds.
  */
 static void zap_locks(void)
 {
 	static unsigned long oops_timestamp;
 
 	if (time_after_eq(jiffies, oops_timestamp) &&
-			!time_after(jiffies, oops_timestamp + 30 * HZ))
+	    !time_after(jiffies, oops_timestamp + 30 * HZ))
 		return;
 
 	oops_timestamp = jiffies;



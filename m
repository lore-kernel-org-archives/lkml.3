Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3KEUkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:40:04 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:50869 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755159Ab3KEUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:40:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3870:3872:4321:4419:4605:5007:7652:9592:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12517:12519:12555:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast23_916e1ca45125b
X-Filterd-Recvd-Size: 2651
Message-ID: <1383684000.4387.42.camel@joe-AO722>
Subject: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 05 Nov 2013 12:40:00 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wcn36xx_err macro should not end in a semicolon as
there are 2 consecutive semicolons in the preprocessed
output.

Remove it.

Neaten the logging macros to use a more common style.
Convert to use pr_debug to enable dynamic debug.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 58b6383..d157bb7 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -53,22 +53,20 @@ enum wcn36xx_debug_mask {
 	WCN36XX_DBG_ANY		= 0xffffffff,
 };
 
-#define wcn36xx_err(fmt, arg...)				\
-	printk(KERN_ERR pr_fmt("ERROR " fmt), ##arg);
-
-#define wcn36xx_warn(fmt, arg...)				\
-	printk(KERN_WARNING pr_fmt("WARNING " fmt), ##arg)
-
-#define wcn36xx_info(fmt, arg...)		\
-	printk(KERN_INFO pr_fmt(fmt), ##arg)
-
-#define wcn36xx_dbg(mask, fmt, arg...) do {			\
-	if (wcn36xx_dbg_mask & mask)					\
-		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
+#define wcn36xx_err(fmt, ...)					\
+	pr_err("ERROR " fmt, ##__VA_ARGS__)
+#define wcn36xx_warn(fmt, ...)					\
+	pr_warn("WARNING " fmt, ##__VA_ARGS__)
+#define wcn36xx_info(fmt, ...)					\
+	pr_info(fmt, ##__VA_ARGS__)
+#define wcn36xx_dbg(mask, fmt, ...)				\
+do {								\
+	if (wcn36xx_dbg_mask & mask)				\
+		pr_debug(fmt, ##__VA_ARGS__);			\
 } while (0)
-
-#define wcn36xx_dbg_dump(mask, prefix_str, buf, len) do {	\
-	if (wcn36xx_dbg_mask & mask)					\
+#define wcn36xx_dbg_dump(mask, prefix_str, buf, len)		\
+do {								\
+	if (wcn36xx_dbg_mask & mask)				\
 		print_hex_dump(KERN_DEBUG, pr_fmt(prefix_str),	\
 			       DUMP_PREFIX_OFFSET, 32, 1,	\
 			       buf, len, false);		\



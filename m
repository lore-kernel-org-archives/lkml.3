Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaIVQwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:52:23 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:34219 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753318AbaIVQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:52:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3355:3865:3866:3867:3871:4321:4605:5007:6119:7652:7903:9592:10004:10394:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:12683:13161:13229:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: play46_6ba6ccc47e753
X-Filterd-Recvd-Size: 4407
Message-ID: <1411404738.2952.39.camel@joe-AO725>
Subject: [PATCH] libata: change ata_<foo>_printk routines to return void
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 09:52:18 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not used by callers of these functions nor
by uses of all macros so change the functions to return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/ata/libata-core.c | 35 +++++++++++++----------------------
 include/linux/libata.h    | 12 ++++++------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f27dc07..b80b160 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6772,32 +6772,28 @@ const struct ata_port_info ata_dummy_port_info = {
 /*
  * Utility print functions
  */
-int ata_port_printk(const struct ata_port *ap, const char *level,
-		    const char *fmt, ...)
+void ata_port_printk(const struct ata_port *ap, const char *level,
+		     const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = printk("%sata%u: %pV", level, ap->print_id, &vaf);
+	printk("%sata%u: %pV", level, ap->print_id, &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(ata_port_printk);
 
-int ata_link_printk(const struct ata_link *link, const char *level,
-		    const char *fmt, ...)
+void ata_link_printk(const struct ata_link *link, const char *level,
+		     const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
@@ -6805,37 +6801,32 @@ int ata_link_printk(const struct ata_link *link, const char *level,
 	vaf.va = &args;
 
 	if (sata_pmp_attached(link->ap) || link->ap->slave_link)
-		r = printk("%sata%u.%02u: %pV",
-			   level, link->ap->print_id, link->pmp, &vaf);
+		printk("%sata%u.%02u: %pV",
+		       level, link->ap->print_id, link->pmp, &vaf);
 	else
-		r = printk("%sata%u: %pV",
-			   level, link->ap->print_id, &vaf);
+		printk("%sata%u: %pV",
+		       level, link->ap->print_id, &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(ata_link_printk);
 
-int ata_dev_printk(const struct ata_device *dev, const char *level,
+void ata_dev_printk(const struct ata_device *dev, const char *level,
 		    const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = printk("%sata%u.%02u: %pV",
-		   level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
-		   &vaf);
+	printk("%sata%u.%02u: %pV",
+	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
+	       &vaf);
 
 	va_end(args);
-
-	return r;
 }
 EXPORT_SYMBOL(ata_dev_printk);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 92abb49..bd5fefe 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1404,14 +1404,14 @@ static inline int sata_srst_pmp(struct ata_link *link)
  * printk helpers
  */
 __printf(3, 4)
-int ata_port_printk(const struct ata_port *ap, const char *level,
-		    const char *fmt, ...);
+void ata_port_printk(const struct ata_port *ap, const char *level,
+		     const char *fmt, ...);
 __printf(3, 4)
-int ata_link_printk(const struct ata_link *link, const char *level,
-		    const char *fmt, ...);
+void ata_link_printk(const struct ata_link *link, const char *level,
+		     const char *fmt, ...);
 __printf(3, 4)
-int ata_dev_printk(const struct ata_device *dev, const char *level,
-		   const char *fmt, ...);
+void ata_dev_printk(const struct ata_device *dev, const char *level,
+		    const char *fmt, ...);
 
 #define ata_port_err(ap, fmt, ...)				\
 	ata_port_printk(ap, KERN_ERR, fmt, ##__VA_ARGS__)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaIVRB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:01:29 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:60398 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753318AbaIVRB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:01:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1461:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:4321:4605:5007:6119:7652:7903:9592:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:13069:13161:13229:13311:13357:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coil14_298c4111ea853
X-Filterd-Recvd-Size: 2150
Message-ID: <1411405284.2952.42.camel@joe-AO725>
Subject: [PATCH] scsi: sas_ata: change ata_<foo>_printk routines to return
 void
From: Joe Perches <joe@perches.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Todd Brandt <todd.e.brandt@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Sep 2014 10:01:24 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not used by callers of this function
so change the function to return void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/scsi/libsas/sas_ata.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 766098a..2a15a54 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -375,26 +375,23 @@ static int local_ata_check_ready(struct ata_link *link)
 	}
 }
 
-static int sas_ata_printk(const char *level, const struct domain_device *ddev,
-			  const char *fmt, ...)
+static void sas_ata_printk(const char *level, const struct domain_device *ddev,
+			   const char *fmt, ...)
 {
 	struct ata_port *ap = ddev->sata_dev.ap;
 	struct device *dev = &ddev->rphy->dev;
 	struct va_format vaf;
 	va_list args;
-	int r;
 
 	va_start(args, fmt);
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = printk("%ssas: ata%u: %s: %pV",
-		   level, ap->print_id, dev_name(dev), &vaf);
+	printk("%ssas: ata%u: %s: %pV",
+	       level, ap->print_id, dev_name(dev), &vaf);
 
 	va_end(args);
-
-	return r;
 }
 
 static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab3HGSQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:16:54 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57825 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932258Ab3HGSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:16:52 -0400
Message-ID: <1375899409.7303.61.camel@x61.thuisdomein>
Subject: [PATCH] mtd: onenand: omap: remove two unused functions
From: Paul Bolle <pebolle@tiscali.nl>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Aug 2013 20:16:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Aug 2013 18:16:49.0997 (UTC) FILETIME=[490A1FD0:01CE939A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing calls omap2_onenand_rephase(). And __adjust_timing() is only
called by omap2_onenand_rephase(). Remove these two unused functions.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Completely untested.

 drivers/mtd/onenand/omap2.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index d98b198..1d43fdc 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -573,28 +573,6 @@ static int omap2_onenand_write_bufferram(struct mtd_info *mtd, int area,
 
 static struct platform_driver omap2_onenand_driver;
 
-static int __adjust_timing(struct device *dev, void *data)
-{
-	int ret = 0;
-	struct omap2_onenand *c;
-
-	c = dev_get_drvdata(dev);
-
-	BUG_ON(c->setup == NULL);
-
-	/* DMA is not in use so this is all that is needed */
-	/* Revisit for OMAP3! */
-	ret = c->setup(c->onenand.base, &c->freq);
-
-	return ret;
-}
-
-int omap2_onenand_rephase(void)
-{
-	return driver_for_each_device(&omap2_onenand_driver.driver, NULL,
-				      NULL, __adjust_timing);
-}
-
 static void omap2_onenand_shutdown(struct platform_device *pdev)
 {
 	struct omap2_onenand *c = dev_get_drvdata(&pdev->dev);
-- 
1.8.1.4


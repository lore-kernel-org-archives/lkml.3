Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaDANZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:25:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57305 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaDANZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:25:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <arnd@arndb.de>,
        <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 4/5] drivers: bus: omap_l3: Remove the platform driver's remove function
Date: Tue, 1 Apr 2014 16:23:49 +0300
Message-ID: <1396358630-32340-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396358630-32340-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is NOP after the devm_* conversion.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/bus/omap_l3_noc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 25bcb60be880..0eff48585ae3 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -173,11 +173,6 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap4_l3_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 #if defined(CONFIG_OF)
 static const struct of_device_id l3_noc_match[] = {
 	{.compatible = "ti,omap4-l3-noc", },
@@ -190,7 +185,6 @@ MODULE_DEVICE_TABLE(of, l3_noc_match);
 
 static struct platform_driver omap4_l3_driver = {
 	.probe		= omap4_l3_probe,
-	.remove		= omap4_l3_remove,
 	.driver		= {
 		.name		= "omap_l3_noc",
 		.owner		= THIS_MODULE,
-- 
1.9.1


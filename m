Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3EBMKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:10:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57204 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757522Ab3EBMKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:10:02 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH 4/5] drivers: bus: omap_l3: Remove the platform driver's remove function
Date: Thu, 2 May 2013 14:09:46 +0200
Message-ID: <1367496587-6210-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367496587-6210-1-git-send-email-peter.ujfalusi@ti.com>
References: <1367496587-6210-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is NOP after the devm_* conversion.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/bus/omap_l3_noc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 2bbc87b..ed428ad 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -177,11 +177,6 @@ static int omap4_l3_probe(struct platform_device *pdev)
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
@@ -194,7 +189,6 @@ MODULE_DEVICE_TABLE(of, l3_noc_match);
 
 static struct platform_driver omap4_l3_driver = {
 	.probe		= omap4_l3_probe,
-	.remove		= omap4_l3_remove,
 	.driver		= {
 		.name		= "omap_l3_noc",
 		.owner		= THIS_MODULE,
-- 
1.8.2.1


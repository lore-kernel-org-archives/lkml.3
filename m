Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbaCDMts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:49:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52092 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbaCDMtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:49:04 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 4/5] drivers: bus: omap_l3: Remove the platform driver's remove function
Date: Tue, 4 Mar 2014 14:48:12 +0200
Message-ID: <1393937293-6036-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393937293-6036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393937293-6036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is NOP after the devm_* conversion.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
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
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab3EPLOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:14:41 -0400
Received: from sauhun.de ([89.238.76.85]:56053 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab3EPLOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:39 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Deepak Saxena <dsaxena@plexity.net>
Subject: [PATCH 02/33] drivers/char/hw_random: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:30 +0200
Message-Id: <1368702961-4325-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/char/hw_random/mxc-rnga.c |    6 ------
 drivers/char/hw_random/omap-rng.c |    5 -----
 2 files changed, 11 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index 4ca35e8..19a12ac 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -167,11 +167,6 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	clk_prepare_enable(mxc_rng->clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -ENOENT;
-		goto err_region;
-	}
-
 	mxc_rng->mem = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(mxc_rng->mem)) {
 		err = PTR_ERR(mxc_rng->mem);
@@ -189,7 +184,6 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	return 0;
 
 err_ioremap:
-err_region:
 	clk_disable_unprepare(mxc_rng->clk);
 
 out:
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 749dc16..d2903e7 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -119,11 +119,6 @@ static int omap_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 
 	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!priv->mem_res) {
-		ret = -ENOENT;
-		goto err_ioremap;
-	}
-
 	priv->base = devm_ioremap_resource(&pdev->dev, priv->mem_res);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
-- 
1.7.10.4


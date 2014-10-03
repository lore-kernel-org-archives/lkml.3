Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaJCP7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:59:25 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54292 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaJCPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:55:57 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] mmc: sdhci-pxav2: Drop unused struct sdhci_pxa
Date: Fri,  3 Oct 2014 17:55:36 +0200
Message-Id: <1412351747-4188-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1412351747-4188-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sdhci_pxa is private data of PXA SDHCI driver, but not used in
sdhci-pxav2 at all. Drop unused references to struct sdhci_pxa.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav2.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index b4c23e983baf..f98008b5ea77 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -167,23 +167,17 @@ static int sdhci_pxav2_probe(struct platform_device *pdev)
 	struct sdhci_pxa_platdata *pdata = pdev->dev.platform_data;
 	struct device *dev = &pdev->dev;
 	struct sdhci_host *host = NULL;
-	struct sdhci_pxa *pxa = NULL;
 	const struct of_device_id *match;
 
 	int ret;
 	struct clk *clk;
 
-	pxa = kzalloc(sizeof(struct sdhci_pxa), GFP_KERNEL);
-	if (!pxa)
-		return -ENOMEM;
-
 	host = sdhci_pltfm_init(pdev, NULL, 0);
-	if (IS_ERR(host)) {
-		kfree(pxa);
+	if (IS_ERR(host))
 		return PTR_ERR(host);
-	}
+
 	pltfm_host = sdhci_priv(host);
-	pltfm_host->priv = pxa;
+	pltfm_host->priv = NULL;
 
 	clk = clk_get(dev, "PXA-SDHCLK");
 	if (IS_ERR(clk)) {
@@ -238,7 +232,6 @@ err_add_host:
 	clk_put(clk);
 err_clk_get:
 	sdhci_pltfm_free(pdev);
-	kfree(pxa);
 	return ret;
 }
 
@@ -246,14 +239,12 @@ static int sdhci_pxav2_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct sdhci_pxa *pxa = pltfm_host->priv;
 
 	sdhci_remove_host(host, 1);
 
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	sdhci_pltfm_free(pdev);
-	kfree(pxa);
 
 	return 0;
 }
-- 
2.1.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbaHHPca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:32:30 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:51786 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaHHPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:32:28 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] mmc: sdhci-pxav3: Remove unused variable in sdhci_pxav3_remove()
Date: Fri,  8 Aug 2014 17:32:11 +0200
Message-Id: <1407511931-26712-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8f69e585ca3ad324ea57e113bff06d366dfa010e ("mmc: sdhci-pxav3: Use
devm_* managed helpers") removed the later user of pxa:

drivers/mmc/host/sdhci-pxav3.c: In function 'sdhci_pxav3_remove':
drivers/mmc/host/sdhci-pxav3.c:400:20: warning: unused variable 'pxa' [-Wunused-variable]
  struct sdhci_pxa *pxa = pltfm_host->priv;
                    ^

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/mmc/host/sdhci-pxav3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 527dfa3faeab..6f842fb8e6b8 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -397,7 +397,6 @@ static int sdhci_pxav3_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	struct sdhci_pxa *pxa = pltfm_host->priv;
 
 	pm_runtime_get_sync(&pdev->dev);
 	sdhci_remove_host(host, 1);
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaJWLbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:31:36 -0400
Received: from atl4mhob16.myregisteredsite.com ([209.17.115.109]:44789 "EHLO
	atl4mhob16.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbaJWLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:31:33 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: michal.simek@xilinx.com, chris@printf.net, ulf.hansson@linaro.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH 1/2] mmc/host/sdhci-of-arasan.c: Use signed formatting in error messages
Date: Thu, 23 Oct 2014 13:31:00 +0200
Message-Id: <1414063861-5491-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret" is a signed int, so use "%d" in format strings instead of "%u".
This prevents cryptic codes in error messages like this:
sdhci-arasan e0101000.sdhci: platform register failed (4294966779)

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/mmc/host/sdhci-of-arasan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 8cf81c3..7ac6718 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -161,7 +161,7 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
-		dev_err(&pdev->dev, "platform init failed (%u)\n", ret);
+		dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
 		goto clk_disable_all;
 	}
 
@@ -172,7 +172,7 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 
 	ret = sdhci_add_host(host);
 	if (ret) {
-		dev_err(&pdev->dev, "platform register failed (%u)\n", ret);
+		dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
 		goto err_pltfm_free;
 	}
 
-- 
1.7.9.5


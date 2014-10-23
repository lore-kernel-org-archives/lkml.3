Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaJWLby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:31:54 -0400
Received: from atl4mhob01.myregisteredsite.com ([209.17.115.39]:40831 "EHLO
	atl4mhob01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbaJWLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:31:34 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: michal.simek@xilinx.com, chris@printf.net, ulf.hansson@linaro.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH 2/2] mmc/host/sdhci-of-arasan.c: Skip EPROBE_DEFER error messages
Date: Thu, 23 Oct 2014 13:31:01 +0200
Message-Id: <1414063861-5491-2-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414063861-5491-1-git-send-email-mike.looijmans@topic.nl>
References: <1414063861-5491-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the error code is -EPROBE_DEFER, this will already be reported
so don't emit an error message in that case.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/mmc/host/sdhci-of-arasan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 7ac6718..d5812a0 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -161,7 +161,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
-		dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
 		goto clk_disable_all;
 	}
 
@@ -172,7 +173,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 
 	ret = sdhci_add_host(host);
 	if (ret) {
-		dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
 		goto err_pltfm_free;
 	}
 
-- 
1.7.9.5


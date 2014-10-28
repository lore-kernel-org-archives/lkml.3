Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbaJ1Hxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:53:34 -0400
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:44429 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760921AbaJ1Hx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:53:29 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, michal.simek@xilinx.com, chris@printf.net,
        ulf.hansson@linaro.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] mmc/host/sdhci-of-arasan.c: Omit superfluous error messages
Date: Tue, 28 Oct 2014 08:53:21 +0100
Message-Id: <1414482801-3773-2-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414482801-3773-1-git-send-email-mike.looijmans@topic.nl>
References: <CAPDyKFpuiPqZ+5h-SS2-7XeVVh4J2v3SQr=RtjaTZw=0=bXABw@mail.gmail.com>
 <1414482801-3773-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdhci_add_host and sdhci_platfm_init already report failure,
so don't emit error messages when a failure occurs. This prevents
occurences of "deferred" messages when required power supplies
are not ready for operation yet.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/mmc/host/sdhci-of-arasan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 7ac6718..75bea2e 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -161,7 +161,6 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	host = sdhci_pltfm_init(pdev, &sdhci_arasan_pdata, 0);
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
-		dev_err(&pdev->dev, "platform init failed (%d)\n", ret);
 		goto clk_disable_all;
 	}
 
@@ -171,10 +170,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	pltfm_host->clk = clk_xin;
 
 	ret = sdhci_add_host(host);
-	if (ret) {
-		dev_err(&pdev->dev, "platform register failed (%d)\n", ret);
+	if (ret)
 		goto err_pltfm_free;
-	}
 
 	return 0;
 
-- 
1.7.9.5


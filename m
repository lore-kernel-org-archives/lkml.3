Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3EPLPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:19 -0400
Received: from sauhun.de ([89.238.76.85]:56165 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3EPLPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:10 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org
Subject: [PATCH 17/33] drivers/spi: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:45 +0200
Message-Id: <1368702961-4325-18-git-send-email-wsa@the-dreams.de>
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
 drivers/spi/spi-tegra20-sflash.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index d65c000..09df8e2 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -489,11 +489,6 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 	tegra_sflash_parse_dt(tsd);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
-	}
 	tsd->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(tsd->base)) {
 		ret = PTR_ERR(tsd->base);
-- 
1.7.10.4


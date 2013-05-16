Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3EPLYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:24:23 -0400
Received: from sauhun.de ([89.238.76.85]:56095 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3EPLOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:14:49 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH 08/33] drivers/i2c/busses: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:36 +0200
Message-Id: <1368702961-4325-9-git-send-email-wsa@the-dreams.de>
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
 drivers/i2c/busses/i2c-s3c2410.c |    5 -----
 drivers/i2c/busses/i2c-sirf.c    |    6 ------
 drivers/i2c/busses/i2c-tegra.c   |    5 -----
 3 files changed, 16 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index 6e8ee92..cab1c91 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1082,11 +1082,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	/* map the registers */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
 	i2c->regs = devm_ioremap_resource(&pdev->dev, res);
 
 	if (IS_ERR(i2c->regs))
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 5a7ad24..a63c7d5 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -303,12 +303,6 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 	adap->class = I2C_CLASS_HWMON;
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem_res == NULL) {
-		dev_err(&pdev->dev, "Unable to get MEM resource\n");
-		err = -EINVAL;
-		goto out;
-	}
-
 	siic->base = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(siic->base)) {
 		err = PTR_ERR(siic->base);
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index b60ff90..9aa1b60 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -714,11 +714,6 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no mem resource\n");
-		return -EINVAL;
-	}
-
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3EPLW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:22:28 -0400
Received: from sauhun.de ([89.238.76.85]:56156 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3EPLPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:08 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        linux-tegra@vger.kernel.org
Subject: [PATCH 16/33] drivers/rtc: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:44 +0200
Message-Id: <1368702961-4325-17-git-send-email-wsa@the-dreams.de>
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
 drivers/rtc/rtc-nuc900.c |    5 -----
 drivers/rtc/rtc-omap.c   |    5 -----
 drivers/rtc/rtc-s3c.c    |    5 -----
 drivers/rtc/rtc-tegra.c  |    6 ------
 4 files changed, 21 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index f5dfb6e..d592e2f 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -234,11 +234,6 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "platform_get_resource failed\n");
-		return -ENXIO;
-	}
-
 	nuc900_rtc->rtc_reg = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_rtc->rtc_reg))
 		return PTR_ERR(nuc900_rtc->rtc_reg);
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 4e1bdb8..b0ba3fc 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -347,11 +347,6 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		pr_debug("%s: RTC resource data missing\n", pdev->name);
-		return -ENOENT;
-	}
-
 	rtc_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(rtc_base))
 		return PTR_ERR(rtc_base);
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 14040b2..0b495e8 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -477,11 +477,6 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	/* get the memory region */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get memory region resource\n");
-		return -ENOENT;
-	}
-
 	s3c_rtc_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(s3c_rtc_base))
 		return PTR_ERR(s3c_rtc_base);
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index a34315d..76af92a 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -322,12 +322,6 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev,
-			"Unable to allocate resources for device.\n");
-		return -EBUSY;
-	}
-
 	info->rtc_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(info->rtc_base))
 		return PTR_ERR(info->rtc_base);
-- 
1.7.10.4


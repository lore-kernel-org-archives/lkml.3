Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3GWSDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:31 -0400
Received: from sauhun.de ([89.238.76.85]:58741 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934039Ab3GWSD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:28 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 14/27] drivers/pinctrl: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:47 +0200
Message-Id: <1374602524-3398-15-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/pinctrl/pinctrl-imx.c      |    3 ---
 drivers/pinctrl/pinctrl-rockchip.c |    5 -----
 drivers/pinctrl/pinctrl-u300.c     |    3 ---
 3 files changed, 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 57a4eb0..dea739a 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -580,9 +580,6 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
 	ipctl->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ipctl->base))
 		return PTR_ERR(ipctl->base);
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 1eb5a2e..6c88837 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1270,11 +1270,6 @@ static int rockchip_pinctrl_probe(struct platform_device *pdev)
 	info->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
 	info->reg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(info->reg_base))
 		return PTR_ERR(info->reg_base);
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 46a152d..6fbdc06 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1075,9 +1075,6 @@ static int u300_pmx_probe(struct platform_device *pdev)
 	upmx->dev = &pdev->dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
 	upmx->virtbase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(upmx->virtbase))
 		return PTR_ERR(upmx->virtbase);
-- 
1.7.10.4


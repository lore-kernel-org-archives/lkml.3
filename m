Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaA1AqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:46:24 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:51745 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbaA1AqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:46:17 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/21] pinctrl: mvebu: remove base address from common driver
Date: Tue, 28 Jan 2014 01:39:26 +0100
Message-Id: <1390869573-27624-15-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common pinctrl driver does not need to know about any addresses now,
so remove anything related to it from our pinctrl drivers.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c | 2 +-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  | 2 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c       | 2 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   | 2 +-
 drivers/pinctrl/mvebu/pinctrl-mvebu.c      | 9 +--------
 drivers/pinctrl/mvebu/pinctrl-mvebu.h      | 2 +-
 6 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index 5e8e83f57b8e..7e2f0f694210 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -428,7 +428,7 @@ static int armada_370_pinctrl_probe(struct platform_device *pdev)
 
 	pdev->dev.platform_data = soc;
 
-	return mvebu_pinctrl_probe(pdev, mpp_base);
+	return mvebu_pinctrl_probe(pdev);
 }
 
 static int armada_370_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index 5cfa00cae490..678a8078d100 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -475,7 +475,7 @@ static int armada_xp_pinctrl_probe(struct platform_device *pdev)
 
 	pdev->dev.platform_data = soc;
 
-	return mvebu_pinctrl_probe(pdev, mpp_base);
+	return mvebu_pinctrl_probe(pdev);
 }
 
 static int armada_xp_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index cd55f2ca4e8a..98f8cae72ace 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -822,7 +822,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	return mvebu_pinctrl_probe(pdev, mpp_base);
+	return mvebu_pinctrl_probe(pdev);
 }
 
 static int dove_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index 2872f28057fb..9e80e2fe0bda 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -492,7 +492,7 @@ static int kirkwood_pinctrl_probe(struct platform_device *pdev)
 		return PTR_ERR(mpp_base);
 
 	pdev->dev.platform_data = (void *)match->data;
-	return mvebu_pinctrl_probe(pdev, mpp_base);
+	return mvebu_pinctrl_probe(pdev);
 }
 
 static int kirkwood_pinctrl_remove(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index dd65b8c44b26..7c9533b8b527 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -50,7 +50,6 @@ struct mvebu_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctldev;
 	struct pinctrl_desc desc;
-	void __iomem *base;
 	struct mvebu_pinctrl_group *groups;
 	unsigned num_groups;
 	struct mvebu_pinctrl_function *functions;
@@ -546,7 +545,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 	return 0;
 }
 
-int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base)
+int mvebu_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
 	struct mvebu_pinctrl *pctl;
@@ -554,11 +553,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base)
 	unsigned gid, n, k;
 	int ret;
 
-	if (!base) {
-		dev_err(&pdev->dev, "missing base address\n");
-		return -EINVAL;
-	}
-
 	if (!soc || !soc->controls || !soc->modes) {
 		dev_err(&pdev->dev, "wrong pinctrl soc info\n");
 		return -EINVAL;
@@ -577,7 +571,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base)
 	pctl->desc.pmxops = &mvebu_pinmux_ops;
 	pctl->desc.confops = &mvebu_pinconf_ops;
 	pctl->variant = soc->variant;
-	pctl->base = base;
 	pctl->dev = &pdev->dev;
 	platform_set_drvdata(pdev, pctl);
 
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.h b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
index 6c8451af95b6..5d3093673e48 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.h
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.h
@@ -178,7 +178,7 @@ struct mvebu_pinctrl_soc_info {
 #define MVEBU_MPP_BITS		4
 #define MVEBU_MPP_MASK		0xf
 
-int mvebu_pinctrl_probe(struct platform_device *pdev, void __iomem *base);
+int mvebu_pinctrl_probe(struct platform_device *pdev);
 int mvebu_pinctrl_remove(struct platform_device *pdev);
 
 #endif
-- 
1.8.5.2


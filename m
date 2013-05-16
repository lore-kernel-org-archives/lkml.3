Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3EPLPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:32 -0400
Received: from sauhun.de ([89.238.76.85]:56232 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3EPLP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:27 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 24/33] drivers/usb/phy: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:52 +0200
Message-Id: <1368702961-4325-25-git-send-email-wsa@the-dreams.de>
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
 drivers/usb/phy/phy-mv-u3d-usb.c   |    5 -----
 drivers/usb/phy/phy-mxs-usb.c      |    5 -----
 drivers/usb/phy/phy-samsung-usb2.c |    5 -----
 drivers/usb/phy/phy-samsung-usb3.c |    5 -----
 4 files changed, 20 deletions(-)

diff --git a/drivers/usb/phy/phy-mv-u3d-usb.c b/drivers/usb/phy/phy-mv-u3d-usb.c
index f7838a4..1568ea6 100644
--- a/drivers/usb/phy/phy-mv-u3d-usb.c
+++ b/drivers/usb/phy/phy-mv-u3d-usb.c
@@ -278,11 +278,6 @@ static int mv_u3d_phy_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "missing mem resource\n");
-		return -ENODEV;
-	}
-
 	phy_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(phy_base))
 		return PTR_ERR(phy_base);
diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
index 9d4381e..eb25dd2 100644
--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -130,11 +130,6 @@ static int mxs_phy_probe(struct platform_device *pdev)
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't get device resources\n");
-		return -ENOENT;
-	}
-
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 45ffe03..9d5e273 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -363,11 +363,6 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!phy_mem) {
-		dev_err(dev, "%s: missing mem resource\n", __func__);
-		return -ENODEV;
-	}
-
 	phy_base = devm_ioremap_resource(dev, phy_mem);
 	if (IS_ERR(phy_base))
 		return PTR_ERR(phy_base);
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 133f3d0..5a9efcb 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -239,11 +239,6 @@ static int samsung_usb3phy_probe(struct platform_device *pdev)
 	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!phy_mem) {
-		dev_err(dev, "%s: missing mem resource\n", __func__);
-		return -ENODEV;
-	}
-
 	phy_base = devm_ioremap_resource(dev, phy_mem);
 	if (IS_ERR(phy_base))
 		return PTR_ERR(phy_base);
-- 
1.7.10.4


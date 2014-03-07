Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaCGNJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:09:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55864 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaCGNJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:09:50 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 4/8] phy: omap-usb2: Use generic clock names "wkupclk" and "refclk"
Date: Fri, 7 Mar 2014 15:09:07 +0200
Message-ID: <1394197751-28984-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As clocks might be named differently on multiple platforms, use a generic
name in the driver and allow device tree node to specify the platform
specific clock name.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-omap-usb2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index a2205a8..fb5e515 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -275,16 +275,16 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	if (IS_ERR(phy_provider))
 		return PTR_ERR(phy_provider);
 
-	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
+	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
 	if (IS_ERR(phy->wkupclk)) {
-		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
+		dev_err(&pdev->dev, "unable to get wkupclk\n");
 		return PTR_ERR(phy->wkupclk);
 	}
 	clk_prepare(phy->wkupclk);
 
-	phy->optclk = devm_clk_get(phy->dev, "usb_otg_ss_refclk960m");
+	phy->optclk = devm_clk_get(phy->dev, "refclk");
 	if (IS_ERR(phy->optclk))
-		dev_vdbg(&pdev->dev, "unable to get refclk960m\n");
+		dev_dbg(&pdev->dev, "unable to get refclk\n");
 	else
 		clk_prepare(phy->optclk);
 
-- 
1.8.3.2


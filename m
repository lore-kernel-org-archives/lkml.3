Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3F1Vib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:38:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17558 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3F1ViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:38:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Jun 2013 14:36:00 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 6/9] usb: host: tegra: Locate a PHY via standard API
Date: Sat, 29 Jun 2013 00:37:04 +0300
Message-ID: <1372455427-20898-7-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_get_phy_by_phandle to get a PHY device instead of the custom
Tegra functions.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index a208cea..db8031f 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -328,7 +328,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	struct tegra_ehci_hcd *tegra;
 	int err = 0;
 	int irq;
-	struct device_node *np_phy;
 	struct usb_phy *u_phy;
 
 	/* Right now device-tree probed devices don't get dma_mask set.
@@ -367,13 +366,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	udelay(1);
 	tegra_periph_reset_deassert(tegra->clk);
 
-	np_phy = of_parse_phandle(pdev->dev.of_node, "nvidia,phy", 0);
-	if (!np_phy) {
-		err = -ENODEV;
-		goto cleanup_clk_en;
-	}
-
-	u_phy = tegra_usb_get_phy(np_phy);
+	u_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "nvidia,phy", 0);
 	if (IS_ERR(u_phy)) {
 		err = PTR_ERR(u_phy);
 		goto cleanup_clk_en;
-- 
1.8.1.5


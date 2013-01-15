Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3AOKTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:19:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6314 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3AOKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:19:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 15 Jan 2013 02:18:30 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] usb: phy: remove unused APIs from Tegra PHY.
Date: Tue, 15 Jan 2013 15:49:30 +0530
Message-ID: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As tegra_usb_phy_clk_disable/enable() are not being
used, removing them.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/tegra_usb_phy.c   |   13 -------------
 include/linux/usb/tegra_usb_phy.h |    4 ----
 2 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 2d3cae9..3059384 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -825,16 +825,3 @@ void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy)
 }
 EXPORT_SYMBOL_GPL(tegra_ehci_phy_restore_end);
 
-void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_disable(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_disable);
-
-void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy)
-{
-	if (!phy_is_ulpi(phy))
-		utmi_phy_clk_enable(phy);
-}
-EXPORT_SYMBOL_GPL(tegra_usb_phy_clk_enable);
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 176b1ca..34e6355 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -64,10 +64,6 @@ struct tegra_usb_phy {
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
 
-void tegra_usb_phy_clk_disable(struct tegra_usb_phy *phy);
-
-void tegra_usb_phy_clk_enable(struct tegra_usb_phy *phy);
-
 void tegra_usb_phy_preresume(struct tegra_usb_phy *phy);
 
 void tegra_usb_phy_postresume(struct tegra_usb_phy *phy);
-- 
1.7.0.4


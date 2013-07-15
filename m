Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3GOTyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:54:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11142 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3GOTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:54:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 15 Jul 2013 12:54:16 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v2 7/9] usb: phy: tegra: Remove custom PHY locating APIs
Date: Mon, 15 Jul 2013 22:53:47 +0300
Message-ID: <1373918029-28977-8-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra EHCI driver is no longer using these custom functions, so they
can be removed.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c   | 24 ------------------------
 include/linux/usb/tegra_usb_phy.h |  2 --
 2 files changed, 26 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 8397206..0d48f4e 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -967,29 +967,5 @@ static struct platform_driver tegra_usb_phy_driver = {
 };
 module_platform_driver(tegra_usb_phy_driver);
 
-static int tegra_usb_phy_match(struct device *dev, void *data)
-{
-	struct tegra_usb_phy *tegra_phy = dev_get_drvdata(dev);
-	struct device_node *dn = data;
-
-	return (tegra_phy->u_phy.dev->of_node == dn) ? 1 : 0;
-}
-
-struct usb_phy *tegra_usb_get_phy(struct device_node *dn)
-{
-	struct device *dev;
-	struct tegra_usb_phy *tegra_phy;
-
-	dev = driver_find_device(&tegra_usb_phy_driver.driver, NULL, dn,
-				 tegra_usb_phy_match);
-	if (!dev)
-		return ERR_PTR(-EPROBE_DEFER);
-
-	tegra_phy = dev_get_drvdata(dev);
-
-	return &tegra_phy->u_phy;
-}
-EXPORT_SYMBOL_GPL(tegra_usb_get_phy);
-
 MODULE_DESCRIPTION("Tegra USB PHY driver");
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 8474153..a095c98 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -60,8 +60,6 @@ struct tegra_usb_phy {
 	int reset_gpio;
 };
 
-struct usb_phy *tegra_usb_get_phy(struct device_node *dn);
-
 void tegra_usb_phy_preresume(struct usb_phy *phy);
 
 void tegra_usb_phy_postresume(struct usb_phy *phy);
-- 
1.8.1.5


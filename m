Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab3GYTYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:24:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9564 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3GYTYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:24:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 25 Jul 2013 12:24:24 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] usb: phy: tegra: Use switch instead of if-else
Date: Thu, 25 Jul 2013 22:24:09 +0300
Message-ID: <1374780249-22207-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130725191734.GB26858@radagast>
References: <20130725191734.GB26858@radagast>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use switch() instead of if-else when checking for the PHY type.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
Ah :). Here.

 drivers/usb/phy/phy-tegra-usb.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 01c30ff..49fa2da 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -887,11 +887,14 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
 
 	phy_type = of_usb_get_phy_mode(np);
-	if (phy_type == USBPHY_INTERFACE_MODE_UTMI) {
+	switch (phy_type) {
+	case USBPHY_INTERFACE_MODE_UTMI:
 		err = utmi_phy_probe(tegra_phy, pdev);
 		if (err < 0)
 			return err;
-	} else if (phy_type == USBPHY_INTERFACE_MODE_ULPI) {
+		break;
+
+	case USBPHY_INTERFACE_MODE_ULPI:
 		tegra_phy->is_ulpi_phy = true;
 
 		tegra_phy->reset_gpio =
@@ -902,7 +905,9 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 			return tegra_phy->reset_gpio;
 		}
 		tegra_phy->config = NULL;
-	} else {
+		break;
+
+	default:
 		dev_err(&pdev->dev, "phy_type is invalid or unsupported\n");
 		return -EINVAL;
 	}
-- 
1.8.1.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaIXJvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:51:43 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:55455 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbaIXJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:51:39 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: kishon@ti.com, kgene.kim@samsung.com, k.debski@samsung.com,
        maxime.ripard@free-electrons.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 4/5] Phy: Remove .owner field for driver
Date: Wed, 24 Sep 2014 15:19:17 +0530
Message-Id: <1411552158-27928-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superflous .owner field for drivers which
use the module_platform_driver API, as this is overriden in
platform_driver_register anyway."

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/phy/phy-bcm-kona-usb2.c     |    1 -
 drivers/phy/phy-berlin-sata.c       |    1 -
 drivers/phy/phy-exynos-dp-video.c   |    1 -
 drivers/phy/phy-exynos-mipi-video.c |    1 -
 drivers/phy/phy-exynos5-usbdrd.c    |    1 -
 drivers/phy/phy-exynos5250-sata.c   |    1 -
 drivers/phy/phy-hix5hd2-sata.c      |    1 -
 drivers/phy/phy-miphy365x.c         |    1 -
 drivers/phy/phy-mvebu-sata.c        |    1 -
 drivers/phy/phy-omap-usb2.c         |    1 -
 drivers/phy/phy-qcom-apq8064-sata.c |    1 -
 drivers/phy/phy-qcom-ipq806x-sata.c |    1 -
 drivers/phy/phy-samsung-usb2.c      |    1 -
 drivers/phy/phy-sun4i-usb.c         |    1 -
 drivers/phy/phy-ti-pipe3.c          |    1 -
 drivers/phy/phy-xgene.c             |    1 -
 16 files changed, 16 deletions(-)

diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
index 894fe74..c1e0ca3 100644
--- a/drivers/phy/phy-bcm-kona-usb2.c
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -143,7 +143,6 @@ static struct platform_driver bcm_kona_usb2_driver = {
 	.probe		= bcm_kona_usb2_probe,
 	.driver		= {
 		.name	= "bcm-kona-usb2",
-		.owner	= THIS_MODULE,
 		.of_match_table = bcm_kona_usb2_dt_ids,
 	},
 };
diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index 5c3a042..69ced52 100644
--- a/drivers/phy/phy-berlin-sata.c
+++ b/drivers/phy/phy-berlin-sata.c
@@ -273,7 +273,6 @@ static struct platform_driver phy_berlin_sata_driver = {
 	.probe	= phy_berlin_sata_probe,
 	.driver	= {
 		.name		= "phy-berlin-sata",
-		.owner		= THIS_MODULE,
 		.of_match_table	= phy_berlin_sata_of_match,
 	},
 };
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
index 8b3026e..5c6e513 100644
--- a/drivers/phy/phy-exynos-dp-video.c
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -99,7 +99,6 @@ static struct platform_driver exynos_dp_video_phy_driver = {
 	.probe	= exynos_dp_video_phy_probe,
 	.driver = {
 		.name	= "exynos-dp-video-phy",
-		.owner	= THIS_MODULE,
 		.of_match_table	= exynos_dp_video_phy_of_match,
 	}
 };
diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
index b55a92e..6a9bef1 100644
--- a/drivers/phy/phy-exynos-mipi-video.c
+++ b/drivers/phy/phy-exynos-mipi-video.c
@@ -165,7 +165,6 @@ static struct platform_driver exynos_mipi_video_phy_driver = {
 	.driver = {
 		.of_match_table	= exynos_mipi_video_phy_of_match,
 		.name  = "exynos-mipi-video-phy",
-		.owner = THIS_MODULE,
 	}
 };
 module_platform_driver(exynos_mipi_video_phy_driver);
diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 392101c..f756aca 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -667,7 +667,6 @@ static struct platform_driver exynos5_usb3drd_phy = {
 	.driver = {
 		.of_match_table	= exynos5_usbdrd_phy_of_match,
 		.name		= "exynos5_usb3drd_phy",
-		.owner		= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
index 19a679a..54cf4ae 100644
--- a/drivers/phy/phy-exynos5250-sata.c
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -240,7 +240,6 @@ static struct platform_driver exynos_sata_phy_driver = {
 	.driver = {
 		.of_match_table	= exynos_sata_phy_of_match,
 		.name  = "samsung,sata-phy",
-		.owner = THIS_MODULE,
 	}
 };
 module_platform_driver(exynos_sata_phy_driver);
diff --git a/drivers/phy/phy-hix5hd2-sata.c b/drivers/phy/phy-hix5hd2-sata.c
index 6a08fa5..d5d9780 100644
--- a/drivers/phy/phy-hix5hd2-sata.c
+++ b/drivers/phy/phy-hix5hd2-sata.c
@@ -180,7 +180,6 @@ static struct platform_driver hix5hd2_sata_phy_driver = {
 	.probe	= hix5hd2_sata_phy_probe,
 	.driver = {
 		.name	= "hix5hd2-sata-phy",
-		.owner	= THIS_MODULE,
 		.of_match_table	= hix5hd2_sata_phy_of_match,
 	}
 };
diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
index e0fb7a1..801afaf 100644
--- a/drivers/phy/phy-miphy365x.c
+++ b/drivers/phy/phy-miphy365x.c
@@ -626,7 +626,6 @@ static struct platform_driver miphy365x_driver = {
 	.probe	= miphy365x_probe,
 	.driver = {
 		.name	= "miphy365x-phy",
-		.owner	= THIS_MODULE,
 		.of_match_table	= miphy365x_of_match,
 	}
 };
diff --git a/drivers/phy/phy-mvebu-sata.c b/drivers/phy/phy-mvebu-sata.c
index cc3c0e1..bb0b3b8 100644
--- a/drivers/phy/phy-mvebu-sata.c
+++ b/drivers/phy/phy-mvebu-sata.c
@@ -126,7 +126,6 @@ static struct platform_driver phy_mvebu_sata_driver = {
 	.probe	= phy_mvebu_sata_probe,
 	.driver = {
 		.name	= "phy-mvebu-sata",
-		.owner	= THIS_MODULE,
 		.of_match_table	= phy_mvebu_sata_of_match,
 	}
 };
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 93d7835..37cbf67 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -382,7 +382,6 @@ static struct platform_driver omap_usb2_driver = {
 	.remove		= omap_usb2_remove,
 	.driver		= {
 		.name	= "omap-usb2",
-		.owner	= THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 		.of_match_table = of_match_ptr(omap_usb2_id_table),
 	},
diff --git a/drivers/phy/phy-qcom-apq8064-sata.c b/drivers/phy/phy-qcom-apq8064-sata.c
index b3ef7d8..7b3ddfb 100644
--- a/drivers/phy/phy-qcom-apq8064-sata.c
+++ b/drivers/phy/phy-qcom-apq8064-sata.c
@@ -279,7 +279,6 @@ static struct platform_driver qcom_apq8064_sata_phy_driver = {
 	.remove	= qcom_apq8064_sata_phy_remove,
 	.driver = {
 		.name	= "qcom-apq8064-sata-phy",
-		.owner	= THIS_MODULE,
 		.of_match_table	= qcom_apq8064_sata_phy_of_match,
 	}
 };
diff --git a/drivers/phy/phy-qcom-ipq806x-sata.c b/drivers/phy/phy-qcom-ipq806x-sata.c
index 909b5a8..759b0bf 100644
--- a/drivers/phy/phy-qcom-ipq806x-sata.c
+++ b/drivers/phy/phy-qcom-ipq806x-sata.c
@@ -201,7 +201,6 @@ static struct platform_driver qcom_ipq806x_sata_phy_driver = {
 	.remove	= qcom_ipq806x_sata_phy_remove,
 	.driver = {
 		.name	= "qcom-ipq806x-sata-phy",
-		.owner	= THIS_MODULE,
 		.of_match_table	= qcom_ipq806x_sata_phy_of_match,
 	}
 };
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 3732ca2..908949d 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -231,7 +231,6 @@ static struct platform_driver samsung_usb2_phy_driver = {
 	.driver = {
 		.of_match_table	= samsung_usb2_phy_of_match,
 		.name		= "samsung-usb2-phy",
-		.owner		= THIS_MODULE,
 	}
 };
 
diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 61ebea4..0baf5ef 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -325,7 +325,6 @@ static struct platform_driver sun4i_usb_phy_driver = {
 	.driver = {
 		.of_match_table	= sun4i_usb_phy_of_match,
 		.name  = "sun4i-usb-phy",
-		.owner = THIS_MODULE,
 	}
 };
 module_platform_driver(sun4i_usb_phy_driver);
diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index b964aa9..561dcd4 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -519,7 +519,6 @@ static struct platform_driver ti_pipe3_driver = {
 	.remove		= ti_pipe3_remove,
 	.driver		= {
 		.name	= "ti-pipe3",
-		.owner	= THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 		.of_match_table = of_match_ptr(ti_pipe3_id_table),
 	},
diff --git a/drivers/phy/phy-xgene.c b/drivers/phy/phy-xgene.c
index db809b9..f8a51b1 100644
--- a/drivers/phy/phy-xgene.c
+++ b/drivers/phy/phy-xgene.c
@@ -1738,7 +1738,6 @@ static struct platform_driver xgene_phy_driver = {
 	.probe = xgene_phy_probe,
 	.driver = {
 		   .name = "xgene-phy",
-		   .owner = THIS_MODULE,
 		   .of_match_table = xgene_phy_of_match,
 	},
 };
-- 
1.7.9.5


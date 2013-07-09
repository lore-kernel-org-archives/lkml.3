Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3GIPte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:49:34 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50749 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab3GIPsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:08 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 5/7] usb: phy: msm: Fix WARNING: quoted string split across lines
Date: Tue,  9 Jul 2013 18:47:11 +0300
Message-Id: <1373384833-18077-6-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This fixes checkpatch.pl warnings.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 0e7d7ab..41938e6 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -67,8 +67,7 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 				USB_PHY_VDD_DIG_VOL_MIN,
 				USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret) {
-			dev_err(motg->phy.dev, "unable to set the voltage "
-					"for hsusb vddcx\n");
+			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 			return ret;
 		}
 
@@ -79,8 +78,7 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 		ret = regulator_set_voltage(motg->vddcx, 0,
 			USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret)
-			dev_err(motg->phy.dev, "unable to set the voltage "
-					"for hsusb vddcx\n");
+			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 		ret = regulator_disable(motg->vddcx);
 		if (ret)
 			dev_err(motg->phy.dev, "unable to disable hsusb vddcx\n");
@@ -97,8 +95,7 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 		rc = regulator_set_voltage(motg->v3p3, USB_PHY_3P3_VOL_MIN,
 				USB_PHY_3P3_VOL_MAX);
 		if (rc) {
-			dev_err(motg->phy.dev, "unable to set voltage level "
-					"for hsusb 3p3\n");
+			dev_err(motg->phy.dev, "Cannot set v3p3 voltage\n");
 			return rc;
 		}
 		rc = regulator_enable(motg->v3p3);
@@ -110,8 +107,7 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 		rc = regulator_set_voltage(motg->v1p8, USB_PHY_1P8_VOL_MIN,
 				USB_PHY_1P8_VOL_MAX);
 		if (rc) {
-			dev_err(motg->phy.dev, "unable to set voltage level "
-					"for hsusb 1p8\n");
+			dev_err(motg->phy.dev, "Cannot set v1p8 voltage\n");
 			goto disable_3p3;
 		}
 		rc = regulator_enable(motg->v1p8);
@@ -144,8 +140,7 @@ static int msm_hsusb_config_vddcx(struct msm_otg *motg, int high)
 
 	ret = regulator_set_voltage(motg->vddcx, min_vol, max_vol);
 	if (ret) {
-		pr_err("%s: unable to set the voltage for regulator "
-			"HSUSB_VDDCX\n", __func__);
+		dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 		return ret;
 	}
 
@@ -163,15 +158,13 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
 		ret = regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_HPM_LOAD);
 		if (ret < 0) {
-			pr_err("%s: Unable to set HPM of the regulator "
-				"HSUSB_1p8\n", __func__);
+			pr_err("Could not set HPM for v1p8\n");
 			return ret;
 		}
 		ret = regulator_set_optimum_mode(motg->v3p3,
 				USB_PHY_3P3_HPM_LOAD);
 		if (ret < 0) {
-			pr_err("%s: Unable to set HPM of the regulator "
-				"HSUSB_3p3\n", __func__);
+			pr_err("Could not set HPM for v3p3\n");
 			regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_LPM_LOAD);
 			return ret;
@@ -180,13 +173,11 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
 		ret = regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_LPM_LOAD);
 		if (ret < 0)
-			pr_err("%s: Unable to set LPM of the regulator "
-				"HSUSB_1p8\n", __func__);
+			pr_err("Could not set LPM for v1p8\n");
 		ret = regulator_set_optimum_mode(motg->v3p3,
 				USB_PHY_3P3_LPM_LOAD);
 		if (ret < 0)
-			pr_err("%s: Unable to set LPM of the regulator "
-				"HSUSB_3p3\n", __func__);
+			pr_err("Could not set LPM for v3p3\n");
 	}
 
 	pr_debug("reg (%s)\n", on ? "HPM" : "LPM");
@@ -519,8 +510,7 @@ static int msm_otg_resume(struct msm_otg *motg)
 		 * PHY. USB state can not be restored. Re-insertion
 		 * of USB cable is the only way to get USB working.
 		 */
-		dev_err(phy->dev, "Unable to resume USB."
-				"Re-plugin the cable\n");
+		dev_err(phy->dev, "Unable to resume USB. Re-plugin the cable\n");
 		msm_otg_reset(phy);
 	}
 
@@ -1513,8 +1503,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 			motg->pdata->otg_control == OTG_USER_CONTROL) {
 		ret = msm_otg_debugfs_init(motg);
 		if (ret)
-			dev_dbg(&pdev->dev, "mode debugfs file is"
-					"not available\n");
+			dev_dbg(&pdev->dev, "Can not create mode change file\n");
 	}
 
 	pm_runtime_set_active(&pdev->dev);
-- 
1.7.9.5


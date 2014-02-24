Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBXRLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:11:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45071 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBXRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:11:03 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] usb: phy: msm: use ASSIGN_*_PM_OPS variants
Date: Mon, 24 Feb 2014 11:08:27 -0600
Message-Id: <1393261707-30565-4-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ASSIGN_SYSTEM_SLEEP_PM_OPS and ASSIGN_RUNTIME_PM_OPS in the
initializer for msm_otg_dev_pm_ops.  Doing so allows us to eliminate
preprocessor conditionals around the specified callbacks.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/usb/phy/phy-msm-usb.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 5b37b81..c04f2e3 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -414,8 +414,6 @@ static int msm_otg_reset(struct usb_phy *phy)
 #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
 #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
 
-#ifdef CONFIG_PM
-
 #define USB_PHY_SUSP_DIG_VOL  500000
 static int msm_hsusb_config_vddcx(int high)
 {
@@ -609,7 +607,6 @@ skip_phy_resume:
 
 	return 0;
 }
-#endif
 
 static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
 {
@@ -1664,7 +1661,6 @@ static int msm_otg_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
 static int msm_otg_runtime_idle(struct device *dev)
 {
 	struct msm_otg *motg = dev_get_drvdata(dev);
@@ -1699,9 +1695,7 @@ static int msm_otg_runtime_resume(struct device *dev)
 	dev_dbg(dev, "OTG runtime resume\n");
 	return msm_otg_resume(motg);
 }
-#endif
 
-#ifdef CONFIG_PM_SLEEP
 static int msm_otg_pm_suspend(struct device *dev)
 {
 	struct msm_otg *motg = dev_get_drvdata(dev);
@@ -1731,12 +1725,11 @@ static int msm_otg_pm_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops msm_otg_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
-	SET_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
-				msm_otg_runtime_idle)
+	ASSIGN_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
+	ASSIGN_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
+			      msm_otg_runtime_idle)
 };
 
 static struct platform_driver msm_otg_driver = {
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


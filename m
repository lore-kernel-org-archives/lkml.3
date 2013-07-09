Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3GIPtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:49:09 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50752 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab3GIPsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:09 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 7/7] usb: phy: msm: Lindent the code
Date: Tue,  9 Jul 2013 18:47:13 +0300
Message-Id: <1373384833-18077-8-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |   99 ++++++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 47 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 6d05085..111f454 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -45,18 +45,18 @@
 
 #define ULPI_IO_TIMEOUT_USEC	(10 * 1000)
 
-#define USB_PHY_3P3_VOL_MIN	3050000 /* uV */
-#define USB_PHY_3P3_VOL_MAX	3300000 /* uV */
+#define USB_PHY_3P3_VOL_MIN	3050000	/* uV */
+#define USB_PHY_3P3_VOL_MAX	3300000	/* uV */
 #define USB_PHY_3P3_HPM_LOAD	50000	/* uA */
 #define USB_PHY_3P3_LPM_LOAD	4000	/* uA */
 
-#define USB_PHY_1P8_VOL_MIN	1800000 /* uV */
-#define USB_PHY_1P8_VOL_MAX	1800000 /* uV */
+#define USB_PHY_1P8_VOL_MIN	1800000	/* uV */
+#define USB_PHY_1P8_VOL_MAX	1800000	/* uV */
 #define USB_PHY_1P8_HPM_LOAD	50000	/* uA */
 #define USB_PHY_1P8_LPM_LOAD	4000	/* uA */
 
-#define USB_PHY_VDD_DIG_VOL_MIN	1000000 /* uV */
-#define USB_PHY_VDD_DIG_VOL_MAX	1320000 /* uV */
+#define USB_PHY_VDD_DIG_VOL_MIN	1000000	/* uV */
+#define USB_PHY_VDD_DIG_VOL_MAX	1320000	/* uV */
 
 static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 {
@@ -64,8 +64,8 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 
 	if (init) {
 		ret = regulator_set_voltage(motg->vddcx,
-				USB_PHY_VDD_DIG_VOL_MIN,
-				USB_PHY_VDD_DIG_VOL_MAX);
+					    USB_PHY_VDD_DIG_VOL_MIN,
+					    USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret) {
 			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 			return ret;
@@ -73,15 +73,17 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 
 		ret = regulator_enable(motg->vddcx);
 		if (ret)
-			dev_err(motg->phy.dev, "unable to enable hsusb vddcx\n");
+			dev_err(motg->phy.dev,
+				"unable to enable hsusb vddcx\n");
 	} else {
 		ret = regulator_set_voltage(motg->vddcx, 0,
-			USB_PHY_VDD_DIG_VOL_MAX);
+					    USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret)
 			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
 		ret = regulator_disable(motg->vddcx);
 		if (ret)
-			dev_err(motg->phy.dev, "unable to disable hsusb vddcx\n");
+			dev_err(motg->phy.dev,
+				"unable to disable hsusb vddcx\n");
 	}
 
 	return ret;
@@ -93,26 +95,28 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 
 	if (init) {
 		rc = regulator_set_voltage(motg->v3p3, USB_PHY_3P3_VOL_MIN,
-				USB_PHY_3P3_VOL_MAX);
+					   USB_PHY_3P3_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "Cannot set v3p3 voltage\n");
 			return rc;
 		}
 		rc = regulator_enable(motg->v3p3);
 		if (rc) {
-			dev_err(motg->phy.dev, "unable to enable the hsusb 3p3\n");
+			dev_err(motg->phy.dev,
+				"unable to enable the hsusb 3p3\n");
 			return rc;
 		}
 
 		rc = regulator_set_voltage(motg->v1p8, USB_PHY_1P8_VOL_MIN,
-				USB_PHY_1P8_VOL_MAX);
+					   USB_PHY_1P8_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "Cannot set v1p8 voltage\n");
 			goto disable_3p3;
 		}
 		rc = regulator_enable(motg->v1p8);
 		if (rc) {
-			dev_err(motg->phy.dev, "unable to enable the hsusb 1p8\n");
+			dev_err(motg->phy.dev,
+				"unable to enable the hsusb 1p8\n");
 			goto disable_3p3;
 		}
 
@@ -156,26 +160,26 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
 
 	if (on) {
 		ret = regulator_set_optimum_mode(motg->v1p8,
-				USB_PHY_1P8_HPM_LOAD);
+						 USB_PHY_1P8_HPM_LOAD);
 		if (ret < 0) {
 			pr_err("Could not set HPM for v1p8\n");
 			return ret;
 		}
 		ret = regulator_set_optimum_mode(motg->v3p3,
-				USB_PHY_3P3_HPM_LOAD);
+						 USB_PHY_3P3_HPM_LOAD);
 		if (ret < 0) {
 			pr_err("Could not set HPM for v3p3\n");
 			regulator_set_optimum_mode(motg->v1p8,
-				USB_PHY_1P8_LPM_LOAD);
+						   USB_PHY_1P8_LPM_LOAD);
 			return ret;
 		}
 	} else {
 		ret = regulator_set_optimum_mode(motg->v1p8,
-				USB_PHY_1P8_LPM_LOAD);
+						 USB_PHY_1P8_LPM_LOAD);
 		if (ret < 0)
 			pr_err("Could not set LPM for v1p8\n");
 		ret = regulator_set_optimum_mode(motg->v3p3,
-				USB_PHY_3P3_LPM_LOAD);
+						 USB_PHY_3P3_LPM_LOAD);
 		if (ret < 0)
 			pr_err("Could not set LPM for v3p3\n");
 	}
@@ -190,8 +194,7 @@ static int ulpi_read(struct usb_phy *phy, u32 reg)
 	int cnt = 0;
 
 	/* initiate read operation */
-	writel(ULPI_RUN | ULPI_READ | ULPI_ADDR(reg),
-	       USB_ULPI_VIEWPORT);
+	writel(ULPI_RUN | ULPI_READ | ULPI_ADDR(reg), USB_ULPI_VIEWPORT);
 
 	/* wait for completion */
 	while (cnt < ULPI_IO_TIMEOUT_USEC) {
@@ -216,8 +219,7 @@ static int ulpi_write(struct usb_phy *phy, u32 val, u32 reg)
 
 	/* initiate write operation */
 	writel(ULPI_RUN | ULPI_WRITE |
-	       ULPI_ADDR(reg) | ULPI_DATA(val),
-	       USB_ULPI_VIEWPORT);
+	       ULPI_ADDR(reg) | ULPI_DATA(val), USB_ULPI_VIEWPORT);
 
 	/* wait for completion */
 	while (cnt < ULPI_IO_TIMEOUT_USEC) {
@@ -249,7 +251,7 @@ static void ulpi_init(struct msm_otg *motg)
 
 	while (seq[0] >= 0) {
 		dev_vdbg(motg->phy.dev, "ulpi: write 0x%02x to 0x%02x\n",
-				seq[0], seq[1]);
+			 seq[0], seq[1]);
 		ulpi_write(&motg->phy, seq[0], seq[1]);
 		seq += 2;
 	}
@@ -277,7 +279,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 
 	for (retries = 3; retries > 0; retries--) {
 		ret = ulpi_write(&motg->phy, ULPI_FUNC_CTRL_SUSPENDM,
-				ULPI_CLR(ULPI_FUNC_CTRL));
+				 ULPI_CLR(ULPI_FUNC_CTRL));
 		if (!ret)
 			break;
 		ret = pdata->phy_clk_reset(motg->phy_reset_clk);
@@ -429,7 +431,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	writel(readl(USB_USBCMD) | ASYNC_INTR_CTRL | ULPI_STP_CTRL, USB_USBCMD);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
-			motg->pdata->otg_control == OTG_PMIC_CONTROL)
+	    motg->pdata->otg_control == OTG_PMIC_CONTROL)
 		writel(readl(USB_PHY_CTRL) | PHY_RETEN, USB_PHY_CTRL);
 
 	clk_disable_unprepare(motg->pclk);
@@ -441,7 +443,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 		clk_disable_unprepare(motg->pclk_src);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
-			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
+	    motg->pdata->otg_control == OTG_PMIC_CONTROL) {
 		msm_hsusb_ldo_set_mode(motg, 0);
 		msm_hsusb_config_vddcx(motg, 0);
 	}
@@ -478,7 +480,7 @@ static int msm_otg_resume(struct msm_otg *motg)
 		clk_prepare_enable(motg->core_clk);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
-			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
+	    motg->pdata->otg_control == OTG_PMIC_CONTROL) {
 		msm_hsusb_ldo_set_mode(motg, 1);
 		msm_hsusb_config_vddcx(motg, 1);
 		writel(readl(USB_PHY_CTRL) & ~PHY_RETEN, USB_PHY_CTRL);
@@ -510,7 +512,8 @@ static int msm_otg_resume(struct msm_otg *motg)
 		 * PHY. USB state can not be restored. Re-insertion
 		 * of USB cable is the only way to get USB working.
 		 */
-		dev_err(phy->dev, "Unable to resume USB. Re-plugin the cable\n");
+		dev_err(phy->dev,
+			"Unable to resume USB. Re-plugin the cable\n");
 		msm_otg_reset(phy);
 	}
 
@@ -674,7 +677,7 @@ static void msm_otg_start_peripheral(struct usb_phy *phy, int on)
 }
 
 static int msm_otg_set_peripheral(struct usb_otg *otg,
-					struct usb_gadget *gadget)
+				  struct usb_gadget *gadget)
 {
 	struct msm_otg *motg = container_of(otg->phy, struct msm_otg, phy);
 
@@ -948,10 +951,10 @@ static void msm_chg_block_off(struct msm_otg *motg)
 	ulpi_write(phy, func_ctrl, ULPI_FUNC_CTRL);
 }
 
-#define MSM_CHG_DCD_POLL_TIME		(100 * HZ/1000) /* 100 msec */
-#define MSM_CHG_DCD_MAX_RETRIES		6 /* Tdcd_tmout = 6 * 100 msec */
-#define MSM_CHG_PRIMARY_DET_TIME	(40 * HZ/1000) /* TVDPSRC_ON */
-#define MSM_CHG_SECONDARY_DET_TIME	(40 * HZ/1000) /* TVDMSRC_ON */
+#define MSM_CHG_DCD_POLL_TIME		(100 * HZ/1000)	/* 100 msec */
+#define MSM_CHG_DCD_MAX_RETRIES		6	/* Tdcd_tmout = 6 * 100 msec */
+#define MSM_CHG_PRIMARY_DET_TIME	(40 * HZ/1000)	/* TVDPSRC_ON */
+#define MSM_CHG_SECONDARY_DET_TIME	(40 * HZ/1000)	/* TVDMSRC_ON */
 static void msm_chg_detect_work(struct work_struct *w)
 {
 	struct msm_otg *motg = container_of(w, struct msm_otg, chg_work.work);
@@ -1094,20 +1097,20 @@ static void msm_otg_sm_work(struct work_struct *w)
 				switch (motg->chg_type) {
 				case USB_DCP_CHARGER:
 					msm_otg_notify_charger(motg,
-							IDEV_CHG_MAX);
+							       IDEV_CHG_MAX);
 					break;
 				case USB_CDP_CHARGER:
 					msm_otg_notify_charger(motg,
-							IDEV_CHG_MAX);
+							       IDEV_CHG_MAX);
 					msm_otg_start_peripheral(otg->phy, 1);
 					otg->phy->state
-						= OTG_STATE_B_PERIPHERAL;
+					    = OTG_STATE_B_PERIPHERAL;
 					break;
 				case USB_SDP_CHARGER:
 					msm_otg_notify_charger(motg, IUNIT);
 					msm_otg_start_peripheral(otg->phy, 1);
 					otg->phy->state
-						= OTG_STATE_B_PERIPHERAL;
+					    = OTG_STATE_B_PERIPHERAL;
 					break;
 				default:
 					break;
@@ -1135,7 +1138,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 	case OTG_STATE_B_PERIPHERAL:
 		dev_dbg(otg->phy->dev, "OTG_STATE_B_PERIPHERAL state\n");
 		if (!test_bit(B_SESS_VLD, &motg->inputs) ||
-				!test_bit(ID, &motg->inputs)) {
+		    !test_bit(ID, &motg->inputs)) {
 			msm_otg_notify_charger(motg, 0);
 			msm_otg_start_peripheral(otg->phy, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
@@ -1223,7 +1226,7 @@ static int msm_otg_mode_open(struct inode *inode, struct file *file)
 }
 
 static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
-				size_t count, loff_t *ppos)
+				  size_t count, loff_t *ppos)
 {
 	struct seq_file *s = file->private_data;
 	struct msm_otg *motg = s->private;
@@ -1312,7 +1315,8 @@ static int msm_otg_debugfs_init(struct msm_otg *motg)
 		return -ENODEV;
 
 	msm_otg_dbg_mode = debugfs_create_file("mode", S_IRUGO | S_IWUSR,
-				msm_otg_dbg_root, motg, &msm_otg_mode_fops);
+					       msm_otg_dbg_root, motg,
+					       &msm_otg_mode_fops);
 	if (!msm_otg_dbg_mode) {
 		debugfs_remove(msm_otg_dbg_root);
 		msm_otg_dbg_root = NULL;
@@ -1384,9 +1388,9 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * CORE CLK. For such USB cores, vote for maximum clk frequency
 	 * on pclk source
 	 */
-	 if (motg->pdata->pclk_src_name) {
+	if (motg->pdata->pclk_src_name) {
 		motg->pclk_src = devm_clk_get(&pdev->dev,
-			motg->pdata->pclk_src_name);
+					      motg->pdata->pclk_src_name);
 		if (IS_ERR(motg->pclk_src))
 			return PTR_ERR(motg->pclk_src);
 		clk_set_rate(motg->pclk_src, INT_MAX);
@@ -1475,7 +1479,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	INIT_WORK(&motg->sm_work, msm_otg_sm_work);
 	INIT_DELAYED_WORK(&motg->chg_work, msm_chg_detect_work);
 	ret = devm_request_irq(&pdev->dev, motg->irq, msm_otg_irq, IRQF_SHARED,
-					"msm_otg", motg);
+			       "msm_otg", motg);
 	if (ret) {
 		dev_err(&pdev->dev, "request irq failed\n");
 		goto disable_clks;
@@ -1500,10 +1504,11 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 1);
 
 	if (motg->pdata->mode == USB_OTG &&
-			motg->pdata->otg_control == OTG_USER_CONTROL) {
+	    motg->pdata->otg_control == OTG_USER_CONTROL) {
 		ret = msm_otg_debugfs_init(motg);
 		if (ret)
-			dev_dbg(&pdev->dev, "Can not create mode change file\n");
+			dev_dbg(&pdev->dev,
+				"Can not create mode change file\n");
 	}
 
 	pm_runtime_set_active(&pdev->dev);
-- 
1.7.9.5


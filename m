Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3JNP17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:27:59 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49825 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab3JNP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v3 10/13] usb: phy: msm: Switch clock consumer strings
Date: Mon, 14 Oct 2013 18:24:37 +0300
Message-Id: <1381764280-28420-11-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Replace the USB specific clock names in driver
with the more standard 'core' and 'iface' ... names.

Cc: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/mach-msm/devices-msm7x00.c |    4 +-
 arch/arm/mach-msm/devices-msm7x30.c |    8 ++--
 arch/arm/mach-msm/devices-qsd8x50.c |    6 +--
 drivers/usb/phy/phy-msm-usb.c       |   79 +++++++++++++++++++----------------
 include/linux/usb/msm_hsusb.h       |   14 +++----
 5 files changed, 58 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index d83404d..e7274e1 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -461,8 +461,8 @@ static struct clk_pcom_desc msm_clocks_7x01a[] = {
 	CLK_PCOM("core",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uart1dm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uart2dm_clk",	UART2DM_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	"msm_hsusb", OFF),
-	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	"msm_hsusb", OFF),
+	CLK_PCOM("core",	USB_HS_CLK,	"msm_hsusb", OFF),
+	CLK_PCOM("iface",	USB_HS_P_CLK,	"msm_hsusb", OFF),
 	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF ),
 	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index c15ea8a..b7d00fa 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -212,10 +212,10 @@ static struct clk_pcom_desc msm_clocks_7x30[] = {
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
 	CLK_PCOM("core",	UART2_CLK,	"msm_serial.1", 0),
-	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
-	CLK_PCOM("usb_hs_core_clk",	USB_HS_CORE_CLK,	NULL, OFF),
+	CLK_PCOM("phy",	USB_PHY_CLK,	NULL, 0),
+	CLK_PCOM("core",		USB_HS_CLK,		NULL, OFF),
+	CLK_PCOM("iface",		USB_HS_P_CLK,		NULL, OFF),
+	CLK_PCOM("alt_core",	USB_HS_CORE_CLK,	NULL, OFF),
 	CLK_PCOM("usb_hs2_clk",		USB_HS2_CLK,		NULL, OFF),
 	CLK_PCOM("usb_hs2_pclk",	USB_HS2_P_CLK,		NULL, OFF),
 	CLK_PCOM("usb_hs2_core_clk",	USB_HS2_CORE_CLK,	NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index 9e1e9ce..c9614b8 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -363,8 +363,8 @@ static struct clk_pcom_desc msm_clocks_8x50[] = {
 	CLK_PCOM("core",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
-	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
-	CLK_PCOM("usb_hs_pclk",	USB_HS_P_CLK,	NULL, OFF),
+	CLK_PCOM("core",	USB_HS_CLK,	NULL, OFF),
+	CLK_PCOM("iface",	USB_HS_P_CLK,	NULL, OFF),
 	CLK_PCOM("usb_otg_clk",	USB_OTG_CLK,	NULL, 0),
 	CLK_PCOM("vdc_clk",	VDC_CLK,	NULL, OFF | CLK_MIN),
 	CLK_PCOM("vfe_clk",	VFE_CLK,	NULL, OFF),
@@ -374,7 +374,7 @@ static struct clk_pcom_desc msm_clocks_8x50[] = {
 	CLK_PCOM("usb_hs2_pclk",	USB_HS2_P_CLK,	NULL, OFF),
 	CLK_PCOM("usb_hs3_clk",	USB_HS3_CLK,	NULL, OFF),
 	CLK_PCOM("usb_hs3_pclk",	USB_HS3_P_CLK,	NULL, OFF),
-	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
+	CLK_PCOM("phy",	USB_PHY_CLK,	NULL, 0),
 };
 
 static struct pcom_clk_pdata msm_clock_8x50_pdata = {
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index c1020d9..0bd3ba5 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -262,7 +262,7 @@ static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 	if (!motg->pdata->link_clk_reset)
 		return ret;
 
-	ret = motg->pdata->link_clk_reset(motg->clk, assert);
+	ret = motg->pdata->link_clk_reset(motg->core_clk, assert);
 	if (ret)
 		dev_err(motg->phy.dev, "usb link clk reset failed\n");
 
@@ -276,7 +276,7 @@ static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 	if (!motg->pdata->phy_clk_reset)
 		return ret;
 
-	ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
+	ret = motg->pdata->phy_clk_reset(motg->phy_clk);
 	if (ret)
 		dev_err(motg->phy.dev, "usb phy clk assert failed\n");
 
@@ -459,10 +459,10 @@ static int msm_otg_suspend(struct msm_otg *motg)
 			motg->pdata->otg_control == OTG_PMIC_CONTROL)
 		writel(readl(USB_PHY_CTRL) | PHY_RETEN, USB_PHY_CTRL);
 
-	clk_disable_unprepare(motg->pclk);
-	clk_disable_unprepare(motg->clk);
-	if (!IS_ERR(motg->core_clk))
-		clk_disable_unprepare(motg->core_clk);
+	clk_disable_unprepare(motg->iface_clk);
+	clk_disable_unprepare(motg->core_clk);
+	if (!IS_ERR(motg->alt_core_clk))
+		clk_disable_unprepare(motg->alt_core_clk);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
@@ -493,10 +493,10 @@ static int msm_otg_resume(struct msm_otg *motg)
 	if (!atomic_read(&motg->in_lpm))
 		return 0;
 
-	clk_prepare_enable(motg->pclk);
-	clk_prepare_enable(motg->clk);
-	if (!IS_ERR(motg->core_clk))
-		clk_prepare_enable(motg->core_clk);
+	clk_prepare_enable(motg->iface_clk);
+	clk_prepare_enable(motg->core_clk);
+	if (!IS_ERR(motg->alt_core_clk))
+		clk_prepare_enable(motg->alt_core_clk);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
@@ -1372,16 +1372,16 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	phy = &motg->phy;
 	phy->dev = &pdev->dev;
 
-	motg->phy_reset_clk = devm_clk_get(&pdev->dev, "usb_phy_clk");
-	if (IS_ERR(motg->phy_reset_clk)) {
-		dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
-		return PTR_ERR(motg->phy_reset_clk);
+	motg->phy_clk = devm_clk_get(&pdev->dev, "phy");
+	if (IS_ERR(motg->phy_clk)) {
+		dev_err(&pdev->dev, "failed to get phy clock\n");
+		return PTR_ERR(motg->phy_clk);
 	}
 
-	motg->clk = devm_clk_get(&pdev->dev, "usb_hs_clk");
-	if (IS_ERR(motg->clk)) {
-		dev_err(&pdev->dev, "failed to get usb_hs_clk\n");
-		return PTR_ERR(motg->clk);
+	motg->core_clk = devm_clk_get(&pdev->dev, "core");
+	if (IS_ERR(motg->core_clk)) {
+		dev_err(&pdev->dev, "failed to get core clock\n");
+		return PTR_ERR(motg->core_clk);
 	}
 
 	/*
@@ -1390,18 +1390,22 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * operation and USB core cannot tolerate frequency changes on
 	 * CORE CLK.
 	 */
-	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
-	if (IS_ERR(motg->pclk)) {
-		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
-		return PTR_ERR(motg->pclk);
+
+	motg->iface_clk = devm_clk_get(&pdev->dev, "iface");
+	if (IS_ERR(motg->iface_clk)) {
+		dev_err(&pdev->dev, "failed to get iface clock\n");
+		return PTR_ERR(motg->iface_clk);
 	}
 
 	/*
-	 * USB core clock is not present on all MSM chips. This
+	 * USB alt_core clock is not present on all MSM chips. This
 	 * clock is introduced to remove the dependency on AXI
 	 * bus frequency.
+	 *
+	 * Targets on which link uses asynchronous reset methodology,
+	 * free running clock is not required during the reset.
 	 */
-	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");
+	motg->alt_core_clk = devm_clk_get(&pdev->dev, "alt_core");
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	motg->regs = devm_ioremap_resource(&pdev->dev, res);
@@ -1434,13 +1438,13 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return PTR_ERR(motg->v1p8);
 	}
 
-	clk_set_rate(motg->clk, 60000000);
+	clk_set_rate(motg->core_clk, 60000000);
 
-	clk_prepare_enable(motg->clk);
-	clk_prepare_enable(motg->pclk);
+	clk_prepare_enable(motg->core_clk);
+	clk_prepare_enable(motg->iface_clk);
 
-	if (!IS_ERR(motg->core_clk))
-		clk_prepare_enable(motg->core_clk);
+	if (!IS_ERR(motg->alt_core_clk))
+		clk_prepare_enable(motg->alt_core_clk);
 
 	ret = msm_hsusb_init_vddcx(motg, 1);
 	if (ret) {
@@ -1506,10 +1510,10 @@ disable_ldo:
 disable_vddcx:
 	msm_hsusb_init_vddcx(motg, 0);
 disable_clks:
-	clk_disable_unprepare(motg->pclk);
-	clk_disable_unprepare(motg->clk);
-	if (!IS_ERR(motg->core_clk))
-		clk_disable_unprepare(motg->core_clk);
+	clk_disable_unprepare(motg->iface_clk);
+	clk_disable_unprepare(motg->core_clk);
+	if (!IS_ERR(motg->alt_core_clk))
+		clk_disable_unprepare(motg->alt_core_clk);
 	return ret;
 }
 
@@ -1550,10 +1554,11 @@ static int msm_otg_remove(struct platform_device *pdev)
 	if (cnt >= PHY_SUSPEND_TIMEOUT_USEC)
 		dev_err(phy->dev, "Unable to suspend PHY\n");
 
-	clk_disable_unprepare(motg->pclk);
-	clk_disable_unprepare(motg->clk);
-	if (!IS_ERR(motg->core_clk))
-		clk_disable_unprepare(motg->core_clk);
+	clk_disable_unprepare(motg->iface_clk);
+	clk_disable_unprepare(motg->core_clk);
+	if (!IS_ERR(motg->alt_core_clk))
+		clk_disable_unprepare(motg->alt_core_clk);
+
 	msm_hsusb_ldo_init(motg, 0);
 
 	pm_runtime_set_suspended(&pdev->dev);
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 262ed80..f1b98f2 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -124,10 +124,10 @@ struct msm_otg_platform_data {
  * @otg: USB OTG Transceiver structure.
  * @pdata: otg device platform data.
  * @irq: IRQ number assigned for HSUSB controller.
- * @clk: clock struct of usb_hs_clk.
- * @pclk: clock struct of usb_hs_pclk.
- * @phy_reset_clk: clock struct of usb_phy_clk.
- * @core_clk: clock struct of usb_hs_core_clk.
+ * @core_clk: reference to core clock struct.
+ * @iface_clk: reference to interface clock struct.
+ * @phy_clk: reference to PHY clock struct.
+ * @alt_core_clk: reference to alternative clock struct
  * @regs: ioremapped register base address.
  * @inputs: OTG state machine inputs(Id, SessValid etc).
  * @sm_work: OTG state machine work.
@@ -144,10 +144,10 @@ struct msm_otg {
 	struct usb_phy phy;
 	struct msm_otg_platform_data *pdata;
 	int irq;
-	struct clk *clk;
-	struct clk *pclk;
-	struct clk *phy_reset_clk;
 	struct clk *core_clk;
+	struct clk *iface_clk;
+	struct clk *phy_clk;
+	struct clk *alt_core_clk;
 	void __iomem *regs;
 #define ID		0
 #define B_SESS_VLD	1
-- 
1.7.9.5


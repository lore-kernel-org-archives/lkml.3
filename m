Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbaKUNtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:49:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21303 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbaKUNt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:49:28 -0500
X-AuditID: cbfee691-f79b86d000004a5a-18-546f42e6cbe2
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 06/11] phy: exynos5-usbdrd: Add facility for VBUS-BOOST-5V
 supply
Date: Fri, 21 Nov 2014 19:05:49 +0530
Message-id: <1416576954-11997-7-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSp/vMKT/E4MdCRYuD9+st5h85x2rR
	duUgu0Xz4vVsFr0LrrJZXHjaw2ZxedccNovZS/pZLGac38dksWhZK7NF694j7BaH37SzWkz4
	fYHNYtWuP4wOfB47Z91l99i0qpPNY//cNewes+/+YPTo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBlTD88j7lgiUTF1g+v2RsYLwh3MXJySAiYSPzvXMoEYYtJXLi3nq2LkYtDSGAp
	o8S9ZdNYuxg5wIqurtIDqRESmM4o0dYZCFEzgUnid8NJFpAEm4CuRNPbXYwgtojAbKCig0Ig
	RcwC9xglPr//DlYkLBAssfjFPTYQm0VAVeLo3LPMIDavgIfEyTP32SCWKUjMmWQDEuYU8JRo
	WX+ZCWKxh8SaXbsZQWZKCNxil/h1dj0TxBwBiW+TD7FA9MpKbDrADPGMpMTBFTdYJjAKL2Bk
	WMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGD2n/z2buIPx/gHrQ4wCHIxKPLwfpueFCLEm
	lhVX5h5iNAXaMJFZSjQ5HxijeSXxhsZmRhamJqbGRuaWZkrivDrSP4OFBNITS1KzU1MLUovi
	i0pzUosPMTJxcEo1MFZUVT/mD7szv5rBYmvyqqp57l93yGzalrL/m2OCmHH21b3dU5PDOh7/
	n/Bb/86+atHWhkcxld1b1tg5ufb/eLhg3UPjezderndkF5N51vxNYE9GXvrd6e8b1TbOYeDm
	3mg6TYhZ+PgOtl8vLCYdWGzD3dyRyW3u3qyhe/6KyY3NQcFTtH8pVyqxFGckGmoxFxUnAgAX
	7YoMmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd1nTvkhBvvniFscvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktWvceYbc4/Kad1WLC
	7wtsFqt2/WF04PPYOesuu8emVZ1sHvvnrmH3mH33B6NH35ZVjB7Hb2xn8vi8SS6APaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b0w/OYC5ZIVGz98Jq9gfGCcBcjB4eE
	gInE1VV6XYycQKaYxIV769lAbCGB6YwSbZ2BXYxcQPYEJonfDSdZQBJsAroSTW93MYLYIgKz
	gYoOCoEUMQvcY5T4/P47WJGwQLDE4hf3wCaxCKhKHJ17lhnE5hXwkDh55j4bxGIFiTmTbEDC
	nAKeEi3rLzNBLPaQWLNrN+MERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj85n0
	DsZVDRaHGAU4GJV4eD9MzwsRYk0sK67MPcQowcGsJMJbLpwfIsSbklhZlVqUH19UmpNafIjR
	FOioicxSosn5wLSRVxJvaGxibmpsamliYWJmqSTOe+NmboiQQHpiSWp2ampBahFMHxMHp1QD
	4+S5nVFcPkzLttyU+5DCsmFdXOAWLwa5i24nvCI0J4TMuuM+P7ndJji8U/C2NduO61HiXCv3
	GzxMjfzYsi67sOlqVazD3o4VvN/Kf62+3fPM9baBbOs2zoczk+Li32yd9C1Xs2R+Xnw/87SL
	778n+F+XS3b6cHOj3USL7bqSb6+s71py/9gGPSWW4oxEQy3mouJEAKneYqfjAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Exynos boards have a separate regulator controlling a
Boost 5V supply which goes as input for VBUS regulator.
So adding a control for the same in driver, to enable
vbus supply on the port.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 3654712..1f54639 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -159,6 +159,8 @@ struct exynos5_usbdrd_phy_drvdata {
  *	       reference clocks' for SS and HS operations
  * @ref_clk: reference clock to PHY block from which PHY's
  *	     operational clocks are derived
+ * vbus: VBUS regulator for phy
+ * vbus_boost: Boost regulator for VBUS present on few Exynos boards
  */
 struct exynos5_usbdrd_phy {
 	struct device *dev;
@@ -178,6 +180,7 @@ struct exynos5_usbdrd_phy {
 	u32 extrefclk;
 	struct clk *ref_clk;
 	struct regulator *vbus;
+	struct regulator *vbus_boost;
 };
 
 static inline
@@ -460,11 +463,20 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 	}
 
 	/* Enable VBUS supply */
+	if (phy_drd->vbus_boost) {
+		ret = regulator_enable(phy_drd->vbus_boost);
+		if (ret) {
+			dev_err(phy_drd->dev,
+				"Failed to enable VBUS boost supply\n");
+			goto fail_vbus;
+		}
+	}
+
 	if (phy_drd->vbus) {
 		ret = regulator_enable(phy_drd->vbus);
 		if (ret) {
 			dev_err(phy_drd->dev, "Failed to enable VBUS supply\n");
-			goto fail_vbus;
+			goto fail_vbus_boost;
 		}
 	}
 
@@ -473,6 +485,10 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
 
 	return 0;
 
+fail_vbus_boost:
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
+
 fail_vbus:
 	clk_disable_unprepare(phy_drd->ref_clk);
 	if (!phy_drd->drv_data->has_common_clk_gate) {
@@ -497,6 +513,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	/* Disable VBUS supply */
 	if (phy_drd->vbus)
 		regulator_disable(phy_drd->vbus);
+	if (phy_drd->vbus_boost)
+		regulator_disable(phy_drd->vbus_boost);
 
 	clk_disable_unprepare(phy_drd->ref_clk);
 	if (!phy_drd->drv_data->has_common_clk_gate) {
@@ -690,7 +708,7 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		break;
 	}
 
-	/* Get Vbus regulator */
+	/* Get Vbus regulators */
 	phy_drd->vbus = devm_regulator_get(dev, "vbus");
 	if (IS_ERR(phy_drd->vbus)) {
 		ret = PTR_ERR(phy_drd->vbus);
@@ -701,6 +719,16 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
 		phy_drd->vbus = NULL;
 	}
 
+	phy_drd->vbus_boost = devm_regulator_get(dev, "vbus-boost");
+	if (IS_ERR(phy_drd->vbus_boost)) {
+		ret = PTR_ERR(phy_drd->vbus_boost);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+
+		dev_warn(dev, "Failed to get VBUS boost supply regulator\n");
+		phy_drd->vbus_boost = NULL;
+	}
+
 	dev_vdbg(dev, "Creating usbdrd_phy phy\n");
 
 	for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
-- 
1.7.10.4


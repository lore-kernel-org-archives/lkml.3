Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3CBN0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:26:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30681 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3CBNZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:46 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-b9-5131fdd9d847
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 08/10] usb: phy: samsung: Add support for external reference
 clock
Date: Sat, 02 Mar 2013 18:53:09 +0530
Message-id: <1362230590-20960-9-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkVvfmX8NAg90/RCwO3q+3aF68ns2i
	d8FVNosLT3vYLC7vmsNmMXtJP4vFjPP7mCwWLWtltmg+cYrZgdNj3slAj/1z17B79G1Zxehx
	/MZ2Jo/Pm+QCWKO4bFJSczLLUov07RK4Mnpb7QqeylSsW/SUuYHxp3gXIyeHhICJxMGDq5gh
	bDGJC/fWs3UxcnEICSxllJj3t40Rpujo8vlMEInpjBINx2dDOVOYJPZeu8cEUsUmoCvR9HYX
	WIeIgKzE4Su/mUGKmAUuMUqsWLGFpYuRg0NYIFxiz0Z/kBoWAVWJT59+sILYvAIeEj9n74Ta
	piDx5vYzsJM4BTwlpl/fDFYjBFTz595xdpCZEgKr2CV+fD/GAjFIQOLb5ENg8yWAFm86APWO
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtcmpeul5yfu4kRGPan/z3r38F494D1IcZk
	oHETmaVEk/OBcZNXEm9obGJuamxqZmRpaWlKmrCSOK/8JZlAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYybrHsn7ih8vnHGxxWMcjyuCtXPXBfFPtAoPrFqUUu8v8XV+7bfWCdW55zK/8Z2
	9m2/WG7yq13cslpC6XzTNWzEV9vcOPE08OSVlxG8Xb6hYmsM0pay7vzjv7FldviNDXtXd7+5
	d5X1ZMuply93XNRtTtkz8cebT2sq+Be3Jp7mLNgeXR7EeG6eEktxRqKhFnNRcSIAUH3N85EC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd2bfw0DDa4t5rY4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR22pX8FSm
	Yt2ip8wNjD/Fuxg5OSQETCSOLp/PBGGLSVy4t56ti5GLQ0hgOqNEw/HZTBDOFCaJvdfugVWx
	CehKNL3dxQhiiwjIShy+8psZpIhZ4BKjxIoVW1i6GDk4hAXCJfZs9AepYRFQlfj06QcriM0r
	4CHxc/ZORohtChJvbj9jBrE5BTwlpl/fDFYjBFTz595x9gmMvAsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBEfVM6kdjCsbLA4xCnAwKvHwBnw0CBRiTSwrrsw9xCjBwawkwnv+qmGg
	EG9KYmVValF+fFFpTmrxIcZkoKsmMkuJJucDIz6vJN7Q2MTc1NjU0sTCxMySNGElcV7GU08C
	hATSE0tSs1NTC1KLYLYwcXBKNQBdtqRjvUukydcGXsapHfyHFC3r2qcYxa15JLWOyed584HM
	hOrsWsMplzVyo4/Y+xhfnhhnEpy67fmiJvF/nypajrtNSXwiW/gu8XrLyvh48RutOR3M3lb5
	By5nR3p3ij95dz/rr7OT05+OP7a75aTVledu3h31oT6Zq8fzvZFvB//tmhfblViKMxINtZiL
	ihMB7T6cle4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PHY controller can choose between ref_pad_clk (XusbXTI-external PLL),
or EXTREFCLK (XXTI-internal clock crystal) to generate the required clock.
Adding the provision for ref_pad_clk here.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/samsung-usb3phy.c |   46 ++++++++++++++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/samsung-usb3phy.c b/drivers/usb/phy/samsung-usb3phy.c
index 7594cc7..46dd97c 100644
--- a/drivers/usb/phy/samsung-usb3phy.c
+++ b/drivers/usb/phy/samsung-usb3phy.c
@@ -33,7 +33,7 @@
 /*
  * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
  */
-static u32 samsung_usb3phy_set_refclk(struct samsung_usbphy *sphy)
+static u32 samsung_usb3phy_set_refclk_int(struct samsung_usbphy *sphy)
 {
 	u32 reg;
 	u32 refclk;
@@ -66,7 +66,22 @@ static u32 samsung_usb3phy_set_refclk(struct samsung_usbphy *sphy)
 	return reg;
 }
 
-static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
+/*
+ * Sets the phy clk as ref_pad_clk (XusbXTI) which is clock from external PLL.
+ */
+static u32 samsung_usb3phy_set_refclk_ext(void)
+{
+	u32 reg;
+
+	reg = PHYCLKRST_REFCLKSEL_PAD_REFCLK |
+		PHYCLKRST_FSEL_PAD_100MHZ |
+		PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF;
+
+	return reg;
+}
+
+static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy,
+							bool use_ext_clk)
 {
 	void __iomem *regs = sphy->regs;
 	u32 phyparam0;
@@ -81,7 +96,10 @@ static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
 
 	phyparam0 = readl(regs + EXYNOS5_DRD_PHYPARAM0);
 	/* Select PHY CLK source */
-	phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
+	if (use_ext_clk)
+		phyparam0 |= PHYPARAM0_REF_USE_PAD;
+	else
+		phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
 	/* Set Loss-of-Signal Detector sensitivity */
 	phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
 	phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
@@ -116,7 +134,10 @@ static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
 	/* UTMI Power Control */
 	writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
 
-	phyclkrst = samsung_usb3phy_set_refclk(sphy);
+	if (use_ext_clk)
+		phyclkrst = samsung_usb3phy_set_refclk_ext();
+	else
+		phyclkrst = samsung_usb3phy_set_refclk_int(sphy);
 
 	phyclkrst |= PHYCLKRST_PORTRESET |
 			/* Digital power supply in normal operating mode */
@@ -164,7 +185,7 @@ static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
 	writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
 }
 
-static int samsung_usb3phy_init(struct usb_phy *phy)
+static int samsung_exynos5_usb3phy_init(struct usb_phy *phy, bool use_ext_clk)
 {
 	struct samsung_usbphy *sphy;
 	unsigned long flags;
@@ -188,7 +209,7 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 	samsung_usbphy_set_isolation(sphy, false);
 
 	/* Initialize usb phy registers */
-	samsung_exynos5_usb3phy_enable(sphy);
+	samsung_exynos5_usb3phy_enable(sphy, use_ext_clk);
 
 	spin_unlock_irqrestore(&sphy->lock, flags);
 
@@ -199,6 +220,19 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 }
 
 /*
+ * The function passed to the usb driver for phy initialization
+ */
+static int samsung_usb3phy_init(struct usb_phy *phy)
+{
+	/*
+	 * We start with using PHY refclk from external PLL,
+	 * once runtime suspend for the device is called this
+	 * will change to internal core clock
+	 */
+	return samsung_exynos5_usb3phy_init(phy, true);
+}
+
+/*
  * The function passed to the usb driver for phy shutdown
  */
 static void samsung_usb3phy_shutdown(struct usb_phy *phy)
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3DAN6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:58:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57928 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab3DAN6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:58:33 -0400
X-AuditID: cbfee68d-b7f786d000005188-75-515992877a66
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Subject: [PATCH v3 09/11] usb: phy: samsung: Add support for external reference
 clock
Date: Mon, 01 Apr 2013 19:24:08 +0530
Message-id: <1364824448-14732-10-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkWrd9UmSgwYomS4uD9+stzi47yGbR
	vHg9m0XvgqtsFhee9rBZXN41h81i9pJ+FosZ5/cxWSxa1spscX5LJ5PF4RUHmCyaT5xitpjw
	+wKbxfoZr1kc+DwWfL7C7jG74SKLx7yTgR77564B8u7+YPTo27KK0eP4je1MHp83yQVwRHHZ
	pKTmZJalFunbJXBlXG1fzFTwQqZiwjKXBsY/4l2MnBwSAiYS23esY4SwxSQu3FvP1sXIxSEk
	sJRRYv2sq+wwRR9nrmSCSCxilFj3tgHKmcIk8X/NDmaQKjYBXYmmt7uARnFwiAjESWyeIAwS
	ZhboYpJYehRsm7BAuMSeJ19ZQGwWAVWJ6Vt6mEBsXgFPibv3VjFBLFOQeHP7GdhITqD4h62L
	weJCAh4S7VdPsILslRB4xC4xa8J+VohBAhLfJh9iAdkrISArsekAM8QcSYmDK26wTGAUXsDI
	sIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjMIpO/3vWu4Px9gHrQ4zJQOMmMkuJJucDozCv
	JN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwVQZ/L
	eOITFYW/aBmWFx7VfpO8fg0D25ejXitW/X/2dsKeafesUmXV7J5psbJo6d1U5fr4e+al5f+P
	9jUwas0L1JqpNuvF1XJRqRvipmHXzhS8XfNnTu6uBy9KxMz5LrL6bvi7qqve7anpy9KPB+wk
	by45+e7RYiauu8vl/8ybKfKTKXX6U8mzSizFGYmGWsxFxYkAaxeasbgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG77pMhAg4Pv9C0O3q+3OLvsIJtF
	8+L1bBa9C66yWVx42sNmcXnXHDaL2Uv6WSxmnN/HZLFoWSuzxfktnUwWh1ccYLJoPnGK2WLC
	7wtsFutnvGZx4PNY8PkKu8fshossHvNOBnrsn7sGyLv7g9Gjb8sqRo/jN7YzeXzeJBfAEdXA
	aJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLeSQlli
	TilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeNq+2KmghcyFROWuTQw/hHvYuTk
	kBAwkfg4cyUThC0mceHeerYuRi4OIYFFjBLr3jYwQThTmCT+r9nBDFLFJqAr0fR2F2MXIweH
	iECcxOYJwiBhZoEuJomlR8GGCguES+x58pUFxGYRUJWYvqUHbAGvgKfE3XuroJYpSLy5/Qxs
	JCdQ/MPWxWBxIQEPifarJ1gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREco8+k
	djCubLA4xCjAwajEwxtxISJQiDWxrLgy9xCjBAezkgjviszIQCHelMTKqtSi/Pii0pzU4kOM
	yUBXTWSWEk3OB6aPvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLg
	lGpg5G1YsvpXP4eTzqbDTXvSjyW3BHz3YC8+/emA8Ap3vlMLpnAeeKvk9TN/Rn375IlSYg+t
	XxZemfBrhY3JFUb+3kUBOsvYn/qzqyueSnx18uT8wOvTJyjKTPz4Z31fzbyXy53WL54Wc/7F
	zD1T+9av5jyy7/tUiwBt77TTFW3Lvd90Ll7q1WfKFqTEUpyRaKjFXFScCAAiXyzZFQMAAA==
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
 drivers/usb/phy/phy-samsung-usb3.c |   46 +++++++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index a713585..8afef9d 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
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


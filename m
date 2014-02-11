Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBKJbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:31:24 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:53152 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795AbaBKJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:31:18 -0500
From: Mohit Kumar <mohit.kumar@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V6 07/12] phy: st-miphy-40lp: Add SPEAr1310 and SPEAr1340 PCIe phy support
Date: Tue, 11 Feb 2014 15:00:03 +0530
Message-ID: <f84ed875ae7a356a8056f4645a4d1e59c665c972.1392109054.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1392109054.git.mohit.kumar@st.com>
References: <cover.1392109054.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr1310 and SPEAr1340 uses miphy40lp phy for PCIe. This driver adds
support for the same.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Tested-by: Mohit Kumar <mohit.kumar@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: spear-devel@list.st.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/phy-miphy40lp.c |  165 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 165 insertions(+), 0 deletions(-)

diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
index 16da55b..dec67ed 100644
--- a/drivers/phy/phy-miphy40lp.c
+++ b/drivers/phy/phy-miphy40lp.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  *
  * 04/02/2014: Adding support of SATA mode for SPEAr1340.
+ * 04/02/2014: Adding support of PCIe mode for SPEAr1340 and SPEAr1310
  */
 
 #include <linux/bitops.h>
@@ -74,6 +75,80 @@
 	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
 			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
 			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
+/* SPEAr1310 Registers */
+#define SPEAR1310_PCIE_SATA_CFG			0x3A4
+	#define SPEAR1310_PCIE_SATA2_SEL_PCIE		(0 << 31)
+	#define SPEAR1310_PCIE_SATA1_SEL_PCIE		(0 << 30)
+	#define SPEAR1310_PCIE_SATA0_SEL_PCIE		(0 << 29)
+	#define SPEAR1310_PCIE_SATA2_SEL_SATA		BIT(31)
+	#define SPEAR1310_PCIE_SATA1_SEL_SATA		BIT(30)
+	#define SPEAR1310_PCIE_SATA0_SEL_SATA		BIT(29)
+	#define SPEAR1310_SATA2_CFG_TX_CLK_EN		BIT(27)
+	#define SPEAR1310_SATA2_CFG_RX_CLK_EN		BIT(26)
+	#define SPEAR1310_SATA2_CFG_POWERUP_RESET	BIT(25)
+	#define SPEAR1310_SATA2_CFG_PM_CLK_EN		BIT(24)
+	#define SPEAR1310_SATA1_CFG_TX_CLK_EN		BIT(23)
+	#define SPEAR1310_SATA1_CFG_RX_CLK_EN		BIT(22)
+	#define SPEAR1310_SATA1_CFG_POWERUP_RESET	BIT(21)
+	#define SPEAR1310_SATA1_CFG_PM_CLK_EN		BIT(20)
+	#define SPEAR1310_SATA0_CFG_TX_CLK_EN		BIT(19)
+	#define SPEAR1310_SATA0_CFG_RX_CLK_EN		BIT(18)
+	#define SPEAR1310_SATA0_CFG_POWERUP_RESET	BIT(17)
+	#define SPEAR1310_SATA0_CFG_PM_CLK_EN		BIT(16)
+	#define SPEAR1310_PCIE2_CFG_DEVICE_PRESENT	BIT(11)
+	#define SPEAR1310_PCIE2_CFG_POWERUP_RESET	BIT(10)
+	#define SPEAR1310_PCIE2_CFG_CORE_CLK_EN		BIT(9)
+	#define SPEAR1310_PCIE2_CFG_AUX_CLK_EN		BIT(8)
+	#define SPEAR1310_PCIE1_CFG_DEVICE_PRESENT	BIT(7)
+	#define SPEAR1310_PCIE1_CFG_POWERUP_RESET	BIT(6)
+	#define SPEAR1310_PCIE1_CFG_CORE_CLK_EN		BIT(5)
+	#define SPEAR1310_PCIE1_CFG_AUX_CLK_EN		BIT(4)
+	#define SPEAR1310_PCIE0_CFG_DEVICE_PRESENT	BIT(3)
+	#define SPEAR1310_PCIE0_CFG_POWERUP_RESET	BIT(2)
+	#define SPEAR1310_PCIE0_CFG_CORE_CLK_EN		BIT(1)
+	#define SPEAR1310_PCIE0_CFG_AUX_CLK_EN		BIT(0)
+
+	#define SPEAR1310_PCIE_CFG_MASK(x) ((0xF << (x * 4)) | BIT((x + 29)))
+	#define SPEAR1310_SATA_CFG_MASK(x) ((0xF << (x * 4 + 16)) | \
+			BIT((x + 29)))
+	#define SPEAR1310_PCIE_CFG_VAL(x) \
+			(SPEAR1310_PCIE_SATA##x##_SEL_PCIE | \
+			SPEAR1310_PCIE##x##_CFG_AUX_CLK_EN | \
+			SPEAR1310_PCIE##x##_CFG_CORE_CLK_EN | \
+			SPEAR1310_PCIE##x##_CFG_POWERUP_RESET | \
+			SPEAR1310_PCIE##x##_CFG_DEVICE_PRESENT)
+	#define SPEAR1310_SATA_CFG_VAL(x) \
+			(SPEAR1310_PCIE_SATA##x##_SEL_SATA | \
+			SPEAR1310_SATA##x##_CFG_PM_CLK_EN | \
+			SPEAR1310_SATA##x##_CFG_POWERUP_RESET | \
+			SPEAR1310_SATA##x##_CFG_RX_CLK_EN | \
+			SPEAR1310_SATA##x##_CFG_TX_CLK_EN)
+
+#define SPEAR1310_PCIE_MIPHY_CFG_1		0x3A8
+	#define SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT	BIT(31)
+	#define SPEAR1310_MIPHY_DUAL_CLK_REF_DIV2	BIT(28)
+	#define SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(x)	(x << 16)
+	#define SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT	BIT(15)
+	#define SPEAR1310_MIPHY_SINGLE_CLK_REF_DIV2	BIT(12)
+	#define SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(x)	(x << 0)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA_MASK (0xFFFF)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK (0xFFFF << 16)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA \
+			(SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_DUAL_CLK_REF_DIV2 | \
+			SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(60) | \
+			SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_SINGLE_CLK_REF_DIV2 | \
+			SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(60))
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
+			(SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(120))
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE \
+			(SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(25) | \
+			SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(25))
+
+#define SPEAR1310_PCIE_MIPHY_CFG_2		0x3AC
 
 enum phy_mode {
 	SATA,
@@ -146,12 +221,35 @@ static int miphy40lp_spear1340_sata_exit(struct miphy40lp_priv *priv)
 	return 0;
 }
 
+static int miphy40lp_spear1340_pcie_init(struct miphy40lp_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK,
+			SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_PCIE_CFG_VAL);
+
+	return 0;
+}
+
+static int miphy40lp_spear1340_pcie_exit(struct miphy40lp_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
+
+	return 0;
+}
+
 static int miphy40lp_spear1340_init(struct miphy40lp_priv *priv)
 {
 	int ret = 0;
 
 	if (priv->mode == SATA)
 		ret = miphy40lp_spear1340_sata_init(priv);
+	else if (priv->mode == PCIE)
+		ret = miphy40lp_spear1340_pcie_init(priv);
 
 	return ret;
 }
@@ -162,6 +260,8 @@ static int miphy40lp_spear1340_exit(struct miphy40lp_priv *priv)
 
 	if (priv->mode == SATA)
 		ret = miphy40lp_spear1340_sata_exit(priv);
+	else if (priv->mode == PCIE)
+		ret = miphy40lp_spear1340_pcie_exit(priv);
 
 	return ret;
 }
@@ -193,6 +293,70 @@ static struct miphy40lp_plat_ops spear1340_phy_ops = {
 	.plat_resume = miphy40lp_spear1340_resume,
 };
 
+static int miphy40lp_spear1310_pcie_init(struct miphy40lp_priv *priv)
+{
+	u32 val;
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE);
+
+	switch (priv->id) {
+	case 0:
+		val = SPEAR1310_PCIE_CFG_VAL(0);
+		break;
+	case 1:
+		val = SPEAR1310_PCIE_CFG_VAL(1);
+		break;
+	case 2:
+		val = SPEAR1310_PCIE_CFG_VAL(2);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_SATA_CFG,
+			SPEAR1310_PCIE_CFG_MASK(priv->id), val);
+
+	return 0;
+}
+
+static int miphy40lp_spear1310_pcie_exit(struct miphy40lp_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_SATA_CFG,
+			SPEAR1310_PCIE_CFG_MASK(priv->id), 0);
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK, 0);
+
+	return 0;
+}
+
+static int miphy40lp_spear1310_init(struct miphy40lp_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->mode == PCIE)
+		ret = miphy40lp_spear1310_pcie_init(priv);
+
+	return ret;
+}
+
+static int miphy40lp_spear1310_exit(struct miphy40lp_priv *priv)
+{
+	int ret = 0;
+
+	if (priv->mode == PCIE)
+		ret = miphy40lp_spear1310_pcie_exit(priv);
+
+	return ret;
+}
+
+static struct miphy40lp_plat_ops spear1310_phy_ops = {
+	.plat_init = miphy40lp_spear1310_init,
+	.plat_exit = miphy40lp_spear1310_exit,
+};
+
 static int miphy40lp_init(struct phy *phy)
 {
 	struct miphy40lp_priv *priv = phy_get_drvdata(phy);
@@ -244,6 +408,7 @@ static int miphy40lp_power_on(struct phy *phy)
 static const struct of_device_id miphy40lp_of_match[] = {
 	{ .compatible = "st,miphy40lp-phy", .data = NULL },
 	{ .compatible = "st,spear1340-miphy", .data = &spear1340_phy_ops },
+	{ .compatible = "st,spear1310-miphy", .data = &spear1310_phy_ops },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, miphy40lp_of_match);
-- 
1.7.0.1


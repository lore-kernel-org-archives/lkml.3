Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaBFEqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:46:00 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:41271 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbaBFEpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:45:54 -0500
From: Pratyush Anand <pratyush.anand@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 6/8] phy: st-miphy-40lp: Add SPEAr1310 and SPEAr1340 PCIe phy support
Date: Thu, 6 Feb 2014 10:14:53 +0530
Message-ID: <dca9c501de8386003142b463469c3d267a049eeb.1391661589.git.pratyush.anand@st.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1391661589.git.pratyush.anand@st.com>
References: <cover.1391661589.git.pratyush.anand@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPEAr1310 and SPEAr1340 uses miphy40lp phy for PCIe. This driver adds
support for the same.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Tested-by: Mohit Kumar <mohit.kumar@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: spear-devel@list.st.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/phy-miphy40lp.c | 178 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 178 insertions(+)

diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
index cc7f45d..61e94be 100644
--- a/drivers/phy/phy-miphy40lp.c
+++ b/drivers/phy/phy-miphy40lp.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  *
  * 04/02/2014: Adding support of SATA mode for SPEAr1340.
+ * 04/02/2014: Adding support of PCIe mode for SPEAr1340 and SPEAr1310
  */
 
 #include <linux/delay.h>
@@ -73,6 +74,80 @@
 	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
 			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
 			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
+/* SPEAr1310 Registers */
+#define SPEAR1310_PCIE_SATA_CFG			0x3A4
+	#define SPEAR1310_PCIE_SATA2_SEL_PCIE		(0 << 31)
+	#define SPEAR1310_PCIE_SATA1_SEL_PCIE		(0 << 30)
+	#define SPEAR1310_PCIE_SATA0_SEL_PCIE		(0 << 29)
+	#define SPEAR1310_PCIE_SATA2_SEL_SATA		(1 << 31)
+	#define SPEAR1310_PCIE_SATA1_SEL_SATA		(1 << 30)
+	#define SPEAR1310_PCIE_SATA0_SEL_SATA		(1 << 29)
+	#define SPEAR1310_SATA2_CFG_TX_CLK_EN		(1 << 27)
+	#define SPEAR1310_SATA2_CFG_RX_CLK_EN		(1 << 26)
+	#define SPEAR1310_SATA2_CFG_POWERUP_RESET	(1 << 25)
+	#define SPEAR1310_SATA2_CFG_PM_CLK_EN		(1 << 24)
+	#define SPEAR1310_SATA1_CFG_TX_CLK_EN		(1 << 23)
+	#define SPEAR1310_SATA1_CFG_RX_CLK_EN		(1 << 22)
+	#define SPEAR1310_SATA1_CFG_POWERUP_RESET	(1 << 21)
+	#define SPEAR1310_SATA1_CFG_PM_CLK_EN		(1 << 20)
+	#define SPEAR1310_SATA0_CFG_TX_CLK_EN		(1 << 19)
+	#define SPEAR1310_SATA0_CFG_RX_CLK_EN		(1 << 18)
+	#define SPEAR1310_SATA0_CFG_POWERUP_RESET	(1 << 17)
+	#define SPEAR1310_SATA0_CFG_PM_CLK_EN		(1 << 16)
+	#define SPEAR1310_PCIE2_CFG_DEVICE_PRESENT	(1 << 11)
+	#define SPEAR1310_PCIE2_CFG_POWERUP_RESET	(1 << 10)
+	#define SPEAR1310_PCIE2_CFG_CORE_CLK_EN		(1 << 9)
+	#define SPEAR1310_PCIE2_CFG_AUX_CLK_EN		(1 << 8)
+	#define SPEAR1310_PCIE1_CFG_DEVICE_PRESENT	(1 << 7)
+	#define SPEAR1310_PCIE1_CFG_POWERUP_RESET	(1 << 6)
+	#define SPEAR1310_PCIE1_CFG_CORE_CLK_EN		(1 << 5)
+	#define SPEAR1310_PCIE1_CFG_AUX_CLK_EN		(1 << 4)
+	#define SPEAR1310_PCIE0_CFG_DEVICE_PRESENT	(1 << 3)
+	#define SPEAR1310_PCIE0_CFG_POWERUP_RESET	(1 << 2)
+	#define SPEAR1310_PCIE0_CFG_CORE_CLK_EN		(1 << 1)
+	#define SPEAR1310_PCIE0_CFG_AUX_CLK_EN		(1 << 0)
+
+	#define SPEAR1310_PCIE_CFG_MASK(x) ((0xF << (x * 4)) | (1 << (x + 29)))
+	#define SPEAR1310_SATA_CFG_MASK(x) ((0xF << (x * 4 + 16)) | \
+			(1 << (x + 29)))
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
+	#define SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT	(1 << 31)
+	#define SPEAR1310_MIPHY_DUAL_CLK_REF_DIV2	(1 << 28)
+	#define SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(x)	(x << 16)
+	#define SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT	(1 << 15)
+	#define SPEAR1310_MIPHY_SINGLE_CLK_REF_DIV2	(1 << 12)
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
@@ -181,6 +256,104 @@ static int sata_miphy_resume(struct st_miphy40lp_priv *phypriv)
 		return -EINVAL;
 }
 
+static int spear1340_pcie_miphy_init(struct st_miphy40lp_priv *phypriv)
+{
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK,
+			SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE);
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_PCIE_CFG_VAL);
+
+	return 0;
+}
+
+static int spear1340_pcie_miphy_exit(struct st_miphy40lp_priv *phypriv)
+{
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
+
+	return 0;
+}
+
+static int spear1310_pcie_miphy_init(struct st_miphy40lp_priv *phypriv)
+{
+	u32 mask, val;
+
+	regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE);
+
+	switch (phypriv->id) {
+	case 0:
+		mask = SPEAR1310_PCIE_CFG_MASK(0);
+		val = SPEAR1310_PCIE_CFG_VAL(0);
+		break;
+	case 1:
+		mask = SPEAR1310_PCIE_CFG_MASK(1);
+		val = SPEAR1310_PCIE_CFG_VAL(1);
+		break;
+	case 2:
+		mask = SPEAR1310_PCIE_CFG_MASK(2);
+		val = SPEAR1310_PCIE_CFG_VAL(2);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_SATA_CFG, mask, val);
+
+	return 0;
+}
+
+static int spear1310_pcie_miphy_exit(struct st_miphy40lp_priv *phypriv)
+{
+	u32 mask;
+
+	switch (phypriv->id) {
+	case 0:
+		mask = SPEAR1310_PCIE_CFG_MASK(0);
+		break;
+	case 1:
+		mask = SPEAR1310_PCIE_CFG_MASK(1);
+		break;
+	case 2:
+		mask = SPEAR1310_PCIE_CFG_MASK(2);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_SATA_CFG,
+			SPEAR1310_PCIE_CFG_MASK(phypriv->id), 0);
+
+	regmap_update_bits(phypriv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK, 0);
+
+	return 0;
+}
+
+static int pcie_miphy_init(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_pcie_miphy_init(phypriv);
+	else if (of_device_is_compatible(phypriv->np, "st,spear1310-miphy"))
+		return spear1310_pcie_miphy_init(phypriv);
+	else
+		return -EINVAL;
+}
+
+static int pcie_miphy_exit(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_pcie_miphy_exit(phypriv);
+	else if (of_device_is_compatible(phypriv->np, "st,spear1310-miphy"))
+		return spear1310_pcie_miphy_exit(phypriv);
+	else
+		return -EINVAL;
+}
+
 static int miphy40lp_init(struct phy *phy)
 {
 	struct st_miphy40lp_priv *phypriv = phy_get_drvdata(phy);
@@ -188,6 +361,8 @@ static int miphy40lp_init(struct phy *phy)
 	switch (phypriv->mode) {
 	case SATA:
 		return sata_miphy_init(phypriv);
+	case PCIE:
+		return pcie_miphy_init(phypriv);
 	default:
 		return -EINVAL;
 	}
@@ -200,6 +375,8 @@ static int miphy40lp_exit(struct phy *phy)
 	switch (phypriv->mode) {
 	case SATA:
 		return sata_miphy_exit(phypriv);
+	case PCIE:
+		return pcie_miphy_exit(phypriv);
 	default:
 		return -EINVAL;
 	}
@@ -232,6 +409,7 @@ static int miphy40lp_power_on(struct phy *phy)
 static const struct of_device_id st_miphy40lp_of_match[] = {
 	{ .compatible = "st,miphy40lp-phy" },
 	{ .compatible = "st,spear1340-miphy" },
+	{ .compatible = "st,spear1310-miphy" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, st_miphy40lp_of_match);
-- 
1.8.1.2


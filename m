Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbbATVwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:52:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:15690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbbATVuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442896582"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] x86: pmc_atom: print index of device in loop
Date: Tue, 20 Jan 2015 23:50:01 +0200
Message-Id: <1421790603-30097-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register mapping may change from one platform to another. Thus, indices
might be not the same on different platforms. The patch makes the code to print
the device index dynamically at run time.

The patch also changes the for loop to iterate over the map until a terminator
is found.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kernel/pmc_atom.c | 129 ++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index d338222..0bcfc9e 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -43,63 +43,65 @@ struct pmc_bit_map {
 };
 
 static const struct pmc_bit_map dev_map[] = {
-	{"0  - LPSS1_F0_DMA",		BIT_LPSS1_F0_DMA},
-	{"1  - LPSS1_F1_PWM1",		BIT_LPSS1_F1_PWM1},
-	{"2  - LPSS1_F2_PWM2",		BIT_LPSS1_F2_PWM2},
-	{"3  - LPSS1_F3_HSUART1",	BIT_LPSS1_F3_HSUART1},
-	{"4  - LPSS1_F4_HSUART2",	BIT_LPSS1_F4_HSUART2},
-	{"5  - LPSS1_F5_SPI",		BIT_LPSS1_F5_SPI},
-	{"6  - LPSS1_F6_Reserved",	BIT_LPSS1_F6_XXX},
-	{"7  - LPSS1_F7_Reserved",	BIT_LPSS1_F7_XXX},
-	{"8  - SCC_EMMC",		BIT_SCC_EMMC},
-	{"9  - SCC_SDIO",		BIT_SCC_SDIO},
-	{"10 - SCC_SDCARD",		BIT_SCC_SDCARD},
-	{"11 - SCC_MIPI",		BIT_SCC_MIPI},
-	{"12 - HDA",			BIT_HDA},
-	{"13 - LPE",			BIT_LPE},
-	{"14 - OTG",			BIT_OTG},
-	{"15 - USH",			BIT_USH},
-	{"16 - GBE",			BIT_GBE},
-	{"17 - SATA",			BIT_SATA},
-	{"18 - USB_EHCI",		BIT_USB_EHCI},
-	{"19 - SEC",			BIT_SEC},
-	{"20 - PCIE_PORT0",		BIT_PCIE_PORT0},
-	{"21 - PCIE_PORT1",		BIT_PCIE_PORT1},
-	{"22 - PCIE_PORT2",		BIT_PCIE_PORT2},
-	{"23 - PCIE_PORT3",		BIT_PCIE_PORT3},
-	{"24 - LPSS2_F0_DMA",		BIT_LPSS2_F0_DMA},
-	{"25 - LPSS2_F1_I2C1",		BIT_LPSS2_F1_I2C1},
-	{"26 - LPSS2_F2_I2C2",		BIT_LPSS2_F2_I2C2},
-	{"27 - LPSS2_F3_I2C3",		BIT_LPSS2_F3_I2C3},
-	{"28 - LPSS2_F3_I2C4",		BIT_LPSS2_F4_I2C4},
-	{"29 - LPSS2_F5_I2C5",		BIT_LPSS2_F5_I2C5},
-	{"30 - LPSS2_F6_I2C6",		BIT_LPSS2_F6_I2C6},
-	{"31 - LPSS2_F7_I2C7",		BIT_LPSS2_F7_I2C7},
-	{"32 - SMB",			BIT_SMB},
-	{"33 - OTG_SS_PHY",		BIT_OTG_SS_PHY},
-	{"34 - USH_SS_PHY",		BIT_USH_SS_PHY},
-	{"35 - DFX",			BIT_DFX},
+	{"LPSS1_F0_DMA",	BIT_LPSS1_F0_DMA},
+	{"LPSS1_F1_PWM1",	BIT_LPSS1_F1_PWM1},
+	{"LPSS1_F2_PWM2",	BIT_LPSS1_F2_PWM2},
+	{"LPSS1_F3_HSUART1",	BIT_LPSS1_F3_HSUART1},
+	{"LPSS1_F4_HSUART2",	BIT_LPSS1_F4_HSUART2},
+	{"LPSS1_F5_SPI",	BIT_LPSS1_F5_SPI},
+	{"LPSS1_F6_Reserved",	BIT_LPSS1_F6_XXX},
+	{"LPSS1_F7_Reserved",	BIT_LPSS1_F7_XXX},
+	{"SCC_EMMC",		BIT_SCC_EMMC},
+	{"SCC_SDIO",		BIT_SCC_SDIO},
+	{"SCC_SDCARD",		BIT_SCC_SDCARD},
+	{"SCC_MIPI",		BIT_SCC_MIPI},
+	{"HDA",			BIT_HDA},
+	{"LPE",			BIT_LPE},
+	{"OTG",			BIT_OTG},
+	{"USH",			BIT_USH},
+	{"GBE",			BIT_GBE},
+	{"SATA",		BIT_SATA},
+	{"USB_EHCI",		BIT_USB_EHCI},
+	{"SEC",			BIT_SEC},
+	{"PCIE_PORT0",		BIT_PCIE_PORT0},
+	{"PCIE_PORT1",		BIT_PCIE_PORT1},
+	{"PCIE_PORT2",		BIT_PCIE_PORT2},
+	{"PCIE_PORT3",		BIT_PCIE_PORT3},
+	{"LPSS2_F0_DMA",	BIT_LPSS2_F0_DMA},
+	{"LPSS2_F1_I2C1",	BIT_LPSS2_F1_I2C1},
+	{"LPSS2_F2_I2C2",	BIT_LPSS2_F2_I2C2},
+	{"LPSS2_F3_I2C3",	BIT_LPSS2_F3_I2C3},
+	{"LPSS2_F3_I2C4",	BIT_LPSS2_F4_I2C4},
+	{"LPSS2_F5_I2C5",	BIT_LPSS2_F5_I2C5},
+	{"LPSS2_F6_I2C6",	BIT_LPSS2_F6_I2C6},
+	{"LPSS2_F7_I2C7",	BIT_LPSS2_F7_I2C7},
+	{"SMB",			BIT_SMB},
+	{"OTG_SS_PHY",		BIT_OTG_SS_PHY},
+	{"USH_SS_PHY",		BIT_USH_SS_PHY},
+	{"DFX",			BIT_DFX},
+	{},
 };
 
 static const struct pmc_bit_map pss_map[] = {
-	{"0  - GBE",			PMC_PSS_BIT_GBE},
-	{"1  - SATA",			PMC_PSS_BIT_SATA},
-	{"2  - HDA",			PMC_PSS_BIT_HDA},
-	{"3  - SEC",			PMC_PSS_BIT_SEC},
-	{"4  - PCIE",			PMC_PSS_BIT_PCIE},
-	{"5  - LPSS",			PMC_PSS_BIT_LPSS},
-	{"6  - LPE",			PMC_PSS_BIT_LPE},
-	{"7  - DFX",			PMC_PSS_BIT_DFX},
-	{"8  - USH_CTRL",		PMC_PSS_BIT_USH_CTRL},
-	{"9  - USH_SUS",		PMC_PSS_BIT_USH_SUS},
-	{"10 - USH_VCCS",		PMC_PSS_BIT_USH_VCCS},
-	{"11 - USH_VCCA",		PMC_PSS_BIT_USH_VCCA},
-	{"12 - OTG_CTRL",		PMC_PSS_BIT_OTG_CTRL},
-	{"13 - OTG_VCCS",		PMC_PSS_BIT_OTG_VCCS},
-	{"14 - OTG_VCCA_CLK",		PMC_PSS_BIT_OTG_VCCA_CLK},
-	{"15 - OTG_VCCA",		PMC_PSS_BIT_OTG_VCCA},
-	{"16 - USB",			PMC_PSS_BIT_USB},
-	{"17 - USB_SUS",		PMC_PSS_BIT_USB_SUS},
+	{"GBE",			PMC_PSS_BIT_GBE},
+	{"SATA",		PMC_PSS_BIT_SATA},
+	{"HDA",			PMC_PSS_BIT_HDA},
+	{"SEC",			PMC_PSS_BIT_SEC},
+	{"PCIE",		PMC_PSS_BIT_PCIE},
+	{"LPSS",		PMC_PSS_BIT_LPSS},
+	{"LPE",			PMC_PSS_BIT_LPE},
+	{"DFX",			PMC_PSS_BIT_DFX},
+	{"USH_CTRL",		PMC_PSS_BIT_USH_CTRL},
+	{"USH_SUS",		PMC_PSS_BIT_USH_SUS},
+	{"USH_VCCS",		PMC_PSS_BIT_USH_VCCS},
+	{"USH_VCCA",		PMC_PSS_BIT_USH_VCCA},
+	{"OTG_CTRL",		PMC_PSS_BIT_OTG_CTRL},
+	{"OTG_VCCS",		PMC_PSS_BIT_OTG_VCCS},
+	{"OTG_VCCA_CLK",	PMC_PSS_BIT_OTG_VCCA_CLK},
+	{"OTG_VCCA",		PMC_PSS_BIT_OTG_VCCA},
+	{"USB",			PMC_PSS_BIT_USB},
+	{"USB_SUS",		PMC_PSS_BIT_USB_SUS},
+	{},
 };
 
 static inline u32 pmc_reg_read(struct pmc_dev *pmc, int reg_offset)
@@ -148,16 +150,14 @@ static int pmc_dev_state_show(struct seq_file *s, void *unused)
 	struct pmc_dev *pmc = s->private;
 	u32 func_dis, func_dis_2, func_dis_index;
 	u32 d3_sts_0, d3_sts_1, d3_sts_index;
-	int dev_num, dev_index, reg_index;
+	int dev_index, reg_index;
 
 	func_dis = pmc_reg_read(pmc, PMC_FUNC_DIS);
 	func_dis_2 = pmc_reg_read(pmc, PMC_FUNC_DIS_2);
 	d3_sts_0 = pmc_reg_read(pmc, PMC_D3_STS_0);
 	d3_sts_1 = pmc_reg_read(pmc, PMC_D3_STS_1);
 
-	dev_num = ARRAY_SIZE(dev_map);
-
-	for (dev_index = 0; dev_index < dev_num; dev_index++) {
+	for (dev_index = 0; dev_map[dev_index].name; dev_index++) {
 		reg_index = dev_index / PMC_REG_BIT_WIDTH;
 		if (reg_index) {
 			func_dis_index = func_dis_2;
@@ -167,8 +167,8 @@ static int pmc_dev_state_show(struct seq_file *s, void *unused)
 			d3_sts_index = d3_sts_0;
 		}
 
-		seq_printf(s, "Dev: %-32s\tState: %s [%s]\n",
-			dev_map[dev_index].name,
+		seq_printf(s, "Dev: %-2d - %-32s\tState: %s [%s]\n",
+			dev_index, dev_map[dev_index].name,
 			dev_map[dev_index].bit_mask & func_dis_index ?
 			"Disabled" : "Enabled ",
 			dev_map[dev_index].bit_mask & d3_sts_index ?
@@ -195,9 +195,9 @@ static int pmc_pss_state_show(struct seq_file *s, void *unused)
 	u32 pss = pmc_reg_read(pmc, PMC_PSS);
 	int pss_index;
 
-	for (pss_index = 0; pss_index < ARRAY_SIZE(pss_map); pss_index++) {
-		seq_printf(s, "Island: %-32s\tState: %s\n",
-			pss_map[pss_index].name,
+	for (pss_index = 0; pss_map[pss_index].name; pss_index++) {
+		seq_printf(s, "Island: %-2d - %-32s\tState: %s\n",
+			pss_index, pss_map[pss_index].name,
 			pss_map[pss_index].bit_mask & pss ? "Off" : "On");
 	}
 	return 0;
@@ -322,9 +322,8 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 	pmc_hw_reg_setup(pmc);
 
 	ret = pmc_dbgfs_register(pmc);
-	if (ret) {
+	if (ret)
 		iounmap(pmc->regmap);
-	}
 
 	return ret;
 }
-- 
2.1.4


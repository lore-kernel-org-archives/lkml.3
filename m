Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbaEFNid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:38:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54875 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbaEFNfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:35:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <rogerq@ti.com>, <balajitk@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 09/17] arm: dra7xx: Add hwmod data for pcie1 phy and pcie2 phy
Date: Tue, 6 May 2014 19:03:55 +0530
Message-ID: <1399383244-14556-10-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399383244-14556-1-git-send-email-kishon@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added hwmod data for pcie1 and pcie2 phy present in DRA7xx SOC.
Also added the missing CLKCTRL OFFSET macro and CONTEXT OFFSET macro
for pcie1 phy and pcie2 phy.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/cm2_7xx.h             |    4 ++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   57 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prm7xx.h              |    4 ++
 3 files changed, 65 insertions(+)

diff --git a/arch/arm/mach-omap2/cm2_7xx.h b/arch/arm/mach-omap2/cm2_7xx.h
index 9ad7594..e966e3a 100644
--- a/arch/arm/mach-omap2/cm2_7xx.h
+++ b/arch/arm/mach-omap2/cm2_7xx.h
@@ -357,6 +357,10 @@
 #define DRA7XX_CM_L3INIT_SATA_CLKCTRL				DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x0088)
 #define DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET				0x00a0
 #define DRA7XX_CM_PCIE_STATICDEP_OFFSET				0x00a4
+#define DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL_OFFSET			0x00b0
+#define DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL			DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x00b0)
+#define DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL_OFFSET			0x00b8
+#define DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL			DRA7XX_CM_CORE_REGADDR(DRA7XX_CM_CORE_L3INIT_INST, 0x00b8)
 #define DRA7XX_CM_GMAC_CLKSTCTRL_OFFSET				0x00c0
 #define DRA7XX_CM_GMAC_STATICDEP_OFFSET				0x00c4
 #define DRA7XX_CM_GMAC_DYNAMICDEP_OFFSET			0x00c8
diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index b9bb476..1282a42 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1231,6 +1231,45 @@ static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
 };
 
 /*
+ * 'PCIE PHY' class
+ *
+ */
+
+static struct omap_hwmod_class dra7xx_pcie_phy_hwmod_class = {
+	.name	= "pcie-phy",
+};
+
+/* pcie1 phy */
+static struct omap_hwmod dra7xx_pcie1_phy_hwmod = {
+	.name		= "pcie1-phy",
+	.class		= &dra7xx_pcie_phy_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L3INIT_PCIESS1_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L3INIT_PCIESS1_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* pcie2 phy */
+static struct omap_hwmod dra7xx_pcie2_phy_hwmod = {
+	.name		= "pcie2-phy",
+	.class		= &dra7xx_pcie_phy_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L3INIT_PCIESS2_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L3INIT_PCIESS2_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
  * 'qspi' class
  *
  */
@@ -2349,6 +2388,22 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_cfg -> pcie1 phy */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1_phy = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_pcie1_phy_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4_cfg -> pcie2 phy */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie2_phy = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_pcie2_phy_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_addr_space dra7xx_qspi_addrs[] = {
 	{
 		.pa_start	= 0x4b300000,
@@ -2696,6 +2751,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_cfg__mpu,
 	&dra7xx_l4_cfg__ocp2scp1,
 	&dra7xx_l4_cfg__ocp2scp3,
+	&dra7xx_l4_cfg__pcie1_phy,
+	&dra7xx_l4_cfg__pcie2_phy,
 	&dra7xx_l3_main_1__qspi,
 	&dra7xx_l4_cfg__sata,
 	&dra7xx_l4_cfg__smartreflex_core,
diff --git a/arch/arm/mach-omap2/prm7xx.h b/arch/arm/mach-omap2/prm7xx.h
index d92a840..4bb50fbf 100644
--- a/arch/arm/mach-omap2/prm7xx.h
+++ b/arch/arm/mach-omap2/prm7xx.h
@@ -374,6 +374,10 @@
 #define DRA7XX_RM_L3INIT_IEEE1500_2_OCP_CONTEXT_OFFSET		0x007c
 #define DRA7XX_PM_L3INIT_SATA_WKDEP_OFFSET			0x0088
 #define DRA7XX_RM_L3INIT_SATA_CONTEXT_OFFSET			0x008c
+#define DRA7XX_PM_L3INIT_PCIESS1_WKDEP_OFFSET			0x00b0
+#define DRA7XX_RM_L3INIT_PCIESS1_CONTEXT_OFFSET		0x00b4
+#define DRA7XX_PM_L3INIT_PCIESS2_WKDEP_OFFSET			0x00b8
+#define DRA7XX_RM_L3INIT_PCIESS2_CONTEXT_OFFSET		0x00bc
 #define DRA7XX_RM_GMAC_GMAC_CONTEXT_OFFSET			0x00d4
 #define DRA7XX_RM_L3INIT_OCP2SCP1_CONTEXT_OFFSET		0x00e4
 #define DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET		0x00ec
-- 
1.7.9.5


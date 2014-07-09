Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbaGIJDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:03:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35518 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGIJDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:03:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <rnayak@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH v2] arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
Date: Wed, 9 Jul 2014 14:32:47 +0530
Message-ID: <1404896567-32204-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403719366-9656-3-git-send-email-kishon@ti.com>
References: <1403719366-9656-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added hwmod data for pcie1 and pcie2 subsystem present in DRA7xx SOC.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
* changed the clock domain to "pcie_clkdm"
* Added PCIe as a slave port for l3_main.

Boot log for dra7xx can be found at http://paste.ubuntu.com/7769402/

 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   73 +++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 6ff40a6..2f37ca8 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1290,6 +1290,43 @@ static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
 };
 
 /*
+ * 'PCIE' class
+ *
+ */
+
+static struct omap_hwmod_class dra7xx_pcie_hwmod_class = {
+	.name	= "pcie",
+};
+
+/* pcie1 */
+static struct omap_hwmod dra7xx_pcie1_hwmod = {
+	.name		= "pcie1",
+	.class		= &dra7xx_pcie_hwmod_class,
+	.clkdm_name	= "pcie_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs	= DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET,
+			.modulemode	= MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/* pcie2 */
+static struct omap_hwmod dra7xx_pcie2_hwmod = {
+	.name		= "pcie2",
+	.class		= &dra7xx_pcie_hwmod_class,
+	.clkdm_name	= "pcie_clkdm",
+	.main_clk	= "l4_root_clk_div",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_PCIE_CLKSTCTRL_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+/*
  * 'PCIE PHY' class
  *
  */
@@ -2448,6 +2485,38 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l3_main_1 -> pcie1 */
+static struct omap_hwmod_ocp_if dra7xx_l3_main_1__pcie1 = {
+	.master		= &dra7xx_l3_main_1_hwmod,
+	.slave		= &dra7xx_pcie1_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4_cfg -> pcie1 */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1 = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_pcie1_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l3_main_1 -> pcie2 */
+static struct omap_hwmod_ocp_if dra7xx_l3_main_1__pcie2 = {
+	.master		= &dra7xx_l3_main_1_hwmod,
+	.slave		= &dra7xx_pcie2_hwmod,
+	.clk		= "l3_iclk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* l4_cfg -> pcie2 */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie2 = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_pcie2_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* l4_cfg -> pcie1 phy */
 static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1_phy = {
 	.master		= &dra7xx_l4_cfg_hwmod,
@@ -2813,6 +2882,10 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_cfg__mpu,
 	&dra7xx_l4_cfg__ocp2scp1,
 	&dra7xx_l4_cfg__ocp2scp3,
+	&dra7xx_l3_main_1__pcie1,
+	&dra7xx_l4_cfg__pcie1,
+	&dra7xx_l3_main_1__pcie2,
+	&dra7xx_l4_cfg__pcie2,
 	&dra7xx_l4_cfg__pcie1_phy,
 	&dra7xx_l4_cfg__pcie2_phy,
 	&dra7xx_l3_main_1__qspi,
-- 
1.7.9.5


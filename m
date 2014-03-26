Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaCZOCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:02:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46620 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaCZN7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:59:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>, <jg1.han@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <rnayak@ti.com>, <paul@pwsan.com>, <kishon@ti.com>
Subject: [RFC PATCH 07/12] arm: dra7xx: Add hwmod data for pcie1 and pcie2 subsystems
Date: Wed, 26 Mar 2014 19:27:47 +0530
Message-ID: <1395842272-15267-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395842272-15267-1-git-send-email-kishon@ti.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added hwmod data for pcie1 and pcie2 subsystem present in DRA7xx SOC.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   55 +++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 9397265..c789b00 100644
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
+	.clkdm_name	= "l3init_clkdm",
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
+	.clkdm_name	= "l3init_clkdm",
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
@@ -2459,6 +2496,22 @@ static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp1 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_cfg -> pcie1 */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__pcie1 = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_pcie1_hwmod,
+	.clk		= "l4_root_clk_div",
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
@@ -2824,6 +2877,8 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_cfg__mpu,
 	&dra7xx_l4_cfg__ocp2scp1,
 	&dra7xx_l4_cfg__ocp2scp3,
+	&dra7xx_l4_cfg__pcie1,
+	&dra7xx_l4_cfg__pcie2,
 	&dra7xx_l4_cfg__pcie1_phy,
 	&dra7xx_l4_cfg__pcie2_phy,
 	&dra7xx_l3_main_1__qspi,
-- 
1.7.9.5


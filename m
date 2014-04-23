Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbaDWRgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:36:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41871 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbaDWRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:36:09 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 3/4] ARM: DRA7: hwmod: Add ocp2scp3 and sata hwmods
Date: Wed, 23 Apr 2014 20:35:59 +0300
Message-ID: <1398274559-24777-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398274237-24510-1-git-send-email-rogerq@ti.com>
References: <1398274237-24510-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Add hwmods for ocp2scp3 and sata modules.

[Roger Q] Clean up.

CC: Benoit Cousson <bcousson@baylibre.com>
CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 810c205..b02a4ab 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1215,6 +1215,30 @@ static struct omap_hwmod dra7xx_ocp2scp1_hwmod = {
 	},
 };
 
+/* ocp2scp3 */
+static struct omap_hwmod dra7xx_ocp2scp3_hwmod;
+
+/* l4_cfg -> ocp2scp3 */
+static struct omap_hwmod_ocp_if dra7xx_l4_cfg__ocp2scp3 = {
+	.master		= &dra7xx_l4_cfg_hwmod,
+	.slave		= &dra7xx_ocp2scp3_hwmod,
+	.clk		= "l4_root_clk_div",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+static struct omap_hwmod dra7xx_ocp2scp3_hwmod = {
+	.name		= "ocp2scp3",
+	.class		= &dra7xx_ocp2scp_hwmod_class,
+	.clkdm_name	= "l3init_clkdm",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = DRA7XX_CM_L3INIT_OCP2SCP3_CLKCTRL_OFFSET,
+			.context_offs = DRA7XX_RM_L3INIT_OCP2SCP3_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_HWCTRL,
+		},
+	},
+};
+
 /*
  * 'qspi' class
  *
@@ -1268,9 +1292,6 @@ static struct omap_hwmod_class dra7xx_sata_hwmod_class = {
 };
 
 /* sata */
-static struct omap_hwmod_opt_clk sata_opt_clks[] = {
-	{ .role = "ref_clk", .clk = "sata_ref_clk" },
-};
 
 static struct omap_hwmod dra7xx_sata_hwmod = {
 	.name		= "sata",
@@ -1278,6 +1299,7 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
 	.clkdm_name	= "l3init_clkdm",
 	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
 	.main_clk	= "func_48m_fclk",
+	.mpu_rt_idx	= 1,
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = DRA7XX_CM_L3INIT_SATA_CLKCTRL_OFFSET,
@@ -1285,8 +1307,6 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
 			.modulemode   = MODULEMODE_SWCTRL,
 		},
 	},
-	.opt_clks	= sata_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(sata_opt_clks),
 };
 
 /*
@@ -2682,6 +2702,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_per1__mmc4,
 	&dra7xx_l4_cfg__mpu,
 	&dra7xx_l4_cfg__ocp2scp1,
+	&dra7xx_l4_cfg__ocp2scp3,
 	&dra7xx_l3_main_1__qspi,
 	&dra7xx_l4_cfg__sata,
 	&dra7xx_l4_cfg__smartreflex_core,
-- 
1.8.3.2


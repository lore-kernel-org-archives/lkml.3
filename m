Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaKDLQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:16:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32818 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbaKDLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:16:25 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Vignesh R <vigneshr@ti.com>
Subject: [PATCH v2 1/3] ARM: OMAP2+: hwmod: AM335x/AM43x: Move am33xx_l4_hs_hwmod to ipblock_data
Date: Tue, 4 Nov 2014 16:45:26 +0530
Message-ID: <1415099728-10959-2-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves am33xx_l4_hs_hwmod from 33xx_data to ipblock_data. This
is required because it can be reused in 43xx to add hwmod support to
tscadc as it uses the same l4_hs hwmod in am43xx. This helps in setting
appropriate clock domain names for tscadc on am33xx and am43xx.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h  |  1 +
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 15 +++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c              | 15 ---------------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
index 130332c0534d..6e57b8ad0db5 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_common_data.h
@@ -82,6 +82,7 @@ extern struct omap_hwmod am33xx_l3_main_hwmod;
 extern struct omap_hwmod am33xx_l3_s_hwmod;
 extern struct omap_hwmod am33xx_l3_instr_hwmod;
 extern struct omap_hwmod am33xx_l4_ls_hwmod;
+extern struct omap_hwmod am33xx_l4_hs_hwmod;
 extern struct omap_hwmod am33xx_l4_wkup_hwmod;
 extern struct omap_hwmod am33xx_mpu_hwmod;
 extern struct omap_hwmod am33xx_pruss_hwmod;
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
index a579b89ce9b7..7f44922ab540 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
@@ -94,6 +94,21 @@ struct omap_hwmod am33xx_l4_ls_hwmod = {
 	},
 };
 
+/* l4_hs */
+struct omap_hwmod am33xx_l4_hs_hwmod = {
+	.name		= "l4_hs",
+	.class		= &am33xx_l4_hwmod_class,
+	.clkdm_name	= "l4hs_clkdm",
+	.flags		= HWMOD_INIT_NO_IDLE,
+	.main_clk	= "l4hs_gclk",
+	.prcm		= {
+		.omap4  = {
+			.clkctrl_offs   = AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET,
+			.modulemode     = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
 /* l4_wkup */
 struct omap_hwmod am33xx_l4_wkup_hwmod = {
 	.name		= "l4_wkup",
diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
index 6b406ca4bd3b..ce7d260495cb 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_data.c
@@ -63,21 +63,6 @@ static struct omap_hwmod am33xx_emif_hwmod = {
 	},
 };
 
-/* l4_hs */
-static struct omap_hwmod am33xx_l4_hs_hwmod = {
-	.name		= "l4_hs",
-	.class		= &am33xx_l4_hwmod_class,
-	.clkdm_name	= "l4hs_clkdm",
-	.flags		= HWMOD_INIT_NO_IDLE,
-	.main_clk	= "l4hs_gclk",
-	.prcm		= {
-		.omap4	= {
-			.clkctrl_offs	= AM33XX_CM_PER_L4HS_CLKCTRL_OFFSET,
-			.modulemode	= MODULEMODE_SWCTRL,
-		},
-	},
-};
-
 static struct omap_hwmod_rst_info am33xx_wkup_m3_resets[] = {
 	{ .name = "wkup_m3", .rst_shift = 3, .st_shift = 5 },
 };
-- 
1.9.1


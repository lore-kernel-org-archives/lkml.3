Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaLRQYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:24:38 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39705 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaLRQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:24:35 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        LAK <linux-arm-kernel@lists.infradead.org>,
        OMAP <linux-omap@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/5] ARM: AM43xx: hwmod: add VPFE hwmod entries
Date: Thu, 18 Dec 2014 21:54:10 +0530
Message-Id: <1418919854-16164-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1418919854-16164-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

this patch adds VPFE HWMOD data for AM43xx.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 56 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/prcm43xx.h             |  3 +-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
index fea01aa..bd9067e 100644
--- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
@@ -483,6 +483,44 @@ static struct omap_hwmod am43xx_dss_rfbi_hwmod = {
 	},
 };
 
+static struct omap_hwmod_class_sysconfig am43xx_vpfe_sysc = {
+	.rev_offs       = 0x0,
+	.sysc_offs      = 0x104,
+	.sysc_flags     = SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE,
+	.idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+				MSTANDBY_FORCE | MSTANDBY_SMART | MSTANDBY_NO),
+	.sysc_fields    = &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class am43xx_vpfe_hwmod_class = {
+	.name           = "vpfe",
+	.sysc           = &am43xx_vpfe_sysc,
+};
+
+static struct omap_hwmod am43xx_vpfe0_hwmod = {
+	.name           = "vpfe0",
+	.class          = &am43xx_vpfe_hwmod_class,
+	.clkdm_name     = "l3s_clkdm",
+	.prcm           = {
+		.omap4  = {
+			.modulemode     = MODULEMODE_SWCTRL,
+			.clkctrl_offs   = AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET,
+		},
+	},
+};
+
+static struct omap_hwmod am43xx_vpfe1_hwmod = {
+	.name           = "vpfe1",
+	.class          = &am43xx_vpfe_hwmod_class,
+	.clkdm_name     = "l3s_clkdm",
+	.prcm           = {
+		.omap4  = {
+			.modulemode     = MODULEMODE_SWCTRL,
+			.clkctrl_offs   = AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET,
+		},
+	},
+};
+
 /* Interfaces */
 static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
 	.master		= &am33xx_l3_main_hwmod,
@@ -750,6 +788,22 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
+	.master         = &am33xx_l3_main_hwmod,
+	.slave          = &am43xx_vpfe0_hwmod,
+	.clk            = "l3_gclk",
+	.flags          = OCPIF_SWSUP_IDLE,
+	.user           = OCP_USER_MPU,
+};
+
+static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
+	.master         = &am33xx_l3_main_hwmod,
+	.slave          = &am43xx_vpfe1_hwmod,
+	.clk            = "l3_gclk",
+	.flags          = OCPIF_SWSUP_IDLE,
+	.user           = OCP_USER_MPU,
+};
+
 static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am33xx_l4_wkup__synctimer,
 	&am43xx_l4_ls__timer8,
@@ -848,6 +902,8 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata = {
 	&am43xx_l4_ls__dss,
 	&am43xx_l4_ls__dss_dispc,
 	&am43xx_l4_ls__dss_rfbi,
+	&am43xx_l3__vpfe0,
+	&am43xx_l3__vpfe1,
 	NULL,
 };
 
diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43xx.h
index ad7b3e9..8aa4c2c 100644
--- a/arch/arm/mach-omap2/prcm43xx.h
+++ b/arch/arm/mach-omap2/prcm43xx.h
@@ -143,5 +143,6 @@
 #define AM43XX_CM_PER_USB_OTG_SS1_CLKCTRL_OFFSET        0x0268
 #define AM43XX_CM_PER_USBPHYOCP2SCP1_CLKCTRL_OFFSET	0x05C0
 #define AM43XX_CM_PER_DSS_CLKCTRL_OFFSET		0x0a20
-
+#define AM43XX_CM_PER_VPFE0_CLKCTRL_OFFSET		0x0068
+#define AM43XX_CM_PER_VPFE1_CLKCTRL_OFFSET		0x0070
 #endif
-- 
1.9.1


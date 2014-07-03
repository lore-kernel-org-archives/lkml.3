Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaGCLBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:01:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37405 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaGCLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:01:33 -0400
From: Roger Quadros <rogerq@ti.com>
To: <paul@pwsan.com>, <tony@atomide.com>
CC: <rnayak@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>, <balbi@ti.com>,
        <balajitk@ti.com>, <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 2/3] ARM: DRA7: hwmod: Fixup SATA hwmod
Date: Thu, 3 Jul 2014 14:01:13 +0300
Message-ID: <1404385274-5093-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404385274-5093-1-git-send-email-rogerq@ti.com>
References: <1404385274-5093-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of optional clock as that is now managed by the
AHCI platform driver.

Correct .mpu_rt_idx to 1 as the module register space (SYSCONFIG..)
is passed as the second memory resource in the device tree.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Rajendra Nayak <rnayak@ti.com>
Tested-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index c9daee4..5ea094a 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -1283,9 +1283,6 @@ static struct omap_hwmod_class dra7xx_sata_hwmod_class = {
 };
 
 /* sata */
-static struct omap_hwmod_opt_clk sata_opt_clks[] = {
-	{ .role = "ref_clk", .clk = "sata_ref_clk" },
-};
 
 static struct omap_hwmod dra7xx_sata_hwmod = {
 	.name		= "sata",
@@ -1293,6 +1290,7 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
 	.clkdm_name	= "l3init_clkdm",
 	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
 	.main_clk	= "func_48m_fclk",
+	.mpu_rt_idx	= 1,
 	.prcm = {
 		.omap4 = {
 			.clkctrl_offs = DRA7XX_CM_L3INIT_SATA_CLKCTRL_OFFSET,
@@ -1300,8 +1298,6 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
 			.modulemode   = MODULEMODE_SWCTRL,
 		},
 	},
-	.opt_clks	= sata_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(sata_opt_clks),
 };
 
 /*
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaDYXDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:03:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48398 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaDYXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:19 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 06/10] ARM: OMAP4: hwmod: add hwmod data for DES IP
Date: Fri, 25 Apr 2014 18:02:44 -0500
Message-ID: <1398466968-29506-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398466968-29506-1-git-send-email-joelf@ti.com>
References: <1398466968-29506-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 has a DES IP for DES and 3DES encryption, Add hwmod data for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   35 ++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 3b12244..8bf6083 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -4824,6 +4824,40 @@ static struct omap_hwmod_ocp_if omap4_l3_main_2__aes1 = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* DES3DES */
+static struct omap_hwmod_class_sysconfig omap4_des_sysc = {
+	.rev_offs	= 0x30,
+	.sysc_offs	= 0x34,
+	.syss_offs	= 0x38,
+	.sysc_flags	= SYSS_HAS_RESET_STATUS,
+	.sysc_fields	= &omap_hwmod_sysc_type4,
+};
+
+static struct omap_hwmod_class omap4_des_hwmod_class = {
+	.name		= "des",
+	.sysc		= &omap4_des_sysc,
+};
+
+static struct omap_hwmod omap4_des_hwmod = {
+	.name		= "des",
+	.class		= &omap4_des_hwmod_class,
+	.clkdm_name	= "l4_secure_clkdm",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_L4SEC_DES3DES_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L4SEC_DES3DES_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_ocp_if omap4_l4_per__des = {
+	.master		= &omap44xx_l4_per_hwmod,
+	.slave		= &omap4_des_hwmod,
+	.clk		= "des_fck",
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_l3_main_1__dmm,
 	&omap44xx_mpu__dmm,
@@ -4979,6 +5013,7 @@ static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_mpu__emif1,
 	&omap44xx_mpu__emif2,
 	&omap4_l3_main_2__aes1,
+	&omap4_l4_per__des,
 	NULL,
 };
 
-- 
1.7.9.5


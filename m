Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3KYVpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:45:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49092 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3KYVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:45:09 -0500
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 5/7] ARM: OMAP4: hwmod: add hwmod data for DES IP
Date: Mon, 25 Nov 2013 15:44:34 -0600
Message-ID: <1385415876-12387-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385415876-12387-1-git-send-email-joelf@ti.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 has a DES IP for DES and 3DES encryption, Add hwmod data for the same.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 47 ++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
index 664b2c6..e0992d3 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -4844,6 +4844,52 @@ static struct omap_hwmod_ocp_if omap4_l3_main_2__aes1 = {
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
+
+static struct omap_hwmod omap4_des_hwmod = {
+	.name		= "des",
+	.class		= &omap4_des_hwmod_class,
+	.clkdm_name	= "l4_secure_clkdm",
+	.main_clk	= "des_fck",
+	.prcm = {
+		.omap4 = {
+			.clkctrl_offs = OMAP4_CM_L4SEC_DES3DES_CLKCTRL_OFFSET,
+			.context_offs = OMAP4_RM_L4SEC_DES3DES_CONTEXT_OFFSET,
+			.modulemode   = MODULEMODE_SWCTRL,
+		},
+	},
+};
+
+static struct omap_hwmod_addr_space omap4_des_addrs[] = {
+	{
+		.pa_start	= 0x480A4000,
+		.pa_end		= 0x481A4000,
+		.flags		= ADDR_TYPE_RT
+	},
+	{ }
+};
+
+static struct omap_hwmod_ocp_if omap4_l4_per__des = {
+	.master		= &omap44xx_l4_per_hwmod,
+	.slave		= &omap4_des_hwmod,
+	.clk		= "des_fck",
+	.addr		= omap4_des_addrs,
+	.user		= OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_l3_main_1__dmm,
 	&omap44xx_mpu__dmm,
@@ -4999,6 +5045,7 @@ static struct omap_hwmod_ocp_if *omap44xx_hwmod_ocp_ifs[] __initdata = {
 	&omap44xx_mpu__emif1,
 	&omap44xx_mpu__emif2,
 	&omap4_l3_main_2__aes1,
+	&omap4_l4_per__des,
 	NULL,
 };
 
-- 
1.8.1.2


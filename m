Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaDYXGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 19:06:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48405 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaDYXDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 19:03:25 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Joel Fernandes <joelf@ti.com>
Subject: [PATCH 04/10] ARM: DRA7xx: Add hwmod entries for RNG module
Date: Fri, 25 Apr 2014 18:02:42 -0500
Message-ID: <1398466968-29506-5-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398466968-29506-1-git-send-email-joelf@ti.com>
References: <1398466968-29506-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the CLKCTRL offsets, SYSC offsets to the RNG module.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   35 +++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index e76e712..7c75e5f 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -583,6 +583,15 @@ static struct omap_hwmod_class_sysconfig dra7xx_des_sysc = {
 	.sysc_fields	= &omap_hwmod_sysc_type4,
 };
 
+/* rng */
+static struct omap_hwmod_class_sysconfig dra7xx_rng_sysc = {
+        .rev_offs       = 0x1fe0,
+        .sysc_offs      = 0x1fe4,
+        .sysc_flags     = SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE,
+        .idlemodes      = SIDLE_FORCE | SIDLE_NO,
+        .sysc_fields    = &omap_hwmod_sysc_type1,
+};
+
 static struct omap_hwmod_class dra7xx_aes_hwmod_class = {
 	.name	= "aes",
 	.sysc	= &dra7xx_aes_sysc,
@@ -595,6 +604,11 @@ static struct omap_hwmod_class dra7xx_des_hwmod_class = {
 	.rev	= 2,
 };
 
+static struct omap_hwmod_class dra7xx_rng_hwmod_class = {
+        .name           = "rng",
+        .sysc           = &dra7xx_rng_sysc,
+};
+
 /* gpio dev_attr */
 static struct omap_gpio_dev_attr gpio_dev_attr = {
 	.bank_width	= 32,
@@ -810,6 +824,19 @@ static struct omap_hwmod dra7xx_des_hwmod = {
 	},
 };
 
+static struct omap_hwmod dra7xx_rng_hwmod = {
+        .name           = "rng",
+        .class          = &dra7xx_rng_hwmod_class,
+        .clkdm_name     = "l4sec_clkdm",
+        .prcm = {
+                .omap4 = {
+                        .clkctrl_offs = DRA7XX_CM_L4SEC_RNG_CLKCTRL_OFFSET,
+                        .context_offs = DRA7XX_RM_L4SEC_RNG_CONTEXT_OFFSET,
+                        .modulemode   = MODULEMODE_HWCTRL,
+                },
+        },
+};
+
 /*
  * 'gpmc' class
  *
@@ -2246,6 +2273,13 @@ static struct omap_hwmod_ocp_if dra7xx_l4_per1__des = {
 	.user		= OCP_USER_MPU | OCP_USER_SDMA,
 };
 
+/* l4_per1 -> rng */
+static struct omap_hwmod_ocp_if dra7xx_l4_per1__rng = {
+        .master         = &dra7xx_l4_per1_hwmod,
+        .slave          = &dra7xx_rng_hwmod,
+        .user           = OCP_USER_MPU,
+};
+
 static struct omap_hwmod_addr_space dra7xx_gpmc_addrs[] = {
 	{
 		.pa_start	= 0x50000000,
@@ -2782,6 +2816,7 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_per1__uart5,
 	&dra7xx_l4_per1__uart6,
 	&dra7xx_l4_per1__des,
+	&dra7xx_l4_per1__rng,
 	&dra7xx_l4_per3__usb_otg_ss1,
 	&dra7xx_l4_per3__usb_otg_ss2,
 	&dra7xx_l4_per3__usb_otg_ss3,
-- 
1.7.9.5


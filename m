Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3HSPHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:07:02 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:51224 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3HSPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:07:00 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 11:06:59 EDT
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk
Subject: [PATCH] ARM: OMAP: TI81XX: add always-on powerdomain for TI81XX
Date: Mon, 19 Aug 2013 18:56:38 +0400
Message-Id: <1376924198-22678-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds alwon powerdomain support for TI81XX, which is required
for stable functioning of a big number of TI81XX subsystems.
---
 arch/arm/mach-omap2/powerdomains3xxx_data.c | 8 ++++++++
 arch/arm/mach-omap2/prcm-common.h           | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/mach-omap2/powerdomains3xxx_data.c b/arch/arm/mach-omap2/powerdomains3xxx_data.c
index e2d4bd8..328c103 100644
--- a/arch/arm/mach-omap2/powerdomains3xxx_data.c
+++ b/arch/arm/mach-omap2/powerdomains3xxx_data.c
@@ -336,6 +336,13 @@ static struct powerdomain dpll5_pwrdm = {
 	.voltdm		  = { .name = "core" },
 };
 
+static struct powerdomain alwon_81xx_pwrdm = {
+	.name		  = "alwon_pwrdm",
+	.prcm_offs	  = TI81XX_PRM_ALWON_MOD,
+	.pwrsts		  = PWRSTS_OFF_ON,
+	.voltdm		  = { .name = "core" },
+};
+
 static struct powerdomain device_81xx_pwrdm = {
 	.name		  = "device_pwrdm",
 	.prcm_offs	  = TI81XX_PRM_DEVICE_MOD,
@@ -442,6 +449,7 @@ static struct powerdomain *powerdomains_am35x[] __initdata = {
 };
 
 static struct powerdomain *powerdomains_ti81xx[] __initdata = {
+	&alwon_81xx_pwrdm,
 	&device_81xx_pwrdm,
 	&active_816x_pwrdm,
 	&default_816x_pwrdm,
diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index ff1ac4a..0e841fd 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -58,6 +58,7 @@
 #define TI816X_PRM_IVAHD1_MOD			0x0d00
 #define TI816X_PRM_IVAHD2_MOD			0x0e00
 #define TI816X_PRM_SGX_MOD				0x0f00
+#define TI81XX_PRM_ALWON_MOD			0x1800
 
 /* 24XX register bits shared between CM & PRM registers */
 
-- 
1.8.1.2


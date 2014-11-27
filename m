Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaK0X1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:27:15 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:54863 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaK0X1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:27:14 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] ARM vf610: add compatibilty strings of supported Vybrid SoC's
Date: Fri, 28 Nov 2014 00:27:05 +0100
Message-Id: <1417130825-2818-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Vybrid SoC family (in the kernel known as vf610) is a familiy
of multiple similar SoC's. The VF5xx series comes without secondary
Cortex-M4 core, while the second number VFx1x indicates the presence
of a L2 cache controller.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 Documentation/devicetree/bindings/arm/fsl.txt | 12 ++++++++++++
 arch/arm/mach-imx/mach-vf610.c                |  5 ++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
index 4e8b7df..c830b5b 100644
--- a/Documentation/devicetree/bindings/arm/fsl.txt
+++ b/Documentation/devicetree/bindings/arm/fsl.txt
@@ -75,6 +75,18 @@ i.MX6q generic board
 Required root node properties:
     - compatible = "fsl,imx6q";
 
+Freescale Vybrid Platform Device Tree Bindings
+----------------------------------------------
+
+For the Vybrid SoC familiy all variants with DDR controller are supported,
+which is the VF5xx and VF6xx series. Out of historical reasons, in most
+places the kernel uses vf610 to refer to the whole familiy.
+
+Required root node compatible property (one of them):
+    - compatible = "fsl,vf500";
+    - compatible = "fsl,vf510";
+    - compatible = "fsl,vf600";
+    - compatible = "fsl,vf610";
 
 Freescale LS1021A Platform Device Tree Bindings
 ------------------------------------------------
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index c11ab6a..2e7c75b 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -13,11 +13,14 @@
 #include <asm/hardware/cache-l2x0.h>
 
 static const char * const vf610_dt_compat[] __initconst = {
+	"fsl,vf500",
+	"fsl,vf510",
+	"fsl,vf600",
 	"fsl,vf610",
 	NULL,
 };
 
-DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF610 (Device Tree)")
+DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF5xx/VF6xx (Device Tree)")
 	.l2c_aux_val	= 0,
 	.l2c_aux_mask	= ~0,
 	.dt_compat	= vf610_dt_compat,
-- 
2.1.3


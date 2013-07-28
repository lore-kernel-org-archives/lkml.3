Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3G1AA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 20:00:27 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51809 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3G1AAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 20:00:25 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] dts: wandboard: Add support for SDIO bcm4329
Date: Sun, 28 Jul 2013 12:00:20 +1200
Message-Id: <1374969621-4187-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wandboard has a Broadcom 4329 WiFi connected via SDIO. This patch
sets the required pins to enable the wifi module.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
index 7a46f64..2fb0e9b 100644
--- a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
@@ -73,9 +73,14 @@
 	hog {
 		pinctrl_hog: hoggrp {
 			fsl,pins = <
-				MX6QDL_PAD_GPIO_0__CCM_CLKO1 	0x130b0
-				MX6QDL_PAD_GPIO_2__GPIO1_IO02	0x80000000
-				MX6QDL_PAD_EIM_DA9__GPIO3_IO09	0x80000000
+				MX6QDL_PAD_GPIO_0__CCM_CLKO1 	 0x130b0
+				MX6QDL_PAD_GPIO_2__GPIO1_IO02	 0x80000000
+				MX6QDL_PAD_EIM_DA9__GPIO3_IO09	 0x80000000
+				MX6QDL_PAD_EIM_EB1__GPIO2_IO29   0x80000000 /* WL_REF_ON */
+				MX6QDL_PAD_EIM_A25__GPIO5_IO02   0x80000000 /* WL_RST_N */
+				MX6QDL_PAD_ENET_RXD1__GPIO1_IO26 0x80000000 /* WL_REG_ON */
+				MX6QDL_PAD_ENET_TXD1__GPIO1_IO29 0x80000000 /* WL_HOST_WAKE */
+				MX6QDL_PAD_ENET_TXD0__GPIO1_IO30 0x80000000 /* WL_WAKE */
 			>;
 		};
 	};
-- 
1.7.9.5


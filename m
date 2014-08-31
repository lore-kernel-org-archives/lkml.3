Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHaUk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:40:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62339 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHaUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:40:43 -0400
From: Philippe Reynes <tremyfr@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, shc_work@mail.ru,
        Philippe Reynes <tremyfr@gmail.com>
Subject: [PATCH v3] apf27dev: add max1027 in the dts
Date: Sun, 31 Aug 2014 22:40:29 +0200
Message-Id: <1409517629-5918-1-git-send-email-tremyfr@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
---
 arch/arm/boot/dts/imx27-apf27dev.dts |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

Changelog:
v3: (thanks Alexander Shiyan for the feedback)
- add datasheet pin name as comment

v2: (thanks Alexander Shiyan for the feedback)
- spi mode 0 is the default so no need to explicitly define it

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index b982309..0c08fbb 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -82,6 +82,16 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_cspi1 &pinctrl_cspi1_cs>;
 	status = "okay";
+
+	adc@0 {
+		compatible = "maxim,max1027";
+		reg = <0>;
+		interrupt-parent = <&gpio5>;
+		interrupts = <15 IRQ_TYPE_EDGE_FALLING>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_max1027>;
+		spi-max-frequency = <10000000>;
+	};
 };
 
 &cspi2 {
@@ -230,6 +240,13 @@
 		pinctrl_sdhc2_cd: sdhc2cdgrp {
 			fsl,pins = <MX27_PAD_TOUT__GPIO3_14 0x0>;
 		};
+
+		pinctrl_max1027: max1027 {
+			 fsl,pins = <
+				 MX27_PAD_UART1_CTS__GPIO5_14 0 /* CNVST */
+				 MX27_PAD_UART1_RTS__GPIO5_15 0 /* EOC */
+			>;
+		};
 	};
 };
 
-- 
1.7.4.4


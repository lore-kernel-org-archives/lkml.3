Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaH3NWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 09:22:49 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:38120 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaH3NWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 09:22:47 -0400
From: Philippe Reynes <tremyfr@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        Philippe Reynes <tremyfr@gmail.com>
Subject: [PATCH] apf27dev: add max1027 in the dts
Date: Sat, 30 Aug 2014 15:22:12 +0200
Message-Id: <1409404932-12532-1-git-send-email-tremyfr@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Philippe Reynes <tremyfr@gmail.com>
---
 arch/arm/boot/dts/imx27-apf27dev.dts |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index b982309..25b9ecd 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -82,6 +82,19 @@
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
+		/* SPI mode = 0 */
+		spi-cpol = <0>;
+		spi-cpha = <0>;
+		spi-max-frequency = <10000000>;
+	};
 };
 
 &cspi2 {
@@ -230,6 +243,13 @@
 		pinctrl_sdhc2_cd: sdhc2cdgrp {
 			fsl,pins = <MX27_PAD_TOUT__GPIO3_14 0x0>;
 		};
+
+		pinctrl_max1027: max1027 {
+			 fsl,pins = <
+				 MX27_PAD_UART1_CTS__GPIO5_14 0
+				 MX27_PAD_UART1_RTS__GPIO5_15 0
+			>;
+		};
 	};
 };
 
-- 
1.7.4.4


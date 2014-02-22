Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBVVls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:41:48 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44136 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752544AbaBVVkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:40:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 7/7] ARM: dts: sun7i: Enable the SPI controllers of the A20-olinuxino-micro
Date: Sat, 22 Feb 2014 22:35:59 +0100
Message-Id: <1393104959-12831-8-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A20-Olinuxino-micro has two SPI bus exposed on its UEXT connectors, enable
them.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index b02a796..9d98316 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -18,7 +18,24 @@
 	model = "Olimex A20-Olinuxino Micro";
 	compatible = "olimex,a20-olinuxino-micro", "allwinner,sun7i-a20";
 
+	aliases {
+		spi0 = &spi1;
+		spi1 = &spi2;
+	};
+
 	soc@01c00000 {
+		spi1: spi@01c06000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi1_pins_a>;
+			status = "okay";
+		};
+
+		spi2: spi@01c17000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&spi2_pins_a>;
+			status = "okay";
+		};
+
 		pinctrl@01c20800 {
 			led_pins_olinuxino: led_pins@0 {
 				allwinner,pins = "PH2";
-- 
1.9.0


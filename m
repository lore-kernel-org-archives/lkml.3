Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaHQDzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:55:35 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58660 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHQDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:30 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] ARM: dts: sun8i: Enable mmc controller on ippo-q8h-v5
Date: Sun, 17 Aug 2014 11:52:15 +0800
Message-Id: <1408247538-16950-10-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The card detect pin setting was taken from the original fex file,
and is confirmed to work.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
index 224f53e..ef1e4f3 100644
--- a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
+++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
@@ -13,6 +13,7 @@
 
 /dts-v1/;
 /include/ "sun8i-a23.dtsi"
+/include/ "sunxi-common-regulators.dtsi"
 
 / {
 	model = "Ippo Q8H Dual Core Tablet (v5)";
@@ -23,6 +24,25 @@
 	};
 
 	soc@01c00000 {
+		mmc0: mmc@01c0f000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&mmc0_pins_a>, <&mmc0_cd_pin_q8h>;
+			vmmc-supply = <&reg_vcc3v0>;
+			bus-width = <4>;
+			cd-gpios = <&pio 1 4 0>; /* PB4 */
+			cd-inverted;
+			status = "okay";
+		};
+
+		pinctrl@01c20800 {
+			mmc0_cd_pin_q8h: mmc0_cd_pin@0 {
+				allwinner,pins = "PB4";
+				allwinner,function = "gpio_in";
+				allwinner,drive = <0>;
+				allwinner,pull = <1>;
+			};
+		};
+
 		r_uart: serial@01f02800 {
 			pinctrl-names = "default";
 			pinctrl-0 = <&r_uart_pins_a>;
-- 
2.1.0


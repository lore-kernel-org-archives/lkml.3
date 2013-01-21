Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3AUNfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:35:34 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54257 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AUNfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:35:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] ARM: ux500: Enable Snowball's GPIO controlled Ethernet regulator in DT
Date: Mon, 21 Jan 2013 13:35:23 +0000
Message-Id: <1358775323-8155-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Snowball Board's Ethernet chip is configured in a slightly
non-standard way. Its SoC has an address space usually reserved
for a NOR-flash device. However, on the Snowball, that external
bus is populated by the SMSC9115 Ethernet chip. So, to power on
the Ethernet chip, we have to enable the GPIO controlled
regulator which usually controls the NOR-flash. In this patch
we inform the Snowball's Device Tree which GPIO is used to
operate it.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/snowball.dts |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index 27f31a5..4733a96 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -134,6 +134,7 @@
 				reg = <0 0x10000>;
 				interrupts = <12 0x1>;
 				interrupt-parent = <&gpio4>;
+
 				vdd33a-supply = <&en_3v3_reg>;
 				vddvario-supply = <&db8500_vape_reg>;
 
@@ -153,6 +154,7 @@
 			bus-width = <4>;
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
+			vqmmc-supply = <&vmmci>;
 
 			cd-gpios  = <&gpio6 26 0x4>; // 218
 			cd-inverted;
@@ -346,5 +348,12 @@
 				};
 			};
 		};
+
+		vmmci: regulator-gpio {
+			gpios = <&gpio7 4 0x4>;        // 228
+			enable-gpio = <&gpio6 25 0x4>; // 217
+
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5


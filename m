Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaEOPM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:12:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541AbaEOPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:12:55 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: dt: imx28-cfa10036: introduce a regulator for mmc0
Date: Thu, 15 May 2014 17:12:48 +0200
Message-Id: <1400166768-18801-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM3 pinmux configuration conflicts with gpio 3.28. Introduce a regulator
for mmc0 so that it conflicts with the pwm driver and fails gracefully. The
kernel will then able to access mmc0 normally.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10036.dts | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index cabb6171a19d..cd5fab8efa76 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -53,6 +53,17 @@
 					fsl,pull-up = <MXS_PULL_DISABLE>;
 				};
 
+				mmc_pwr_cfa10036: mmc_pwr_cfa10036@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x31c3 /*
+						MX28_PAD_PWM3__GPIO_3_28 */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
 			};
 
 			ssp0: ssp@80010000 {
@@ -60,6 +71,7 @@
 				pinctrl-names = "default";
 				pinctrl-0 = <&mmc0_4bit_pins_a
 					&mmc0_cd_cfg &mmc0_sck_cfg>;
+				vmmc-supply = <&reg_vddio_sd0>;
 				bus-width = <4>;
 				status = "okay";
 			};
@@ -114,4 +126,14 @@
 			default-state = "on";
 		};
 	};
+
+	reg_vddio_sd0: vddio-sd0 {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&mmc_pwr_cfa10036>;
+		regulator-name = "vddio-sd0";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio3 28 0>;
+	};
 };
-- 
1.9.1


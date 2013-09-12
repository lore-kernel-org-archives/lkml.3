Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3ILSfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:35:47 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58515 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3ILSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:35:44 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH v4 1/4] ARM: dts: am335x-bone: add CD for mmc1
Date: Thu, 12 Sep 2013 20:35:32 +0200
Message-Id: <1379010935-25943-2-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
References: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Holler <holler@ahsoftware.de>

This enables the use of MMC cards even when no card was inserted at boot.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 14 ++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts         |  1 -
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2f66ded..0d95d54 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -107,6 +107,12 @@
 				0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
 			>;
 		};
+
+		mmc1_pins: pinmux_mmc1_pins {
+			pinctrl-single,pins = <
+				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
+			>;
+		};
 	};
 
 	ocp {
@@ -260,3 +266,11 @@
 	pinctrl-0 = <&davinci_mdio_default>;
 	pinctrl-1 = <&davinci_mdio_sleep>;
 };
+
+&mmc1 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+	cd-inverted;
+};
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index d5f43fe..0d63348 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -17,6 +17,5 @@
 };
 
 &mmc1 {
-	status = "okay";
 	vmmc-supply = <&ldo3_reg>;
 };
-- 
1.8.2.1


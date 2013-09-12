Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3ILPnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:43:37 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61705 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3ILPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:42:23 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH 1/4] arm: bone: dts: add CD for mmc1
Date: Thu, 12 Sep 2013 17:42:09 +0200
Message-Id: <1379000532-27376-2-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net>
References: <1379000532-27376-1-git-send-email-koen@dominion.thruhere.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Holler <holler@ahsoftware.de>

This enables the use of MMC cards even when no card was inserted at boot.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
---

Changes since v2:
	None, again a simple repost

Changes since v1:
	None, simple repost

 arch/arm/boot/dts/am335x-bone-common.dtsi | 14 ++++++++++++++
 arch/arm/boot/dts/am335x-bone.dts         |  4 ----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 2f66ded..ced256c 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -107,6 +107,11 @@
 				0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
 			>;
 		};
+		mmc1_pins: pinmux_mmc1_pins {
+			pinctrl-single,pins = <
+				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
+			>;
+		};
 	};
 
 	ocp {
@@ -260,3 +265,12 @@
 	pinctrl-0 = <&davinci_mdio_default>;
 	pinctrl-1 = <&davinci_mdio_sleep>;
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&ldo3_reg>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+	cd-inverted;
+};
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index d5f43fe..d34469c 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -16,7 +16,3 @@
 	regulator-always-on;
 };
 
-&mmc1 {
-	status = "okay";
-	vmmc-supply = <&ldo3_reg>;
-};
-- 
1.8.2.1


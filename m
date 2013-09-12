Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3ILSgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:36:50 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52307 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3ILSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:35:45 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
To: linux-kernel@vger.kernel.org
Cc: bcousson@baylibre.com, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH v4 2/4] ARM: dts: am335x-boneblack: add eMMC DT entry
Date: Thu, 12 Sep 2013 20:35:33 +0200
Message-Id: <1379010935-25943-3-git-send-email-koen@dominion.thruhere.net>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
References: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pinmux is specified in am335x-bone-common.dtsi to be reused by the eMMC cape.

Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi | 22 ++++++++++++++++++++++
 arch/arm/boot/dts/am335x-boneblack.dts    | 14 ++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index 0d95d54..bc8d1a2 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -113,6 +113,21 @@
 				0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
 			>;
 		};
+
+		emmc_pins: pinmux_emmc_pins {
+			pinctrl-single,pins = <
+				0x80 (PIN_INPUT_PULLUP | MUX_MODE2) /* gpmc_csn1.mmc1_clk, INPUT_PULLUP | MODE2 */
+				0x84 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_csn2.mmc1_cmd, INPUT_PULLUP | MODE2 */
+				0x00 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad0.mmc1_dat0, INPUT_PULLUP | MODE1 */
+				0x04 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad1.mmc1_dat1, INPUT_PULLUP | MODE1 */
+				0x08 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad2.mmc1_dat2, INPUT_PULLUP | MODE1 */
+				0x0c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad3.mmc1_dat3, INPUT_PULLUP | MODE1 */
+				0x10 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad4.mmc1_dat4, INPUT_PULLUP | MODE1 */
+				0x14 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad5.mmc1_dat5, INPUT_PULLUP | MODE1 */
+				0x18 (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad6.mmc1_dat6, INPUT_PULLUP | MODE1 */
+				0x1c (PIN_INPUT_PULLUP | MUX_MODE1) /* gpmc_ad7.mmc1_dat7, INPUT_PULLUP | MODE1 */
+			>;
+		};
 	};
 
 	ocp {
@@ -242,6 +257,13 @@
 			regulator-always-on;
 		};
 	};
+
+	vmmcsd_fixed: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "vmmcsd_fixed";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
 };
 
 &cpsw_emac0 {
diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 197cadf..f4703cf 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -15,3 +15,17 @@
 	regulator-max-microvolt = <1800000>;
 	regulator-always-on;
 };
+
+&mmc1 { 
+	vmmc-supply = <&vmmcsd_fixed>;
+};
+
+&mmc2 { 
+	vmmc-supply = <&vmmcsd_fixed>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&emmc_pins>;
+	bus-width = <8>;
+	status = "okay";
+	ti,vcc-aux-disable-is-sleep;
+};
+
-- 
1.8.2.1


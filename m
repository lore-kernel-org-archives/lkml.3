Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaGNLhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:37:14 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45139 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaGNLhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:37:03 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v8 02/13] mfd: max77802: Add DT binding documentation
Date: Mon, 14 Jul 2014 13:35:58 +0200
Message-Id: <1405337769-3741-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Device Tree binding documentation for Maxim 77802 PMIC.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v7:
 - Remove information about DVS since that will be added as a follow up.

Changes since v6: None

Changes since v5:
 - Use max77686,* properties instead of max77802,* since the support is
   now in the max77686 driver and that IP defined the properties first.
 - Fix issues in DT binding documentation. Suggested by Andreas Farber.

Changes since v4: None

Changes since v3: None

Changes since v2:
 - Explain better the Dynamic Voltage Scaling (DVS) support in some Buck
   regulators and the max77802,pmic-buck-{dvs,selb}-gpios properties.
   Suggested by Mark Brown.
---
 Documentation/devicetree/bindings/mfd/max77802.txt | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max77802.txt

diff --git a/Documentation/devicetree/bindings/mfd/max77802.txt b/Documentation/devicetree/bindings/mfd/max77802.txt
new file mode 100644
index 0000000..9f72b8f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/max77802.txt
@@ -0,0 +1,59 @@
+Maxim MAX77802 multi-function device
+
+MAX77802 is a Multifunction device with PMIC, RTC and Charger on chip. It is
+interfaced to host controller using i2c interface. PMIC, Charger and RTC
+submodules are addressed using same i2c slave address.
+
+This document describes the binding for mfd device and PMIC submodule.
+
+Binding for the built-in 32k clock generator block is defined separately
+in bindings/clk/maxim,max77802.txt file.
+
+Required properties:
+- compatible : Must be "maxim,max77802";
+- reg : Specifies the i2c slave address of PMIC block.
+- interrupts : This i2c device has an IRQ line connected to the main SoC.
+- interrupt-parent : The parent interrupt controller.
+
+Optional node:
+- regulators : The regulators of max77802 have to be instantiated
+  under subnode named "regulators" using the following format.
+
+	regulator-name {
+		standard regulator constraints....
+	};
+	refer Documentation/devicetree/bindings/regulator/regulator.txt
+
+  The regulator node name should be initialized with a string
+to get matched with their hardware counterparts as follow. The valid names are:
+
+	-LDOn 	:	for LDOs, where n can lie in range 1 to 35.
+			example: LDO1, LDO2, LDO35.
+	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 10.
+			example: BUCK1, BUCK5, BUCK10.
+Example:
+
+	max77802@09 {
+		compatible = "maxim,max77802";
+		interrupt-parent = <&wakeup_eint>;
+		interrupts = <26 0>;
+		reg = <0x09>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		regulators {
+			ldo11_reg: LDO11 {
+				regulator-name = "vdd_ldo11";
+				regulator-min-microvolt = <1900000>;
+				regulator-max-microvolt = <1900000>;
+				regulator-always-on;
+			};
+
+			buck1_reg: BUCK1 {
+				regulator-name = "vdd_mif";
+				regulator-min-microvolt = <950000>;
+				regulator-max-microvolt = <1300000>;
+				regulator-always-on;
+				regulator-boot-on;
+			};
+	};
-- 
2.0.0.rc2


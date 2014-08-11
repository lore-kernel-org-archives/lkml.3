Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaHKPlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:41:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:45791 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbaHKPk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:40:58 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] ARM: dts: qcom: Add APQ8074 Dragonboard PMIC GPIO bindings
Date: Mon, 11 Aug 2014 18:40:34 +0300
Message-Id: <1407771634-14946-7-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add default states for PMIC GPIO's on APQ8074 Dragonboard

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../dts/qcom-apq8074-dragonboard-pmics-pins.dtsi   | 103 +++++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts     |   1 +
 2 files changed, 104 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi b/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi
new file mode 100644
index 0000000..c69ecc2
--- /dev/null
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard-pmics-pins.dtsi
@@ -0,0 +1,103 @@
+
+#include <dt-bindings/pinctrl/qcom,pmic-mpp.h>
+#include <dt-bindings/pinctrl/qcom,pmic-gpio.h>
+
+&pm8941_gpios {
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&pm8941_gpios_default>;
+
+	pm8941_gpios_default: default {
+		group-1 {
+			pins = "gpio1", "gpio2", "gpio5", "gpio29";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			input-enable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
+		};
+		group-6 {	/* TUSB3_HUB-RESET */
+			pins = "gpio6";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-high;
+			drive-push-pull;
+			power-source = <PM8941_GPIO_VPH>;
+			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-8 {	/* HSIC_HUB-RESET */
+			pins = "gpio8";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-low;
+			bias-disable;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-9 {	/* GbE_RST_N */
+			pins = "gpio9";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-high;
+			drive-push-pull;
+			power-source = <PM8941_GPIO_VPH>;
+			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-10 {	/* SATA_RST_N */
+			pins = "gpio10";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-high;
+			drive-push-pull;
+			power-source = <PM8941_GPIO_VPH>;
+			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-15 {	/* DIVCLK1_CODEC */
+			pins = "gpio15";
+			function = PM8941_GPIO15_18_DIV_CLK;
+			output-high;
+			drive-push-pull;
+			bias-disable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_LOW>;
+		};
+		group-19 {	/* MIPI_DSI0_RESET_N */
+			pins = "gpio19";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-low;
+			drive-push-pull;
+			bias-disable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-29 {	/* SD_WP_N */
+			pins = "gpio29";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			input-enable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,pull-up-strength = <PMIC_GPIO_PULL_UP_30>;
+		};
+		group-33 {	/* WLAN_PWD_L */
+			pins = "gpio33";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-high;
+			drive-push-pull;
+			bias-disable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+		group-34 {	/* BT_PWD_L */
+			pins = "gpio34";
+			function = PMIC_GPIO_FUNC_NORMAL;
+			output-low;
+			drive-push-pull;
+			bias-disable;
+			power-source = <PM8941_GPIO_S3>;
+			qcom,drive-strength = <PMIC_GPIO_STRENGTH_MED>;
+		};
+	};
+};
+
+&pm8941_mpps {
+};
+
+&pm8841_mpps {
+};
+
diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index b4dfb01..87b90e3 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -1,4 +1,5 @@
 #include "qcom-msm8974.dtsi"
+#include "qcom-apq8074-dragonboard-pmics-pins.dtsi"
 
 / {
 	model = "Qualcomm APQ8074 Dragonboard";
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaI3OJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:09:58 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53377 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaI3OJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:09:55 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 1/4] ARM: dts: apq8064: add RPM regulators support
Date: Tue, 30 Sep 2014 15:09:48 +0100
Message-Id: <1412086188-20940-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412086159-20894-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1412086159-20894-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds rpm node to apq8064 dt as rpm would be used by other
devices for regulator support. Also adds all the regulators in the rpm.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 297 ++++++++++++++++++++++++++++++++++++
 1 file changed, 297 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index b3154c0..64708cb 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -3,6 +3,7 @@
 #include "skeleton.dtsi"
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8960.h>
+#include <dt-bindings/mfd/qcom-rpm.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
@@ -246,6 +247,302 @@
 			#reset-cells = <1>;
 		};
 
+		l2cc: clock-controller@2011000 {
+			compatible	= "syscon";
+			reg		= <0x2011000 0x1000>;
+		};
+
+		rpm@108000 {
+			compatible	= "qcom,rpm-apq8064";
+			reg		= <0x108000 0x1000>;
+			qcom,ipc	= <&l2cc 0x8 2>;
+
+			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupt-names	= "ack", "err", "wakeup";
+
+			#address-cells	= <1>;
+			#size-cells	= <0>;
+
+			/* Buck SMPS */
+			pm8921_s1: pm8921-s1 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS1>;
+				regulator-min-microvolt	= <850000>;
+				regulator-max-microvolt	= <1300000>;
+			};
+
+			pm8921_s2: pm8921-s2 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS2>;
+				regulator-min-microvolt	= <1000000>;
+				regulator-max-microvolt	= <1400000>;
+			};
+
+			pm8921_s3: pm8921-s3 {
+				compatible			= "qcom,rpm-pm8921-smps";
+				reg				= <QCOM_RPM_PM8921_SMPS3>;
+				regulator-min-microvolt		= <1000000>;
+				regulator-max-microvolt		= <1400000>;
+				qcom,switch-mode-frequency	= <4800000>;
+			};
+
+			pm8921_s4: pm8921-s4 {
+				compatible			= "qcom,rpm-pm8921-smps";
+				reg				= <QCOM_RPM_PM8921_SMPS4>;
+				regulator-min-microvolt		= <1800000>;
+				regulator-max-microvolt		= <1800000>;
+				qcom,switch-mode-frequency	= <3200000>;
+			};
+
+			pm8921_s5: pm8921-s5 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS5>;
+				regulator-min-microvolt	= < 850000>;
+				regulator-max-microvolt	= <1300000>;
+			};
+
+			pm8921_s6: pm8921-s6 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS6>;
+				regulator-min-microvolt	= < 850000>;
+				regulator-max-microvolt	= <1300000>;
+			};
+
+			pm8921_s7: pm8921-s7 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS7>;
+				regulator-min-microvolt	= < 500000>;
+				regulator-max-microvolt	= <1350000>;
+			};
+
+			pm8921_s8: pm8921-s8 {
+				compatible		= "qcom,rpm-pm8921-smps";
+				reg			= <QCOM_RPM_PM8921_SMPS8>;
+				regulator-min-microvolt	= <1500000>;
+				regulator-max-microvolt	= <2350000>;
+			};
+
+			/* PMOS LDO */
+			pm8921_l1: pm8921-l1 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO1>;
+				regulator-min-microvolt	= <1000000>;
+				regulator-max-microvolt	= <1450000>;
+			};
+
+			pm8921_l2: pm8921-l2 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO2>;
+				regulator-min-microvolt	= <1200000>;
+				regulator-max-microvolt	= <1200000>;
+			};
+
+			pm8921_l3: pm8921-l3 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO3>;
+				regulator-min-microvolt = <3050000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			pm8921_l4: pm8921-l4 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO4>;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1800000>;
+			};
+
+			pm8921_l5: pm8921-l5 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO5>;
+				regulator-min-microvolt = <2750000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l6: pm8921-l6 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO6>;
+				regulator-min-microvolt = <2750000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l7: pm8921-l7 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO7>;
+				regulator-min-microvolt = <2750000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l8: pm8921-l8 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO8>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l9: pm8921-l9 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO9>;
+				regulator-min-microvolt = <2600000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l10: pm8921-l10 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO10>;
+				regulator-min-microvolt = <2600000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			pm8921_l11: pm8921-l11 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO11>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			pm8921_l12: pm8921-l12 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO12>;
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1500000>;
+			};
+
+			pm8921_l14: pm8921-l14 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO14>;
+				regulator-min-microvolt = <1700000>;
+				regulator-max-microvolt = <1900000>;
+			};
+
+			pm8921_l15: pm8921-l15 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO15>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+			};
+
+			pm8921_l16: pm8921-l16 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO16>;
+				regulator-min-microvolt = <2600000>;
+				regulator-max-microvolt = <3000000>;
+			};
+
+			pm8921_l17: pm8921-l17 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO17>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3600000>;
+			};
+
+			pm8921_l18: pm8921-l18 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO18>;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1500000>;
+			};
+
+			pm8921_l21: pm8921-l21 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO21>;
+				regulator-min-microvolt = <1700000>;
+				regulator-max-microvolt = <2100000>;
+			};
+
+			pm8921_l22: pm8921-l22 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO22>;
+				regulator-min-microvolt = <1700000>;
+				regulator-max-microvolt = <2850000>;
+			};
+
+			pm8921_l23: pm8921-l23 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO23>;
+				regulator-min-microvolt = <1700000>;
+				regulator-max-microvolt = <1900000>;
+			};
+
+			pm8921_l24: pm8921-l24 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO24>;
+				regulator-min-microvolt = <0750000>;
+				regulator-max-microvolt = <1250000>;
+			};
+
+			pm8921_l25: pm8921-l25 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO25>;
+				regulator-min-microvolt = <0750000>;
+				regulator-max-microvolt = <1250000>;
+			};
+
+			pm8921_l26: pm8921-l26 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO26>;
+				regulator-min-microvolt = <0750000>;
+				regulator-max-microvolt = <1250000>;
+			};
+
+			pm8921_l27: pm8921-l27 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO27>;
+				regulator-min-microvolt = <0750000>;
+				regulator-max-microvolt = <1250000>;
+			};
+
+			pm8921_l28: pm8921-l28 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO28>;
+				regulator-min-microvolt = <0750000>;
+				regulator-max-microvolt = <1500000>;
+			};
+
+			pm8921_l29: pm8921-l29 {
+				compatible		= "qcom,rpm-pm8921-pldo";
+				reg			= <QCOM_RPM_PM8921_LDO29>;
+				regulator-min-microvolt = <1700000>;
+				regulator-max-microvolt = <2200000>;
+			};
+
+			/* Low Voltage Switch */
+			pm8921_lvs1: pm8921-lvs1 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS1>;
+			};
+
+			pm8921_lvs2: pm8921-lvs2 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS2>;
+			};
+
+			pm8921_lvs3: pm8921-lvs3 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS3>;
+			};
+
+			pm8921_lvs4: pm8921-lvs4 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS4>;
+			};
+
+			pm8921_lvs5: pm8921-lvs5 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS5>;
+			};
+
+			pm8921_lvs6: pm8921-lvs6 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS6>;
+			};
+
+			pm8921_lvs7: pm8921-lvs7 {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_PM8921_LVS7>;
+			};
+
+		};
+
 		/* Temporary fixed regulator */
 		vsdcc_fixed: vsdcc-regulator {
 			compatible = "regulator-fixed";
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaJAJGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:06:43 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48079 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaJAJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:06:41 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 1/4] ARM: dts: apq8064: add RPM regulators support
Date: Wed,  1 Oct 2014 10:06:36 +0100
Message-Id: <1412154396-2712-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412154355-2639-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1412154355-2639-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds rpm node to apq8064 dt as rpm would be used by other
devices for regulator support. Also adds all the regulators in the rpm.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 241 ++++++++++++++++++++++++++++++++++++
 1 file changed, 241 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index b3154c0..db5fc59 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -3,6 +3,7 @@
 #include "skeleton.dtsi"
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8960.h>
+#include <dt-bindings/mfd/qcom-rpm.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
@@ -246,6 +247,246 @@
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
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS1>;
+			};
+
+			pm8921_s2: pm8921-s2 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS2>;
+			};
+
+			pm8921_s3: pm8921-s3 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS3>;
+			};
+
+			pm8921_s4: pm8921-s4 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS4>;
+			};
+
+			pm8921_s5: pm8921-s5 {
+				compatible	= "qcom,rpm-pm8921-ftsmps";
+				reg		= <QCOM_RPM_PM8921_SMPS5>;
+			};
+
+			pm8921_s6: pm8921-s6 {
+				compatible	= "qcom,rpm-pm8921-ftsmps";
+				reg		= <QCOM_RPM_PM8921_SMPS6>;
+			};
+
+			pm8921_s7: pm8921-s7 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS7>;
+			};
+
+			pm8921_s8: pm8921-s8 {
+				compatible	= "qcom,rpm-pm8921-smps";
+				reg		= <QCOM_RPM_PM8921_SMPS8>;
+			};
+
+			/* PMOS LDO */
+			pm8921_l1: pm8921-l1 {
+				compatible	= "qcom,rpm-pm8921-nldo";
+				reg		= <QCOM_RPM_PM8921_LDO1>;
+			};
+
+			pm8921_l2: pm8921-l2 {
+				compatible	= "qcom,rpm-pm8921-nldo";
+				reg		= <QCOM_RPM_PM8921_LDO2>;
+			};
+
+			pm8921_l3: pm8921-l3 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO3>;
+			};
+
+			pm8921_l4: pm8921-l4 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO4>;
+			};
+
+			pm8921_l5: pm8921-l5 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO5>;
+			};
+
+			pm8921_l6: pm8921-l6 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO6>;
+			};
+
+			pm8921_l7: pm8921-l7 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO7>;
+			};
+
+			pm8921_l8: pm8921-l8 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO8>;
+			};
+
+			pm8921_l9: pm8921-l9 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO9>;
+			};
+
+			pm8921_l10: pm8921-l10 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO10>;
+			};
+
+			pm8921_l11: pm8921-l11 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO11>;
+			};
+
+			pm8921_l12: pm8921-l12 {
+				compatible	= "qcom,rpm-pm8921-nldo";
+				reg		= <QCOM_RPM_PM8921_LDO12>;
+			};
+
+			pm8921_l14: pm8921-l14 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO14>;
+			};
+
+			pm8921_l15: pm8921-l15 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO15>;
+			};
+
+			pm8921_l16: pm8921-l16 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO16>;
+			};
+
+			pm8921_l17: pm8921-l17 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO17>;
+			};
+
+			pm8921_l18: pm8921-l18 {
+				compatible	= "qcom,rpm-pm8921-nldo";
+				reg		= <QCOM_RPM_PM8921_LDO18>;
+			};
+
+			pm8921_l21: pm8921-l21 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO21>;
+			};
+
+			pm8921_l22: pm8921-l22 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO22>;
+			};
+
+			pm8921_l23: pm8921-l23 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO23>;
+			};
+
+			pm8921_l24: pm8921-l24 {
+				compatible	= "qcom,rpm-pm8921-nldo1200";
+				reg		= <QCOM_RPM_PM8921_LDO24>;
+			};
+
+			pm8921_l25: pm8921-l25 {
+				compatible	= "qcom,rpm-pm8921-nldo1200";
+				reg		= <QCOM_RPM_PM8921_LDO25>;
+			};
+
+			pm8921_l26: pm8921-l26 {
+				compatible	= "qcom,rpm-pm8921-nldo1200";
+				reg		= <QCOM_RPM_PM8921_LDO26>;
+			};
+
+			pm8921_l27: pm8921-l27 {
+				compatible	= "qcom,rpm-pm8921-nldo1200";
+				reg		= <QCOM_RPM_PM8921_LDO27>;
+			};
+
+			pm8921_l28: pm8921-l28 {
+				compatible	= "qcom,rpm-pm8921-nldo1200";
+				reg		= <QCOM_RPM_PM8921_LDO28>;
+			};
+
+			pm8921_l29: pm8921-l29 {
+				compatible	= "qcom,rpm-pm8921-pldo";
+				reg		= <QCOM_RPM_PM8921_LDO29>;
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
+			pm8921_usb_switch: pm8921-usb-switch {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_USB_OTG_SWITCH>;
+			};
+
+			pm8921_hdmi_switch: pm8921-hdmi-switch {
+				compatible	= "qcom,rpm-pm8921-switch";
+				reg		= <QCOM_RPM_HDMI_SWITCH>;
+			};
+
+			pm8921_ncp: pm8921-ncp {
+				compatible	= "qcom,rpm-pm8921-ncp";
+				reg		= <QCOM_RPM_PM8921_NCP>;
+			};
+		};
+
 		/* Temporary fixed regulator */
 		vsdcc_fixed: vsdcc-regulator {
 			compatible = "regulator-fixed";
-- 
1.9.1


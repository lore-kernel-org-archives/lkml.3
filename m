Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbaGQP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:26:23 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60067 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934224AbaGQP0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:15 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes
Date: Thu, 17 Jul 2014 18:25:48 +0300
Message-Id: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add nodes for PM8941 and PM8841 GPIO and MPP sub-functions.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 61 +++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index c7ae7ba..b0164f9 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -6,6 +6,8 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/reset/qcom,gcc-msm8974.h>
 #include <dt-bindings/spmi/spmi.h>
+#include <dt-bindings/pinctrl/qcom,pm8xxx-mpp.h>
+#include <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>
 
 / {
 	model = "Qualcomm MSM8974";
@@ -267,6 +269,33 @@
 					reg-names = "rtc", "alarm";
 					interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
 				};
+
+				gpios@c000 {
+					compatible = "qcom,pm8941-gpio";
+					reg = <0xc000>;
+					gpio-controller;
+					#gpio-cells = <2>;
+					label = "pm8941-gpio";
+					interrupts = <0 0xc0 0 0>, <0 0xc1 0 0>, <0 0xc2 0 0>, <0 0xc3 0 0>,
+						     <0 0xc4 0 0>, <0 0xc5 0 0>, <0 0xc6 0 0>, <0 0xc7 0 0>,
+						     <0 0xc8 0 0>, <0 0xc9 0 0>, <0 0xca 0 0>, <0 0xcb 0 0>,
+						     <0 0xcc 0 0>, <0 0xcd 0 0>, <0 0xce 0 0>, <0 0xcf 0 0>,
+						     <0 0xd0 0 0>, <0 0xd1 0 0>, <0 0xd2 0 0>, <0 0xd3 0 0>,
+						     <0 0xd4 0 0>, <0 0xd5 0 0>, <0 0xd6 0 0>, <0 0xd7 0 0>,
+						     <0 0xd8 0 0>, <0 0xd9 0 0>, <0 0xda 0 0>, <0 0xdb 0 0>,
+						     <0 0xdc 0 0>, <0 0xdd 0 0>, <0 0xde 0 0>, <0 0xdf 0 0>,
+						     <0 0xe0 0 0>, <0 0xe1 0 0>, <0 0xe2 0 0>, <0 0xe3 0 0>;
+				};
+
+				mpps@a000 {
+					compatible = "qcom,pm8941-mpp";
+					reg = <0xa000>;
+					gpio-controller;
+					#gpio-cells = <2>;
+					label = "pm8941-mpp";
+					interrupts = <0 0xa0 0 0>, <0 0xa1 0 0>, <0 0xa2 0 0>, <0 0xa3 0 0>,
+						     <0 0xa4 0 0>, <0 0xa5 0 0>, <0 0xa6 0 0>, <0 0xa7 0 0>;
+				};
 			};
 
 			usid1: pm8941@1 {
@@ -281,6 +310,38 @@
 				reg = <0x4 SPMI_USID>;
 				#address-cells = <1>;
 				#size-cells = <0>;
+
+				mpps@a000 {
+					compatible = "qcom,pm8841-mpp";
+					reg = <0xa000>;
+					gpio-controller;
+					#gpio-cells = <2>;
+					interrupts = <4 0xa0 0 0>, <4 0xa1 0 0>, <4 0xa2 0 0>, <4 0xa3 0 0>;
+
+					pinctrl-names = "default", "sleep";
+					pinctrl-0 = <&pm8841_default>;
+					pinctrl-1 = <&pm8841_sleep>;
+
+					pm8841_sleep: sleep {
+						gpio {
+							pins = "mpp1", "mpp2", "mpp3", "mpp4";
+							function = "gpio";
+
+							input-enable;
+
+							power-source = <PM8XXX_GPIO_VIN0>;
+							qcom,pull-up = <PM8XXX_GPIO_STRENGTH_NO>;
+							qcom,strength = <PM8XXX_GPIO_PULL_UP_30>;
+						};
+					};
+
+					pm8841_default: default {
+						ain {
+							pins = "mpp1", "mpp2", "mpp3", "mpp4";
+							function = "ain";
+						};
+					};
+				};
 			};
 
 			usid5: pm8841@5 {
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaGHP4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:56:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60214 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbaGHP4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:56:01 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 3/3] dt: qcom: msm8974: add qpnp-spmi device nodes
Date: Tue,  8 Jul 2014 18:54:29 +0300
Message-Id: <1404834869-23049-4-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
References: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivan T. Ivanov <iivanov@mm-sol.com>

The qpnp-spmi device nodes are childrens of spmi pmic arbiter.
msm8974 SoC using two pmic chips pm8941 and pm8841. Every chip
has two spmi-qpnp bus id's.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi |   45 +++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 69dca2a..9166b8e 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -3,6 +3,7 @@
 #include "skeleton.dtsi"
 
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
+#include <dt-bindings/spmi/spmi.h>
 
 / {
 	model = "Qualcomm MSM8974";
@@ -236,5 +237,49 @@
 			#interrupt-cells = <2>;
 			interrupts = <0 208 0>;
 		};
+
+		spmi@fc4cf000 {
+			compatible = "qcom,spmi-pmic-arb";
+			reg-names = "core", "intr", "cnfg";
+			reg = <0xfc4cf000 0x1000>,
+			      <0xfc4cb000 0x1000>,
+			      <0xfc4ca000 0x1000>;
+			interrupt-names = "periph_irq";
+			interrupts = <0 190 0>;
+			qcom,ee = <0>;
+			qcom,channel = <0>;
+			#address-cells = <2>;
+			#size-cells = <0>;
+			interrupt-controller;
+			#interrupt-cells = <4>;
+
+			usid0: pm8941@0 {
+				compatible = "qcom,qpnp-spmi";
+				reg = <0x0 SPMI_USID>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			usid1: pm8941@1 {
+				compatible = "qcom,qpnp-spmi";
+				reg = <0x1 SPMI_USID>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			usid4: pm8841@4 {
+				compatible = "qcom,qpnp-spmi";
+				reg = <0x4 SPMI_USID>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+
+			usid5: pm8841@5 {
+				compatible = "qcom,qpnp-spmi";
+				reg = <0x5 SPMI_USID>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+			};
+		};
 	};
 };
-- 
1.7.0.4


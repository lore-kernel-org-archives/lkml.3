Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbbA0WLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:11:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38519 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbbA0WKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:10:51 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH 4/6] ARM: DT: ipq8064: Add TCSR support
Date: Tue, 27 Jan 2015 16:10:42 -0600
Message-Id: <1422396644-21714-5-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
References: <1422396644-21714-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds TCSR support for use by the GSBI to automatically configure ADM
CRCI values based on the GSBI port configuration.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 arch/arm/boot/dts/qcom-ipq8064.dtsi |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 63b2146..e47358d 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -119,7 +119,7 @@
 		};
 
 		gsbi2: gsbi@12480000 {
-			compatible = "qcom,gsbi-v1.0.0";
+			compatible = "qcom,gsbi-ipq8064";
 			reg = <0x12480000 0x100>;
 			clocks = <&gcc GSBI2_H_CLK>;
 			clock-names = "iface";
@@ -128,6 +128,9 @@
 			ranges;
 			status = "disabled";
 
+			qcom,gsbi-num = <2>;
+			syscon-tcsr = <&tcsr>;
+
 			serial@12490000 {
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x12490000 0x1000>,
@@ -154,7 +157,7 @@
 		};
 
 		gsbi4: gsbi@16300000 {
-			compatible = "qcom,gsbi-v1.0.0";
+			compatible = "qcom,gsbi-ipq8064";
 			reg = <0x16300000 0x100>;
 			clocks = <&gcc GSBI4_H_CLK>;
 			clock-names = "iface";
@@ -163,6 +166,9 @@
 			ranges;
 			status = "disabled";
 
+			qcom,gsbi-num = <4>;
+			syscon-tcsr = <&tcsr>;
+
 			serial@16340000 {
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16340000 0x1000>,
@@ -188,7 +194,7 @@
 		};
 
 		gsbi5: gsbi@1a200000 {
-			compatible = "qcom,gsbi-v1.0.0";
+			compatible = "qcom,gsbi-ipq8064";
 			reg = <0x1a200000 0x100>;
 			clocks = <&gcc GSBI5_H_CLK>;
 			clock-names = "iface";
@@ -197,6 +203,9 @@
 			ranges;
 			status = "disabled";
 
+			qcom,gsbi-num = <5>;
+			syscon-tcsr = <&tcsr>;
+
 			serial@1a240000 {
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x1a240000 0x1000>,
@@ -279,5 +288,10 @@
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 		};
+
+		tcsr: syscon@1a400000 {
+			compatible = "qcom,tcsr-ipq8064", "syscon";
+			reg = <0x1a400000 0x100>;
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


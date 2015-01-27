Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbbA0WLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:11:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38533 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760146AbbA0WKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:10:53 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-soc@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [PATCH 6/6] ARM: DT: msm8960: Add TCSR support
Date: Tue, 27 Jan 2015 16:10:44 -0600
Message-Id: <1422396644-21714-7-git-send-email-agross@codeaurora.org>
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
 arch/arm/boot/dts/qcom-msm8960.dtsi |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index e1b0d5c..913a9f1 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -121,7 +121,7 @@
 		};
 
 		gsbi5: gsbi@16400000 {
-			compatible = "qcom,gsbi-v1.0.0";
+			compatible = "qcom,gsbi-msm8960";
 			reg = <0x16400000 0x100>;
 			clocks = <&gcc GSBI5_H_CLK>;
 			clock-names = "iface";
@@ -129,6 +129,9 @@
 			#size-cells = <1>;
 			ranges;
 
+			qcom,gsbi-num = <5>;
+			syscon-tcsr = <&tcsr>;
+
 			serial@16440000 {
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16440000 0x1000>,
@@ -238,5 +241,10 @@
 				vmmc-supply = <&vsdcc_fixed>;
 			};
 		};
+
+		tcsr: syscon@1a400000 {
+			compatible = "qcom,tcsr-msm8960", "syscon";
+			reg = <0x1a400000 0x100>;
+		};
 	};
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaDDS7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:59:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59318 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaDDSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:45:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/4] ARM: dts: qcom: Add GDSC nodes underneath clock controller
Date: Fri,  4 Apr 2014 11:45:35 -0700
Message-Id: <1396637136-29974-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the GDSCs present on the multimedia clock
controller in 8974.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts | 18 ++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            | 26 ++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
index 13ac3e222495..478e89de0f38 100644
--- a/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
@@ -3,4 +3,22 @@
 / {
 	model = "Qualcomm APQ8074 Dragonboard";
 	compatible = "qcom,apq8074-dragonboard", "qcom,apq8074";
+
+};
+
+&gdsc_venus {
+	qcom,skip-logic-collapse;
+	qcom,retain-periph;
+	qcom,retain-mem;
+};
+
+&gdsc_mdss {
+	qcom,skip-logic-collapse;
+	qcom,retain-periph;
+	qcom,retain-mem;
+};
+
+&gdsc_oxili_gx {
+	qcom,retain-mem;
+	qcom,retain-periph;
 };
diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9e5dadb101eb..e38ae30930b2 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -108,6 +108,32 @@
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			reg = <0xfd8c0000 0x6000>;
+
+			regulators {
+				gdsc_venus: gdsc_venus {
+					regulator-name = "gdsc_venus";
+				};
+
+				gdsc_mdss: gdsc_mdss {
+					regulator-name = "gdsc_mdss";
+				};
+
+				gdsc_jpeg: gdsc_jpeg {
+					regulator-name = "gdsc_jpeg";
+				};
+
+				gdsc_vfe: gdsc_vfe {
+					regulator-name = "gdsc_vfe";
+				};
+
+				gdsc_oxili_gx: gdsc_oxili_gx {
+					regulator-name = "gdsc_oxili_gx";
+				};
+
+				gdsc_oxili_cx: gdsc_oxili_cx {
+					regulator-name = "gdsc_oxili_cx";
+				};
+			};
 		};
 
 		serial@f991e000 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


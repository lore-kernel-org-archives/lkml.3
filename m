Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaFCOaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:30:08 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50156 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbaFCOaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:30:04 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: mturquette@linaro.org, sboyd@codeaurora.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 2/2] ARM: dts: qcom: Add APQ8084 serial port DT node
Date: Tue,  3 Jun 2014 17:29:41 +0300
Message-Id: <1401805781-26637-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401805781-26637-1-git-send-email-gdjakov@mm-sol.com>
References: <1401805781-26637-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary DT node to probe the serial driver on
APQ8084 platforms.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-apq8084-mtp.dts |    6 ++++++
 arch/arm/boot/dts/qcom-apq8084.dtsi    |    8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084-mtp.dts b/arch/arm/boot/dts/qcom-apq8084-mtp.dts
index 9dae387..8ecec58 100644
--- a/arch/arm/boot/dts/qcom-apq8084-mtp.dts
+++ b/arch/arm/boot/dts/qcom-apq8084-mtp.dts
@@ -3,4 +3,10 @@
 / {
 	model = "Qualcomm APQ 8084-MTP";
 	compatible = "qcom,apq8084-mtp", "qcom,apq8084";
+
+	soc {
+		serial@f995e000 {
+			status = "okay";
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index 1e785df..b5b156e 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -185,5 +185,13 @@
 			reg = <0xfc400000 0x4000>;
 		};
 
+		serial@f995e000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf995e000 0x1000>;
+			interrupts = <0 114 0x0>;
+			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5


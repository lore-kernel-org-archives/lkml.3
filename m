Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaJARJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:09:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45424 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaJARJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:09:03 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: qcom: add description of KPSS WDT for IPQ8064
Date: Wed,  1 Oct 2014 12:03:15 -0500
Message-Id: <50c0ec1514173ce07641a95839e939dcda41b110.1412182773.git.joshc@codeaurora.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1412182773.git.joshc@codeaurora.org>
References: <cover.1412182773.git.joshc@codeaurora.org>
In-Reply-To: <cover.1412182773.git.joshc@codeaurora.org>
References: <cover.1412182773.git.joshc@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe the Krait Processor Sub-system (KPSS) Watchdog timer in the
IPQ8064 device tree.  Also, add a fixed-clock description of SLEEP_CLK,
which will do for now.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 244f857..3372b49 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -60,6 +60,14 @@
 		};
 	};
 
+	clocks {
+		sleep_clk: sleep_clk {
+			compatible = "fixed-clock";
+			clock-frequency = <32768>;
+			#clock-cells = <0>;
+		};
+	};
+
 	soc: soc {
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -96,6 +104,13 @@
 			cpu-offset = <0x80000>;
 		};
 
+		watchdog@208a038 {
+			compatible = "qcom,kpss-wdt-ipq8064";
+			reg = <0x0208a038 0x40>;
+			clocks = <&sleep_clk>;
+			timeout-sec = <10>;
+		};
+
 		acc0: clock-controller@2088000 {
 			compatible = "qcom,kpss-acc-v1";
 			reg = <0x02088000 0x1000>, <0x02008000 0x1000>;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaBFPaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:30:46 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:36416 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbaBFPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:30:43 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: MSM8974: Add pinctrl node
Date: Thu,  6 Feb 2014 17:28:49 +0200
Message-Id: <1391700529-11816-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
References: <1391700529-11816-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add the pin control node and pin definitions of SPI8.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 9e5dadb..395603f 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -117,5 +117,34 @@
 			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
 			clock-names = "core", "iface";
 		};
+
+		msmgpio: pinctrl@fd510000 {
+			compatible = "qcom,msm8974-pinctrl";
+			reg = <0xfd510000 0x4000>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+			interrupts = <0 208 0>;
+
+			spi8_default: spi8_default {
+				mosi {
+					pins = "gpio45";
+					function = "blsp_spi8";
+				};
+				miso {
+					pins = "gpio46";
+					function = "blsp_spi8";
+				};
+				cs {
+					pins = "gpio47";
+					function = "blsp_spi8";
+				};
+				clk {
+					pins = "gpio48";
+					function = "blsp_spi8";
+				};
+			};
+		};
 	};
 };
-- 
1.7.9.5


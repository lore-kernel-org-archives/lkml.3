Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaEVQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:25:57 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58979 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaEVQZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:25:17 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 5/5] ARM: dts: qcom: Add APQ8084 serial port DT node
Date: Thu, 22 May 2014 19:24:45 +0300
Message-Id: <1400775885-10296-6-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary DT node to probe the serial driver on
APQ8084 platforms.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/boot/dts/qcom-apq8084.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index 2dcd11e..c346549 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -185,5 +185,12 @@
 			reg = <0xfc400000 0x4000>;
 		};
 
+		serial@f995e000 {
+			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			reg = <0xf995e000 0x1000>;
+			interrupts = <0 114 0x0>;
+			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
+			clock-names = "core", "iface";
+		};
 	};
 };
-- 
1.7.9.5


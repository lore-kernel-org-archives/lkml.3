Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaFCOaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:30:03 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50141 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbaFCO37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:29:59 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: mturquette@linaro.org, sboyd@codeaurora.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 1/2] ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
Date: Tue,  3 Jun 2014 17:29:40 +0300
Message-Id: <1401805781-26637-2-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401805781-26637-1-git-send-email-gdjakov@mm-sol.com>
References: <1401805781-26637-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary node to probe the global clock
controller on APQ8084 platforms.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-apq8084.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
index e3e009a..1e785df 100644
--- a/arch/arm/boot/dts/qcom-apq8084.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
@@ -2,6 +2,8 @@
 
 #include "skeleton.dtsi"
 
+#include <dt-bindings/clock/qcom,gcc-apq8084.h>
+
 / {
 	model = "Qualcomm APQ 8084";
 	compatible = "qcom,apq8084";
@@ -175,5 +177,13 @@
 			compatible = "qcom,pshold";
 			reg = <0xfc4ab000 0x4>;
 		};
+
+		gcc: clock-controller@fc400000 {
+			compatible = "qcom,gcc-apq8084";
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+			reg = <0xfc400000 0x4000>;
+		};
+
 	};
 };
-- 
1.7.9.5


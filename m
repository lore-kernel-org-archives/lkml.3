Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaI2JPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:15:00 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:57615 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaI2JO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:14:58 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Cc: broonie@kernel.org, lee.jones@linaro.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@sonymobile.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 1/4] ARM: DT: apq8064: add rpm support
Date: Mon, 29 Sep 2014 10:14:52 +0100
Message-Id: <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds rpm node to apq8064 dt as rpm would be used by other
devices for regulator support.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index b3154c0..9c2c8e6 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -3,6 +3,7 @@
 #include "skeleton.dtsi"
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8960.h>
+#include <dt-bindings/mfd/qcom-rpm.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
@@ -246,6 +247,24 @@
 			#reset-cells = <1>;
 		};
 
+		apcs: syscon@2011000 {
+			compatible = "syscon";
+			reg = <0x2011000 0x1000>;
+		};
+
+		rpm@108000 {
+			compatible	= "qcom,rpm-apq8064";
+			reg		= <0x108000 0x1000>;
+			qcom,ipc = <&apcs 0x8 2>;
+
+			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupt-names = "ack", "err", "wakeup";
+
+			#address-cells	= <1>;
+			#size-cells	= <0>;
+
+		};
+
 		/* Temporary fixed regulator */
 		vsdcc_fixed: vsdcc-regulator {
 			compatible = "regulator-fixed";
-- 
1.9.1


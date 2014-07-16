Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaGPUtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:49:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37773 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGPUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:49:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: dts: qcom: Add 8064 multimedia clock controller node
Date: Wed, 16 Jul 2014 13:49:43 -0700
Message-Id: <1405543783-10211-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the mmcc node so that we can probe and use the multimedia
clocks on apq8064.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index db896bddeea3..245351bde5f4 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -2,6 +2,7 @@
 
 #include "skeleton.dtsi"
 #include <dt-bindings/clock/qcom,gcc-msm8960.h>
+#include <dt-bindings/clock/qcom,mmcc-msm8960.h>
 #include <dt-bindings/soc/qcom,gsbi.h>
 
 / {
@@ -167,6 +168,13 @@
 			#reset-cells = <1>;
 		};
 
+		mmcc: clock-controller@4000000 {
+			compatible = "qcom,mmcc-apq8064";
+			reg = <0x4000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+
 		msmgpio: pinctrl@800000 {
 			compatible = "qcom,apq8064-pinctrl";
 			reg = <0x800000 0x4000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


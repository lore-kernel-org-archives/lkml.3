Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaGBOJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:09:51 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50242 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbaGBOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:09:49 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: sti: Add STiH407 reset controller support.
Date: Wed,  2 Jul 2014 15:08:49 +0100
Message-Id: <1404310129-14667-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the reset controller DT nodes for the powerdown,
 softreset and picophy controllers.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih407.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
index 4f9024f..d2f1aaa 100644
--- a/arch/arm/boot/dts/stih407.dtsi
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -8,6 +8,7 @@
  */
 #include "stih407-clock.dtsi"
 #include "stih407-pinctrl.dtsi"
+#include <dt-bindings/reset-controller/stih407-resets.h>
 / {
 	#address-cells = <1>;
 	#size-cells = <1>;
@@ -63,6 +64,21 @@
 		ranges;
 		compatible = "simple-bus";
 
+		powerdown: powerdown-controller {
+			compatible = "st,stih407-powerdown";
+			#reset-cells = <1>;
+		};
+
+		softreset: softreset-controller {
+			compatible = "st,stih407-softreset";
+			#reset-cells = <1>;
+		};
+
+		picophyreset: picophyreset-controller {
+			compatible = "st,stih407-picophyreset";
+			#reset-cells = <1>;
+		};
+
 		syscfg_sbc: sbc-syscfg@9620000 {
 			compatible = "st,stih407-sbc-syscfg", "syscon";
 			reg = <0x9620000 0x1000>;
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbaGAOby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:31:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34308 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbaGAObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:31:51 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 3/3] ARM: STi: STiH407: Add reset controller support.
Date: Tue,  1 Jul 2014 15:30:47 +0100
Message-Id: <1404225047-9495-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
References: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
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
index 4f9024f..e8fbb88 100644
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
+			#reset-cells = <1>;
+			compatible = "st,stih407-powerdown";
+		};
+
+		softreset: softreset-controller {
+			#reset-cells = <1>;
+			compatible = "st,stih407-softreset";
+		};
+
+		picophyreset: picophyreset-controller {
+			#reset-cells = <1>;
+			compatible = "st,stih407-picophyreset";
+		};
+
 		syscfg_sbc: sbc-syscfg@9620000 {
 			compatible = "st,stih407-sbc-syscfg", "syscon";
 			reg = <0x9620000 0x1000>;
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbbAGPGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:06:02 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41132 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbbAGPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:04:28 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 4/7] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Date: Wed,  7 Jan 2015 15:04:09 +0000
Message-Id: <1420643052-4506-5-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
References: <1420643052-4506-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the dt nodes for the extra usb2 picophys found on
the stih410.

These two picophys are used in conjunction with the extra ehci/ohci usb
controllers also found on the stih410 SoC.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/stih410.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index c05627e..2e5e9ed 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -10,5 +10,23 @@
 #include "stih407-family.dtsi"
 #include "stih410-pinctrl.dtsi"
 / {
+	soc {
+		usb2_picophy1: phy2 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_core 0xf8 0xf4>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY0_RESET>;
+			reset-names = "global", "port";
+		};
 
+		usb2_picophy2: phy3 {
+			compatible = "st,stih407-usb2-phy";
+			#phy-cells = <0>;
+			st,syscfg = <&syscfg_core 0xfc 0xf4>;
+			resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
+				 <&picophyreset STIH407_PICOPHY1_RESET>;
+			reset-names = "global", "port";
+		};
+	};
 };
-- 
1.9.1


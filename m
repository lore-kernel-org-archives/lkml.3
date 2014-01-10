Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaAJHCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:02:21 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34866 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:24 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v2 14/16] ARM: dts: sun7i: cubieboard2: Enable GMAC instead of EMAC
Date: Fri, 10 Jan 2014 15:00:15 +0800
Message-Id: <1389337217-29032-15-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389337217-29032-1-git-send-email-wens@csie.org>
References: <1389337217-29032-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GMAC has better performance and fewer hardware issues.
Use the GMAC in MII mode for ethernet instead of the EMAC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
index 5c51cb8..7bf4935 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
@@ -19,21 +19,6 @@
 	compatible = "cubietech,cubieboard2", "allwinner,sun7i-a20";
 
 	soc@01c00000 {
-		emac: ethernet@01c0b000 {
-			pinctrl-names = "default";
-			pinctrl-0 = <&emac_pins_a>;
-			phy = <&phy1>;
-			status = "okay";
-		};
-
-		mdio@01c0b080 {
-			status = "okay";
-
-			phy1: ethernet-phy@1 {
-				reg = <1>;
-			};
-		};
-
 		pinctrl@01c20800 {
 			led_pins_cubieboard2: led_pins@0 {
 				allwinner,pins = "PH20", "PH21";
@@ -60,6 +45,18 @@
 			pinctrl-0 = <&i2c1_pins_a>;
 			status = "okay";
 		};
+
+		gmac: ethernet@01c50000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&gmac_pins_mii_a>;
+			phy = <&phy1>;
+			phy-mode = "mii";
+			status = "okay";
+
+			phy1: ethernet-phy@1 {
+				reg = <1>;
+			};
+		};
 	};
 
 	leds {
-- 
1.8.5.2


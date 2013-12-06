Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3LFSJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:09:34 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38816 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131Ab3LFSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:07:14 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 09/10] ARM: dts: sun7i: olinuxino-micro: Enable GMAC instead of EMAC
Date: Sat,  7 Dec 2013 01:29:42 +0800
Message-Id: <1386350983-13281-10-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GMAC has better performance and fewer hardware issues.
Use the GMAC in MII mode for ethernet instead of the EMAC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index ead3013..185623f 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -19,21 +19,6 @@
 	compatible = "olimex,a20-olinuxino-micro", "allwinner,sun7i-a20";
 
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
 			led_pins_olinuxino: led_pins@0 {
 				allwinner,pins = "PH2";
@@ -78,6 +63,14 @@
 			pinctrl-0 = <&i2c2_pins_a>;
 			status = "okay";
 		};
+
+		gmac: ethernet@01c50000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&gmac_pins_mii>;
+			snps,phy-addr = <1>;
+			phy-mode = "mii";
+			status = "okay";
+		};
 	};
 
 	leds {
-- 
1.8.5.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaBCDd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 22:33:27 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37171 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaBCDcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 22:32:35 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/8] ARM: dts: sun7i: Add pin muxing options for the GMAC
Date: Mon,  3 Feb 2014 11:32:22 +0800
Message-Id: <1391398346-5094-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1391398346-5094-1-git-send-email-wens@csie.org>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A20 has EMAC and GMAC muxed on the same pins.
Add pin sets with gmac function for MII and RGMII mode to the DTSI.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 5fbac23..65fb8d0 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -469,6 +469,32 @@
 				allwinner,drive = <0>;
 				allwinner,pull = <0>;
 			};
+
+			gmac_pins_mii_a: gmac_mii@0 {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA9", "PA10",
+						"PA11", "PA12", "PA13", "PA14",
+						"PA15", "PA16";
+				allwinner,function = "gmac";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
+
+			gmac_pins_rgmii_a: gmac_rgmii@0 {
+				allwinner,pins = "PA0", "PA1", "PA2",
+						"PA3", "PA4", "PA5", "PA6",
+						"PA7", "PA8", "PA10",
+						"PA11", "PA12", "PA13",
+						"PA15", "PA16";
+				allwinner,function = "gmac";
+				/*
+				 * data lines in RGMII mode use DDR mode
+				 * and need a higher signal drive strength
+				 */
+				allwinner,drive = <3>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		timer@01c20c00 {
-- 
1.9.rc1


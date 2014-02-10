Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaBJKhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:37:53 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:51380 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaBJKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:36:00 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] ARM: dts: sun7i: cubietruck: Enable the GMAC
Date: Mon, 10 Feb 2014 18:35:51 +0800
Message-Id: <1392028554-32545-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.rc1
In-Reply-To: <1392028554-32545-1-git-send-email-wens@csie.org>
References: <1392028554-32545-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CubieTruck uses the GMAC with an RGMII phy.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index f9dcb61..025ce52 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -51,6 +51,18 @@
 			pinctrl-0 = <&i2c2_pins_a>;
 			status = "okay";
 		};
+
+		gmac: ethernet@01c50000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&gmac_pins_rgmii_a>;
+			phy = <&phy1>;
+			phy-mode = "rgmii";
+			status = "okay";
+
+			phy1: ethernet-phy@1 {
+				reg = <1>;
+			};
+		};
 	};
 
 	leds {
-- 
1.9.rc1


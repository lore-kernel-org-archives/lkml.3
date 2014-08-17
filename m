Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaHQD5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:57:22 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58642 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaHQDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:28 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] ARM: dts: sun8i: Add R_PIO controller node to the dtsi
Date: Sun, 17 Aug 2014 11:52:08 +0800
Message-Id: <1408247538-16950-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a driver for the R_PIO controller,
add the corresponding device node to the dtsi.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index 41823b1..a40e632 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -353,5 +353,18 @@
 			resets = <&apb0_rst 4>;
 			status = "disabled";
 		};
+
+		r_pio: pinctrl@01f02c00 {
+			compatible = "allwinner,sun8i-a23-r-pinctrl";
+			reg = <0x01f02c00 0x400>;
+			interrupts = <0 45 4>;
+			clocks = <&apb0_gates 0>;
+			resets = <&apb0_rst 0>;
+			gpio-controller;
+			interrupt-controller;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#gpio-cells = <3>;
+		};
 	};
 };
-- 
2.1.0


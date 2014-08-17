Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaHQDyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:54:31 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58643 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaHQDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:28 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] ARM: dts: sun8i: Add PIO controller node to the sun8i dtsi
Date: Sun, 17 Aug 2014 11:52:07 +0800
Message-Id: <1408247538-16950-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a driver for the sun8i PIO controller,
add the corresponding device node to the dtsi.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index 54ac0787..41823b1 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -187,6 +187,20 @@
 		#size-cells = <1>;
 		ranges;
 
+		pio: pinctrl@01c20800 {
+			compatible = "allwinner,sun8i-a23-pinctrl";
+			reg = <0x01c20800 0x400>;
+			interrupts = <0 11 4>,
+				     <0 15 4>,
+				     <0 17 4>;
+			clocks = <&apb1_gates 5>;
+			gpio-controller;
+			interrupt-controller;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#gpio-cells = <3>;
+		};
+
 		ahb1_rst: reset@01c202c0 {
 			#reset-cells = <1>;
 			compatible = "allwinner,sun6i-a31-clock-reset";
-- 
2.1.0


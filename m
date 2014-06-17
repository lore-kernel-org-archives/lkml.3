Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbaFQO6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:58:44 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41383 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbaFQOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:27 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 08/20] ARM: sun6i: DT: Rename PLL6 to PLL6x2 and add fixed-factor-clock for PLL6
Date: Tue, 17 Jun 2014 22:52:45 +0800
Message-Id: <1403016777-15121-9-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PLL6 clock driver actually manages the PLL6x2 output of PLL6, so
rename the node accordingly, and add a halved fixed-factor-clock for
normal PLL6 output used by most modules.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index a9dfa12..12d558b 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -94,11 +94,20 @@
 			clock-output-names = "pll1";
 		};
 
-		pll6: clk@01c20028 {
+		pll6x2: clk@01c20028 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun6i-a31-pll6-clk";
 			reg = <0x01c20028 0x4>;
 			clocks = <&osc24M>;
+			clock-output-names = "pll6x2";
+		};
+
+		pll6: pll6_clk {
+			#clock-cells = <0>;
+			compatible = "fixed-factor-clock";
+			clock-div = <2>;
+			clock-mult = <1>;
+			clocks = <&pll6x2>;
 			clock-output-names = "pll6";
 		};
 
-- 
2.0.0


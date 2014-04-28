Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaD1PAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:00:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932395AbaD1PAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:00:17 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 7/7] ARM: sunxi: dt: add PRCM clk and reset controller subdevices
Date: Mon, 28 Apr 2014 16:58:50 +0200
Message-Id: <1398697130-8338-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
controller subdevices.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index ec3253a..83a1634 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -501,6 +501,55 @@
 		prcm@01f01c00 {
 			compatible = "allwinner,sun6i-a31-prcm";
 			reg = <0x01f01400 0x200>;
+
+			ar100_mux: ar100_mux {
+				compatible = "allwinner,sun6i-a31-ar100-mux-clk";
+				#clock-cells = <0>;
+				clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
+			};
+
+			ar100: ar100 {
+				compatible = "allwinner,sun6i-a31-ar100-clk";
+				#clock-cells = <0>;
+				clocks = <&ar100_mux>;
+			};
+
+			ar100_div: ar100_div {
+				compatible = "allwinner,sun6i-a31-ar100-div-clk";
+				#clock-cells = <0>;
+				clocks = <&ar100>;
+			};
+
+			ahb0: ahb0 {
+				compatible = "fixed-factor-clock";
+				#clock-cells = <0>;
+				clock-div = <1>;
+				clock-mult = <1>;
+				clocks = <&ar100_div>;
+				clock-output-names = "ahb0";
+			};
+
+			apb0: apb0 {
+				compatible = "allwinner,sun6i-a31-apb0-clk";
+				#clock-cells = <0>;
+				clocks = <&ahb0>;
+				clock-output-names = "apb0";
+			};
+
+			apb0_gates: apb0_gates {
+				compatible = "allwinner,sun6i-a31-apb0-gates-clk";
+				#clock-cells = <1>;
+				clocks = <&apb0>;
+				clock-output-names = "apb0_pio", "apb0_ir",
+						"apb0_timer01", "apb0_p2wi",
+						"apb0_uart", "apb0_1wire",
+						"apb0_i2c";
+			};
+
+			apb0_rst: apb0_rst {
+				compatible = "allwinner,sun6i-a31-clock-reset";
+				#reset-cells = <1>;
+			};
 		};
 	};
 };
-- 
1.8.3.2


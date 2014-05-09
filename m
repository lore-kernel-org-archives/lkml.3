Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaEILMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:12:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44817 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756354AbaEILME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:12:04 -0400
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
Subject: [PATCH v3 7/7] ARM: sunxi: dt: add PRCM clk and reset controller subdevices
Date: Fri,  9 May 2014 13:11:51 +0200
Message-Id: <1399633911-7094-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT definitions for PRCM (Power/Reset/Clock Management) clock and reset
controller subdevices.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 9feb3f4..03d5258 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -496,6 +496,43 @@
 		prcm@01f01400 {
 			compatible = "allwinner,sun6i-a31-prcm";
 			reg = <0x01f01400 0x200>;
+
+			ar100: ar100_clk {
+				compatible = "allwinner,sun6i-a31-ar100-clk";
+				#clock-cells = <0>;
+				clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
+			};
+
+			ahb0: ahb0_clk {
+				compatible = "fixed-factor-clock";
+				#clock-cells = <0>;
+				clock-div = <1>;
+				clock-mult = <1>;
+				clocks = <&ar100>;
+				clock-output-names = "ahb0";
+			};
+
+			apb0: apb0_clk {
+				compatible = "allwinner,sun6i-a31-apb0-clk";
+				#clock-cells = <0>;
+				clocks = <&ahb0>;
+				clock-output-names = "apb0";
+			};
+
+			apb0_gates: apb0_gates_clk {
+				compatible = "allwinner,sun6i-a31-apb0-gates-clk";
+				#clock-cells = <1>;
+				clocks = <&apb0>;
+				clock-output-names = "apb0_pio", "apb0_ir",
+						"apb0_timer", "apb0_p2wi",
+						"apb0_uart", "apb0_1wire",
+						"apb0_i2c";
+			};
+
+			apb0_rst: apb0_rst {
+				compatible = "allwinner,sun6i-a31-clock-reset";
+				#reset-cells = <1>;
+			};
 		};
 
 		cpucfg@01f01c00 {
-- 
1.8.3.2


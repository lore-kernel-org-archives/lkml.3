Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaD1PIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:08:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbaD1O7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:59:52 -0400
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
Subject: [PATCH 4/7] mfd: sun6i-prcm: document DT bindings
Date: Mon, 28 Apr 2014 16:58:47 +0200
Message-Id: <1398697130-8338-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document DT bindings of the PRCM (Power/Reset/Clock Management) unit.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/mfd/sun6i-prcm.txt         | 71 ++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt

diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
new file mode 100644
index 0000000..de92429
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
@@ -0,0 +1,71 @@
+* Allwinner PRCM (Power/Reset/Clock Management) Multi-Functional Device
+
+PRCM is an MFD device exposing several Power Management related devices
+(like clks and reset controllers).
+
+Required properties:
+ - compatible: "allwinner,sun6i-a31-prcm"
+ - reg: The PRCM registers range
+
+The prcm node may contain several subdevices definitions:
+ - see Documentation/devicetree/clk/sunxi.txt for clock devices
+ - see Documentation/devicetree/reset/allwinner,sunxi-clock-reset.txt for reset
+   controller devices
+
+
+Example:
+
+	prcm: prcm@01f01400 {
+		compatible = "allwinner,sun6i-a31-prcm";
+		reg = <0x01f01400>;
+
+		/* Put subdevices here */
+		ar100_mux: ar100_mux {
+			compatible = "allwinner,sun6i-a31-ar100-mux-clk";
+			#clock-cells = <0>;
+			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
+		};
+
+		ar100: ar100 {
+			compatible = "allwinner,sun6i-a31-ar100-clk";
+			#clock-cells = <0>;
+			clocks = <&ar100_mux>;
+		};
+
+		ar100_div: ar100_div {
+			compatible = "allwinner,sun6i-a31-ar100-div-clk";
+			#clock-cells = <0>;
+			clocks = <&ar100>;
+		};
+
+		ahb0: ahb0 {
+			compatible = "fixed-factor-clock";
+			#clock-cells = <0>;
+			clock-div = <1>;
+			clock-mult = <1>;
+			clocks = <&ar100_div>;
+			clock-output-names = "ahb0";
+		};
+
+		apb0: apb0 {
+			compatible = "allwinner,sun6i-a31-apb0-clk";
+			#clock-cells = <0>;
+			clocks = <&ahb0>;
+			clock-output-names = "apb0";
+		};
+
+		apb0_gates: apb0_gates {
+			compatible = "allwinner,sun6i-a31-apb0-gates-clk";
+			#clock-cells = <1>;
+			clocks = <&apb0>;
+			clock-output-names = "apb0_pio", "apb0_ir",
+					"apb0_timer01", "apb0_p2wi",
+					"apb0_uart", "apb0_1wire",
+					"apb0_i2c";
+		};
+
+		apb0_rst: apb0_rst {
+			compatible = "allwinner,sun6i-a31-clock-reset";
+			#reset-cells = <1>;
+		};
+	};
-- 
1.8.3.2


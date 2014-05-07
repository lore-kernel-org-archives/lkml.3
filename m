Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaEGR1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:27:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:32934 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751331AbaEGR0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:26:10 -0400
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
Subject: [PATCH v2 4/7] mfd: sun6i-prcm: document DT bindings
Date: Wed,  7 May 2014 19:25:51 +0200
Message-Id: <1399483554-8824-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document DT bindings of the PRCM (Power/Reset/Clock Management) unit.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/mfd/sun6i-prcm.txt         | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/sun6i-prcm.txt

diff --git a/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
new file mode 100644
index 0000000..1f5a31f
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sun6i-prcm.txt
@@ -0,0 +1,59 @@
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
+		reg = <0x01f01400 0x200>;
+
+		/* Put subdevices here */
+		ar100: ar100_clk {
+			compatible = "allwinner,sun6i-a31-ar100-clk";
+			#clock-cells = <0>;
+			clocks = <&osc32k>, <&osc24M>, <&pll6>, <&pll6>;
+		};
+
+		ahb0: ahb0_clk {
+			compatible = "fixed-factor-clock";
+			#clock-cells = <0>;
+			clock-div = <1>;
+			clock-mult = <1>;
+			clocks = <&ar100_div>;
+			clock-output-names = "ahb0";
+		};
+
+		apb0: apb0_clk {
+			compatible = "allwinner,sun6i-a31-apb0-clk";
+			#clock-cells = <0>;
+			clocks = <&ahb0>;
+			clock-output-names = "apb0";
+		};
+
+		apb0_gates: apb0_gates_clk {
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


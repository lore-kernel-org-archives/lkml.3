Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab3HEUje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:39:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50706 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755005Ab3HEUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:39:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 1/2] clk: sunxi: Add A10s gates
Date: Mon,  5 Aug 2013 22:39:25 +0200
Message-Id: <1375735167-18031-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375735167-18031-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375735167-18031-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A10s has a slightly different gates set than the A10 and
A13, so add these gates to the clk driver.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Emilio López <emilio@elopez.com.ar>
Reviewed-by: Emilio López <emilio@elopez.com.ar>
---
 Documentation/devicetree/bindings/clock/sunxi.txt  |  3 +
 .../bindings/clock/sunxi/sun5i-a10s-gates.txt      | 75 ++++++++++++++++++++++
 drivers/clk/sunxi/clk-sunxi.c                      | 15 +++++
 3 files changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index d495521..b24de10 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -14,13 +14,16 @@ Required properties:
 	"allwinner,sun4i-ahb-clk" - for the AHB clock
 	"allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
 	"allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
+	"allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
 	"allwinner,sun4i-apb0-clk" - for the APB0 clock
 	"allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
 	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
+	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
 	"allwinner,sun4i-apb1-clk" - for the APB1 clock
 	"allwinner,sun4i-apb1-mux-clk" - for the APB1 clock muxing
 	"allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
 	"allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
+	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
 
 Required properties for all clocks:
 - reg : shall be the control register address for the clock.
diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt b/Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt
new file mode 100644
index 0000000..d24279f
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt
@@ -0,0 +1,75 @@
+Gate clock outputs
+------------------
+
+  * AXI gates ("allwinner,sun4i-axi-gates-clk")
+
+    DRAM					0
+
+  * AHB gates ("allwinner,sun5i-a10s-ahb-gates-clk")
+
+    USB0					0
+    EHCI0					1
+    OHCI0					2
+
+    SS						5
+    DMA						6
+    BIST					7
+    MMC0					8
+    MMC1					9
+    MMC2					10
+
+    NAND					13
+    SDRAM					14
+
+    EMAC					17
+    TS						18
+
+    SPI0					20
+    SPI1					21
+    SPI2					22
+
+    GPS						26
+
+    HSTIMER					28
+
+    VE						32
+
+    TVE						34
+
+    LCD						36
+
+    CSI						40
+
+    HDMI					43
+    DE_BE					44
+
+    DE_FE					46
+
+    IEP						51
+    MALI400					52
+
+  * APB0 gates ("allwinner,sun5i-a10s-apb0-gates-clk")
+
+    CODEC					0
+
+    IIS						3
+
+    PIO						5
+    IR						6
+
+    KEYPAD					10
+
+  * APB1 gates ("allwinner,sun5i-a10s-apb1-gates-clk")
+
+    I2C0					0
+    I2C1					1
+    I2C2					2
+
+    UART0					16
+    UART1					17
+    UART2					18
+    UART3					19
+
+Notation:
+ [*]:  The datasheet didn't mention these, but they are present on AW code
+ [**]: The datasheet had this marked as "NC" but they are used on AW code
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 412912b..db1c45b 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -341,6 +341,10 @@ static const __initconst struct gates_data sun4i_ahb_gates_data = {
 	.mask = {0x7F77FFF, 0x14FB3F},
 };
 
+static const __initconst struct gates_data sun5i_a10s_ahb_gates_data = {
+	.mask = {0x147667e7, 0x185915},
+};
+
 static const __initconst struct gates_data sun5i_a13_ahb_gates_data = {
 	.mask = {0x107067e7, 0x185111},
 };
@@ -349,6 +353,10 @@ static const __initconst struct gates_data sun4i_apb0_gates_data = {
 	.mask = {0x4EF},
 };
 
+static const __initconst struct gates_data sun5i_a10s_apb0_gates_data = {
+	.mask = {0x469},
+};
+
 static const __initconst struct gates_data sun5i_a13_apb0_gates_data = {
 	.mask = {0x61},
 };
@@ -357,6 +365,10 @@ static const __initconst struct gates_data sun4i_apb1_gates_data = {
 	.mask = {0xFF00F7},
 };
 
+static const __initconst struct gates_data sun5i_a10s_apb1_gates_data = {
+	.mask = {0xf0007},
+};
+
 static const __initconst struct gates_data sun5i_a13_apb1_gates_data = {
 	.mask = {0xa0007},
 };
@@ -442,10 +454,13 @@ static const __initconst struct of_device_id clk_mux_match[] = {
 static const __initconst struct of_device_id clk_gates_match[] = {
 	{.compatible = "allwinner,sun4i-axi-gates-clk", .data = &sun4i_axi_gates_data,},
 	{.compatible = "allwinner,sun4i-ahb-gates-clk", .data = &sun4i_ahb_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-ahb-gates-clk", .data = &sun5i_a10s_ahb_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-ahb-gates-clk", .data = &sun5i_a13_ahb_gates_data,},
 	{.compatible = "allwinner,sun4i-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
 	{.compatible = "allwinner,sun4i-apb1-gates-clk", .data = &sun4i_apb1_gates_data,},
+	{.compatible = "allwinner,sun5i-a10s-apb1-gates-clk", .data = &sun5i_a10s_apb1_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb1-gates-clk", .data = &sun5i_a13_apb1_gates_data,},
 	{}
 };
-- 
1.8.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3AOE6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:58:48 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:55986 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3AOE5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:57:50 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] serial: vt8500: UART uses gated clock rather than 24Mhz reference
Date: Tue, 15 Jan 2013 17:58:05 +1300
Message-Id: <1358225886-5686-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UART modules on Wondermedia SoCs are connected via a gated clock
source, rather than directly to the 24Mhz reference clock. While
uboot enables UART0 for debugging, other UART ports are unavailable
until the clock is enabled.

This patch checks that a valid clock is actually passed from devicetree,
enables the clock in probe. This change removes the fallback when a
clock was not specified as it doesn't apply any longer (and would only
work if the UART clock was already enabled).

DTSI files are updated for VT8500, WM8505 and WM8650.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/boot/dts/vt8500.dtsi      |   40 +++++++++++++++++++++---
 arch/arm/boot/dts/wm8505.dtsi      |   60 ++++++++++++++++++++++++++++++++----
 arch/arm/boot/dts/wm8650.dtsi      |   20 ++++++++++--
 drivers/tty/serial/vt8500_serial.c |   34 +++++++++++---------
 4 files changed, 127 insertions(+), 27 deletions(-)

diff --git a/arch/arm/boot/dts/vt8500.dtsi b/arch/arm/boot/dts/vt8500.dtsi
index d8645e9..cf31ced 100644
--- a/arch/arm/boot/dts/vt8500.dtsi
+++ b/arch/arm/boot/dts/vt8500.dtsi
@@ -45,6 +45,38 @@
 					compatible = "fixed-clock";
 					clock-frequency = <24000000>;
 				};
+
+				clkuart0: uart0 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <1>;
+				};
+
+				clkuart1: uart1 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <2>;
+				};
+
+				clkuart2: uart2 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <3>;
+				};
+
+				clkuart3: uart3 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <4>;
+				};
 			};
 		};
 
@@ -83,28 +115,28 @@
 			compatible = "via,vt8500-uart";
 			reg = <0xd8200000 0x1040>;
 			interrupts = <32>;
-			clocks = <&ref24>;
+			clocks = <&clkuart0>;
 		};
 
 		uart@d82b0000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd82b0000 0x1040>;
 			interrupts = <33>;
-			clocks = <&ref24>;
+			clocks = <&clkuart1>;
 		};
 
 		uart@d8210000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd8210000 0x1040>;
 			interrupts = <47>;
-			clocks = <&ref24>;
+			clocks = <&clkuart2>;
 		};
 
 		uart@d82c0000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd82c0000 0x1040>;
 			interrupts = <50>;
-			clocks = <&ref24>;
+			clocks = <&clkuart3>;
 		};
 
 		rtc@d8100000 {
diff --git a/arch/arm/boot/dts/wm8505.dtsi b/arch/arm/boot/dts/wm8505.dtsi
index 330f833..e74a1c0 100644
--- a/arch/arm/boot/dts/wm8505.dtsi
+++ b/arch/arm/boot/dts/wm8505.dtsi
@@ -59,6 +59,54 @@
 					compatible = "fixed-clock";
 					clock-frequency = <24000000>;
 				};
+
+				clkuart0: uart0 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <1>;
+				};
+
+				clkuart1: uart1 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <2>;
+				};
+
+				clkuart2: uart2 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <3>;
+				};
+
+				clkuart3: uart3 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <4>;
+				};
+
+				clkuart4: uart4 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <22>;
+				};
+
+				clkuart5: uart5 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <23>;
+				};
 			};
 		};
 
@@ -96,42 +144,42 @@
 			compatible = "via,vt8500-uart";
 			reg = <0xd8200000 0x1040>;
 			interrupts = <32>;
-			clocks = <&ref24>;
+			clocks = <&clkuart0>;
 		};
 
 		uart@d82b0000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd82b0000 0x1040>;
 			interrupts = <33>;
-			clocks = <&ref24>;
+			clocks = <&clkuart1>;
 		};
 
 		uart@d8210000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd8210000 0x1040>;
 			interrupts = <47>;
-			clocks = <&ref24>;
+			clocks = <&clkuart2>;
 		};
 
 		uart@d82c0000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd82c0000 0x1040>;
 			interrupts = <50>;
-			clocks = <&ref24>;
+			clocks = <&clkuart3>;
 		};
 
 		uart@d8370000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd8370000 0x1040>;
 			interrupts = <31>;
-			clocks = <&ref24>;
+			clocks = <&clkuart4>;
 		};
 
 		uart@d8380000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd8380000 0x1040>;
 			interrupts = <30>;
-			clocks = <&ref24>;
+			clocks = <&clkuart5>;
 		};
 
 		rtc@d8100000 {
diff --git a/arch/arm/boot/dts/wm8650.dtsi b/arch/arm/boot/dts/wm8650.dtsi
index 83b9467..e0c42ff 100644
--- a/arch/arm/boot/dts/wm8650.dtsi
+++ b/arch/arm/boot/dts/wm8650.dtsi
@@ -75,6 +75,22 @@
 					reg = <0x204>;
 				};
 
+				clkuart0: uart0 {
+ 					#clock-cells = <0>;
+ 					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <1>;
+ 				};
+ 
+				clkuart1: uart1 {
+					#clock-cells = <0>;
+					compatible = "via,vt8500-device-clock";
+					clocks = <&ref24>;
+					enable-reg = <0x250>;
+					enable-bit = <2>;
+				};
+
 				arm: arm {
 					#clock-cells = <0>;
 					compatible = "via,vt8500-device-clock";
@@ -128,14 +144,14 @@
 			compatible = "via,vt8500-uart";
 			reg = <0xd8200000 0x1040>;
 			interrupts = <32>;
-			clocks = <&ref24>;
+			clocks = <&clkuart0>;
 		};
 
 		uart@d82b0000 {
 			compatible = "via,vt8500-uart";
 			reg = <0xd82b0000 0x1040>;
 			interrupts = <33>;
-			clocks = <&ref24>;
+			clocks = <&clkuart1>;
 		};
 
 		rtc@d8100000 {
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 3e76dff..7f9e578 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -593,6 +593,23 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	if (!vt8500_port)
 		return -ENOMEM;
 
+	vt8500_port->uart.membase = devm_request_and_ioremap(&pdev->dev, mmres);
+	if (!vt8500_port->uart.membase)
+		return -EADDRNOTAVAIL;
+
+	vt8500_port->clk = of_clk_get(pdev->dev.of_node, 0);
+	if (IS_ERR(vt8500_port->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = clk_prepare_enable(vt8500_port->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to enable clock\n");
+ 		goto err;
+ 	}
+
 	vt8500_port->uart.type = PORT_VT8500;
 	vt8500_port->uart.iotype = UPIO_MEM;
 	vt8500_port->uart.mapbase = mmres->start;
@@ -602,25 +619,11 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	vt8500_port->uart.line = port;
 	vt8500_port->uart.dev = &pdev->dev;
 	vt8500_port->uart.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
-
-	vt8500_port->clk = of_clk_get(pdev->dev.of_node, 0);
-	if (vt8500_port->clk) {
-		vt8500_port->uart.uartclk = clk_get_rate(vt8500_port->clk);
-	} else {
-		/* use the default of 24Mhz if not specified and warn */
-		pr_warn("%s: serial clock source not specified\n", __func__);
-		vt8500_port->uart.uartclk = 24000000;
-	}
+	vt8500_port->uart.uartclk = clk_get_rate(vt8500_port->clk);
 
 	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
 		 "VT8500 UART%d", pdev->id);
 
-	vt8500_port->uart.membase = devm_request_and_ioremap(&pdev->dev, mmres);
-	if (!vt8500_port->uart.membase) {
-		ret = -EADDRNOTAVAIL;
-		goto err;
-	}
-
 	vt8500_uart_ports[port] = vt8500_port;
 
 	uart_add_one_port(&vt8500_uart_driver, &vt8500_port->uart);
@@ -639,6 +642,7 @@ static int vt8500_serial_remove(struct platform_device *pdev)
 	struct vt8500_port *vt8500_port = platform_get_drvdata(pdev);
 
 	platform_set_drvdata(pdev, NULL);
+	clk_disable_unprepare(vt8500_port->clk);
 	uart_remove_one_port(&vt8500_uart_driver, &vt8500_port->uart);
 	kfree(vt8500_port);
 
-- 
1.7.9.5


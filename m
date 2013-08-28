Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3H1TIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:08:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48504 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3H1TIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:08:34 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, gregkh@linuxfoundation.org
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] serial: unify serial bindings into a single dir
Date: Wed, 28 Aug 2013 14:08:23 -0500
Message-Id: <1377716903-19699-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
References: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all bindings in bindings/tty/serial into bindings/serial so we only
have one place dir with serial/uart related bindings in it.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
Note: I did not move msm_serial.txt with the feeling that Stephen will end up
removing it in his patch set.

 .../devicetree/bindings/serial/arc-uart.txt        | 26 ++++++++++++
 .../devicetree/bindings/serial/atmel-usart.txt     | 43 +++++++++++++++++++
 .../devicetree/bindings/serial/efm32-uart.txt      | 20 +++++++++
 .../devicetree/bindings/serial/fsl-imx-uart.txt    | 29 +++++++++++++
 .../devicetree/bindings/serial/fsl-lpuart.txt      | 14 +++++++
 .../devicetree/bindings/serial/fsl-mxs-auart.txt   | 37 ++++++++++++++++
 .../bindings/serial/nxp-lpc32xx-hsuart.txt         | 14 +++++++
 .../devicetree/bindings/serial/of-serial.txt       | 49 ++++++++++++++++++++++
 .../devicetree/bindings/serial/sirf-uart.txt       | 33 +++++++++++++++
 .../bindings/serial/snps-dw-apb-uart.txt           | 25 +++++++++++
 .../devicetree/bindings/serial/st-asc.txt          | 18 ++++++++
 .../devicetree/bindings/serial/via,vt8500-uart.txt | 17 ++++++++
 .../devicetree/bindings/tty/serial/arc-uart.txt    | 26 ------------
 .../devicetree/bindings/tty/serial/atmel-usart.txt | 43 -------------------
 .../devicetree/bindings/tty/serial/efm32-uart.txt  | 20 ---------
 .../bindings/tty/serial/fsl-imx-uart.txt           | 29 -------------
 .../devicetree/bindings/tty/serial/fsl-lpuart.txt  | 14 -------
 .../bindings/tty/serial/fsl-mxs-auart.txt          | 37 ----------------
 .../bindings/tty/serial/nxp-lpc32xx-hsuart.txt     | 14 -------
 .../devicetree/bindings/tty/serial/of-serial.txt   | 49 ----------------------
 .../devicetree/bindings/tty/serial/sirf-uart.txt   | 33 ---------------
 .../bindings/tty/serial/snps-dw-apb-uart.txt       | 25 -----------
 .../devicetree/bindings/tty/serial/st-asc.txt      | 18 --------
 .../bindings/tty/serial/via,vt8500-uart.txt        | 17 --------
 24 files changed, 325 insertions(+), 325 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/arc-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/atmel-usart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/efm32-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/fsl-lpuart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/fsl-mxs-auart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/nxp-lpc32xx-hsuart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/of-serial.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sirf-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/st-asc.txt
 create mode 100644 Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/arc-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/atmel-usart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-lpuart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-mxs-auart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/of-serial.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/sirf-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/st-asc.txt
 delete mode 100644 Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt

diff --git a/Documentation/devicetree/bindings/serial/arc-uart.txt b/Documentation/devicetree/bindings/serial/arc-uart.txt
new file mode 100644
index 0000000..5cae2eb
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/arc-uart.txt
@@ -0,0 +1,26 @@
+* Synopsys ARC UART : Non standard UART used in some of the ARC FPGA boards
+
+Required properties:
+- compatible		: "snps,arc-uart"
+- reg			: offset and length of the register set for the device.
+- interrupts		: device interrupt
+- clock-frequency	: the input clock frequency for the UART
+- current-speed		: baud rate for UART
+
+e.g.
+
+arcuart0: serial@c0fc1000 {
+	compatible = "snps,arc-uart";
+	reg = <0xc0fc1000 0x100>;
+	interrupts = <5>;
+	clock-frequency = <80000000>;
+	current-speed = <115200>;
+	status = "okay";
+};
+
+Note: Each port should have an alias correctly numbered in "aliases" node.
+
+e.g.
+aliases {
+	serial0 = &arcuart0;
+};
diff --git a/Documentation/devicetree/bindings/serial/atmel-usart.txt b/Documentation/devicetree/bindings/serial/atmel-usart.txt
new file mode 100644
index 0000000..2191dcb
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/atmel-usart.txt
@@ -0,0 +1,43 @@
+* Atmel Universal Synchronous Asynchronous Receiver/Transmitter (USART)
+
+Required properties:
+- compatible: Should be "atmel,<chip>-usart"
+  The compatible <chip> indicated will be the first SoC to support an
+  additional mode or an USART new feature.
+- reg: Should contain registers location and length
+- interrupts: Should contain interrupt
+
+Optional properties:
+- atmel,use-dma-rx: use of PDC or DMA for receiving data
+- atmel,use-dma-tx: use of PDC or DMA for transmitting data
+- add dma bindings for dma transfer:
+	- dmas: DMA specifier, consisting of a phandle to DMA controller node,
+		memory peripheral interface and USART DMA channel ID, FIFO configuration.
+		Refer to dma.txt and atmel-dma.txt for details.
+	- dma-names: "rx" for RX channel, "tx" for TX channel.
+
+<chip> compatible description:
+- at91rm9200:  legacy USART support
+- at91sam9260: generic USART implementation for SAM9 SoCs
+
+Example:
+- use PDC:
+	usart0: serial@fff8c000 {
+		compatible = "atmel,at91sam9260-usart";
+		reg = <0xfff8c000 0x4000>;
+		interrupts = <7>;
+		atmel,use-dma-rx;
+		atmel,use-dma-tx;
+	};
+
+- use DMA:
+	usart0: serial@f001c000 {
+		compatible = "atmel,at91sam9260-usart";
+		reg = <0xf001c000 0x100>;
+		interrupts = <12 4 5>;
+		atmel,use-dma-rx;
+		atmel,use-dma-tx;
+		dmas = <&dma0 2 0x3>,
+		       <&dma0 2 0x204>;
+		dma-names = "tx", "rx";
+	};
diff --git a/Documentation/devicetree/bindings/serial/efm32-uart.txt b/Documentation/devicetree/bindings/serial/efm32-uart.txt
new file mode 100644
index 0000000..8e080b8
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/efm32-uart.txt
@@ -0,0 +1,20 @@
+* Energymicro efm32 UART
+
+Required properties:
+- compatible : Should be "efm32,uart"
+- reg : Address and length of the register set
+- interrupts : Should contain uart interrupt
+
+Optional properties:
+- location : Decides the location of the USART I/O pins.
+  Allowed range : [0 .. 5]
+  Default: 0
+
+Example:
+
+uart@0x4000c400 {
+	compatible = "efm32,uart";
+	reg = <0x4000c400 0x400>;
+	interrupts = <15>;
+	location = <0>;
+};
diff --git a/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
new file mode 100644
index 0000000..35ae1fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
@@ -0,0 +1,29 @@
+* Freescale i.MX Universal Asynchronous Receiver/Transmitter (UART)
+
+Required properties:
+- compatible : Should be "fsl,<soc>-uart"
+- reg : Address and length of the register set for the device
+- interrupts : Should contain uart interrupt
+
+Optional properties:
+- fsl,uart-has-rtscts : Indicate the uart has rts and cts
+- fsl,irda-mode : Indicate the uart supports irda mode
+- fsl,dte-mode : Indicate the uart works in DTE mode. The uart works
+                  is DCE mode by default.
+
+Note: Each uart controller should have an alias correctly numbered
+in "aliases" node.
+
+Example:
+
+aliases {
+	serial0 = &uart1;
+};
+
+uart1: serial@73fbc000 {
+	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
+	reg = <0x73fbc000 0x4000>;
+	interrupts = <31>;
+	fsl,uart-has-rtscts;
+	fsl,dte-mode;
+};
diff --git a/Documentation/devicetree/bindings/serial/fsl-lpuart.txt b/Documentation/devicetree/bindings/serial/fsl-lpuart.txt
new file mode 100644
index 0000000..6fd1dd1
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/fsl-lpuart.txt
@@ -0,0 +1,14 @@
+* Freescale low power universal asynchronous receiver/transmitter (lpuart)
+
+Required properties:
+- compatible : Should be "fsl,<soc>-lpuart"
+- reg : Address and length of the register set for the device
+- interrupts : Should contain uart interrupt
+
+Example:
+
+uart0: serial@40027000 {
+	       compatible = "fsl,vf610-lpuart";
+	       reg = <0x40027000 0x1000>;
+	       interrupts = <0 61 0x00>;
+       };
diff --git a/Documentation/devicetree/bindings/serial/fsl-mxs-auart.txt b/Documentation/devicetree/bindings/serial/fsl-mxs-auart.txt
new file mode 100644
index 0000000..59a40f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/fsl-mxs-auart.txt
@@ -0,0 +1,37 @@
+* Freescale MXS Application UART (AUART)
+
+Required properties:
+- compatible : Should be "fsl,<soc>-auart". The supported SoCs include
+  imx23 and imx28.
+- reg : Address and length of the register set for the device
+- interrupts : Should contain the auart interrupt numbers
+- dmas: DMA specifier, consisting of a phandle to DMA controller node
+  and AUART DMA channel ID.
+  Refer to dma.txt and fsl-mxs-dma.txt for details.
+- dma-names: "rx" for RX channel, "tx" for TX channel.
+
+Optional properties:
+- fsl,uart-has-rtscts : Indicate the UART has RTS and CTS lines,
+	it also means you enable the DMA support for this UART.
+
+Example:
+auart0: serial@8006a000 {
+	compatible = "fsl,imx28-auart", "fsl,imx23-auart";
+	reg = <0x8006a000 0x2000>;
+	interrupts = <112>;
+	dmas = <&dma_apbx 8>, <&dma_apbx 9>;
+	dma-names = "rx", "tx";
+};
+
+Note: Each auart port should have an alias correctly numbered in "aliases"
+node.
+
+Example:
+
+aliases {
+	serial0 = &auart0;
+	serial1 = &auart1;
+	serial2 = &auart2;
+	serial3 = &auart3;
+	serial4 = &auart4;
+};
diff --git a/Documentation/devicetree/bindings/serial/nxp-lpc32xx-hsuart.txt b/Documentation/devicetree/bindings/serial/nxp-lpc32xx-hsuart.txt
new file mode 100644
index 0000000..0d439df
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/nxp-lpc32xx-hsuart.txt
@@ -0,0 +1,14 @@
+* NXP LPC32xx SoC High Speed UART
+
+Required properties:
+- compatible: Should be "nxp,lpc3220-hsuart"
+- reg: Should contain registers location and length
+- interrupts: Should contain interrupt
+
+Example:
+
+	uart1: serial@40014000 {
+		compatible = "nxp,lpc3220-hsuart";
+		reg = <0x40014000 0x1000>;
+		interrupts = <26 0>;
+	};
diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
new file mode 100644
index 0000000..1928a3e
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
@@ -0,0 +1,49 @@
+* UART (Universal Asynchronous Receiver/Transmitter)
+
+Required properties:
+- compatible : one of:
+	- "ns8250"
+	- "ns16450"
+	- "ns16550a"
+	- "ns16550"
+	- "ns16750"
+	- "ns16850"
+	- "nvidia,tegra20-uart"
+	- "nxp,lpc3220-uart"
+	- "ibm,qpace-nwp-serial"
+	- "altr,16550-FIFO32"
+	- "altr,16550-FIFO64"
+	- "altr,16550-FIFO128"
+	- "serial" if the port type is unknown.
+- reg : offset and length of the register set for the device.
+- interrupts : should contain uart interrupt.
+- clock-frequency : the input clock frequency for the UART
+	 or
+  clocks phandle to refer to the clk used as per Documentation/devicetree
+  /bindings/clock/clock-bindings.txt
+
+Optional properties:
+- current-speed : the current active speed of the UART.
+- reg-offset : offset to apply to the mapbase from the start of the registers.
+- reg-shift : quantity to shift the register offsets by.
+- reg-io-width : the size (in bytes) of the IO accesses that should be
+  performed on the device.  There are some systems that require 32-bit
+  accesses to the UART (e.g. TI davinci).
+- used-by-rtas : set to indicate that the port is in use by the OpenFirmware
+  RTAS and should not be registered.
+- no-loopback-test: set to indicate that the port does not implements loopback
+  test mode
+- fifo-size: the fifo size of the UART.
+- auto-flow-control: one way to enable automatic flow control support. The
+  driver is allowed to detect support for the capability even without this
+  property.
+
+Example:
+
+	uart@80230000 {
+		compatible = "ns8250";
+		reg = <0x80230000 0x100>;
+		clock-frequency = <3686400>;
+		interrupts = <10>;
+		reg-shift = <2>;
+	};
diff --git a/Documentation/devicetree/bindings/serial/sirf-uart.txt b/Documentation/devicetree/bindings/serial/sirf-uart.txt
new file mode 100644
index 0000000..a2dfc65
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/sirf-uart.txt
@@ -0,0 +1,33 @@
+* CSR SiRFprimaII/atlasVI Universal Synchronous Asynchronous Receiver/Transmitter *
+
+Required properties:
+- compatible : Should be "sirf,prima2-uart" or "sirf, prima2-usp-uart"
+- reg : Offset and length of the register set for the device
+- interrupts : Should contain uart interrupt
+- fifosize : Should define hardware rx/tx fifo size
+- clocks : Should contain uart clock number
+
+Optional properties:
+- sirf,uart-has-rtscts: we have hardware flow controller pins in hardware
+- rts-gpios: RTS pin for USP-based UART if sirf,uart-has-rtscts is true
+- cts-gpios: CTS pin for USP-based UART if sirf,uart-has-rtscts is true
+
+Example:
+
+uart0: uart@b0050000 {
+	cell-index = <0>;
+	compatible = "sirf,prima2-uart";
+	reg = <0xb0050000 0x1000>;
+	interrupts = <17>;
+	fifosize = <128>;
+	clocks = <&clks 13>;
+};
+
+On the board-specific dts, we can put rts-gpios and cts-gpios like
+
+usp@b0090000 {
+	compatible = "sirf,prima2-usp-uart";
+	sirf,uart-has-rtscts;
+	rts-gpios = <&gpio 15 0>;
+	cts-gpios = <&gpio 46 0>;
+};
diff --git a/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
new file mode 100644
index 0000000..f13f1c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
@@ -0,0 +1,25 @@
+* Synopsys DesignWare ABP UART
+
+Required properties:
+- compatible : "snps,dw-apb-uart"
+- reg : offset and length of the register set for the device.
+- interrupts : should contain uart interrupt.
+- clock-frequency : the input clock frequency for the UART.
+
+Optional properties:
+- reg-shift : quantity to shift the register offsets by.  If this property is
+  not present then the register offsets are not shifted.
+- reg-io-width : the size (in bytes) of the IO accesses that should be
+  performed on the device.  If this property is not present then single byte
+  accesses are used.
+
+Example:
+
+	uart@80230000 {
+		compatible = "snps,dw-apb-uart";
+		reg = <0x80230000 0x100>;
+		clock-frequency = <3686400>;
+		interrupts = <10>;
+		reg-shift = <2>;
+		reg-io-width = <4>;
+	};
diff --git a/Documentation/devicetree/bindings/serial/st-asc.txt b/Documentation/devicetree/bindings/serial/st-asc.txt
new file mode 100644
index 0000000..75d877f
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/st-asc.txt
@@ -0,0 +1,18 @@
+*st-asc(Serial Port)
+
+Required properties:
+- compatible : Should be "st,asc".
+- reg, reg-names, interrupts, interrupt-names	: Standard way to define device
+			resources with names. look in
+			Documentation/devicetree/bindings/resource-names.txt
+
+Optional properties:
+- st,hw-flow-ctrl	bool flag to enable hardware flow control.
+- st,force-m1		bool flat to force asc to be in Mode-1 recommeded
+			for high bit rates (above 19.2K)
+Example:
+serial@fe440000{
+    compatible    = "st,asc";
+    reg         = <0xfe440000 0x2c>;
+    interrupts     =  <0 209 0>;
+};
diff --git a/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt b/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
new file mode 100644
index 0000000..5feef1e
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
@@ -0,0 +1,17 @@
+VIA/Wondermedia VT8500 UART Controller
+-----------------------------------------------------
+
+Required properties:
+- compatible : "via,vt8500-uart"
+- reg : Should contain 1 register ranges(address and length)
+- interrupts : UART interrupt
+- clocks : phandle to the uart source clock (usually a 24Mhz fixed clock)
+
+Example:
+
+	uart@d8210000 {
+		compatible = "via,vt8500-uart";
+		reg = <0xd8210000 0x1040>;
+		interrupts = <47>;
+		clocks = <&ref24>;
+	};
diff --git a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
deleted file mode 100644
index 5cae2eb..0000000
--- a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
+++ /dev/null
@@ -1,26 +0,0 @@
-* Synopsys ARC UART : Non standard UART used in some of the ARC FPGA boards
-
-Required properties:
-- compatible		: "snps,arc-uart"
-- reg			: offset and length of the register set for the device.
-- interrupts		: device interrupt
-- clock-frequency	: the input clock frequency for the UART
-- current-speed		: baud rate for UART
-
-e.g.
-
-arcuart0: serial@c0fc1000 {
-	compatible = "snps,arc-uart";
-	reg = <0xc0fc1000 0x100>;
-	interrupts = <5>;
-	clock-frequency = <80000000>;
-	current-speed = <115200>;
-	status = "okay";
-};
-
-Note: Each port should have an alias correctly numbered in "aliases" node.
-
-e.g.
-aliases {
-	serial0 = &arcuart0;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt b/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt
deleted file mode 100644
index 2191dcb..0000000
--- a/Documentation/devicetree/bindings/tty/serial/atmel-usart.txt
+++ /dev/null
@@ -1,43 +0,0 @@
-* Atmel Universal Synchronous Asynchronous Receiver/Transmitter (USART)
-
-Required properties:
-- compatible: Should be "atmel,<chip>-usart"
-  The compatible <chip> indicated will be the first SoC to support an
-  additional mode or an USART new feature.
-- reg: Should contain registers location and length
-- interrupts: Should contain interrupt
-
-Optional properties:
-- atmel,use-dma-rx: use of PDC or DMA for receiving data
-- atmel,use-dma-tx: use of PDC or DMA for transmitting data
-- add dma bindings for dma transfer:
-	- dmas: DMA specifier, consisting of a phandle to DMA controller node,
-		memory peripheral interface and USART DMA channel ID, FIFO configuration.
-		Refer to dma.txt and atmel-dma.txt for details.
-	- dma-names: "rx" for RX channel, "tx" for TX channel.
-
-<chip> compatible description:
-- at91rm9200:  legacy USART support
-- at91sam9260: generic USART implementation for SAM9 SoCs
-
-Example:
-- use PDC:
-	usart0: serial@fff8c000 {
-		compatible = "atmel,at91sam9260-usart";
-		reg = <0xfff8c000 0x4000>;
-		interrupts = <7>;
-		atmel,use-dma-rx;
-		atmel,use-dma-tx;
-	};
-
-- use DMA:
-	usart0: serial@f001c000 {
-		compatible = "atmel,at91sam9260-usart";
-		reg = <0xf001c000 0x100>;
-		interrupts = <12 4 5>;
-		atmel,use-dma-rx;
-		atmel,use-dma-tx;
-		dmas = <&dma0 2 0x3>,
-		       <&dma0 2 0x204>;
-		dma-names = "tx", "rx";
-	};
diff --git a/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt b/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
deleted file mode 100644
index 8e080b8..0000000
--- a/Documentation/devicetree/bindings/tty/serial/efm32-uart.txt
+++ /dev/null
@@ -1,20 +0,0 @@
-* Energymicro efm32 UART
-
-Required properties:
-- compatible : Should be "efm32,uart"
-- reg : Address and length of the register set
-- interrupts : Should contain uart interrupt
-
-Optional properties:
-- location : Decides the location of the USART I/O pins.
-  Allowed range : [0 .. 5]
-  Default: 0
-
-Example:
-
-uart@0x4000c400 {
-	compatible = "efm32,uart";
-	reg = <0x4000c400 0x400>;
-	interrupts = <15>;
-	location = <0>;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
deleted file mode 100644
index 35ae1fb..0000000
--- a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
+++ /dev/null
@@ -1,29 +0,0 @@
-* Freescale i.MX Universal Asynchronous Receiver/Transmitter (UART)
-
-Required properties:
-- compatible : Should be "fsl,<soc>-uart"
-- reg : Address and length of the register set for the device
-- interrupts : Should contain uart interrupt
-
-Optional properties:
-- fsl,uart-has-rtscts : Indicate the uart has rts and cts
-- fsl,irda-mode : Indicate the uart supports irda mode
-- fsl,dte-mode : Indicate the uart works in DTE mode. The uart works
-                  is DCE mode by default.
-
-Note: Each uart controller should have an alias correctly numbered
-in "aliases" node.
-
-Example:
-
-aliases {
-	serial0 = &uart1;
-};
-
-uart1: serial@73fbc000 {
-	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
-	reg = <0x73fbc000 0x4000>;
-	interrupts = <31>;
-	fsl,uart-has-rtscts;
-	fsl,dte-mode;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-lpuart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-lpuart.txt
deleted file mode 100644
index 6fd1dd1..0000000
--- a/Documentation/devicetree/bindings/tty/serial/fsl-lpuart.txt
+++ /dev/null
@@ -1,14 +0,0 @@
-* Freescale low power universal asynchronous receiver/transmitter (lpuart)
-
-Required properties:
-- compatible : Should be "fsl,<soc>-lpuart"
-- reg : Address and length of the register set for the device
-- interrupts : Should contain uart interrupt
-
-Example:
-
-uart0: serial@40027000 {
-	       compatible = "fsl,vf610-lpuart";
-	       reg = <0x40027000 0x1000>;
-	       interrupts = <0 61 0x00>;
-       };
diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-mxs-auart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-mxs-auart.txt
deleted file mode 100644
index 59a40f1..0000000
--- a/Documentation/devicetree/bindings/tty/serial/fsl-mxs-auart.txt
+++ /dev/null
@@ -1,37 +0,0 @@
-* Freescale MXS Application UART (AUART)
-
-Required properties:
-- compatible : Should be "fsl,<soc>-auart". The supported SoCs include
-  imx23 and imx28.
-- reg : Address and length of the register set for the device
-- interrupts : Should contain the auart interrupt numbers
-- dmas: DMA specifier, consisting of a phandle to DMA controller node
-  and AUART DMA channel ID.
-  Refer to dma.txt and fsl-mxs-dma.txt for details.
-- dma-names: "rx" for RX channel, "tx" for TX channel.
-
-Optional properties:
-- fsl,uart-has-rtscts : Indicate the UART has RTS and CTS lines,
-	it also means you enable the DMA support for this UART.
-
-Example:
-auart0: serial@8006a000 {
-	compatible = "fsl,imx28-auart", "fsl,imx23-auart";
-	reg = <0x8006a000 0x2000>;
-	interrupts = <112>;
-	dmas = <&dma_apbx 8>, <&dma_apbx 9>;
-	dma-names = "rx", "tx";
-};
-
-Note: Each auart port should have an alias correctly numbered in "aliases"
-node.
-
-Example:
-
-aliases {
-	serial0 = &auart0;
-	serial1 = &auart1;
-	serial2 = &auart2;
-	serial3 = &auart3;
-	serial4 = &auart4;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt b/Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt
deleted file mode 100644
index 0d439df..0000000
--- a/Documentation/devicetree/bindings/tty/serial/nxp-lpc32xx-hsuart.txt
+++ /dev/null
@@ -1,14 +0,0 @@
-* NXP LPC32xx SoC High Speed UART
-
-Required properties:
-- compatible: Should be "nxp,lpc3220-hsuart"
-- reg: Should contain registers location and length
-- interrupts: Should contain interrupt
-
-Example:
-
-	uart1: serial@40014000 {
-		compatible = "nxp,lpc3220-hsuart";
-		reg = <0x40014000 0x1000>;
-		interrupts = <26 0>;
-	};
diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
deleted file mode 100644
index 1928a3e..0000000
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ /dev/null
@@ -1,49 +0,0 @@
-* UART (Universal Asynchronous Receiver/Transmitter)
-
-Required properties:
-- compatible : one of:
-	- "ns8250"
-	- "ns16450"
-	- "ns16550a"
-	- "ns16550"
-	- "ns16750"
-	- "ns16850"
-	- "nvidia,tegra20-uart"
-	- "nxp,lpc3220-uart"
-	- "ibm,qpace-nwp-serial"
-	- "altr,16550-FIFO32"
-	- "altr,16550-FIFO64"
-	- "altr,16550-FIFO128"
-	- "serial" if the port type is unknown.
-- reg : offset and length of the register set for the device.
-- interrupts : should contain uart interrupt.
-- clock-frequency : the input clock frequency for the UART
-	 or
-  clocks phandle to refer to the clk used as per Documentation/devicetree
-  /bindings/clock/clock-bindings.txt
-
-Optional properties:
-- current-speed : the current active speed of the UART.
-- reg-offset : offset to apply to the mapbase from the start of the registers.
-- reg-shift : quantity to shift the register offsets by.
-- reg-io-width : the size (in bytes) of the IO accesses that should be
-  performed on the device.  There are some systems that require 32-bit
-  accesses to the UART (e.g. TI davinci).
-- used-by-rtas : set to indicate that the port is in use by the OpenFirmware
-  RTAS and should not be registered.
-- no-loopback-test: set to indicate that the port does not implements loopback
-  test mode
-- fifo-size: the fifo size of the UART.
-- auto-flow-control: one way to enable automatic flow control support. The
-  driver is allowed to detect support for the capability even without this
-  property.
-
-Example:
-
-	uart@80230000 {
-		compatible = "ns8250";
-		reg = <0x80230000 0x100>;
-		clock-frequency = <3686400>;
-		interrupts = <10>;
-		reg-shift = <2>;
-	};
diff --git a/Documentation/devicetree/bindings/tty/serial/sirf-uart.txt b/Documentation/devicetree/bindings/tty/serial/sirf-uart.txt
deleted file mode 100644
index a2dfc65..0000000
--- a/Documentation/devicetree/bindings/tty/serial/sirf-uart.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-* CSR SiRFprimaII/atlasVI Universal Synchronous Asynchronous Receiver/Transmitter *
-
-Required properties:
-- compatible : Should be "sirf,prima2-uart" or "sirf, prima2-usp-uart"
-- reg : Offset and length of the register set for the device
-- interrupts : Should contain uart interrupt
-- fifosize : Should define hardware rx/tx fifo size
-- clocks : Should contain uart clock number
-
-Optional properties:
-- sirf,uart-has-rtscts: we have hardware flow controller pins in hardware
-- rts-gpios: RTS pin for USP-based UART if sirf,uart-has-rtscts is true
-- cts-gpios: CTS pin for USP-based UART if sirf,uart-has-rtscts is true
-
-Example:
-
-uart0: uart@b0050000 {
-	cell-index = <0>;
-	compatible = "sirf,prima2-uart";
-	reg = <0xb0050000 0x1000>;
-	interrupts = <17>;
-	fifosize = <128>;
-	clocks = <&clks 13>;
-};
-
-On the board-specific dts, we can put rts-gpios and cts-gpios like
-
-usp@b0090000 {
-	compatible = "sirf,prima2-usp-uart";
-	sirf,uart-has-rtscts;
-	rts-gpios = <&gpio 15 0>;
-	cts-gpios = <&gpio 46 0>;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt b/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
deleted file mode 100644
index f13f1c5..0000000
--- a/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-* Synopsys DesignWare ABP UART
-
-Required properties:
-- compatible : "snps,dw-apb-uart"
-- reg : offset and length of the register set for the device.
-- interrupts : should contain uart interrupt.
-- clock-frequency : the input clock frequency for the UART.
-
-Optional properties:
-- reg-shift : quantity to shift the register offsets by.  If this property is
-  not present then the register offsets are not shifted.
-- reg-io-width : the size (in bytes) of the IO accesses that should be
-  performed on the device.  If this property is not present then single byte
-  accesses are used.
-
-Example:
-
-	uart@80230000 {
-		compatible = "snps,dw-apb-uart";
-		reg = <0x80230000 0x100>;
-		clock-frequency = <3686400>;
-		interrupts = <10>;
-		reg-shift = <2>;
-		reg-io-width = <4>;
-	};
diff --git a/Documentation/devicetree/bindings/tty/serial/st-asc.txt b/Documentation/devicetree/bindings/tty/serial/st-asc.txt
deleted file mode 100644
index 75d877f..0000000
--- a/Documentation/devicetree/bindings/tty/serial/st-asc.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-*st-asc(Serial Port)
-
-Required properties:
-- compatible : Should be "st,asc".
-- reg, reg-names, interrupts, interrupt-names	: Standard way to define device
-			resources with names. look in
-			Documentation/devicetree/bindings/resource-names.txt
-
-Optional properties:
-- st,hw-flow-ctrl	bool flag to enable hardware flow control.
-- st,force-m1		bool flat to force asc to be in Mode-1 recommeded
-			for high bit rates (above 19.2K)
-Example:
-serial@fe440000{
-    compatible    = "st,asc";
-    reg         = <0xfe440000 0x2c>;
-    interrupts     =  <0 209 0>;
-};
diff --git a/Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt b/Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt
deleted file mode 100644
index 5feef1e..0000000
--- a/Documentation/devicetree/bindings/tty/serial/via,vt8500-uart.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-VIA/Wondermedia VT8500 UART Controller
------------------------------------------------------
-
-Required properties:
-- compatible : "via,vt8500-uart"
-- reg : Should contain 1 register ranges(address and length)
-- interrupts : UART interrupt
-- clocks : phandle to the uart source clock (usually a 24Mhz fixed clock)
-
-Example:
-
-	uart@d8210000 {
-		compatible = "via,vt8500-uart";
-		reg = <0xd8210000 0x1040>;
-		interrupts = <47>;
-		clocks = <&ref24>;
-	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


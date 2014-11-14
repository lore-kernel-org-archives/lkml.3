Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162040AbaKNWHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:07:24 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60724 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161814AbaKNWHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:07:20 -0500
Message-ID: <54667D13.2070105@gmail.com>
Date: Fri, 14 Nov 2014 14:07:15 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: [PATCH]  tty: serial: msm_serial: document DT alias
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

Update devicetree binding for msm_serial to reflect msm_serial_probe()
getting line id (port number) from the serialN alias.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt |   15 +++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
===================================================================
--- linux.orig/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
+++ linux/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
@@ -27,27 +27,52 @@ Optional properties:
 - dmas: Should contain dma specifiers for transmit and receive channels
 - dma-names: Should contain "tx" for transmit and "rx" for receive channels
 
+Note: Aliases may be defined to ensure the correct ordering of the UARTs.
+The alias serialN will result in the UART being assigned port N.  If any
+serialN alias exists, then an alias must exist for each enabled UART.  The
+serialN aliases should be in a .dts file instead of in a .dtsi file.
+
 Examples:
 
-A uartdm v1.4 device with dma capabilities.
+- A uartdm v1.4 device with dma capabilities.
+
+	serial@f991e000 {
+		compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+		reg = <0xf991e000 0x1000>;
+		interrupts = <0 108 0x0>;
+		clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
+		clock-names = "core", "iface";
+		dmas = <&dma0 0>, <&dma0 1>;
+		dma-names = "tx", "rx";
+	};
+
+- A uartdm v1.3 device without dma capabilities and part of a GSBI complex.
+
+	serial@19c40000 {
+		compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
+		reg = <0x19c40000 0x1000>,
+	      	<0x19c00000 0x1000>;
+		interrupts = <0 195 0x0>;
+		clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
+		clock-names = "core", "iface";
+	};
+
+- serialN alias.
+
+	aliases {
+		serial0 = &uarta;
+		serial1 = &uartc;
+		serial2 = &uartb;
+	};
+
+	uarta: serial@12490000 {
+		status = "ok";
+	};
+
+	uartb: serial@16340000 {
+		status = "ok";
+	};
 
-serial@f991e000 {
-	compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
-	reg = <0xf991e000 0x1000>;
-	interrupts = <0 108 0x0>;
-	clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
-	clock-names = "core", "iface";
-	dmas = <&dma0 0>, <&dma0 1>;
-	dma-names = "tx", "rx";
-};
-
-A uartdm v1.3 device without dma capabilities and part of a GSBI complex.
-
-serial@19c40000 {
-	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
-	reg = <0x19c40000 0x1000>,
-	      <0x19c00000 0x1000>;
-	interrupts = <0 195 0x0>;
-	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
-	clock-names = "core", "iface";
-};
+	uartc: serial@1a240000 {
+		status = "ok";
+	};

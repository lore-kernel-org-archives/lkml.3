Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaFZLZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:25:13 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57312 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaFZLZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:25:07 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9b-53ac030f1067
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Daniel Drake <drake@endlessm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 1/3] Documentation: devicetree: Update samsung UART bindings
Date: Thu, 26 Jun 2014 13:24:33 +0200
Message-id: <1403781875-5425-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403781875-5425-1-git-send-email-t.figa@samsung.com>
References: <1403781875-5425-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xy7r8zGuCDY5sVLGYf+Qcq8Wj+Y+Z
	LZoXr2ez+Px7F6tF74KrbBabHl9jtbi8aw6bxYzz+5gszizuZbe4fZnXYu2Ru+wWS69fZLJo
	3XuE3WL9jNcsFqt2/WF04PdYM28No0dLcw+bx6LvWR47Z91l99i0qpPNY//cNewem5fUe/Rt
	WcXocWbBEXaPz5vkAriiuGxSUnMyy1KL9O0SuDIm7zvNVHBMomL67KlMDYyrRboYOTkkBEwk
	+hdsYIGwxSQu3FvP1sXIxSEksJRR4s3kv4wQTh+TxOapW5lBqtgE1CQ+NzxiA7FFBFQlPrct
	YAcpYhaYzCKxq/MPO0hCWMBH4uTKBrCxLEBF3/ccAWvgFXCUWL5pG9Q6OYnebW/AhnIKOEms
	PjqLFcQWAqq5seEA0wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQoL6yw7Gxces
	DjEKcDAq8fBKzF0dLMSaWFZcmXuIUYKDWUmEV+Q3UIg3JbGyKrUoP76oNCe1+BAjEwenVAPj
	pIkrPk9uFOu5oSN81yppxiOJdTcZj1/6E7Up8WnP4ao+dzOHVeb8e4R6Dde+nGjAImM0KYjb
	l7Xy9A/ZezvlRfY+SuXQyb/WyyMn4OMhe6fq0U6RVPY/M0579UV3lF9qy/ihfVSYObBk6zLT
	GTsCrPSb3HLV/vWGN35zrys4uPPouzM3v99TYinOSDTUYi4qTgQAdy9nREgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The primary purpose of this patch is to add information about (now
required) aliases of UART ports. However the documentation currently is
heavily outdated and so this patch also takes care of this.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 .../devicetree/bindings/serial/samsung_uart.txt    | 52 +++++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/samsung_uart.txt b/Documentation/devicetree/bindings/serial/samsung_uart.txt
index 2c8a17c..85e8ee2 100644
--- a/Documentation/devicetree/bindings/serial/samsung_uart.txt
+++ b/Documentation/devicetree/bindings/serial/samsung_uart.txt
@@ -1,14 +1,54 @@
 * Samsung's UART Controller
 
-The Samsung's UART controller is used for interfacing SoC with serial communicaion
-devices.
+The Samsung's UART controller is used for interfacing SoC with serial
+communicaion devices.
 
 Required properties:
-- compatible: should be
-  - "samsung,exynos4210-uart", for UART's compatible with Exynos4210 uart ports.
+- compatible: should be one of following:
+  - "samsung,exynos4210-uart" -  Exynos4210 SoC,
+  - "samsung,s3c2410-uart" - compatible with ports present on S3C2410 SoC,
+  - "samsung,s3c2412-uart" - compatible with ports present on S3C2412 SoC,
+  - "samsung,s3c2440-uart" - compatible with ports present on S3C2440 SoC,
+  - "samsung,s3c6400-uart" - compatible with ports present on S3C6400 SoC,
+  - "samsung,s5pv210-uart" - compatible with ports present on S5PV210 SoC.
 
 - reg: base physical address of the controller and length of memory mapped
   region.
 
-- interrupts: interrupt number to the cpu. The interrupt specifier format depends
-  on the interrupt controller parent.
+- interrupts: a single interrupt signal to SoC interrupt controller,
+  according to interrupt bindings documentation [1].
+
+- clock-names: input names of clocks used by the controller:
+  - "uart" - controller bus clock,
+  - "clk_uart_baudN" - Nth baud base clock input (N = 0, 1, ...),
+    according to SoC User's Manual (only N = 0 is allowedfor SoCs without
+    internal baud clock mux).
+- clocks: phandles and specifiers for all clocks specified in "clock-names"
+  property, in the same order, according to clock bindings documentation [2].
+
+[1] Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
+[2] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Note: Each Samsung UART should have an alias correctly numbered in the
+"aliases" node, according to serialN format, where N is the port number
+(non-negative decimal integer) as specified by User's Manual of respective
+SoC.
+
+Example:
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+	};
+
+Example:
+	uart1: serial@7f005400 {
+		compatible = "samsung,s3c6400-uart";
+		reg = <0x7f005400 0x100>;
+		interrupt-parent = <&vic1>;
+		interrupts = <6>;
+		clock-names = "uart", "clk_uart_baud2",
+				"clk_uart_baud3";
+		clocks = <&clocks PCLK_UART1>, <&clocks PCLK_UART1>,
+				<&clocks SCLK_UART>;
+	};
-- 
1.9.3


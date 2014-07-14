Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaGNMQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:16:49 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52101 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaGNMQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:16:39 -0400
From: Harini Katakam <harinik@xilinx.com>
To: wim@iguana.be, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net
Cc: michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v3 2/2] devicetree: Add Cadence WDT devicetree bindings documentation
Date: Mon, 14 Jul 2014 17:46:09 +0530
Message-Id: <1405340169-2820-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
References: <1405340169-2820-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cadence-wdt bindings documentation.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v3 changes:
- Change reset property type and improve description.
- Improve description of clocks and interrupts.
- Use watchdog@ in the example.
- Use only cdns compatible string for now.

v2:
No changes

---
 .../devicetree/bindings/watchdog/cadence-wdt.txt   |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
new file mode 100644
index 0000000..ab23e38
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
@@ -0,0 +1,27 @@
+Zynq Watchdog Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- compatible		: Should be "cdns,wdt-r1p2".
+- clocks		: Input clock specifier. This should be the ref clk.
+- reg			: Physical base address and size of WDT registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number. This interrupt is used for indication
+			  when the watchdog times out.
+- interrupt-parent	: Must be core interrupt controller.
+
+Optional properties
+- reset			: If this property exists, then a reset is done
+			  when watchdog times out.
+- timeout-sec		: Watchdog timeout value (in seconds).
+
+Example:
+	watchdog@f8005000 {
+		compatible = "xlnx,zynq-wdt-r1p2";
+		clocks = <&clkc 45>;
+		interrupt-parent = <&intc>;
+		interrupts = <0 9 1>;
+		reg = <0xf8005000 0x1000>;
+		reset;
+		timeout-sec = <10>;
+	};
-- 
1.7.9.5


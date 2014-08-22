Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaHVJ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:28:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33422 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaHVJ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:28:33 -0400
From: Harini Katakam <harinik@xilinx.com>
To: wim@iguana.be, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net
Cc: michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, harinikatakamlinux@gmail.com,
        linux@roeck-us.net, svemula@xilinx.com, anirudh@xilinx.com,
        Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v5 2/2] devicetree: Add Cadence WDT devicetree bindings documentation
Date: Fri, 22 Aug 2014 14:58:02 +0530
Message-Id: <1408699682-21845-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408699682-21845-1-git-send-email-harinik@xilinx.com>
References: <1408699682-21845-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cadence-wdt bindings documentation.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---

v5 changes:
No changes

v4 changes:
- Change name of property "reset" to "reset-on-timeout".
- Use cdns compatible string in example.
- Improve description of clocks and interrupts.

v3 changes:
- Change reset property type and improve description.
- Improve description of clocks and interrupts.
- Use watchdog@ in the example.
- Use only cdns compatible string for now.

v2:
No changes

---
 .../devicetree/bindings/watchdog/cadence-wdt.txt   |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
new file mode 100644
index 0000000..c3a36ee
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
@@ -0,0 +1,24 @@
+Zynq Watchdog Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- compatible		: Should be "cdns,wdt-r1p2".
+- clocks		: This is pclk (APB clock).
+- interrupts		: This is wd_irq - watchdog timeout interrupt.
+- interrupt-parent	: Must be core interrupt controller.
+
+Optional properties
+- reset-on-timeout	: If this property exists, then a reset is done
+			  when watchdog times out.
+- timeout-sec		: Watchdog timeout value (in seconds).
+
+Example:
+	watchdog@f8005000 {
+		compatible = "cdns,wdt-r1p2";
+		clocks = <&clkc 45>;
+		interrupt-parent = <&intc>;
+		interrupts = <0 9 1>;
+		reg = <0xf8005000 0x1000>;
+		reset-on-timeout;
+		timeout-sec = <10>;
+	};
-- 
1.7.9.5


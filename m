Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaC1Kc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:32:26 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33233 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaC1KcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:32:13 -0400
From: Harini Katakam <harinik@xilinx.com>
To: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net
Cc: michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Harini Katakam <harinik@xilinx.com>
Subject: [PATCH 2/2] devicetree: Add Cadence WDT devicetree bindings documentation
Date: Fri, 28 Mar 2014 16:02:00 +0530
Message-Id: <1396002720-7105-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396002720-7105-1-git-send-email-harinik@xilinx.com>
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cadence-wdt bindings documentation.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
---
 .../devicetree/bindings/watchdog/cadence-wdt.txt   |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/cadence-wdt.txt

diff --git a/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
new file mode 100644
index 0000000..1f7a732
--- /dev/null
+++ b/Documentation/devicetree/bindings/watchdog/cadence-wdt.txt
@@ -0,0 +1,26 @@
+Zynq Watchdog Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- compatible		: Should be "xlnx,zynq-wdt-r1p2" or "cdns,wdt-r1p2".
+- clocks		: Clock phandles (see clock bindings for details).
+- reg			: Physical base address and size of WDT registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller.
+
+Optional properties
+- reset			: Reset interrupt.
+- timeout-sec		: Watchdog timeout value (in seconds).
+
+Example:
+
+		wdt@f8005000 {
+			compatible = "xlnx,zynq-wdt-r1p2";
+			clocks = <&clkc 45>;
+			interrupt-parent = <&intc>;
+			interrupts = <0 9 1>;
+			reg = <0xf8005000 0x1000>;
+			reset = <0>;
+			timeout-sec = <10>;
+		} ;
-- 
1.7.9.5


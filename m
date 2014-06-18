Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966320AbaFRLkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:40:20 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46571 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965934AbaFRLkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:40:15 -0400
From: Harini Katakam <harinik@xilinx.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net
Cc: michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, harinikatakamlinux@gmail.com,
        Harini Katakam <harini.katakam@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: [PATCH v2 2/2] devicetree: Add Zynq GPIO devicetree bindings documentation
Date: Wed, 18 Jun 2014 17:09:37 +0530
Message-Id: <1403091577-10232-2-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Add gpio-zynq bindings documentation.

Signed-off-by: Harini Katakam <harinik@xilinx.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---

v2 changes:
Improve description.

---
 .../devicetree/bindings/gpio/gpio-zynq.txt         |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zynq.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-zynq.txt b/Documentation/devicetree/bindings/gpio/gpio-zynq.txt
new file mode 100644
index 0000000..b2c023a
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-zynq.txt
@@ -0,0 +1,24 @@
+Xilinx Zynq GPIO controller Device Tree Bindings
+-------------------------------------------
+
+Required properties:
+- #gpio-cells 		: Should be two. First cell is used to mention
+			  pin number.
+- compatible		: Should be "xlnx,zynq-gpio-1.0"
+- clocks		: Clock specifier (see clock bindings for details)
+- gpio-controller	: Marks the device node as a GPIO controller.
+- interrupts		: Interrupt specifier (see interrupt bindings for
+			  details)
+- interrupt-parent	: Must be core interrupt controller
+- reg			: Address and length of the register set for the device
+
+Example:
+	gpio@e000a000 {
+		#gpio-cells = <2>;
+		compatible = "xlnx,zynq-gpio-1.0";
+		clocks = <&clkc 42>;
+		gpio-controller;
+		interrupt-parent = <&intc>;
+		interrupts = <0 20 4>;
+		reg = <0xe000a000 0x1000>;
+	};
-- 
1.7.9.5


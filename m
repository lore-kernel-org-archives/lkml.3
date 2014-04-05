Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaDEA3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:29:48 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53830 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaDEA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:29:45 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Grant Likely <grant.likely@linaro.org>
Cc: Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: [RESEND PATCH v3 8/9] tty: cadence: Document DT binding
Date: Fri,  4 Apr 2014 17:23:44 -0700
Message-Id: <1396657425-31029-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396657425-31029-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for the Cadence UART.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Acked-by: Rob Herring <robh@kernel.org>
Tested-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/serial/cdns,uart.txt         | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/cdns,uart.txt

diff --git a/Documentation/devicetree/bindings/serial/cdns,uart.txt b/Documentation/devicetree/bindings/serial/cdns,uart.txt
new file mode 100644
index 000000000000..a3eb154c32ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/cdns,uart.txt
@@ -0,0 +1,20 @@
+Binding for Cadence UART Controller
+
+Required properties:
+- compatible : should be "cdns,uart-r1p8", or "xlnx,xuartps"
+- reg: Should contain UART controller registers location and length.
+- interrupts: Should contain UART controller interrupts.
+- clocks: Must contain phandles to the UART clocks
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Tuple to identify input clocks, must contain "uart_clk" and "pclk"
+  See ../clocks/clock-bindings.txt for details.
+
+
+Example:
+	uart@e0000000 {
+		compatible = "cdns,uart-r1p8";
+		clocks = <&clkc 23>, <&clkc 40>;
+		clock-names = "uart_clk", "pclk";
+		reg = <0xE0000000 0x1000>;
+		interrupts = <0 27 4>;
+	};
-- 
1.9.1.1.gbb9f595


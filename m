Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaIIJ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:58:00 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33679 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaIIJ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:57 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH 4/5] dt-bindings: Add binding info for Xgene QMTM UIO driver
Date: Tue,  9 Sep 2014 15:26:58 +0530
Message-Id: <1410256619-3213-5-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
References: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
Xgene QMTM UIO driver.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt

diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
new file mode 100644
index 0000000..b71831b
--- /dev/null
+++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
@@ -0,0 +1,45 @@
+APM X-Gene QMTM UIO nodes
+
+QMTM UIO nodes are defined for user space access to on-chip QMTM device
+on APM X-Gene SOC using UIO framework.
+
+Required properties:
+- compatible: Should be "apm,xgene-qmtm-uio"
+- reg: Address and length of the register set for the device. It contains the
+  information of registers in the same order as described by reg-names.
+- reg-names: Should contain the register set names
+  - "csr": QMTM control and status register address space.
+  - "fabric": QMTM memory mapped access to queue states.
+  - "qpool": Memory location for creating QMTM queues. This could be some
+    SRAM or reserved portion of RAM. It is expected that size and location
+    of qpool memory will be configurable via bootloader.
+- clocks: Reference to the clock entry.
+- num_queues: Number of queues under this QMTM device.
+- devid: QMTM identification number for the system having multiple QMTM devices
+
+Optional properties:
+- status: Should be "ok" or "disabled" for enabled/disabled. Default is "ok".
+
+Example:
+	qmtm1clk: qmtmclk@1f20c000 {
+		compatible = "apm,xgene-device-clock";
+		clock-output-names = "qmtm1clk";
+		status = "ok";
+	};
+
+	qmtm1_uio: qmtm_uio@1f200000 {
+		compatible = "apm,xgene-qmtm-uio";
+		status = "disabled";
+		reg =  <0x0 0x1f200000 0x0 0x10000
+			0x0 0x1b000000 0x0 0x400000
+			0x0 0x00000000 0x0 0x0>;/* filled by bootloader */
+		reg-names = "csr", "fabric", "qpool";
+		clocks = <&qmtm1clk 0>;
+		num_queues = <0x400>;
+		devid = <1>;
+	};
+
+	/* Board-specific peripheral configurations */
+	&qmtm1_uio {
+		status = "ok";
+	};
-- 
1.7.9.5


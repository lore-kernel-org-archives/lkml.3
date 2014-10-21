Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaJUF6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:58:42 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57659 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaJUF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:58:39 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v3 5/6] Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO driver
Date: Tue, 21 Oct 2014 11:26:49 +0530
Message-Id: <1413871011-4101-6-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
X-Gene QMTM UIO driver.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   53 ++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt

diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
new file mode 100644
index 0000000..288ed92
--- /dev/null
+++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
@@ -0,0 +1,53 @@
+APM X-Gene QMTM UIO nodes
+
+The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
+and Traffic manager). It is a device for managing hardware queues.
+It also implements QoS among hardware queues hence term "traffic"
+manager is present in its name. QMTM UIO nodes are defined for user
+space access to this device using UIO framework.
+
+Required properties:
+- compatible: Should be "apm,xgene-qmtm"
+- reg: Address and length of the register set for the device. It contains the
+  information of registers in the same order as described by reg-names.
+- reg-names: Should contain the register set names
+  - "csr": QMTM control and status register address space.
+  - "fabric": QMTM memory mapped access to queue states.
+- qpool: Points to the phandle of the node defining memory location for
+	 creating QMTM queues. This could point either to the reserved-memory
+	 node (as-per reserved memory bindings) or to the node of on-chip
+	 SRAM etc. It is expected that size and location of qpool memory will
+	 be configurable via bootloader.
+- clocks: Reference to the clock entry.
+- num-queues: Number of queues under this QMTM device.
+- devid: QMTM identification number for the system having multiple QMTM devices.
+	 This is used to form a unique id (a tuple of queue number and
+	 device id) for the queues belonging to this device.
+
+Example:
+	qmtm1_uio_qpool: qmtm1_uio_qpool {
+		reg = <0x0 0x0 0x0 0x0>
+	};
+
+	qmtm1clk: qmtmclk@1f20c000 {
+		compatible = "apm,xgene-device-clock";
+		clock-output-names = "qmtm1clk";
+		status = "ok";
+	};
+
+	qmtm1_uio: qmtm_uio@1f200000 {
+		compatible = "apm,xgene-qmtm";
+		status = "disabled";
+		reg = <0x0 0x1f200000 0x0 0x10000>,
+		      <0x0 0x1b000000 0x0 0x400000>;
+		reg-names = "csr", "fabric";
+		qpool = <&qmtm1_uio_qpool>;
+		clocks = <&qmtm1clk 0>;
+		num-queues = <0x400>;
+		devid = <1>;
+	};
+
+	/* Board-specific peripheral configurations */
+	&qmtm1_uio {
+		status = "ok";
+	};
-- 
1.7.9.5


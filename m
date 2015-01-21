Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbbAULCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:02:40 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:52266 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639AbbAULCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:02:31 -0500
From: Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ddutile@redhat.com, jcm@redhat.com, patches@apm.com,
        Rameshwar Prasad Sahu <rsahu@apm.com>, Loc Ho <lho@apm.com>
Subject: [PATCH v4 3/3] Documentation: dma: Add APM X-Gene SoC DMA engine driver documentation
Date: Wed, 21 Jan 2015 16:31:11 +0530
Message-Id: <1421838071-7347-4-git-send-email-rsahu@apm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421838071-7347-1-git-send-email-rsahu@apm.com>
References: <1421838071-7347-1-git-send-email-rsahu@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding for APM X-Gene SoC DMA engine driver.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
---
 .../devicetree/bindings/dma/apm-xgene-dma.txt      | 49 ++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/apm-xgene-dma.txt

diff --git a/Documentation/devicetree/bindings/dma/apm-xgene-dma.txt b/Documentation/devicetree/bindings/dma/apm-xgene-dma.txt
new file mode 100644
index 0000000..c661cc6
--- /dev/null
+++ b/Documentation/devicetree/bindings/dma/apm-xgene-dma.txt
@@ -0,0 +1,49 @@
+Applied Micro X-Gene SoC DMA nodes
+
+DMA nodes are defined to describe on-chip DMA interfaces in
+APM X-Gene SoC.
+
+Required properties for DMA interfaces:
+- compatible: Should be "apm,xgene-dma".
+- device_type: set to "dma".
+- reg: Address and length of the register set for the device.
+  It contains the information of registers in the same order
+  as described by reg-names.
+- reg-names: Should contain the register set names.
+  - "dma_csr": DMA control and status register address space.
+  - "ring_csr": Descriptor ring control and status register
+                address space.
+  - "ring_cmd": Descriptor ring command register address space.
+- interrupts: DMA has 5 interrupts sources. 1st interrupt is
+  DMA error reporting interrupt. 2nd, 3rd, 4th and 5th interrupts
+  are completion interrupts for each DMA channels.
+- clocks: Reference to the clock entry.
+
+Optional properties:
+- dma-coherent : Present if dma operations are coherent
+
+Example:
+	dmaclk: dmaclk@1f27c000 {
+		compatible = "apm,xgene-device-clock";
+		#clock-cells = <1>;
+		clocks = <&socplldiv2 0>;
+		reg = <0x0 0x1f27c000 0x0 0x1000>;
+		reg-names = "csr-reg";
+		clock-output-names = "dmaclk";
+	};
+
+	dma: dma@1f270000 {
+		compatible = "apm,xgene-dma";
+		device_type = "dma";
+		reg = <0x0 0x1f270000 0x0 0x10000>,
+		      <0x0 0x1f200000 0x0 0x10000>,
+		      <0x0 0x1b008000 0x0 0x2000>;
+		reg-names = "dma_csr", "ring_csr", "ring_cmd";
+		interrupts = <0x0 0xb8 0x4>,
+			     <0x0 0xb9 0x4>,
+			     <0x0 0xba 0x4>,
+			     <0x0 0xbb 0x4>,
+			     <0x0 0x82 0x4>;
+		dma-coherent;
+		clocks = <&dmaclk 0>;
+	};
--
1.8.2.1


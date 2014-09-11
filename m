Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaIKW4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:56:40 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:45422 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753628AbaIKW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:56:36 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH v8 3/4] dt-bindings: pci: xgene pcie device tree bindings
Date: Thu, 11 Sep 2014 15:57:45 -0700
Message-Id: <1410476266-29426-4-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410476266-29426-1-git-send-email-tinamdar@apm.com>
References: <1410476266-29426-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the bindings for X-Gene PCIe driver. The driver resides
under 'drivers/pci/host/pci-xgene.c' file.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 .../devicetree/bindings/pci/xgene-pci.txt          | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt

diff --git a/Documentation/devicetree/bindings/pci/xgene-pci.txt b/Documentation/devicetree/bindings/pci/xgene-pci.txt
new file mode 100644
index 0000000..683a253
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/xgene-pci.txt
@@ -0,0 +1,55 @@
+* AppliedMicro X-Gene PCIe interface
+
+Required properties:
+- device_type: set to "pci"
+- compatible: should contain "apm,xgene-pcie" to identify the core.
+- reg: A list of physical base address and length for each set of controller
+       registers. Must contain an entry for each entry in the reg-names
+       property.
+- reg-names: Must include the following entries:
+  "csr": controller configuration registers.
+  "cfg": pcie configuration space registers.
+- #address-cells: set to <3>
+- #size-cells: set to <2>
+- ranges: ranges for the outbound memory, I/O regions.
+- dma-ranges: ranges for the inbound memory regions.
+- #interrupt-cells: set to <1>
+- interrupt-map-mask and interrupt-map: standard PCI properties
+	to define the mapping of the PCIe interface to interrupt
+	numbers.
+- clocks: from common clock binding: handle to pci clock.
+
+Optional properties:
+- status: Either "ok" or "disabled".
+
+Example:
+
+SoC specific DT Entry:
+
+	pcie0: pcie@1f2b0000 {
+		status = "disabled";
+		device_type = "pci";
+		compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
+			0xe0 0xd0000000 0x0 0x00040000>; /* PCI config space */
+		reg-names = "csr", "cfg";
+		ranges = <0x01000000 0x00 0x00000000 0xe0 0x10000000 0x00 0x00010000   /* io */
+			  0x02000000 0x00 0x80000000 0xe1 0x80000000 0x00 0x80000000>; /* mem */
+		dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+			      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
+		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+		interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
+				 0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
+				 0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
+				 0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
+		clocks = <&pcie0clk 0>;
+	};
+
+
+Board specific DT Entry:
+	&pcie0 {
+		status = "ok";
+	};
-- 
1.9.1


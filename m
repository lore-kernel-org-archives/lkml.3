Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaANXfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:35:21 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:35861 "HELO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178AbaANXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:34:48 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [RFC PATCH V2 3/4] dt-bindings: pci: xgene pcie device tree bindings
Date: Tue, 14 Jan 2014 15:34:17 -0800
Message-Id: <1389742458-7693-4-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the bindings for X-Gene PCIe driver. The driver resides
under 'drivers/pci/host/pci-xgene.c' file.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 .../devicetree/bindings/pci/xgene-pcie.txt         |   45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt

diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
new file mode 100644
index 0000000..19b9c28
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
@@ -0,0 +1,45 @@
+* AppliedMicro X-Gene PCIe interface
+
+Required properties:
+- status: Either "ok" or "disabled".
+- device_type: set to "pci"
+- compatible: should contain "xgene,pcie" to identify the core.
+- reg: base addresses and lengths of the pcie controller configuration
+	space register.
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
+Example:
+
+SoC specific DT Entry:
+	pcie0: pcie@1f2b0000 {
+		status = "disabled";
+		device_type = "pci";
+		compatible = "apm,xgene-pcie";
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = < 0x00 0x1f2b0000 0x0 0x00010000
+			0xe0 0xd0000000 0x0 0x00200000>;
+		ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
+			  0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
+		dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+		interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
+				 0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
+				 0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
+				 0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
+		clocks = <&pcie0clk 0>;
+	};
+
+Board specific DT Entry:
+	&pcie0 {
+		status = "ok";
+	};
-- 
1.7.9.5


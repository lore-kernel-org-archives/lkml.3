Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaIXPi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:38:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35134 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaIXPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:08 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 4/6] pci, thunder: Document PCIe host controller devicetree bindings
Date: Wed, 24 Sep 2014 17:37:46 +0200
Message-Id: <1411573068-12952-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Goutham <sgoutham@cavium.com>

This patch adds documentation for the devicetree bindings used by the
Thunder PCI host controller.

Signed-off-by: Sunil Goutham <sgoutham@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 .../devicetree/bindings/pci/cavium,thunder-pci.txt | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/cavium,thunder-pci.txt

diff --git a/Documentation/devicetree/bindings/pci/cavium,thunder-pci.txt b/Documentation/devicetree/bindings/pci/cavium,thunder-pci.txt
new file mode 100644
index 000000000000..c8ff3d2e8630
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/cavium,thunder-pci.txt
@@ -0,0 +1,32 @@
+* Cavium Thunder PCIe interface
+
+Required properties:
+- compatible: should contain "cavium,thunder-pcie" to identify the core.
+- device_type: set to "pci"
+- #address-cells: set to <3>
+- #size-cells: set to <2>
+- #stream-id-cells: set to <1>
+- bus-range: PCI bus numbers covered
+- reg: base address and length of the pcie configuration space.
+- ranges: ranges for the PCI memory regions.
+- msi-parent: Link to the hardware entity that serves as the Message
+  Signaled Interrupt controller for this PCI controller.
+
+Example:
+
+SoC specific DT Entry:
+
+	pcie0: pcie0@0x848000000000 {
+		compatible = "cavium,thunder-pcie";
+		device_type = "pci";
+		msi-parent = <&its>;
+		bus-range = <0 255>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		#stream-id-cells = <1>;
+		reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
+		ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem */
+			<0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
+			<0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
+	};
+
-- 
2.1.0


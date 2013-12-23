Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3LWICr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:02:47 -0500
Received: from exprod5og119.obsmtp.com ([64.18.0.189]:49767 "HELO
	exprod5og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932164Ab3LWICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:02:44 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>
Cc: linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@apm.com, jcm@redhat.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [RFC PATCH 3/3] dt-bindings: pci: xgene pcie device tree bindings
Date: Mon, 23 Dec 2013 13:32:04 +0530
Message-Id: <1387785725-24262-4-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the bindings for X-Gene PCIe driver. The driver resides
under 'drivers/pci/host/pcie-xgene.c' file.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 .../devicetree/bindings/pci/xgene-pcie.txt         |   43 ++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt

diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
new file mode 100644
index 0000000..d92da4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
@@ -0,0 +1,43 @@
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
+- ranges: ranges for the PCI memory, I/O regions, config and MSI regions
+- #interrupt-cells: set to <1>
+- interrupt-map-mask and interrupt-map: standard PCI properties
+	to define the mapping of the PCIe interface to interrupt
+	numbers.
+- clocks: from common clock binding: handle to pci clock.
+- clock-names: from common clock binding. Should be "pcieclk".
+
+Example:
+
+SoC specific DT Entry:
+	pcie0: pcie@1f2b0000 {
+		status = "disabled";
+		device_type = "pci";
+		compatible = "xgene,pcie";
+		#interrupt-cells = <1>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = < 0x00 0x1f2b0000 0x0 0x00010000>;
+		ranges = <0x02000000 0x0 0x00000000 0xe0 0x00000000 0x0 0x10000000 /* mem*/
+			  0x01000000 0x0 0x80000000 0xe0 0x80000000 0x0 0x00010000 /* io */
+			  0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */
+			  0x00000000 0x0 0x79000000 0x00 0x79000000 0x0 0x00800000>; /* msi */
+		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+		interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;
+		clocks = <&pcie0clk 0>;
+		clock-names = "pcieclk"
+	};
+
+Board specific DT Entry:
+	&pcie0 {
+		status = "ok";
+	};
-- 
1.7.9.5


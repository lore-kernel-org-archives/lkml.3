Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaIXPiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:38:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33536 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaIXPiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:38:06 -0400
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Sunil Goutham <sgoutham@cavium.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
Date: Wed, 24 Sep 2014 17:37:45 +0200
Message-Id: <1411573068-12952-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411573068-12952-1-git-send-email-rric@kernel.org>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Goutham <sgoutham@cavium.com>

This patch adds the PCIe host controller entry for Cavium Thunder SoCs
to the devicetree. There are 4 internal PCI controllers available.

Signed-off-by: Sunil Goutham <sgoutham@cavium.com>
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/boot/dts/thunder-88xx.dtsi | 49 +++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/arm64/boot/dts/thunder-88xx.dtsi b/arch/arm64/boot/dts/thunder-88xx.dtsi
index 9cb7cf94284a..0b433b0e7af4 100644
--- a/arch/arm64/boot/dts/thunder-88xx.dtsi
+++ b/arch/arm64/boot/dts/thunder-88xx.dtsi
@@ -407,4 +407,53 @@
 			clock-names = "apb_pclk";
 		};
 	};
+
+	pcie0@0x8480,00000000 {
+	        compatible = "cavium,thunder-pcie";
+		device_type = "pci";
+		msi-parent = <&its>;
+		bus-range = <0 255>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0x8480 0x00000000 0 0x10000000>;  /* Configuration space */
+		ranges = <0x03000000 0x8010 0x00000000 0x8010 0x00000000 0x70 0x00000000>, /* mem ranges */
+			<0x03000000 0x8300 0x00000000 0x8300 0x00000000 0x80 0x00000000>,
+			<0x03000000 0x87e0 0x00000000 0x87e0 0x00000000 0x01 0x00000000>;
+        };
+
+	pcie1@0x8490,00000000 {
+	        compatible = "cavium,thunder-pcie";
+		device_type = "pci";
+		msi-parent = <&its>;
+		bus-range = <0 255>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0x8490 0x00000000 0 0x10000000>;  /* Configuration space */
+		ranges = <0x03000000 0x8310 0x00000000 0x8310 0x00000000 0x00 0x10000000>, /* mem ranges */
+			<0x03000000 0x8100 0x00000000 0x8100 0x00000000 0x80 0x00000000>;
+        };
+
+	pcie2@0x84a0,00000000 {
+	        compatible = "cavium,thunder-pcie";
+		device_type = "pci";
+		msi-parent = <&its>;
+		bus-range = <0 255>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0x84a0 0x00000000 0 0x10000000>;  /* Configuration space */
+		ranges = <0x03000000 0x8320 0x00000000 0x8320 0x00000000 0x00 0x10000000>, /* mem ranges */
+			<0x03000000 0x8430 0x00000000 0x8430 0x00000000 0x01 0x00000000>;
+        };
+
+	pcie3@0x84b0,00000000 {
+	        compatible = "cavium,thunder-pcie";
+		device_type = "pci";
+		msi-parent = <&its>;
+		bus-range = <0 255>;
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0x84b0 0x00000000 0 0x10000000>;  /* Configuration space */
+		ranges = <0x03000000 0x8330 0x00000000 0x8330 0x00000000 0x00 0x10000000>, /* mem ranges */
+			<0x03000000 0x8180 0x00000000 0x8180 0x00000000 0x80 0x00000000>;
+        };
 };
-- 
2.1.0


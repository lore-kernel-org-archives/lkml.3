Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaANXf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:35:28 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:47456 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752173AbaANXeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:34:46 -0500
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
Subject: [RFC PATCH V2 2/4] arm64:dts: APM X-Gene PCIe device tree nodes
Date: Tue, 14 Jan 2014 15:34:16 -0800
Message-Id: <1389742458-7693-3-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
References: <1389742458-7693-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree nodes for APM X-Gene PCIe controller and
PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
nodes are added.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/arm64/boot/dts/apm-mustang.dts |    4 +
 arch/arm64/boot/dts/apm-storm.dtsi  |  144 +++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-mustang.dts b/arch/arm64/boot/dts/apm-mustang.dts
index 1247ca1..ab2b95f 100644
--- a/arch/arm64/boot/dts/apm-mustang.dts
+++ b/arch/arm64/boot/dts/apm-mustang.dts
@@ -24,3 +24,7 @@
 		reg = < 0x1 0x00000000 0x0 0x80000000 >; /* Updated by bootloader */
 	};
 };
+
+&pcie0 {
+	status = "ok";
+};
diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index d37d736..6b8b995 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -176,6 +176,150 @@
 				reg-names = "csr-reg";
 				clock-output-names = "eth8clk";
 			};
+
+			pcie0clk: pcie0clk@1f2bc000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2bc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie0clk";
+			};
+
+			pcie1clk: pcie1clk@1f2cc000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2cc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie1clk";
+			};
+
+			pcie2clk: pcie2clk@1f2dc000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2dc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie2clk";
+			};
+
+			pcie3clk: pcie3clk@1f50c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f50c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie3clk";
+			};
+
+			pcie4clk: pcie4clk@1f51c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f51c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie4clk";
+			};
+		};
+
+		pcie0: pcie@1f2b0000 {
+			status = "disabled";
+			device_type = "pci";
+			compatible = "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f2b0000 0x0 0x00010000
+				0xe0 0xd0000000 0x0 0x00200000>;
+			ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
+				  0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
+			clocks = <&pcie0clk 0>;
+		};
+
+		pcie1: pcie@1f2c0000 {
+			status = "disabled";
+			device_type = "pci";
+			compatible = "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f2c0000 0x0 0x00010000
+				0xd0 0xd0000000 0x0 0x00200000>;
+			ranges = <0x01000000 0x0 0x00000000 0xd0 0x00000000 0x00 0x00010000   /* io  */
+				  0x02000000 0x0 0x10000000 0xd0 0x10000000 0x00 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc8 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xc9 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xca 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xcb 0x1>;
+			clocks = <&pcie1clk 0>;
+		};
+
+		pcie2: pcie@1f2d0000 {
+			status = "disabled";
+			device_type = "pci";
+			compatible = "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg =  < 0x00 0x1f2d0000 0x0 0x00010000
+				 0x90 0xd0000000 0x0 0x00200000>;
+			ranges = <0x01000000 0x0 0x00000000 0x90 0x00000000 0x0 0x00010000   /* io  */
+				  0x02000000 0x0 0x10000000 0x90 0x10000000 0x0 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xce 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xcf 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xd0 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xd1 0x1>;
+			clocks = <&pcie2clk 0>;
+		};
+
+		pcie3: pcie@1f500000 {
+			status = "disabled";
+			device_type = "pci";
+			compatible = "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f500000 0x0 0x00010000
+				0xa0 0xd0000000 0x0 0x00200000>;
+			ranges = <0x01000000 0x0 0x00000000 0xa0 0x00000000 0x0 0x00010000  /* mem */
+				  0x02000000 0x0 0x10000000 0xa0 0x10000000 0x0 0x80000000>; /* io  */
+			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xd4 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xd5 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xd6 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xd7 0x1>;
+			clocks = <&pcie3clk 0>;
+		};
+
+		pcie4: pcie@1f510000 {
+			status = "disabled";
+			device_type = "pci";
+			compatible = "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = <0x00 0x1f510000 0x0 0x00010000>;
+			ranges = <0x01000000 0x0 0x00000000 0xc0 0x00000000 0x0 0x00010000   /* io  */
+				  0x02000000 0x0 0x10000000 0xc0 0x10000000 0x0 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xda 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xdb 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xdc 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xdd 0x1>;
+			clocks = <&pcie4clk 0>;
 		};
 
 		serial0: serial@1c020000 {
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaIKW5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:57:37 -0400
Received: from exprod5og121.obsmtp.com ([64.18.0.139]:46086 "HELO
	exprod5og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752504AbaIKW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:56:34 -0400
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
Subject: [PATCH v8 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Date: Thu, 11 Sep 2014 15:57:44 -0700
Message-Id: <1410476266-29426-3-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410476266-29426-1-git-send-email-tinamdar@apm.com>
References: <1410476266-29426-1-git-send-email-tinamdar@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree nodes for APM X-Gene PCIe host controller and
PCIe clock interface. Since X-Gene SOC supports maximum 5 ports, 5 dts
nodes are added.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/arm64/boot/dts/apm-mustang.dts |   8 ++
 arch/arm64/boot/dts/apm-storm.dtsi  | 160 ++++++++++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-mustang.dts b/arch/arm64/boot/dts/apm-mustang.dts
index b2f5622..f649000 100644
--- a/arch/arm64/boot/dts/apm-mustang.dts
+++ b/arch/arm64/boot/dts/apm-mustang.dts
@@ -25,6 +25,14 @@
 	};
 };
 
+&pcie0clk {
+	status = "ok";
+};
+
+&pcie0 {
+	status = "ok";
+};
+
 &serial0 {
 	status = "ok";
 };
diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index c0aceef..e8a32a2 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -269,6 +269,166 @@
 				enable-mask = <0x2>;
 				clock-output-names = "rtcclk";
 			};
+
+			pcie0clk: pcie0clk@1f2bc000 {
+				status = "disabled";
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2bc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie0clk";
+			};
+
+			pcie1clk: pcie1clk@1f2cc000 {
+				status = "disabled";
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2cc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie1clk";
+			};
+
+			pcie2clk: pcie2clk@1f2dc000 {
+				status = "disabled";
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f2dc000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie2clk";
+			};
+
+			pcie3clk: pcie3clk@1f50c000 {
+				status = "disabled";
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f50c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "pcie3clk";
+			};
+
+			pcie4clk: pcie4clk@1f51c000 {
+				status = "disabled";
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
+			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
+				0xe0 0xd0000000 0x0 0x00040000>; /* PCI config space */
+			reg-names = "csr", "cfg";
+			ranges = <0x01000000 0x00 0x00000000 0xe0 0x10000000 0x00 0x00010000   /* io */
+				  0x02000000 0x00 0x80000000 0xe1 0x80000000 0x00 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
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
+			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f2c0000 0x0 0x00010000   /* Controller registers */
+				0xd0 0xd0000000 0x0 0x00040000>; /* PCI config space */
+			reg-names = "csr", "cfg";
+			ranges = <0x01000000 0x0 0x00000000 0xd0 0x10000000 0x00 0x00010000   /* io  */
+				  0x02000000 0x0 0x80000000 0xd1 0x80000000 0x00 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
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
+			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg =  < 0x00 0x1f2d0000 0x0 0x00010000   /* Controller registers */
+				 0x90 0xd0000000 0x0 0x00040000>; /* PCI config space */
+			reg-names = "csr", "cfg";
+			ranges = <0x01000000 0x0 0x00000000 0x90 0x10000000 0x0 0x00010000   /* io  */
+				  0x02000000 0x0 0x80000000 0x91 0x80000000 0x0 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
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
+			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f500000 0x0 0x00010000   /* Controller registers */
+				0xa0 0xd0000000 0x0 0x00040000>; /* PCI config space */
+			reg-names = "csr", "cfg";
+			ranges = <0x01000000 0x0 0x00000000 0xa0 0x10000000 0x0 0x00010000   /* io   */
+				  0x02000000 0x0 0x80000000 0xa1 0x80000000 0x0 0x80000000>; /* mem  */
+			dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
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
+			compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			reg = < 0x00 0x1f510000 0x0 0x00010000   /* Controller registers */
+				0xc0 0xd0000000 0x0 0x00200000>; /* PCI config space */
+			reg-names = "csr", "cfg";
+			ranges = <0x01000000 0x0 0x00000000 0xc0 0x10000000 0x0 0x00010000   /* io  */
+				  0x02000000 0x0 0x80000000 0xc1 0x80000000 0x0 0x80000000>; /* mem */
+			dma-ranges = <0x42000000 0x80 0x00000000 0x80 0x00000000 0x00 0x80000000
+				      0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>;
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xda 0x1
+					 0x0 0x0 0x0 0x2 &gic 0x0 0xdb 0x1
+					 0x0 0x0 0x0 0x3 &gic 0x0 0xdc 0x1
+					 0x0 0x0 0x0 0x4 &gic 0x0 0xdd 0x1>;
+			clocks = <&pcie4clk 0>;
 		};
 
 		serial0: serial@1c020000 {
-- 
1.9.1


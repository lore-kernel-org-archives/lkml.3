Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3CVNka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:40:30 -0400
Received: from swissweb.swissdisk.com ([174.129.12.238]:52790 "EHLO
	swissweb.swissdisk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3CVNjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:39:40 -0400
X-Greylist: delayed 1387 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 09:39:40 EDT
From: Ben Collins <ben.c@servergy.com>
Date: Tue, 19 Mar 2013 01:14:22 -0400
Subject: [PATCH] sgy-cts-1000: New DTS file for Servergy CTS-1000 systems
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Message-Id: <E1UJ1fR-0004i4-H8@swissweb.swissdisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't specifically needed in order to build the kernel. It's
stored in flash with firmware. However, keep it in the kernel for
reference (and to have an example for fsl_dpa device tree usage).

Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/boot/dts/sgy-cts-1000.dts | 1570 ++++++++++++++++++++++++++++++++
 1 file changed, 1570 insertions(+)
 create mode 100644 arch/powerpc/boot/dts/sgy-cts-1000.dts

diff --git a/arch/powerpc/boot/dts/sgy-cts-1000.dts b/arch/powerpc/boot/dts/sgy-cts-1000.dts
new file mode 100644
index 0000000..1efa01a
--- /dev/null
+++ b/arch/powerpc/boot/dts/sgy-cts-1000.dts
@@ -0,0 +1,1570 @@
+/*
+ * Servergy CTS-1000 Device Tree Source
+ *
+ * Copyright 2009-2011 Freescale Semiconductor Inc.
+ * Copyright 2011-2013 Servergy, Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/dts-v1/;
+
+/ {
+	model = "sgy,cts-1000";
+	compatible = "fsl,P4080DS";
+	#address-cells = <2>;
+	#size-cells = <2>;
+	interrupt-parent = <&mpic>;
+
+	aliases {
+		ccsr = &soc;
+		dcsr = &dcsr;
+
+		ethernet4 = &enet4;
+		ethernet7 = &enet7;
+		ethernet8 = &enet8;
+		ethernet9 = &enet9;
+		serial0 = &serial0;
+		serial1 = &serial1;
+		pci0 = &pci0;
+		usb0 = &usb0;
+		usb1 = &usb1;
+		dma0 = &dma0;
+		dma1 = &dma1;
+		bman = &bman;
+		qman = &qman;
+		pme = &pme;
+		msi0 = &msi0;
+		msi1 = &msi1;
+		msi2 = &msi2;
+
+		crypto = &crypto;
+		sec_jr0 = &sec_jr0;
+		sec_jr1 = &sec_jr1;
+		sec_jr2 = &sec_jr2;
+		sec_jr3 = &sec_jr3;
+		rtic_a = &rtic_a;
+		rtic_b = &rtic_b;
+		rtic_c = &rtic_c;
+		rtic_d = &rtic_d;
+		sec_mon = &sec_mon;
+
+		fman0 = &fman0;
+		fman0_oh0 = &fman0_oh0;
+		fman0_oh1 = &fman0_oh1;
+		fman0_oh2 = &fman0_oh2;
+		fman0_oh3 = &fman0_oh3;
+		fman0_oh4 = &fman0_oh4;
+		fman0_oh5 = &fman0_oh5;
+		fman0_oh6 = &fman0_oh6;
+		fman0_rx0 = &fman0_rx0;
+		fman0_rx1 = &fman0_rx1;
+		fman0_rx2 = &fman0_rx2;
+		fman0_rx3 = &fman0_rx3;
+		fman0_rx4 = &fman0_rx4;
+
+		fman1 = &fman1;
+		fman1_oh0 = &fman1_oh0;
+		fman1_oh1 = &fman1_oh1;
+		fman1_oh2 = &fman1_oh2;
+		fman1_oh3 = &fman1_oh3;
+		fman1_oh4 = &fman1_oh4;
+		fman1_oh5 = &fman1_oh5;
+		fman1_oh6 = &fman1_oh6;
+		fman1_rx0 = &fman1_rx0;
+		fman1_rx1 = &fman1_rx1;
+		fman1_rx2 = &fman1_rx2;
+		fman1_rx3 = &fman1_rx3;
+		fman1_rx4 = &fman1_rx4;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu0: PowerPC,e500mc@0 {
+			device_type = "cpu";
+			reg = <0>;
+			next-level-cache = <&L2_0>;
+			L2_0: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu1: PowerPC,e500mc@1 {
+			device_type = "cpu";
+			reg = <1>;
+			next-level-cache = <&L2_1>;
+			L2_1: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu2: PowerPC,e500mc@2 {
+			device_type = "cpu";
+			reg = <2>;
+			next-level-cache = <&L2_2>;
+			L2_2: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu3: PowerPC,e500mc@3 {
+			device_type = "cpu";
+			reg = <3>;
+			next-level-cache = <&L2_3>;
+			L2_3: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu4: PowerPC,e500mc@4 {
+			device_type = "cpu";
+			reg = <4>;
+			next-level-cache = <&L2_4>;
+			L2_4: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu5: PowerPC,e500mc@5 {
+			device_type = "cpu";
+			reg = <5>;
+			next-level-cache = <&L2_5>;
+			L2_5: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu6: PowerPC,e500mc@6 {
+			device_type = "cpu";
+			reg = <6>;
+			next-level-cache = <&L2_6>;
+			L2_6: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+		cpu7: PowerPC,e500mc@7 {
+			device_type = "cpu";
+			reg = <7>;
+			next-level-cache = <&L2_7>;
+			L2_7: l2-cache {
+				next-level-cache = <&cpc>;
+			};
+		};
+	};
+
+	memory {
+		device_type = "memory";
+	};
+
+	dcsr: dcsr@f00000000 {
+		ranges = <0x00000000 0xf 0x00000000 0x01008000>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "fsl,dcsr", "simple-bus";
+
+		dcsr-epu@0 {
+			compatible = "fsl,dcsr-epu";
+			interrupts = <52 2 0 0
+  				      84 2 0 0
+				      85 2 0 0>;
+			reg = <0x0 0x1000>;
+		};
+		dcsr-npc {
+			compatible = "fsl,dcsr-npc";
+			reg = <0x1000 0x1000 0x1000000 0x8000>;
+		};
+		dcsr-nxc@2000 {
+			compatible = "fsl,dcsr-nxc";
+			reg = <0x2000 0x1000>;
+		};
+		dcsr-corenet {
+			compatible = "fsl,dcsr-corenet";
+			reg = <0x8000 0x1000 0xB0000 0x1000>;
+		};
+		dcsr-dpaa@9000 {
+			compatible = "fsl,p4080-dcsr-dpaa", "fsl,dcsr-dpaa";
+			reg = <0x9000 0x1000>;
+		};
+		dcsr-ocn@11000 {
+			compatible = "fsl,p4080-dcsr-ocn", "fsl,dcsr-ocn";
+			reg = <0x11000 0x1000>;
+		};
+		dcsr-ddr@12000 {
+			compatible = "fsl,dcsr-ddr";
+			dev-handle = <&ddr1>;
+			reg = <0x12000 0x1000>;
+		};
+		dcsr-ddr@13000 {
+			compatible = "fsl,dcsr-ddr";
+			dev-handle = <&ddr2>;
+			reg = <0x13000 0x1000>;
+		};
+		dcsr-nal@18000 {
+			compatible = "fsl,p4080-dcsr-nal", "fsl,dcsr-nal";
+			reg = <0x18000 0x1000>;
+		};
+		dcsr-rcpm@22000 {
+			compatible = "fsl,p4080-dcsr-rcpm", "fsl,dcsr-rcpm";
+			reg = <0x22000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@40000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu0>;
+			reg = <0x40000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@41000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu1>;
+			reg = <0x41000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@42000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu2>;
+			reg = <0x42000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@43000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu3>;
+			reg = <0x43000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@44000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu4>;
+			reg = <0x44000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@45000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu5>;
+			reg = <0x45000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@46000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu6>;
+			reg = <0x46000 0x1000>;
+		};
+		dcsr-cpu-sb-proxy@47000 {
+			compatible = "fsl,dcsr-e500mc-sb-proxy", "fsl,dcsr-cpu-sb-proxy";
+			cpu-handle = <&cpu7>;
+			reg = <0x47000 0x1000>;
+		};
+	};
+
+	bman-portals@ff4000000 {
+		#address-cells = <0x1>;
+		#size-cells = <0x1>;
+		compatible = "simple-bus";
+		ranges = <0x0 0xf 0xf4000000 0x200000>;
+		bman-portal@0 {
+			cell-index = <0x0>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x0 0x4000 0x100000 0x1000>;
+			cpu-handle = <&cpu0>;
+			interrupts = <105 2 0 0>;
+		};
+		bman-portal@4000 {
+			cell-index = <0x1>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x4000 0x4000 0x101000 0x1000>;
+			cpu-handle = <&cpu1>;
+			interrupts = <107 2 0 0>;
+		};
+		bman-portal@8000 {
+			cell-index = <2>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x8000 0x4000 0x102000 0x1000>;
+			cpu-handle = <&cpu2>;
+			interrupts = <109 2 0 0>;
+		};
+		bman-portal@c000 {
+			cell-index = <0x3>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0xc000 0x4000 0x103000 0x1000>;
+			cpu-handle = <&cpu3>;
+			interrupts = <111 2 0 0>;
+		};
+		bman-portal@10000 {
+			cell-index = <0x4>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x10000 0x4000 0x104000 0x1000>;
+			cpu-handle = <&cpu4>;
+			interrupts = <113 2 0 0>;
+		};
+		bman-portal@14000 {
+			cell-index = <0x5>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x14000 0x4000 0x105000 0x1000>;
+			cpu-handle = <&cpu5>;
+			interrupts = <115 2 0 0>;
+		};
+		bman-portal@18000 {
+			cell-index = <0x6>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x18000 0x4000 0x106000 0x1000>;
+			cpu-handle = <&cpu6>;
+			interrupts = <117 2 0 0>;
+		};
+		bman-portal@1c000 {
+			cell-index = <0x7>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x1c000 0x4000 0x107000 0x1000>;
+			cpu-handle = <&cpu7>;
+			interrupts = <119 2 0 0>;
+		};
+		bman-portal@20000 {
+			cell-index = <0x8>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x20000 0x4000 0x108000 0x1000>;
+			interrupts = <121 2 0 0>;
+		};
+		bman-portal@24000 {
+			cell-index = <0x9>;
+			compatible = "fsl,p4080-bman-portal", "fsl,bman-portal";
+			reg = <0x24000 0x4000 0x109000 0x1000>;
+			interrupts = <123 2 0 0>;
+		};
+
+		buffer-pool@0 {
+			compatible = "fsl,p4080-bpool", "fsl,bpool";
+			fsl,bpid = <0>;
+			fsl,bpool-cfg = <0 0x100 0 1 0 0x100>;
+		};
+	};
+
+	qman-portals@ff4200000 {
+		#address-cells = <0x1>;
+		#size-cells = <0x1>;
+		compatible = "simple-bus";
+		ranges = <0x0 0xf 0xf4200000 0x200000>;
+		qportal0: qman-portal@0 {
+			cell-index = <0x0>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x0 0x4000 0x100000 0x1000>;
+			cpu-handle = <&cpu0>;
+			interrupts = <104 0x2 0 0>;
+			fsl,qman-channel-id = <0x0>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal1: qman-portal@4000 {
+			cell-index = <0x1>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x4000 0x4000 0x101000 0x1000>;
+			cpu-handle = <&cpu1>;
+			interrupts = <106 0x2 0 0>;
+			fsl,qman-channel-id = <0x1>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal2: qman-portal@8000 {
+			cell-index = <0x2>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x8000 0x4000 0x102000 0x1000>;
+			cpu-handle = <&cpu2>;
+			interrupts = <108 0x2 0 0>;
+			fsl,qman-channel-id = <0x2>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal3: qman-portal@c000 {
+			cell-index = <0x3>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0xc000 0x4000 0x103000 0x1000>;
+			cpu-handle = <&cpu3>;
+			interrupts = <110 0x2 0 0>;
+			fsl,qman-channel-id = <0x3>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal4: qman-portal@10000 {
+			cell-index = <0x4>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x10000 0x4000 0x104000 0x1000>;
+			cpu-handle = <&cpu4>;
+			interrupts = <112 0x2 0 0>;
+			fsl,qman-channel-id = <0x4>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal5: qman-portal@14000 {
+			cell-index = <0x5>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x14000 0x4000 0x105000 0x1000>;
+			cpu-handle = <&cpu5>;
+			interrupts = <114 0x2 0 0>;
+			fsl,qman-channel-id = <0x5>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal6: qman-portal@18000 {
+			cell-index = <0x6>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x18000 0x4000 0x106000 0x1000>;
+			cpu-handle = <&cpu6>;
+			interrupts = <116 0x2 0 0>;
+			fsl,qman-channel-id = <0x6>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal7: qman-portal@1c000 {
+			cell-index = <0x7>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x1c000 0x4000 0x107000 0x1000>;
+			cpu-handle = <&cpu7>;
+			interrupts = <118 0x2 0 0>;
+			fsl,qman-channel-id = <0x7>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal8: qman-portal@20000 {
+			cell-index = <0x8>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x20000 0x4000 0x108000 0x1000>;
+			interrupts = <120 0x2 0 0>;
+			fsl,qman-channel-id = <0x8>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qportal9: qman-portal@24000 {
+			cell-index = <0x9>;
+			compatible = "fsl,p4080-qman-portal", "fsl,qman-portal";
+			reg = <0x24000 0x4000 0x109000 0x1000>;
+			interrupts = <122 0x2 0 0>;
+			fsl,qman-channel-id = <0x9>;
+			fsl,qman-pool-channels = <&qpool1 &qpool2 &qpool3
+						  &qpool4 &qpool5 &qpool6
+						  &qpool7 &qpool8 &qpool9
+						  &qpool10 &qpool11 &qpool12
+						  &qpool13 &qpool14 &qpool15>;
+		};
+
+		qpool1: qman-pool@1 {
+			cell-index = <1>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x21>;
+		};
+
+		qpool2: qman-pool@2 {
+			cell-index = <2>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x22>;
+		};
+
+		qpool3: qman-pool@3 {
+			cell-index = <3>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x23>;
+		};
+
+		qpool4: qman-pool@4 {
+			cell-index = <4>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x24>;
+		};
+
+		qpool5: qman-pool@5 {
+			cell-index = <5>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x25>;
+		};
+
+		qpool6: qman-pool@6 {
+			cell-index = <6>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x26>;
+		};
+
+		qpool7: qman-pool@7 {
+			cell-index = <7>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x27>;
+		};
+
+		qpool8: qman-pool@8 {
+			cell-index = <8>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x28>;
+		};
+
+		qpool9: qman-pool@9 {
+			cell-index = <9>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x29>;
+		};
+
+		qpool10: qman-pool@10 {
+			cell-index = <10>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2a>;
+		};
+
+		qpool11: qman-pool@11 {
+			cell-index = <11>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2b>;
+		};
+
+		qpool12: qman-pool@12 {
+			cell-index = <12>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2c>;
+		};
+
+		qpool13: qman-pool@13 {
+			cell-index = <13>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2d>;
+		};
+
+		qpool14: qman-pool@14 {
+			cell-index = <14>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2e>;
+		};
+
+		qpool15: qman-pool@15 {
+			cell-index = <15>;
+			compatible = "fsl,p4080-qman-pool-channel", "fsl,qman-pool-channel";
+			fsl,qman-channel-id = <0x2f>;
+		};
+	};
+
+	soc: soc@ffe000000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		device_type = "soc";
+		compatible = "simple-bus";
+		ranges = <0x00000000 0xf 0xfe000000 0x1000000>;
+		reg = <0xf 0xfe000000 0 0x00001000>;
+
+		soc-sram-error {
+			compatible = "fsl,soc-sram-error";
+			interrupts = <16 2 1 29>;
+		};
+
+		corenet-law@0 {
+			compatible = "fsl,corenet-law";
+			reg = <0x0 0x1000>;
+			fsl,num-laws = <32>;
+		};
+
+		ddr1: memory-controller@8000 {
+			compatible = "fsl,qoriq-memory-controller-v4.4", "fsl,qoriq-memory-controller";
+			reg = <0x8000 0x1000>;
+			interrupts = <16 2 1 23>;
+		};
+
+		ddr2: memory-controller@9000 {
+			compatible = "fsl,qoriq-memory-controller-v4.4","fsl,qoriq-memory-controller";
+			reg = <0x9000 0x1000>;
+			interrupts = <16 2 1 22>;
+		};
+
+		cpc: l3-cache-controller@10000 {
+			compatible = "fsl,p4080-l3-cache-controller", "cache";
+			reg = <0x10000 0x1000
+			       0x11000 0x1000>;
+			interrupts = <16 2 1 27
+				      16 2 1 26>;
+		};
+
+		corenet-cf@18000 {
+			compatible = "fsl,corenet-cf";
+			reg = <0x18000 0x1000>;
+			interrupts = <16 2 1 31>;
+			fsl,ccf-num-csdids = <32>;
+			fsl,ccf-num-snoopids = <32>;
+		};
+
+		iommu@20000 {
+			compatible = "fsl,pamu-v1.0", "fsl,pamu";
+			reg = <0x20000 0x5000>;
+			interrupts = <
+				24 2 0 0
+				16 2 1 30>;
+		};
+
+		mpic: pic@40000 {
+			clock-frequency = <0>;
+			interrupt-controller;
+			#address-cells = <0>;
+			#interrupt-cells = <4>;
+			reg = <0x40000 0x40000>;
+			compatible = "fsl,mpic", "chrp,open-pic";
+			device_type = "open-pic";
+		};
+
+		timer@41100 {
+			compatible = "fsl,mpic-global-timer";
+			reg = <0x41100 0x100 0x41300 4>;
+			interrupts = <
+				0 0 3 0
+				1 0 3 0
+				2 0 3 0
+				3 0 3 0>;
+		};
+
+		msi0: msi@41600 {
+			compatible = "fsl,mpic-msi";
+			reg = <0x41600 0x200>;
+			msi-available-ranges = <0 0x100>;
+			interrupts = <
+				0xe0 0 0 0
+				0xe1 0 0 0
+				0xe2 0 0 0
+				0xe3 0 0 0
+				0xe4 0 0 0
+				0xe5 0 0 0
+				0xe6 0 0 0
+				0xe7 0 0 0>;
+		};
+
+		msi1: msi@41800 {
+			compatible = "fsl,mpic-msi";
+			reg = <0x41800 0x200>;
+			msi-available-ranges = <0 0x100>;
+			interrupts = <
+				0xe8 0 0 0
+				0xe9 0 0 0
+				0xea 0 0 0
+				0xeb 0 0 0
+				0xec 0 0 0
+				0xed 0 0 0
+				0xee 0 0 0
+				0xef 0 0 0>;
+		};
+
+		msi2: msi@41a00 {
+			compatible = "fsl,mpic-msi";
+			reg = <0x41a00 0x200>;
+			msi-available-ranges = <0 0x100>;
+			interrupts = <
+				0xf0 0 0 0
+				0xf1 0 0 0
+				0xf2 0 0 0
+				0xf3 0 0 0
+				0xf4 0 0 0
+				0xf5 0 0 0
+				0xf6 0 0 0
+				0xf7 0 0 0>;
+		};
+
+		timer@42100 {
+			compatible = "fsl,mpic-global-timer";
+			reg = <0x42100 0x100 0x42300 4>;
+			interrupts = <
+				4 0 3 0
+				5 0 3 0
+				6 0 3 0
+				7 0 3 0>;
+		};
+
+		guts: global-utilities@e0000 {
+			compatible = "fsl,qoriq-device-config-1.0", "fsl,mpc8572-guts";
+			reg = <0xe0000 0xe00>;
+			fsl,has-rstcr;
+			#sleep-cells = <1>;
+			fsl,liodn-bits = <12>;
+		};
+
+		pins: global-utilities@e0e00 {
+			compatible = "fsl,qoriq-pin-control-1.0";
+			reg = <0xe0e00 0x200>;
+			#sleep-cells = <2>;
+		};
+
+		clockgen: global-utilities@e1000 {
+			compatible = "fsl,p4080-clockgen", "fsl,qoriq-clockgen-1.0";
+			reg = <0xe1000 0x1000>;
+			clock-frequency = <0>;
+		};
+
+		rcpm: global-utilities@e2000 {
+			compatible = "fsl,qoriq-rcpm-1.0";
+			reg = <0xe2000 0x1000>;
+			#sleep-cells = <1>;
+		};
+
+		sfp: sfp@e8000 {
+			compatible = "fsl,p4080-sfp", "fsl,qoriq-sfp-1.0";
+			reg	   = <0xe8000 0x1000>;
+		};
+
+		serdes: serdes@ea000 {
+			compatible = "fsl,p4080-serdes";
+			reg	   = <0xea000 0x1000>;
+		};
+
+		dma0: dma@100300 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,eloplus-dma";
+			reg = <0x100300 0x4>;
+			ranges = <0x0 0x100100 0x200>;
+			cell-index = <0>;
+			dma-channel@0 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x0 0x80>;
+				cell-index = <0>;
+				interrupts = <28 2 0 0>;
+			};
+			dma-channel@80 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x80 0x80>;
+				cell-index = <1>;
+				interrupts = <29 2 0 0>;
+			};
+			dma-channel@100 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x100 0x80>;
+				cell-index = <2>;
+				interrupts = <30 2 0 0>;
+			};
+			dma-channel@180 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x180 0x80>;
+				cell-index = <3>;
+				interrupts = <31 2 0 0>;
+			};
+		};
+
+		dma1: dma@101300 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "fsl,eloplus-dma";
+			reg = <0x101300 0x4>;
+			ranges = <0x0 0x101100 0x200>;
+			cell-index = <1>;
+			dma-channel@0 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x0 0x80>;
+				cell-index = <0>;
+				interrupts = <32 2 0 0>;
+			};
+			dma-channel@80 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x80 0x80>;
+				cell-index = <1>;
+				interrupts = <33 2 0 0>;
+			};
+			dma-channel@100 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x100 0x80>;
+				cell-index = <2>;
+				interrupts = <34 2 0 0>;
+			};
+			dma-channel@180 {
+				compatible = "fsl,eloplus-dma-channel";
+				reg = <0x180 0x80>;
+				cell-index = <3>;
+				interrupts = <35 2 0 0>;
+			};
+		};
+
+		/* I2C1 */
+		i2c@118000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <0>;
+			compatible = "fsl-i2c";
+			reg = <0x118000 0x100>;
+			interrupts = <38 2 0 0>;
+			dfsrr;
+
+			/* RCW EEPROM */
+			eeprom@50 {
+				compatible = "at24,24c64";
+				reg = <0x50>;
+			};
+			/* SYS EEPROM */
+			eeprom@57 {
+				compatible = "at24,24c02";
+				reg = <0x57>;
+			};
+		};
+
+		/* I2C2 */
+		i2c@118100 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <1>;
+			compatible = "fsl-i2c";
+			reg = <0x118100 0x100>;
+			interrupts = <38 2 0 0>;
+			dfsrr;
+
+			rtc@68 {
+				compatible = "dallas,ds3232";
+				reg = <0x68>;
+				interrupts = <1 1 0 0>;
+			};
+
+			hwmon@4c {
+				compatible = "adt,adt7461";
+				reg = <0x4c>;
+				/* 
+				 * Enabling this causes a flood of interrupts
+				 * on the ds3232 device (and since it never
+				 * gets ACK'd, it consumes 100% of a CPU).
+				 * -- BenC
+				interrupts = <1 10 0 0
+					      1 11 0 0>;
+				 */
+			};
+		};
+
+		i2c@119000 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <2>;
+			compatible = "fsl-i2c";
+			reg = <0x119000 0x100>;
+			interrupts = <39 2 0 0>;
+			dfsrr;
+		};
+
+		i2c@119100 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			cell-index = <3>;
+			compatible = "fsl-i2c";
+			reg = <0x119100 0x100>;
+			interrupts = <39 2 0 0>;
+			dfsrr;
+		};
+
+		serial0: serial@11c500 {
+			cell-index = <0>;
+			device_type = "serial";
+			compatible = "fsl,ns16550", "ns16550";
+			reg = <0x11c500 0x100>;
+			clock-frequency = <0>;
+			interrupts = <36 2 0 0>;
+		};
+
+		serial1: serial@11c600 {
+			cell-index = <1>;
+			device_type = "serial";
+			compatible = "fsl,ns16550", "ns16550";
+			reg = <0x11c600 0x100>;
+			clock-frequency = <0>;
+			interrupts = <36 2 0 0>;
+		};
+
+		gpio0: gpio@130000 {
+			compatible = "fsl,qoriq-gpio";
+			reg = <0x130000 0x1000>;
+			interrupts = <55 2 0 0>;
+			#gpio-cells = <2>;
+			gpio-controller;
+
+			/* Allows powering off the system via GPIO signal. */
+			gpio-halt@27 {
+				compatible = "sgy,gpio-halt";
+				gpios = <&gpio0 27 0>;
+				interrupts = <8 1 0 0>;
+			};
+		};
+
+		usb0: usb@210000 {
+			compatible = "fsl,mpc85xx-usb2-dr", "fsl-usb2-dr";
+			reg = <0x210000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			interrupts = <44 0x2 0 0>;
+		};
+
+		usb1: usb@211000 {
+			compatible = "fsl,mpc85xx-usb2-dr", "fsl-usb2-dr";
+			reg = <0x211000 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			interrupts = <45 0x2 0 0>;
+		};
+
+		crypto: crypto@300000 {
+			compatible = "fsl,sec-v4.0";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg		 = <0x300000 0x10000>;
+			ranges		 = <0 0x300000 0x10000>;
+			interrupts	 = <92 2 0 0>;
+			fsl,qi-spids	 = <5>;
+
+			sec_jr0: jr@1000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg	   = <0x1000 0x1000>;
+				interrupts	 = <88 2 0 0>;
+			};
+
+			sec_jr1: jr@2000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg	   = <0x2000 0x1000>;
+				interrupts	 = <89 2 0 0>;
+			};
+
+			sec_jr2: jr@3000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg	   = <0x3000 0x1000>;
+				interrupts	 = <90 2 0 0>;
+			};
+
+			sec_jr3: jr@4000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg	   = <0x4000 0x1000>;
+				interrupts	 = <91 2 0 0>;
+			};
+
+			rtic@6000 {
+				compatible = "fsl,sec-v4.0-rtic";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg		 = <0x6000 0x100>;
+				ranges		 = <0x0 0x6100 0xe00>;
+
+				rtic_a: rtic-a@0 {
+					compatible = "fsl,sec-v4.0-rtic-memory";
+					reg		 = <0x00 0x20 0x100 0x80>;
+				};
+
+				rtic_b: rtic-b@20 {
+					compatible = "fsl,sec-v4.0-rtic-memory";
+					reg		 = <0x20 0x20 0x200 0x80>;
+				};
+
+				rtic_c: rtic-c@40 {
+					compatible = "fsl,sec-v4.0-rtic-memory";
+					reg		 = <0x40 0x20 0x300 0x80>;
+				};
+
+				rtic_d: rtic-d@60 {
+					compatible = "fsl,sec-v4.0-rtic-memory";
+					reg		 = <0x60 0x20 0x500 0x80>;
+				};
+			};
+		};
+
+		sec_mon: sec_mon@314000 {
+			compatible = "fsl,sec-v4.0-mon";
+			reg	   = <0x314000 0x1000>;
+			interrupts	 = <93 2 0 0>;
+		};
+
+		pme: pme@316000 {
+			compatible = "fsl,pme";
+			reg = <0x316000 0x10000>;
+			/* Use default allocation */
+			/* fsl,pme-pdsr = <0x0 0x23000000 0x0 0x01000000>; */
+			/* fsl,pme-sre = <0x0 0x24000000 0x0 0x00a00000>; */
+			interrupts = <16 2 1 5>;
+		};
+
+		qman: qman@318000 {
+			compatible = "fsl,p4080-qman", "fsl,qman";
+			reg = <0x318000 0x1000>;
+			interrupts = <16 2 1 3>;
+			/* Commented out, use default allocation */
+			/* fsl,qman-fqd = <0x0 0x20000000 0x0 0x01000000>; */
+			/* fsl,qman-pfdr = <0x0 0x21000000 0x0 0x01000000>; */
+		};
+
+		bman: bman@31a000 {
+			compatible = "fsl,p4080-bman", "fsl,bman";
+			reg = <0x31a000 0x1000>;
+			interrupts = <16 2 1 2>;
+			/* Same as fsl,qman-*, use default allocation */
+			/* fsl,bman-fbpr = <0x0 0x22000000 0x0 0x01000000>; */
+		};
+
+		fman0: fman@400000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			cell-index = <0>;
+			compatible = "fsl,p4080-fman", "fsl,fman", "simple-bus";
+			ranges = <0 0x400000 0x100000>;
+			reg = <0x400000 0x100000>;
+			clock-frequency = <0>;
+			interrupts = <
+				96 2 0 0
+				16 2 1 1>;
+
+			cc@0 {
+				compatible = "fsl,p4080-fman-cc", "fsl,fman-cc";
+			};
+
+			parser@c7000 {
+				compatible = "fsl,p4080-fman-parser", "fsl,fman-parser";
+				reg = <0xc7000 0x1000>;
+			};
+
+			keygen@c1000 {
+				compatible = "fsl,p4080-fman-keygen", "fsl,fman-keygen";
+				reg = <0xc1000 0x1000>;
+			};
+
+			policer@c0000 {
+				compatible = "fsl,p4080-fman-policer", "fsl,fman-policer";
+				reg = <0xc0000 0x1000>;
+			};
+
+			muram@0 {
+				compatible = "fsl,p4080-fman-muram", "fsl,fman-muram";
+				reg = <0x0 0x28000>;
+			};
+
+			bmi@80000 {
+				compatible = "fsl,p4080-fman-bmi", "fsl,fman-bmi";
+				reg = <0x80000 0x400>;
+			};
+
+			qmi@80400 {
+				compatible = "fsl,p4080-fman-qmi", "fsl,fman-qmi";
+				reg = <0x80400 0x400>;
+			};
+
+			fman0_rx0: port@88000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x88000 0x1000>;
+			};
+			fman0_rx1: port@89000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x89000 0x1000>;
+			};
+			fman0_rx2: port@8a000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x8a000 0x1000>;
+			};
+			fman0_rx3: port@8b000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x8b000 0x1000>;
+			};
+			fman0_rx4: port@90000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-10g-rx", "fsl,fman-port-10g-rx";
+				reg = <0x90000 0x1000>;
+			};
+
+			fman0_tx4: port@b0000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-10g-tx", "fsl,fman-port-10g-tx";
+				reg = <0xb0000 0x1000>;
+				fsl,qman-channel-id = <0x40>;
+			};
+			fman0_tx0: port@a8000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xa8000 0x1000>;
+				fsl,qman-channel-id = <0x41>;
+			};
+			fman0_tx1: port@a9000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xa9000 0x1000>;
+				fsl,qman-channel-id = <0x42>;
+			};
+			fman0_tx2: port@aa000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xaa000 0x1000>;
+				fsl,qman-channel-id = <0x43>;
+			};
+			fman0_tx3: port@ab000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xab000 0x1000>;
+				fsl,qman-channel-id = <0x44>;
+			};
+
+			fman0_oh0: port@81000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x81000 0x1000>;
+				fsl,qman-channel-id = <0x45>;
+			};
+			fman0_oh1: port@82000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x82000 0x1000>;
+				fsl,qman-channel-id = <0x46>;
+			};
+			fman0_oh2: port@83000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x83000 0x1000>;
+				fsl,qman-channel-id = <0x47>;
+			};
+			fman0_oh3: port@84000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x84000 0x1000>;
+				fsl,qman-channel-id = <0x48>;
+			};
+			fman0_oh4: port@85000 {
+				cell-index = <4>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x85000 0x1000>;
+				fsl,qman-channel-id = <0x49>;
+			};
+			fman0_oh5: port@86000 {
+				cell-index = <5>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x86000 0x1000>;
+				fsl,qman-channel-id = <0x4a>;
+			};
+			fman0_oh6: port@87000 {
+				cell-index = <6>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x87000 0x1000>;
+				fsl,qman-channel-id = <0x4b>;
+			};
+
+			/* FM2@DTSEC 3-4 */
+			emi1: mdio@e1120 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,fman-mdio";
+				reg = <0xe1120 0xee0>;
+				interrupts = <100 1 0 0>;
+
+				phy0: ethernet-phy@1c {
+					reg = <0x1c>;
+				};
+
+				phy1: ethernet-phy@1d {
+					reg = <0x1d>;
+				};
+			};
+
+			enet4: ethernet@f0000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-10g-mac", "fsl,fman-10g-mac";
+				reg = <0xf0000 0x1000>;
+				fsl,port-handles = <&fman0_rx4 &fman0_tx4>;
+				phy-handle = <&xphy0>;
+				phy-connection-type = "xgmii";
+			};
+
+			/* FM[12]@TGEC */
+			xmdio0: mdio@f1000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,fman-xmdio";
+				reg = <0xf1000 0x1000>;
+				interrupts = <100 1 0 0>;
+				gpios = <&gpio0 2 0
+					 &gpio0 3 0>;
+
+				xphy0: p4080ds-xmdio1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "fsl,p4080ds-xmdio";
+					fsl,mdio-handle = <&xmdio0>;
+					fsl,muxval = <1>;
+					reg = <0x4>;
+				};
+
+				xphy1: p4080ds-xmdio3 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "fsl,p4080ds-xmdio";
+					fsl,mdio-handle = <&xmdio0>;
+					fsl,muxval = <3>;
+					reg = <0x5>;
+				};
+			};
+		};
+
+		fman1: fman@500000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			cell-index = <1>;
+			compatible = "fsl,p4080-fman", "fsl,fman", "simple-bus";
+			ranges = <0 0x500000 0x100000>;
+			reg = <0x500000 0x100000>;
+			clock-frequency = <0>;
+			interrupts = <
+				97 2 0 0
+				16 2 1 0>;
+
+			cc@0 {
+				compatible = "fsl,p4080-fman-cc", "fsl,fman-cc";
+			};
+
+			parser@c7000 {
+				compatible = "fsl,p4080-fman-parser", "fsl,fman-parser";
+				reg = <0xc7000 0x1000>;
+			};
+
+			keygen@c1000 {
+				compatible = "fsl,p4080-fman-keygen", "fsl,fman-keygen";
+				reg = <0xc1000 0x1000>;
+			};
+
+			policer@c0000 {
+				compatible = "fsl,p4080-fman-policer", "fsl,fman-policer";
+				reg = <0xc0000 0x1000>;
+			};
+
+			muram@0 {
+				compatible = "fsl,p4080-fman-muram", "fsl,fman-muram";
+				reg = <0x0 0x28000>;
+			};
+
+			bmi@80000 {
+				compatible = "fsl,p4080-fman-bmi", "fsl,fman-bmi";
+				reg = <0x80000 0x400>;
+			};
+
+			qmi@80400 {
+				compatible = "fsl,p4080-fman-qmi", "fsl,fman-qmi";
+				reg = <0x80400 0x400>;
+			};
+
+			fman1_rx0: port@88000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x88000 0x1000>;
+			};
+			fman1_rx1: port@89000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x89000 0x1000>;
+			};
+			fman1_rx2: port@8a000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x8a000 0x1000>;
+			};
+			fman1_rx3: port@8b000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-1g-rx", "fsl,fman-port-1g-rx";
+				reg = <0x8b000 0x1000>;
+			};
+			fman1_rx4: port@90000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-10g-rx", "fsl,fman-port-10g-rx";
+				reg = <0x90000 0x1000>;
+			};
+
+			fman1_tx4: port@b0000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-10g-tx", "fsl,fman-port-10g-tx";
+				reg = <0xb0000 0x1000>;
+				fsl,qman-channel-id = <0x60>;
+			};
+			fman1_tx0: port@a8000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xa8000 0x1000>;
+				fsl,qman-channel-id = <0x61>;
+			};
+			fman1_tx1: port@a9000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xa9000 0x1000>;
+				fsl,qman-channel-id = <0x62>;
+			};
+			fman1_tx2: port@aa000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xaa000 0x1000>;
+				fsl,qman-channel-id = <0x63>;
+			};
+			fman1_tx3: port@ab000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-1g-tx", "fsl,fman-port-1g-tx";
+				reg = <0xab000 0x1000>;
+				fsl,qman-channel-id = <0x64>;
+			};
+
+			fman1_oh0: port@81000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x81000 0x1000>;
+				fsl,qman-channel-id = <0x65>;
+			};
+			fman1_oh1: port@82000 {
+				cell-index = <1>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x82000 0x1000>;
+				fsl,qman-channel-id = <0x66>;
+			};
+			fman1_oh2: port@83000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x83000 0x1000>;
+				fsl,qman-channel-id = <0x67>;
+			};
+			fman1_oh3: port@84000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x84000 0x1000>;
+				fsl,qman-channel-id = <0x68>;
+			};
+			fman1_oh4: port@85000 {
+				cell-index = <4>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x85000 0x1000>;
+				fsl,qman-channel-id = <0x69>;
+			};
+			fman1_oh5: port@86000 {
+				cell-index = <5>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x86000 0x1000>;
+				fsl,qman-channel-id = <0x6a>;
+			};
+			fman1_oh6: port@87000 {
+				cell-index = <6>;
+				compatible = "fsl,p4080-fman-port-oh", "fsl,fman-port-oh";
+				reg = <0x87000 0x1000>;
+				fsl,qman-channel-id = <0x6b>;
+			};
+
+			enet7: ethernet@e4000 {
+				cell-index = <2>;
+				compatible = "fsl,p4080-fman-1g-mac", "fsl,fman-1g-mac";
+				reg = <0xe4000 0x1000>;
+				fsl,port-handles = <&fman1_rx2 &fman1_tx2>;
+				tbi-handle = <&tbi0>;
+				phy-handle = <&phy0>;
+				phy-connection-type = "sgmii";
+			};
+
+			mdio@e5120 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,fman-tbi";
+				reg = <0xe5120 0xee0>;
+				interrupts = <101 1 0 0>;
+
+				tbi0: tbi-phy@8 {
+					reg = <0x08>;
+					device_type = "tbi-phy";
+				};
+			};
+
+			enet8: ethernet@e6000 {
+				cell-index = <3>;
+				compatible = "fsl,p4080-fman-1g-mac", "fsl,fman-1g-mac";
+				reg = <0xe6000 0x1000>;
+				fsl,port-handles = <&fman1_rx3 &fman1_tx3>;
+				tbi-handle = <&tbi1>;
+				phy-handle = <&phy1>;
+				phy-connection-type = "sgmii";
+			};
+
+			mdio@e7120 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				compatible = "fsl,fman-tbi";
+				reg = <0xe7120 0xee0>;
+				interrupts = <101 1 0 0>;
+
+				tbi1: tbi-phy@8 {
+					reg = <0x8>;
+					device_type = "tbi-phy";
+				};
+			};
+
+			enet9: ethernet@f0000 {
+				cell-index = <0>;
+				compatible = "fsl,p4080-fman-10g-mac", "fsl,fman-10g-mac";
+				reg = <0xf0000 0x1000>;
+				fsl,port-handles = <&fman1_rx4 &fman1_tx4>;
+				phy-handle = <&xphy1>;
+				phy-connection-type = "xgmii";
+			};
+		};
+	};
+
+	localbus@ffe124000 {
+		compatible = "fsl,p4080-elbc", "fsl,elbc", "simple-bus";
+		reg = <0xf 0xfe124000 0 0x1000>;
+		interrupts = <25 2 0 0>;
+		#address-cells = <2>;
+		#size-cells = <1>;
+
+		ranges = <0 0 0xf 0xe8000000 0x08000000>;
+
+		/* 256M Flash device */
+		flash@0,0 {
+			compatible = "cfi-flash";
+			reg = <0 0 0x08000000>;
+			bank-width = <2>;
+			device-width = <2>;
+			#address-cells = <0x1>;
+			#size-cells = <0x1>;
+
+			/* 16M for kernel */
+			partition@0 {
+				label = "sgyboot-kernel";
+				reg = <0x00000000 0x01000000>;
+			};
+			/* 64M for root fs */
+			partition@1 {
+				label = "sgyboot-initrd";
+				reg = <0x01000000 0x04000000>;
+			};
+			/* 256K for FMan microcode */
+			partition@2 {
+				label = "fsl-fman-ucode";
+				reg = <0x05000000 0x00040000>;
+			};
+			/* 256K for Device-tree */
+			partition@3 {
+				label = "device-tree";
+				reg = <0x05040000 0x00040000>;
+			};
+			/* 128K for u-Boot environment */
+			partition@4 {
+				label = "u-boot-env";
+				reg = <0x05080000 0x00020000>;
+			};
+			/* 128K Unused */
+
+			/* 1Meg for splash screen in u-boot's UDL driver */
+			partition@6 {
+				label = "udl-splash";
+				reg = <0x050c0000 0x00100000>;
+			};
+
+			/* ~44Megs Unused */
+
+			/* 2.5M for u-Boot */
+			partition@5 {
+				label = "u-boot";
+				reg = <0x07D80000 0x00280000>;
+			};
+
+			/* The whole flash area */
+			partition@20 {
+				label = "whole";
+				reg = <0x00000000 0x08000000>;
+			};
+		};
+	};
+
+	pci0: pcie@ffe200000 {
+		compatible = "fsl,p4080-pcie";
+		device_type = "pci";
+		#size-cells = <2>;
+		#address-cells = <3>;
+		reg = <0xf 0xfe200000 0 0x1000>;
+		bus-range = <0x0 0xff>;
+		ranges = <0x02000000 0 0xe0000000 0xc 0x00000000 0x0 0x20000000
+			  0x01000000 0 0x00000000 0xf 0xf8000000 0x0 0x00010000>;
+		clock-frequency = <0x1fca055>;
+		fsl,msi = <&msi0>;
+		interrupts = <16 2 1 15>;
+
+		pcie@0 {
+			reg = <0 0 0 0 0>;
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			device_type = "pci";
+			interrupts = <16 2 1 15>;
+			interrupt-map-mask = <0xf800 0 0 7>;
+			interrupt-map = <
+				/* IDSEL 0x0 */
+				0000 0 0 1 &mpic 40 1 0 0
+				0000 0 0 2 &mpic 1 1 0 0
+				0000 0 0 3 &mpic 2 1 0 0
+				0000 0 0 4 &mpic 3 1 0 0
+				>;
+			ranges = <0x02000000 0 0xe0000000
+				  0x02000000 0 0xe0000000
+				  0 0x20000000
+
+				  0x01000000 0 0x00000000
+				  0x01000000 0 0x00000000
+				  0 0x00010000>;
+		};
+	};
+
+	fsl,dpaa {
+		compatible = "fsl,p4080-dpaa", "fsl,dpaa";
+
+		ethernet@4 {
+			compatible = "fsl,p4080-dpa-ethernet", "fsl,dpa-ethernet";
+			fsl,qman-channel = <&qpool1>;
+			fsl,fman-mac = <&enet4>;
+		};
+		ethernet@7 {
+			compatible = "fsl,p4080-dpa-ethernet", "fsl,dpa-ethernet";
+			fsl,qman-channel = <&qpool1>;
+			fsl,fman-mac = <&enet7>;
+		};
+		ethernet@8 {
+			compatible = "fsl,p4080-dpa-ethernet", "fsl,dpa-ethernet";
+			fsl,qman-channel = <&qpool1>;
+			fsl,fman-mac = <&enet8>;
+		};
+		ethernet@9 {
+			compatible = "fsl,p4080-dpa-ethernet", "fsl,dpa-ethernet";
+			fsl,qman-channel = <&qpool1>;
+			fsl,fman-mac = <&enet9>;
+		};
+	};
+};
-- 
1.8.1.2


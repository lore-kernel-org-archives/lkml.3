Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbaGOIxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:53:52 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:26549
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758293AbaGOIsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:23 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 18/29] nios2: Device tree support
Date: Tue, 15 Jul 2014 16:45:45 +0800
Message-ID: <1405413956-2772-19-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(22564002)(199002)(106466001)(87286001)(79102001)(15202345003)(97736001)(81542001)(6806004)(80022001)(77982001)(88136002)(83072002)(76176999)(85852003)(21056001)(47776003)(20776003)(81342001)(42186005)(87936001)(107046002)(92566001)(62966002)(89996001)(93916002)(575784001)(19580405001)(104166001)(76482001)(68736004)(44976005)(83322001)(46102001)(19580395003)(50986999)(2201001)(99396002)(105596002)(229853001)(92726001)(64706001)(48376002)(36756003)(77156001)(86362001)(102836001)(74502001)(77096002)(4396001)(74662001)(31966008)(50226001)(95666004)(15975445006)(84676001)(85306003)(33646002)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB045;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support to arch/nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 Documentation/devicetree/bindings/nios2/nios2.txt |  62 +++++++++
 Documentation/devicetree/bindings/nios2/timer.txt |  19 +++
 arch/nios2/boot/dts/3c120_devboard.dts            | 155 ++++++++++++++++++++++
 arch/nios2/boot/linked_dtb.S                      |  19 +++
 arch/nios2/kernel/prom.c                          |  66 +++++++++
 arch/nios2/platform/platform.c                    |  51 +++++++
 6 files changed, 372 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nios2/nios2.txt
 create mode 100644 Documentation/devicetree/bindings/nios2/timer.txt
 create mode 100644 arch/nios2/boot/dts/3c120_devboard.dts
 create mode 100644 arch/nios2/boot/linked_dtb.S
 create mode 100644 arch/nios2/kernel/prom.c
 create mode 100644 arch/nios2/platform/platform.c

diff --git a/Documentation/devicetree/bindings/nios2/nios2.txt b/Documentation/devicetree/bindings/nios2/nios2.txt
new file mode 100644
index 0000000..d6d0a94
--- /dev/null
+++ b/Documentation/devicetree/bindings/nios2/nios2.txt
@@ -0,0 +1,62 @@
+* Nios II Processor Binding
+
+This binding specifies what properties available in the device tree
+representation of a Nios II Processor Core.
+
+Users can use sopc2dts tool for generating device tree sources (dts) from a
+Qsys system. See more detail in: http://www.alterawiki.com/wiki/Sopc2dts
+
+Required properties:
+
+- compatible: Compatible property value should be "altr,nios2-1.0".
+- reg: Contains CPU index.
+- interrupt-controller: Specifies that the node is an interrupt controller
+- #interrupt-cells: Specifies the number of cells needed to encode an
+		interrupt source, should be 1.
+- clock-frequency: Contains the clock frequency for CPU, in Hz.
+- dcache-line-size: Contains data cache line size.
+- icache-line-size: Contains instruction line size.
+- dcache-size: Contains data cache size.
+- icache-size: Contains instruction cache size.
+- altr,pid-num-bits: Specifies the number of bits to use to represent the process
+		identifier (PID).
+- altr,tlb-num-ways: Specifies the number of set-associativity ways in the TLB.
+- altr,tlb-num-entries: Specifies the number of entries in the TLB.
+- altr,tlb-ptr-sz: Specifies size of TLB pointer.
+- altr,has-mul: Specifies CPU hardware multipy support, should be 1.
+- altr,has-mmu: Specifies CPU support MMU support, should be 1.
+- altr,has-initda: Specifies CPU support initda instruction, should be 1.
+- altr,reset-addr: Specifies CPU reset address
+- altr,fast-tlb-miss-addr: Specifies CPU fast TLB miss exception address
+- altr,exception-addr: Specifies CPU exception address
+
+Optional properties:
+- altr,has-div: Specifies CPU hardware divide support
+- altr,implementation: Nios II core implementation, this should be "fast";
+
+Example:
+
+cpu@0x0 {
+	device_type = "cpu";
+	compatible = "altr,nios2-1.0";
+	reg = <0>;
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	clock-frequency = <125000000>;
+	dcache-line-size = <32>;
+	icache-line-size = <32>;
+	dcache-size = <32768>;
+	icache-size = <32768>;
+	altr,implementation = "fast";
+	altr,pid-num-bits = <8>;
+	altr,tlb-num-ways = <16>;
+	altr,tlb-num-entries = <128>;
+	altr,tlb-ptr-sz = <7>;
+	altr,has-div = <1>;
+	altr,has-mul = <1>;
+	altr,reset-addr = <0xc2800000>;
+	altr,fast-tlb-miss-addr = <0xc7fff400>;
+	altr,exception-addr = <0xd0000020>;
+	altr,has-initda = <1>;
+	altr,has-mmu = <1>;
+};
diff --git a/Documentation/devicetree/bindings/nios2/timer.txt b/Documentation/devicetree/bindings/nios2/timer.txt
new file mode 100644
index 0000000..904a584
--- /dev/null
+++ b/Documentation/devicetree/bindings/nios2/timer.txt
@@ -0,0 +1,19 @@
+Altera Timer
+
+Required properties:
+
+- compatible : should be "altr,timer-1.0"
+- reg : Specifies base physical address and size of the registers.
+- interrupt-parent: phandle of the interrupt controller
+- interrupts : Should contain the timer interrupt number
+- clock-frequency : The frequency of the clock that drives the counter, in Hz.
+
+Example:
+
+timer {
+	compatible = "altr,timer-1.0";
+	reg = <0x00400000 0x00000020>;
+	interrupt-parent = <&cpu>;
+	interrupts = <11>;
+	clock-frequency = <125000000>;
+};
diff --git a/arch/nios2/boot/dts/3c120_devboard.dts b/arch/nios2/boot/dts/3c120_devboard.dts
new file mode 100644
index 0000000..c8fe26d
--- /dev/null
+++ b/arch/nios2/boot/dts/3c120_devboard.dts
@@ -0,0 +1,155 @@
+/*
+ *  Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * This file is generated by sopc2dts.
+ */
+
+/dts-v1/;
+
+/ {
+	model = "altr,qsys_ghrd_3c120";
+	compatible = "altr,qsys_ghrd_3c120";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu: cpu@0x0 {
+			device_type = "cpu";
+			compatible = "altr,nios2-1.0";
+			reg = <0x00000000>;
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			clock-frequency = <125000000>;
+			dcache-line-size = <32>;
+			icache-line-size = <32>;
+			dcache-size = <32768>;
+			icache-size = <32768>;
+			altr,implementation = "fast";
+			altr,pid-num-bits = <8>;
+			altr,tlb-num-ways = <16>;
+			altr,tlb-num-entries = <128>;
+			altr,tlb-ptr-sz = <7>;
+			altr,has-div = <1>;
+			altr,has-mul = <1>;
+			altr,reset-addr = <0xc2800000>;
+			altr,fast-tlb-miss-addr = <0xc7fff400>;
+			altr,exception-addr = <0xd0000020>;
+			altr,has-initda = <1>;
+			altr,has-mmu = <1>;
+		};
+	};
+
+	memory@0 {
+		device_type = "memory";
+		reg = <0x10000000 0x08000000>,
+			<0x07fff400 0x00000400>;
+	};
+
+	sopc@0 {
+		device_type = "soc";
+		ranges;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "altr,avalon", "simple-bus";
+		bus-frequency = <125000000>;
+
+		pb_cpu_to_io: bridge@0x8000000 {
+			compatible = "simple-bus";
+			reg = <0x08000000 0x00800000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x00002000 0x08002000 0x00002000>,
+				<0x00004000 0x08004000 0x00000400>,
+				<0x00004400 0x08004400 0x00000040>,
+				<0x00004800 0x08004800 0x00000040>,
+				<0x00004c80 0x08004c80 0x00000020>,
+				<0x00004d50 0x08004d50 0x00000008>,
+				<0x00400000 0x08400000 0x00000020>;
+
+			timer_1ms: timer@0x400000 {
+				compatible = "altr,timer-1.0";
+				reg = <0x00400000 0x00000020>;
+				interrupt-parent = <&cpu>;
+				interrupts = <11>;
+				clock-frequency = <125000000>;
+			};
+
+			jtag_uart: serial@0x4d50 {
+				compatible = "altr,juart-1.0";
+				reg = <0x00004d50 0x00000008>;
+				interrupt-parent = <&cpu>;
+				interrupts = <1>;
+			};
+
+			tse_mac: ethernet@0x4000 {
+				compatible = "altr,tse-1.0";
+				reg = <0x00004000 0x00000400>,
+					<0x00004400 0x00000040>,
+					<0x00004800 0x00000040>,
+					<0x00002000 0x00002000>;
+				reg-names = "control_port", "rx_csr", "tx_csr", "s1";
+				interrupt-parent = <&cpu>;
+				interrupts = <2 3>;
+				interrupt-names = "rx_irq", "tx_irq";
+				rx-fifo-depth = <8192>;
+				tx-fifo-depth = <8192>;
+				max-frame-size = <1518>;
+				local-mac-address = [ 00 00 00 00 00 00 ];
+				phy-mode = "rgmii-id";
+				phy-handle = <&phy0>;
+				tse_mac_mdio: mdio {
+					compatible = "altr,tse-mdio";
+					#address-cells = <1>;
+					#size-cells = <0>;
+					phy0: ethernet-phy@18 {
+						reg = <18>;
+						device_type = "ethernet-phy";
+					};
+				};
+			};
+
+			uart: serial@0x4c80 {
+				compatible = "altr,uart-1.0";
+				reg = <0x00004c80 0x00000020>;
+				interrupt-parent = <&cpu>;
+				interrupts = <10>;
+				current-speed = <115200>;
+				clock-frequency = <62500000>;
+			};
+		};
+
+		cfi_flash_64m: flash@0x0 {
+			compatible = "cfi-flash";
+			reg = <0x00000000 0x04000000>;
+			bank-width = <2>;
+			device-width = <1>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			partition@800000 {
+				reg = <0x00800000 0x01e00000>;
+				label = "JFFS2 Filesystem";
+			};
+		};
+	};
+
+	chosen {
+		bootargs = "debug console=ttyJ0,115200";
+	};
+};
diff --git a/arch/nios2/boot/linked_dtb.S b/arch/nios2/boot/linked_dtb.S
new file mode 100644
index 0000000..071f922
--- /dev/null
+++ b/arch/nios2/boot/linked_dtb.S
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2011 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+.section .dtb.init.rodata,"a"
+.incbin "arch/nios2/boot/system.dtb"
diff --git a/arch/nios2/kernel/prom.c b/arch/nios2/kernel/prom.c
new file mode 100644
index 0000000..8b1ac14
--- /dev/null
+++ b/arch/nios2/kernel/prom.c
@@ -0,0 +1,66 @@
+/*
+ * Device tree support
+ *
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * Based on MIPS support for CONFIG_OF device tree support
+ *
+ * Copyright (C) 2010 Cisco Systems Inc. <dediao@cisco.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/bootmem.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/io.h>
+
+#include <asm/sections.h>
+
+void __init early_init_dt_add_memory_arch(u64 base, u64 size)
+{
+	u64 kernel_start = (u64)virt_to_phys(_text);
+
+	if (!memory_size &&
+	    (kernel_start >= base) && (kernel_start < (base + size)))
+		memory_size = size;
+
+	return;
+}
+
+void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
+{
+	return alloc_bootmem_align(size, align);
+}
+
+void __init early_init_devtree(void *params)
+{
+	__be32 *dtb = (u32*)__dtb_start;
+#if defined(CONFIG_NIOS2_DTB_AT_PHYS_ADDR)
+	if (be32_to_cpup((__be32 *)CONFIG_NIOS2_DTB_PHYS_ADDR) ==
+		 OF_DT_HEADER) {
+		params = (void *)CONFIG_NIOS2_DTB_PHYS_ADDR;
+		early_init_dt_scan(params);
+		return;
+	}
+#endif
+	if (be32_to_cpu((__be32) *dtb) == OF_DT_HEADER)
+		params = (void *)__dtb_start;
+
+	early_init_dt_scan(params);
+}
diff --git a/arch/nios2/platform/platform.c b/arch/nios2/platform/platform.c
new file mode 100644
index 0000000..df759f5
--- /dev/null
+++ b/arch/nios2/platform/platform.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2011 Thomas Chou
+ * Copyright (C) 2011 Walter Goossens
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
+#include <linux/io.h>
+
+static struct of_device_id altera_of_bus_ids[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{ .compatible = "altr,avalon", },
+	{}
+};
+
+static int __init nios2_soc_device_init(void)
+{
+	struct soc_device *soc_dev;
+	struct soc_device_attribute *soc_dev_attr;
+	const char *machine;
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (soc_dev_attr) {
+		machine = of_flat_dt_get_machine_name();
+		if (machine)
+			soc_dev_attr->machine = kasprintf(GFP_KERNEL, "%s",
+						machine);
+
+		soc_dev_attr->family = "Nios II";
+
+		soc_dev = soc_device_register(soc_dev_attr);
+		if (IS_ERR(soc_dev)) {
+			kfree(soc_dev_attr->machine);
+			kfree(soc_dev_attr);
+		}
+	}
+
+	return of_platform_bus_probe(NULL, altera_of_bus_ids, NULL);
+}
+
+device_initcall(nios2_soc_device_init);
-- 
1.8.2.1


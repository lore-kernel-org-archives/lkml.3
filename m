Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbaGXXBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:01:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759806AbaGXXBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:01:11 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 03/11] ARM: dts: zynq: Add Parallella device tree
Date: Fri, 25 Jul 2014 01:00:12 +0200
Message-Id: <1406242820-20140-4-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406242820-20140-1-git-send-email-afaerber@suse.de>
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to boot the Adapteva Parallella board to serial console.

Cc: Andreas Olofsson <andreas@adapteva.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v1 -> v2:
 * Added board-specific compatible string (Olof Johansson).
 * Added /chosen linux,stdout-path property (Olof Johansson).
 * Fixed /memory reg size 0x20000000 -> 0x40000000 (0 considered).
 * Added vendor name to root node's model property (Olof Johansson).
 
 arch/arm/boot/dts/Makefile            |  4 ++-
 arch/arm/boot/dts/zynq-parallella.dts | 64 +++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/zynq-parallella.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index adb5ed9..976720f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -419,7 +419,9 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8650-mid.dtb \
 	wm8750-apc8750.dtb \
 	wm8850-w70v2.dtb
-dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
+dtb-$(CONFIG_ARCH_ZYNQ) += \
+	zynq-parallella.dtb \
+	zynq-zc702.dtb \
 	zynq-zc706.dtb \
 	zynq-zed.dtb
 dtb-$(CONFIG_MACH_ARMADA_370) += \
diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
new file mode 100644
index 0000000..41afd9d
--- /dev/null
+++ b/arch/arm/boot/dts/zynq-parallella.dts
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2014 SUSE LINUX Products GmbH
+ *
+ * Derived from zynq-zed.dts:
+ *
+ *  Copyright (C) 2011 Xilinx
+ *  Copyright (C) 2012 National Instruments Corp.
+ *  Copyright (C) 2013 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/dts-v1/;
+/include/ "zynq-7000.dtsi"
+
+/ {
+	model = "Adapteva Parallella Board";
+	compatible = "adapteva,parallella", "xlnx,zynq-7000";
+
+	memory {
+		device_type = "memory";
+		reg = <0 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
+		linux,stdout-path = "/amba/serial@e0001000";
+	};
+};
+
+&gem0 {
+	status = "okay";
+	phy-mode = "rgmii-id";
+	phy-handle = <&ethernet_phy>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ethernet_phy: ethernet-phy@0 {
+		/* Marvell 88E1318 */
+		compatible = "ethernet-phy-id0141.0e90",
+		             "ethernet-phy-ieee802.3-c22";
+		reg = <0>;
+		marvell,reg-init = <0x3 0x10 0xff00 0x1e>,
+		                   <0x3 0x11 0xfff0 0xa>;
+	};
+};
+
+&i2c0 {
+	status = "okay";
+};
+
+&sdhci1 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3FJRKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:10:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50205 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3FJRK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:10:28 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] arm: dt: zynq: Add support for the zc706 platform
Date: Mon, 10 Jun 2013 10:10:04 -0700
Message-Id: <1370884204-2297-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DT fragment for the zc706 Zynq platform. Also, adding a
corresponding target to the Makefile and adding an appropriate
compatibility string in the BSP.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/Makefile       |  3 ++-
 arch/arm/boot/dts/zynq-zc706.dts | 31 +++++++++++++++++++++++++++++++
 arch/arm/mach-zynq/common.c      |  1 +
 3 files changed, 34 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/zynq-zc706.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9f7121..2aecf7e 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -206,7 +206,8 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8505-ref.dtb \
 	wm8650-mid.dtb \
 	wm8850-w70v2.dtb
-dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
+dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
+	zynq-zc706.dtb
 
 targets += dtbs
 targets += $(dtb-y)
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
new file mode 100644
index 0000000..a8a1d7d
--- /dev/null
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -0,0 +1,31 @@
+/*
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
+	model = "Zynq ZC706 Development Board";
+	compatible = "xlnx,zynq-zc706", "xlnx,zynq-7000";
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyPS1,115200 earlyprintk";
+	};
+
+};
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 5bfe703..221694b 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -99,6 +99,7 @@ static void zynq_system_reset(char mode, const char *cmd)
 
 static const char * const zynq_dt_match[] = {
 	"xlnx,zynq-zc702",
+	"xlnx,zynq-zc706",
 	"xlnx,zynq-7000",
 	NULL
 };
-- 
1.8.3


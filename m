Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3FMQiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:38:00 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64839 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab3FMQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:37:51 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Dinh Nguyen <dinguyen@altera.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 4/4] arm: dt: zynq: Add support for the zed platform
Date: Thu, 13 Jun 2013 09:37:18 -0700
Message-Id: <1371141438-16553-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1371141438-16553-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a DT fragment for the Zed Zynq platform and a corresponding
target to the Makefile

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v3:
 - adding the 'status' override for the UART node
 - changing the console device to ttyPS0
 - dropped 'xlnx,zynq-zed' compat string

 arch/arm/boot/dts/Makefile     |  3 ++-
 arch/arm/boot/dts/zynq-zed.dts | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/zynq-zed.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 2823027..1d4ff16 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -209,7 +209,8 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 	wm8650-mid.dtb \
 	wm8850-w70v2.dtb
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
-	zynq-zc706.dtb
+	zynq-zc706.dtb \
+	zynq-zed.dtb
 
 targets += dtbs
 targets += $(dtb-y)
diff --git a/arch/arm/boot/dts/zynq-zed.dts b/arch/arm/boot/dts/zynq-zed.dts
new file mode 100644
index 0000000..d6acf2b
--- /dev/null
+++ b/arch/arm/boot/dts/zynq-zed.dts
@@ -0,0 +1,35 @@
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
+	model = "Zynq Zed Development Board";
+	compatible = "xlnx,zynq-7000";
+
+	memory {
+		device_type = "memory";
+		reg = <0 0x20000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyPS0,115200 earlyprintk";
+	};
+
+};
+
+&uart1 {
+	status = "okay";
+};
-- 
1.8.3


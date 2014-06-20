Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaFTOxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:53:11 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41712 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaFTOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:53:09 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] ARM: sun8i: dt: Add Ippo-q8h v5 support
Date: Fri, 20 Jun 2014 22:52:53 +0800
Message-Id: <1403275973-24259-5-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403275973-24259-1-git-send-email-wens@csie.org>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Ippo-q8h is a tablet circuit board commonly found in cheap Android
tablets with A23 SoCs. There are at least 2 versions of the board, with
different peripherals, such as WiFi chips.

Common features among these tablets include 512 MB DRAM, NAND, MMC, LCD,
capacitive touchscreen, accelerometer, 1 or 2 camera sensors, USB OTG,
microphone and speaker.

v5 of these board designs has a ESP8089 WiFi chip (not supported)
connected to mmc1. This patch adds very basic support.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/Makefile                  |  2 ++
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 31 +++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 5986ff6..774a14b 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -380,6 +380,8 @@ dtb-$(CONFIG_MACH_SUN7I) += \
 	sun7i-a20-cubietruck.dtb \
 	sun7i-a20-i12-tvbox.dtb \
 	sun7i-a20-olinuxino-micro.dtb
+dtb-$(CONFIG_MACH_SUN8I) += \
+	sun8i-a23-ippo-q8h-v5.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
 	tegra20-medcom-wide.dtb \
diff --git a/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
new file mode 100644
index 0000000..64ec56f
--- /dev/null
+++ b/arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2014 Chen-Yu Tsai
+ *
+ * Chen-Yu Tsai <wens@csie.org>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "sun8i-a23.dtsi"
+
+/ {
+	model = "Ippo Q8H Dual Core Tablet (v5)";
+	compatible = "ippo,q8h-v5", "allwinner,sun8i-a23";
+
+	chosen {
+		bootargs = "earlyprintk console=ttyS0,115200";
+	};
+
+	soc@01c00000 {
+		r_uart: serial@01f02800 {
+			status = "okay";
+		};
+	};
+};
+
-- 
2.0.0


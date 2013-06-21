Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423729Ab3FUTKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:10:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58833 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423604Ab3FUTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:10:47 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] ARM: msm: Add support for MSM8974
Date: Fri, 21 Jun 2013 12:10:34 -0700
Message-Id: <1371841835-29514-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic board support for MSM8974.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/boot/dts/Makefile        |    3 ++-
 arch/arm/boot/dts/msm8974.dts     |   23 +++++++++++++++++++++++
 arch/arm/mach-msm/Kconfig         |   31 +++++++++++++++++++++++++++----
 arch/arm/mach-msm/Makefile        |    1 +
 arch/arm/mach-msm/board-dt-8974.c |   25 +++++++++++++++++++++++++
 5 files changed, 78 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/msm8974.dts
 create mode 100644 arch/arm/mach-msm/board-dt-8974.c

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index b9f7121..7728cfe 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -90,7 +90,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-openblocks_a6.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
 dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
-	msm8960-cdp.dtb
+	msm8960-cdp.dtb \
+	msm8974.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-rd.dtb \
diff --git a/arch/arm/boot/dts/msm8974.dts b/arch/arm/boot/dts/msm8974.dts
new file mode 100644
index 0000000..d9c10d4
--- /dev/null
+++ b/arch/arm/boot/dts/msm8974.dts
@@ -0,0 +1,23 @@
+/dts-v1/;
+
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "Qualcomm MSM8974";
+	compatible = "qcom,msm8974";
+	interrupt-parent = <&intc>;
+
+	intc: interrupt-controller@f9000000 {
+		compatible = "qcom,msm-qgic2";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = < 0xf9000000 0x1000 >,
+		      < 0xf9002000 0x1000 >;
+	};
+
+	timer {
+		compatible = "arm,armv7-timer";
+		interrupts = <1 2 0 1 3 0>;
+		clock-frequency = <19200000>;
+	};
+};
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 614e41e..580e89b 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -1,12 +1,12 @@
 if ARCH_MSM
 
 comment "Qualcomm MSM SoC Type"
-	depends on (ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on ARCH_MSM_DT
 
 choice
 	prompt "Qualcomm MSM SoC Type"
 	default ARCH_MSM7X00A
-	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on !ARCH_MSM_DT
 
 config ARCH_MSM7X00A
 	bool "MSM7x00A / MSM7x01A"
@@ -46,7 +46,6 @@ config ARCH_MSM8X60
 	bool "MSM8X60"
 	select ARM_GIC
 	select CPU_V7
-	select GPIO_MSM_V2
 	select HAVE_SMP
 	select MSM_SCM if SMP
 	select USE_OF
@@ -60,14 +59,37 @@ config ARCH_MSM8960
 	select MSM_SCM if SMP
 	select USE_OF
 
+config ARCH_MSM8974
+	bool "MSM8974"
+	select ARCH_MSM_KRAITMP
+	select ARM_GIC
+	select CPU_V7
+	select HAVE_ARM_ARCH_TIMER
+	select USE_OF
+	select MSM_SCM if SMP
+
+config ARCH_MSM_DT
+	def_bool y
+	depends on (ARCH_MSM8X60 || ARCH_MSM8960 || ARCH_MSM8974)
+
 config MSM_HAS_DEBUG_UART_HS
 	bool
 
 config MSM_SOC_REV_A
 	bool
 
+config ARCH_MSM_KRAIT
+	bool
+	select ARM_L1_CACHE_SHIFT_6
+
+config ARCH_MSM_KRAITMP
+	select ARCH_MSM_KRAIT
+	select HAVE_SMP
+	bool
+
 config  ARCH_MSM_ARM11
 	bool
+
 config  ARCH_MSM_SCORPION
 	bool
 
@@ -75,6 +97,7 @@ config  MSM_VIC
 	bool
 
 menu "Qualcomm MSM Board Type"
+	depends on !ARCH_MSM_DT
 
 config MACH_HALIBUT
 	depends on ARCH_MSM
@@ -121,7 +144,7 @@ config MSM_SMD
 	bool
 
 config MSM_GPIOMUX
-	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
+	depends on !ARCH_MSM_DT
 	bool "MSM V1 TLMM GPIOMUX architecture"
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index d257ff4..80e3b15 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -29,5 +29,6 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
 obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
+obj-$(CONFIG_ARCH_MSM8974) += board-dt-8974.o
 obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
new file mode 100644
index 0000000..a35dff5
--- /dev/null
+++ b/arch/arm/mach-msm/board-dt-8974.c
@@ -0,0 +1,25 @@
+/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/irqchip.h>
+#include <linux/of_platform.h>
+#include <asm/mach/arch.h>
+
+static const char * const msm8974_dt_match[] __initconst = {
+	"qcom,msm8974",
+	NULL
+};
+
+DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.dt_compat = msm8974_dt_match,
+MACHINE_END
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


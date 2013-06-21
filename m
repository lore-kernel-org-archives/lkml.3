Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891Ab3FUAgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:36:22 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62188 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965851Ab3FUAgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:36:02 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 8/8] ARM: dts: Add dts file for S3C6410-based SMDK6410 board
Date: Fri, 21 Jun 2013 02:35:24 +0200
Message-Id: <1371774924-9224-9-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds basic device tree sources for SAMSUNG SMDK6410 board
based on SAMSUNG S3C6410 SoC.

Currently only UARTs, SD channel 0 and 100Mbps ethernet (SMSC911x) are
supported.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/Makefile             |  3 +-
 arch/arm/boot/dts/s3c6410-smdk6410.dts | 93 ++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/s3c6410-smdk6410.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index acf41d7..0382554 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -161,7 +161,8 @@ dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
 	hrefv60plus.dtb \
 	ccu9540.dtb
 dtb-$(CONFIG_ARCH_S3C24XX) += s3c2416-smdk2416.dtb
-dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb
+dtb-$(CONFIG_ARCH_S3C64XX) += s3c6410-mini6410.dtb \
+	s3c6410-smdk6410.dtb
 dtb-$(CONFIG_ARCH_SHMOBILE) += emev2-kzm9d.dtb \
 	r8a7740-armadillo800eva.dtb \
 	r8a7778-bockw.dtb \
diff --git a/arch/arm/boot/dts/s3c6410-smdk6410.dts b/arch/arm/boot/dts/s3c6410-smdk6410.dts
new file mode 100644
index 0000000..91341a5
--- /dev/null
+++ b/arch/arm/boot/dts/s3c6410-smdk6410.dts
@@ -0,0 +1,93 @@
+/*
+ * Samsung S3C6410 based SMDK6410 board device tree source.
+ *
+ * Copyright (c) 2013 Tomasz Figa <tomasz.figa@gmail.com>
+ *
+ * Device tree source file for SAMSUNG SMDK6410 board which is based on
+ * Samsung's S3C6410 SoC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+
+#include <dt-bindings/gpio/gpio.h>
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#include "s3c6410.dtsi"
+
+/ {
+	model = "SAMSUNG SMDK6410 board based on S3C6410";
+	compatible = "samsung,mini6410", "samsung,s3c6410";
+
+	memory {
+		reg = <0x50000000 0x8000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC0,115200n8 earlyprintk rootwait root=/dev/mmcblk0p1";
+	};
+
+	fixed-rate-clocks {
+		xxti {
+			compatible = "samsung,clock-fin-pll";
+			clock-frequency = <12000000>;
+		};
+
+		xusbxti {
+			compatible = "samsung,clock-xusbxti";
+			clock-frequency = <48000000>;
+		};
+	};
+
+	srom-cs1@18000000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x18000000 0x8000000>;
+		ranges;
+
+		ethernet@18000000 {
+			compatible = "smsc,lan9115";
+			reg = <0x18000000 0x10000>;
+			interrupt-parent = <&gpn>;
+			interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
+			phy-mode = "mii";
+			reg-io-width = <4>;
+			smsc,force-internal-phy;
+		};
+	};
+};
+
+&sdhci0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&sd0_clk>, <&sd0_cmd>, <&sd0_cd>, <&sd0_bus4>;
+	bus-width = <4>;
+	status = "okay";
+};
+
+&uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_data>, <&uart0_fctl>;
+	status = "okay";
+};
+
+&uart1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart1_data>;
+	status = "okay";
+};
+
+&uart2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_data>;
+	status = "okay";
+};
+
+&uart3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart3_data>;
+	status = "okay";
+};
-- 
1.8.2.1


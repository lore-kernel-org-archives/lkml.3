Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaG1MSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:18:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaG1MSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:18:24 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org, Hakjoo Kim <ruppi.kim@hardkernel.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 2/5] ARM: dts: exynos5410: Prepare ODROID-XU device tree
Date: Mon, 28 Jul 2014 14:18:09 +0200
Message-Id: <1406549892-5558-3-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406549892-5558-1-git-send-email-afaerber@suse.de>
References: <1406549892-5558-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Derived from exynos5410-smdk5410.dts.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 arch/arm/boot/dts/Makefile                |  1 +
 arch/arm/boot/dts/exynos5410-odroidxu.dts | 86 +++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100644 arch/arm/boot/dts/exynos5410-odroidxu.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 80a781f76e88..13fb64eeee10 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -77,6 +77,7 @@ dtb-$(CONFIG_ARCH_EXYNOS) += exynos4210-origen.dtb \
 	exynos5250-smdk5250.dtb \
 	exynos5250-snow.dtb \
 	exynos5260-xyref5260.dtb \
+	exynos5410-odroidxu.dtb \
 	exynos5410-smdk5410.dtb \
 	exynos5420-arndale-octa.dtb \
 	exynos5420-peach-pit.dtb \
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
new file mode 100644
index 000000000000..b67112bf062a
--- /dev/null
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -0,0 +1,86 @@
+/*
+ * Hardkernel ODROID-XU device tree source
+ *
+ * Copyright (c) 2014 SUSE LINUX Products GmbH
+ *
+ * Based on exynos5410-smdk5410.dts:
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/dts-v1/;
+#include "exynos5410.dtsi"
+/ {
+	model = "ODROID-XU based on EXYNOS5410";
+	compatible = "hardkernel,odroid-xu", "samsung,exynos5410", "samsung,exynos5";
+
+	memory {
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttySAC2,115200";
+	};
+
+	fin_pll: xxti {
+		compatible = "fixed-clock";
+		clock-frequency = <24000000>;
+		clock-output-names = "fin_pll";
+		#clock-cells = <0>;
+	};
+
+	firmware@02037000 {
+		compatible = "samsung,secure-firmware";
+		reg = <0x02037000 0x1000>;
+	};
+
+};
+
+&mmc_0 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	broken-cd;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <8>;
+	};
+};
+
+&mmc_2 {
+	status = "okay";
+	num-slots = <1>;
+	supports-highspeed;
+	card-detect-delay = <200>;
+	samsung,dw-mshc-ciu-div = <3>;
+	samsung,dw-mshc-sdr-timing = <2 3>;
+	samsung,dw-mshc-ddr-timing = <1 2>;
+
+	slot@0 {
+		reg = <0>;
+		bus-width = <4>;
+		disable-wp;
+	};
+};
+
+&uart0 {
+	status = "okay";
+};
+
+&uart1 {
+	status = "okay";
+};
+
+&uart2 {
+	status = "okay";
+};
-- 
1.9.3


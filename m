Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaEZVdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:33:42 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51404 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaEZVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:33:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
Date: Mon, 26 May 2014 23:33:29 +0200
Message-Id: <1401140009-31505-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Mainlining effort for SolidRun CuBox has been carried out on the
Engineering Sample, the board DTS was reflecting this. Actually,
SolidRun CuBox comes in three different variants: Engineering Sample (ES),
production with 1GB RAM (1G), and production with 2GB RAM (2G).

Therefore, we split the current dove-cubox.dts into a common board include
and one board dts for each of the above variants.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/Makefile                         |  4 +++-
 arch/arm/boot/dts/dove-cubox-1g.dts                | 17 ++++++++++++++++
 arch/arm/boot/dts/dove-cubox-2g.dts                | 17 ++++++++++++++++
 arch/arm/boot/dts/dove-cubox-es.dts                | 23 ++++++++++++++++++++++
 .../boot/dts/{dove-cubox.dts => dove-cubox.dtsi}   | 17 ----------------
 5 files changed, 60 insertions(+), 18 deletions(-)
 create mode 100644 arch/arm/boot/dts/dove-cubox-1g.dts
 create mode 100644 arch/arm/boot/dts/dove-cubox-2g.dts
 create mode 100644 arch/arm/boot/dts/dove-cubox-es.dts
 rename arch/arm/boot/dts/{dove-cubox.dts => dove-cubox.dtsi} (86%)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 35c146f31e46..40a008539c0c 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -404,7 +404,9 @@ dtb-$(CONFIG_MACH_ARMADA_XP) += \
 	armada-xp-matrix.dtb \
 	armada-xp-openblocks-ax3-4.dtb
 dtb-$(CONFIG_MACH_DOVE) += dove-cm-a510.dtb \
-	dove-cubox.dtb \
+	dove-cubox-1g.dtb \
+	dove-cubox-2g.dtb \
+	dove-cubox-es.dtb \
 	dove-d2plug.dtb \
 	dove-d3plug.dtb \
 	dove-dove-db.dtb
diff --git a/arch/arm/boot/dts/dove-cubox-1g.dts b/arch/arm/boot/dts/dove-cubox-1g.dts
new file mode 100644
index 000000000000..eebd3f7ca7e6
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cubox-1g.dts
@@ -0,0 +1,17 @@
+/dts-v1/;
+
+#include "dove-cubox.dtsi"
+
+/ {
+	model = "SolidRun CuBox (1G)";
+	compatible = "solidrun,cubox-1g", "solidrun,cubox", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+};
diff --git a/arch/arm/boot/dts/dove-cubox-2g.dts b/arch/arm/boot/dts/dove-cubox-2g.dts
new file mode 100644
index 000000000000..513b6a68eba3
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cubox-2g.dts
@@ -0,0 +1,17 @@
+/dts-v1/;
+
+#include "dove-cubox.dtsi"
+
+/ {
+	model = "SolidRun CuBox (2G)";
+	compatible = "solidrun,cubox-2g", "solidrun,cubox", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+};
diff --git a/arch/arm/boot/dts/dove-cubox-es.dts b/arch/arm/boot/dts/dove-cubox-es.dts
new file mode 100644
index 000000000000..5fc17ce34c98
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cubox-es.dts
@@ -0,0 +1,23 @@
+/dts-v1/;
+
+#include "dove-cubox.dtsi"
+
+/ {
+	model = "SolidRun CuBox (ES)";
+	compatible = "solidrun,cubox-es", "solidrun,cubox", "marvell,dove";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n8 earlyprintk";
+	};
+};
+
+&sdio0 {
+	/* sdio0 card detect is connected to wrong pin on CuBox */
+	cd-gpios = <&gpio0 12 1>;
+	pinctrl-0 = <&pmx_sdio0 &pmx_gpio_12>;
+};
diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dtsi
similarity index 86%
rename from arch/arm/boot/dts/dove-cubox.dts
rename to arch/arm/boot/dts/dove-cubox.dtsi
index 7a70f4ca502a..5752d729cc71 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dtsi
@@ -1,20 +1,6 @@
-/dts-v1/;
-
 #include "dove.dtsi"
 
 / {
-	model = "SolidRun CuBox";
-	compatible = "solidrun,cubox", "marvell,dove";
-
-	memory {
-		device_type = "memory";
-		reg = <0x00000000 0x40000000>;
-	};
-
-	chosen {
-		bootargs = "console=ttyS0,115200n8 earlyprintk";
-	};
-
 	leds {
 		compatible = "gpio-leds";
 		pinctrl-0 = <&pmx_gpio_18>;
@@ -111,9 +97,6 @@
 
 &sdio0 {
 	status = "okay";
-	/* sdio0 card detect is connected to wrong pin on CuBox */
-	cd-gpios = <&gpio0 12 1>;
-	pinctrl-0 = <&pmx_sdio0 &pmx_gpio_12>;
 };
 
 &spi0 {
-- 
1.9.1


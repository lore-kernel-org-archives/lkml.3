Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaE0WAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:00:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35971 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaE0WAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:00:17 -0400
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
Subject: [PATCH v2 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
Date: Wed, 28 May 2014 00:00:06 +0200
Message-Id: <1401228006-3212-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1401140009-31505-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1401140009-31505-2-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Mainlining effort for SolidRun CuBox has been carried out on the
Engineering Sample, the board DTS was reflecting this. Actually,
SolidRun CuBox comes in three different variants:
Engineering Sample (ES), production with 1GB RAM (1G),
and production with 2GB RAM (2G).

Therefore, we base current dove-cubox.dts on to the 1G production
variant and add a ES dts to add required quirk for misrouted SDHCI
card detect on top of dove-cubox.dts. For the 2G variant we rely on
the bootloader to setup correct RAM size.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- drop 2G board dts and rely on bootloader (Suggested by Jason Cooper)
- rework board files to allow to include 1G into ES and add quirks only

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
 arch/arm/boot/dts/Makefile          |  1 +
 arch/arm/boot/dts/dove-cubox-es.dts | 12 ++++++++++++
 arch/arm/boot/dts/dove-cubox.dts    |  3 ---
 3 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/dove-cubox-es.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 35c146f31e46..e7fec04e659d 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -405,6 +405,7 @@ dtb-$(CONFIG_MACH_ARMADA_XP) += \
 	armada-xp-openblocks-ax3-4.dtb
 dtb-$(CONFIG_MACH_DOVE) += dove-cm-a510.dtb \
 	dove-cubox.dtb \
+	dove-cubox-es.dtb \
 	dove-d2plug.dtb \
 	dove-d3plug.dtb \
 	dove-dove-db.dtb
diff --git a/arch/arm/boot/dts/dove-cubox-es.dts b/arch/arm/boot/dts/dove-cubox-es.dts
new file mode 100644
index 000000000000..e28ef056dd17
--- /dev/null
+++ b/arch/arm/boot/dts/dove-cubox-es.dts
@@ -0,0 +1,12 @@
+#include "dove-cubox.dts"
+
+/ {
+	model = "SolidRun CuBox (Engineering Sample)";
+	compatible = "solidrun,cubox-es", "solidrun,cubox", "marvell,dove";
+};
+
+&sdio0 {
+	/* sdio0 card detect is connected to wrong pin on CuBox ES */
+	cd-gpios = <&gpio0 12 1>;
+	pinctrl-0 = <&pmx_sdio0 &pmx_gpio_12>;
+};
diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index 7a70f4ca502a..aae7efc09b0b 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -111,9 +111,6 @@
 
 &sdio0 {
 	status = "okay";
-	/* sdio0 card detect is connected to wrong pin on CuBox */
-	cd-gpios = <&gpio0 12 1>;
-	pinctrl-0 = <&pmx_sdio0 &pmx_gpio_12>;
 };
 
 &spi0 {
-- 
1.9.1


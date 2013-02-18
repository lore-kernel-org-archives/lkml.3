Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab3BRGbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:31:08 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40387 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab3BRGbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:31:04 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: [RFC 8/8] ARM: dts: am43-pre-silicon support
Date: Mon, 18 Feb 2013 12:00:46 +0530
Message-ID: <e344f74da47579c11db68d9f6efe25259ed7f25d.1361166003.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1361166003.git.afzal@ti.com>
References: <cover.1361166003.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM43 SoC is in pre-silicon stage, meanwhile it has been modelled in
a pre-silicon platform. To validate and boot Linux in pre-silicon
platform that emulates an AM43 SoC, add DT build support.

As bootloader is not used, bootargs is passed through DT.

Note: This would be replaced by an original board support.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/boot/dts/Makefile             |  3 ++-
 arch/arm/boot/dts/am43-pre-silicon.dts | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/am43-pre-silicon.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 94d88b9..b434344 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -124,7 +124,8 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap5-evm.dtb \
 	am335x-evm.dtb \
 	am335x-evmsk.dtb \
-	am335x-bone.dtb
+	am335x-bone.dtb \
+	am43-pre-silicon.dtb
 dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
diff --git a/arch/arm/boot/dts/am43-pre-silicon.dts b/arch/arm/boot/dts/am43-pre-silicon.dts
new file mode 100644
index 0000000..b9c6297
--- /dev/null
+++ b/arch/arm/boot/dts/am43-pre-silicon.dts
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* AM43 Pre Silicon */
+
+/dts-v1/;
+
+/include/ "am4372.dtsi"
+
+/ {
+	model = "TI AM43 Pre Silicon";
+	compatible = "ti,am43-pre-silicon","ti,am4372","ti,am43";
+
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x10000000>; /* 256 MB */
+	};
+
+	chosen {
+		bootargs = "console=ttyO0,115200n8 root=/dev/ram rw initrd=0x82000000,32MB earlyprintk";
+	};
+};
+
+&twd1 {
+	clock-frequency = <300000000>;
+};
-- 
1.7.12


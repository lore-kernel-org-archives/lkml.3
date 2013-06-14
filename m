Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3FNOE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:04:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49990 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3FNOEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:04:25 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: dts: AM43x EPOS EVM support
Date: Fri, 14 Jun 2013 19:33:34 +0530
Message-ID: <1371218614-26311-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AM43x ePOS EVM minimal DT source - this is a minimal one to get
it booting. Also include it in omap2plus dtbs and document bindings.
The hardware is under development.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

Hi Benoit,

This is based on your for_3.11/dts branch.

Ideally I wanted to split this into 3 patches - first doc, second dts
and last adding build support. As changes in total is trivial, it was
made a single one.

Regards
Afzal


 Documentation/devicetree/bindings/arm/omap/omap.txt |  3 +++
 arch/arm/boot/dts/Makefile                          |  3 ++-
 arch/arm/boot/dts/am43x-epos-evm.dts                | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/am43x-epos-evm.dts

diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index f8288ea..6d498c7 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -56,3 +56,6 @@ Boards:
 
 - OMAP5 EVM : Evaluation Module
   compatible = "ti,omap5-evm", "ti,omap5"
+
+- AM43x EPOS EVM
+  compatible = "ti,am43x-epos-evm", "ti,am4372", "ti,am43"
diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 8e50761..05da469 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -155,7 +155,8 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	am335x-evmsk.dtb \
 	am335x-bone.dtb \
 	am3517-evm.dtb \
-	am3517_mt_ventoux.dtb
+	am3517_mt_ventoux.dtb \
+	am43x-epos-evm.dtb
 dtb-$(CONFIG_ARCH_ORION5X) += orion5x-lacie-ethernet-disk-mini-v2.dtb
 dtb-$(CONFIG_ARCH_PRIMA2) += prima2-evb.dtb
 dtb-$(CONFIG_ARCH_U8500) += snowball.dtb \
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
new file mode 100644
index 0000000..74174d4
--- /dev/null
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* AM43x EPOS EVM */
+
+/dts-v1/;
+
+#include "am4372.dtsi"
+
+/ {
+	model = "TI AM43x EPOS EVM";
+	compatible = "ti,am43x-epos-evm","ti,am4372","ti,am43";
+};
-- 
1.7.12


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaBSVcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:32:03 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:60950 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaBSVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:32:00 -0500
From: Matt Porter <mporter@linaro.org>
To: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>, Alex Elder <elder@linaro.org>
Subject: [PATCH v2] ARM: dts: remove bcm11351-brt.dts
Date: Wed, 19 Feb 2014 16:31:52 -0500
Message-Id: <1392845512-31333-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM11351 BRT board will never see the light of day. Remove the BRT
dts since it is not maintainable.

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Matt Porter <mporter@linaro.org>
---
Changes since v1:
	- remove bcm11351-brt from Makefile

 arch/arm/boot/dts/Makefile         |  3 +--
 arch/arm/boot/dts/bcm11351-brt.dts | 54 --------------------------------------
 2 files changed, 1 insertion(+), 56 deletions(-)
 delete mode 100644 arch/arm/boot/dts/bcm11351-brt.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 6d1e43d..faf4676 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -47,8 +47,7 @@ dtb-$(CONFIG_ARCH_AT91)	+= sama5d36ek.dtb
 
 dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
-dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
-	bcm28155-ap.dtb
+dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BERLIN) += \
 	berlin2-sony-nsz-gs7.dtb	\
diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
deleted file mode 100644
index 396b704..0000000
--- a/arch/arm/boot/dts/bcm11351-brt.dts
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * Copyright (C) 2012 Broadcom Corporation
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-/dts-v1/;
-
-#include "bcm11351.dtsi"
-
-/ {
-	model = "BCM11351 BRT board";
-	compatible = "brcm,bcm11351-brt", "brcm,bcm11351";
-
-	memory {
-		reg = <0x80000000 0x40000000>; /* 1 GB */
-	};
-
-	uart@3e000000 {
-		status = "okay";
-	};
-
-	sdio1: sdio@3f180000 {
-		max-frequency = <48000000>;
-		status = "okay";
-	};
-
-	sdio2: sdio@3f190000 {
-		non-removable;
-		max-frequency = <48000000>;
-		status = "okay";
-	};
-
-	sdio4: sdio@3f1b0000 {
-		max-frequency = <48000000>;
-		cd-gpios = <&gpio 14 0>;
-		status = "okay";
-	};
-
-	usbotg: usb@3f120000 {
-		status = "okay";
-	};
-
-	usbphy: usb-phy@3f130000 {
-		status = "okay";
-	};
-};
-- 
1.8.4


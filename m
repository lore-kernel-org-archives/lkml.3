Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbbAPQuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:50:12 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:60917 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbbAPQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:50:08 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: swarren@wwwdotorg.org, lee@kernel.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH 4/4] ARM: bcm2835: Use pinctrl header
Date: Fri, 16 Jan 2015 16:49:53 +0000
Message-Id: <1421426993-27264-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V03:K0:waQTkQSOH8KmCnXtGga7Zp1+K15P6uu4OnKsKiylUDCoB7/5hDC
 nB7uf7EgsXtPGaO4eAf/xN84dZaVKpO1NQcyIl8ZlAGgALHopzlhl9fxszLJftaki5ic3b4
 zXlDTsqx+NU4LIbd37Vw9piv0qDYDHpqI0/0NFVsrhjGz27YfM4TyCA6jQSme6fWRACSAi0
 he+hueRoIZS+fX7NH6WPg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts all bcm2835 dts files to use the pinctrl
header file.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts |    4 ++--
 arch/arm/boot/dts/bcm2835-rpi-b.dts      |    4 ++--
 arch/arm/boot/dts/bcm2835-rpi.dtsi       |    8 ++++----
 arch/arm/boot/dts/bcm2835.dtsi           |    3 ++-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
index e479515..668442b 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
@@ -1,5 +1,5 @@
 /dts-v1/;
-/include/ "bcm2835-rpi.dtsi"
+#include "bcm2835-rpi.dtsi"
 
 / {
 	compatible = "raspberrypi,model-b-plus", "brcm,bcm2835";
@@ -25,6 +25,6 @@
 	/* I2S interface */
 	i2s_alt0: i2s_alt0 {
 		brcm,pins = <18 19 20 21>;
-		brcm,function = <4>; /* alt0 */
+		brcm,function = <BCM2835_FSEL_ALT0>;
 	};
 };
diff --git a/arch/arm/boot/dts/bcm2835-rpi-b.dts b/arch/arm/boot/dts/bcm2835-rpi-b.dts
index bafa46f..ee89b79 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-b.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-b.dts
@@ -1,5 +1,5 @@
 /dts-v1/;
-/include/ "bcm2835-rpi.dtsi"
+#include "bcm2835-rpi.dtsi"
 
 / {
 	compatible = "raspberrypi,model-b", "brcm,bcm2835";
@@ -18,6 +18,6 @@
 	/* I2S interface */
 	i2s_alt2: i2s_alt2 {
 		brcm,pins = <28 29 30 31>;
-		brcm,function = <6>; /* alt2 */
+		brcm,function = <BCM2835_FSEL_ALT2>;
 	};
 };
diff --git a/arch/arm/boot/dts/bcm2835-rpi.dtsi b/arch/arm/boot/dts/bcm2835-rpi.dtsi
index c706448..46780bb 100644
--- a/arch/arm/boot/dts/bcm2835-rpi.dtsi
+++ b/arch/arm/boot/dts/bcm2835-rpi.dtsi
@@ -1,4 +1,4 @@
-/include/ "bcm2835.dtsi"
+#include "bcm2835.dtsi"
 
 / {
 	memory {
@@ -21,17 +21,17 @@
 
 	gpioout: gpioout {
 		brcm,pins = <6>;
-		brcm,function = <1>; /* GPIO out */
+		brcm,function = <BCM2835_FSEL_GPIO_OUT>;
 	};
 
 	alt0: alt0 {
 		brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
-		brcm,function = <4>; /* alt0 */
+		brcm,function = <BCM2835_FSEL_ALT0>;
 	};
 
 	alt3: alt3 {
 		brcm,pins = <48 49 50 51 52 53>;
-		brcm,function = <7>; /* alt3 */
+		brcm,function = <BCM2835_FSEL_ALT3>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 3342cb1..be9c914 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -1,4 +1,5 @@
-/include/ "skeleton.dtsi"
+#include <dt-bindings/pinctrl/bcm2835.h>
+#include "skeleton.dtsi"
 
 / {
 	compatible = "brcm,bcm2835";
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIVMCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:02:10 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63977 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaIVMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:02:08 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH] ARM: dts: s3c64xx: Enable PWM node by default
Date: Mon, 22 Sep 2014 14:01:57 +0200
Message-Id: <1411387317-4837-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM block is required for system clock source so it must be always
enabled. This patch fixes boot issues on SMDK6410 which did not have the
node enabled explicitly for other purposes.

Fixes: eeb93d02c5d8 ("clocksource: of: Respect device tree node status")
Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/s3c6410-mini6410.dts | 4 ----
 arch/arm/boot/dts/s3c64xx.dtsi         | 1 -
 2 files changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
index a171cdd26b7f..42c2bcdf2626 100644
--- a/arch/arm/boot/dts/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -252,10 +252,6 @@
 	status = "okay";
 };
 
-&pwm {
-	status = "okay";
-};
-
 &pinctrl0 {
 	gpio_leds: gpio-leds {
 		samsung,pins = "gpk-4", "gpk-5", "gpk-6", "gpk-7";
diff --git a/arch/arm/boot/dts/s3c64xx.dtsi b/arch/arm/boot/dts/s3c64xx.dtsi
index 05c717ad1edd..196fe6ea205d 100644
--- a/arch/arm/boot/dts/s3c64xx.dtsi
+++ b/arch/arm/boot/dts/s3c64xx.dtsi
@@ -239,7 +239,6 @@
 			clocks = <&clocks PCLK_PWM>;
 			samsung,pwm-outputs = <0>, <1>;
 			#pwm-cells = <3>;
-			status = "disabled";
 		};
 
 		pinctrl0: pinctrl@7f008000 {
-- 
2.1.0


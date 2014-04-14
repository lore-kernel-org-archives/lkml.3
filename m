Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaDNJyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:54:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:42716 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaDNJyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:54:46 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 2/2] ARM: at91: localize GPIO header
Date: Mon, 14 Apr 2014 11:54:39 +0200
Message-ID: <935dbc5bc3500bfbf90137929bed4d0bbe151fe9.1397468934.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cb4eece4e6fadca4627a869bfe6efb3d41c66700.1397468934.git.nicolas.ferre@atmel.com>
References: <cb4eece4e6fadca4627a869bfe6efb3d41c66700.1397468934.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This moves the <mach/gpio.h> header in the AT91 platform down
into the machine directory and removes the reliance on
MACH_NEED_GPIO_H from the AT91.

This does not move the platform to GENERIC_GPIO but localize
the remaining work to be done for this to the mach-at91
folder.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[nicolas.ferre@atmel.com: adapt to newer kernel, add rsi-ews board]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
ChangeLog v3->v4:
- removal of board-qil-a9260.c board as it was moved to DT in 3.15
- modification of board-rsi-ews.c needed to avoid compilation issue
- dependency on a path to remove a call to mach/gpio.h in a sound driver
  (sam9g20_wm8731.c)

ChangeLog v2->v3:

- Move a symbol from the pinctrl driver that was for some reason
  put into the <mach/gpio.h> header over to the <mach/hardware>
  file. Add FIXME to investigate the proper solution for this.

 arch/arm/Kconfig                           |   1 -
 arch/arm/mach-at91/at91rm9200_devices.c    |   1 +
 arch/arm/mach-at91/at91sam9260_devices.c   |   2 +-
 arch/arm/mach-at91/at91sam9261_devices.c   |   2 +-
 arch/arm/mach-at91/at91sam9263_devices.c   |   1 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |   1 +
 arch/arm/mach-at91/at91sam9rl_devices.c    |   1 +
 arch/arm/mach-at91/board-1arm.c            |   2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c     |   1 +
 arch/arm/mach-at91/board-cam60.c           |   1 +
 arch/arm/mach-at91/board-carmeva.c         |   1 +
 arch/arm/mach-at91/board-cpu9krea.c        |   1 +
 arch/arm/mach-at91/board-cpuat91.c         |   2 +
 arch/arm/mach-at91/board-csb337.c          |   2 +-
 arch/arm/mach-at91/board-csb637.c          |   1 +
 arch/arm/mach-at91/board-eb9200.c          |   1 +
 arch/arm/mach-at91/board-ecbat91.c         |   1 +
 arch/arm/mach-at91/board-eco920.c          |   2 +
 arch/arm/mach-at91/board-flexibity.c       |   1 +
 arch/arm/mach-at91/board-foxg20.c          |   1 +
 arch/arm/mach-at91/board-gsia18s.c         |   1 +
 arch/arm/mach-at91/board-kafa.c            |   1 +
 arch/arm/mach-at91/board-kb9202.c          |   1 +
 arch/arm/mach-at91/board-pcontrol-g20.c    |   1 +
 arch/arm/mach-at91/board-picotux200.c      |   1 +
 arch/arm/mach-at91/board-rm9200ek.c        |   1 +
 arch/arm/mach-at91/board-rsi-ews.c         |   1 +
 arch/arm/mach-at91/board-sam9-l9260.c      |   1 +
 arch/arm/mach-at91/board-sam9260ek.c       |   1 +
 arch/arm/mach-at91/board-sam9261ek.c       |   1 +
 arch/arm/mach-at91/board-sam9263ek.c       |   1 +
 arch/arm/mach-at91/board-sam9g20ek.c       |   1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c    |   1 +
 arch/arm/mach-at91/board-sam9rlek.c        |   1 +
 arch/arm/mach-at91/board-snapper9260.c     |   1 +
 arch/arm/mach-at91/board-stamp9g20.c       |   1 +
 arch/arm/mach-at91/board-yl-9200.c         |   1 +
 arch/arm/mach-at91/gpio.c                  |   1 +
 arch/arm/mach-at91/gpio.h                  | 214 +++++++++++++++++++++++++++
 arch/arm/mach-at91/include/mach/gpio.h     | 222 -----------------------------
 arch/arm/mach-at91/include/mach/hardware.h |  15 ++
 arch/arm/mach-at91/leds.c                  |   1 +
 arch/arm/mach-at91/pm.c                    |   1 +
 43 files changed, 270 insertions(+), 227 deletions(-)
 create mode 100644 arch/arm/mach-at91/gpio.h
 delete mode 100644 arch/arm/mach-at91/include/mach/gpio.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb5af55..7d401e5ad07a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -375,7 +375,6 @@ config ARCH_AT91
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select IRQ_DOMAIN
-	select NEED_MACH_GPIO_H
 	select NEED_MACH_IO_H if PCCARD
 	select PINCTRL
 	select PINCTRL_AT91 if USE_OF
diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index f3f19f21352a..4860918b411e 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -25,6 +25,7 @@
 
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 8b1b0a870025..845e61e99fde 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -29,7 +29,7 @@
 
 #include "board.h"
 #include "generic.h"
-
+#include "gpio.h"
 
 /* --------------------------------------------------------------------
  *  USB Host
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index 80e35895d28f..43b21f456f6e 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -29,7 +29,7 @@
 
 #include "board.h"
 #include "generic.h"
-
+#include "gpio.h"
 
 /* --------------------------------------------------------------------
  *  USB Host
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index 43d53d6156dd..953616e5dbcb 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -28,6 +28,7 @@
 
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 77b04c2edd78..69e01adf5d99 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -39,6 +39,7 @@
 #include "board.h"
 #include "generic.h"
 #include "clock.h"
+#include "gpio.h"
 
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 428fc412aaf1..ba7ebd9dd4bb 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -26,6 +26,7 @@
 
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 /* --------------------------------------------------------------------
diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
index 35ab632bbf68..3f6dbcc34022 100644
--- a/arch/arm/mach-at91/board-1arm.c
+++ b/arch/arm/mach-at91/board-1arm.c
@@ -39,7 +39,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
-
+#include "gpio.h"
 
 static void __init onearm_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index f95e31cda4b3..597c649170aa 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -46,6 +46,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init afeb9260_init_early(void)
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index 112e867c4abe..a30502c8d379 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -44,6 +44,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init cam60_init_early(void)
diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
index 92983050a9bd..47313d3ee037 100644
--- a/arch/arm/mach-at91/board-carmeva.c
+++ b/arch/arm/mach-at91/board-carmeva.c
@@ -39,6 +39,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init carmeva_init_early(void)
diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
index 008527efdbcf..2037f78c84e7 100644
--- a/arch/arm/mach-at91/board-cpu9krea.c
+++ b/arch/arm/mach-at91/board-cpu9krea.c
@@ -48,6 +48,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 static void __init cpu9krea_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
index 42f1353a4baf..c094350c9314 100644
--- a/arch/arm/mach-at91/board-cpuat91.c
+++ b/arch/arm/mach-at91/board-cpuat91.c
@@ -43,6 +43,8 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
+
 
 static struct gpio_led cpuat91_leds[] = {
 	{
diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
index e5fde215225b..0e35a45cf8d4 100644
--- a/arch/arm/mach-at91/board-csb337.c
+++ b/arch/arm/mach-at91/board-csb337.c
@@ -42,7 +42,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
-
+#include "gpio.h"
 
 static void __init csb337_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
index fdf11061c577..18d027f529a8 100644
--- a/arch/arm/mach-at91/board-csb637.c
+++ b/arch/arm/mach-at91/board-csb637.c
@@ -39,6 +39,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init csb637_init_early(void)
diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
index f9be8161bbfa..aa457a8b22f5 100644
--- a/arch/arm/mach-at91/board-eb9200.c
+++ b/arch/arm/mach-at91/board-eb9200.c
@@ -38,6 +38,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init eb9200_init_early(void)
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index b2fcd71262ba..ede1373ccaba 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -42,6 +42,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ecb_at91init_early(void)
diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
index 77de410efc90..4e75321a8f2a 100644
--- a/arch/arm/mach-at91/board-eco920.c
+++ b/arch/arm/mach-at91/board-eco920.c
@@ -31,6 +31,8 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
+
 
 static void __init eco920_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
index 737c08563628..68f1ab6bd08f 100644
--- a/arch/arm/mach-at91/board-flexibity.c
+++ b/arch/arm/mach-at91/board-flexibity.c
@@ -37,6 +37,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 static void __init flexibity_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
index c20a870ea9c9..8b22c60bb238 100644
--- a/arch/arm/mach-at91/board-foxg20.c
+++ b/arch/arm/mach-at91/board-foxg20.c
@@ -47,6 +47,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 /*
  * The FOX Board G20 hardware comes as the "Netus G20" board with
diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
index 416bae8435ee..b729dd1271bf 100644
--- a/arch/arm/mach-at91/board-gsia18s.c
+++ b/arch/arm/mach-at91/board-gsia18s.c
@@ -39,6 +39,7 @@
 #include "generic.h"
 #include "gsia18s.h"
 #include "stamp9g20.h"
+#include "gpio.h"
 
 static void __init gsia18s_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
index 88e2f5d2d16d..93b1df42f639 100644
--- a/arch/arm/mach-at91/board-kafa.c
+++ b/arch/arm/mach-at91/board-kafa.c
@@ -39,6 +39,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init kafa_init_early(void)
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index 0c519d9ebffc..d58d36225e08 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -42,6 +42,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init kb9202_init_early(void)
diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
index 5f25fa54eb93..b48d95ec5152 100644
--- a/arch/arm/mach-at91/board-pcontrol-g20.c
+++ b/arch/arm/mach-at91/board-pcontrol-g20.c
@@ -37,6 +37,7 @@
 #include "sam9_smc.h"
 #include "generic.h"
 #include "stamp9g20.h"
+#include "gpio.h"
 
 
 static void __init pcontrol_g20_init_early(void)
diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
index ab2b2ec36c14..2c0f2d554d84 100644
--- a/arch/arm/mach-at91/board-picotux200.c
+++ b/arch/arm/mach-at91/board-picotux200.c
@@ -43,6 +43,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init picotux200_init_early(void)
diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
index 8b17dadc1aba..953cea416754 100644
--- a/arch/arm/mach-at91/board-rm9200ek.c
+++ b/arch/arm/mach-at91/board-rm9200ek.c
@@ -45,6 +45,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
index f6d7f1958c7e..f28e8b74df4b 100644
--- a/arch/arm/mach-at91/board-rsi-ews.c
+++ b/arch/arm/mach-at91/board-rsi-ews.c
@@ -31,6 +31,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 static void __init rsi_ews_init_early(void)
 {
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index 43ee4dc43b50..d24dda67e2d3 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -43,6 +43,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index f4f8735315da..65dea12d685e 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -49,6 +49,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index 473546b9408b..4637432de08f 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -53,6 +53,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 2f931915c80c..cd2726ee5add 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -52,6 +52,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index f9cd1f2c7146..e1be6e25b380 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -50,6 +50,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 /*
  * board revision encoding
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index ef39078c8ce2..5cd95ede623e 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -50,6 +50,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index 604eecf6cd70..6b81e4671646 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -38,6 +38,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init ek_init_early(void)
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index f1d49e929ccb..1b870e6def0c 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -38,6 +38,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 #define SNAPPER9260_IO_EXP_GPIO(x)	(NR_BUILTIN_GPIO + (x))
 
diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
index e4a5ac17cdbc..3b575036ff96 100644
--- a/arch/arm/mach-at91/board-stamp9g20.c
+++ b/arch/arm/mach-at91/board-stamp9g20.c
@@ -32,6 +32,7 @@
 #include "board.h"
 #include "sam9_smc.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 void __init stamp9g20_init_early(void)
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index be083771df2e..46fdb0c68a68 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -50,6 +50,7 @@
 #include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
+#include "gpio.h"
 
 
 static void __init yl9200_init_early(void)
diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
index a5afcf76550e..12ed05bbdc5c 100644
--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -29,6 +29,7 @@
 #include <mach/at91_pio.h>
 
 #include "generic.h"
+#include "gpio.h"
 
 #define MAX_NB_GPIO_PER_BANK	32
 
diff --git a/arch/arm/mach-at91/gpio.h b/arch/arm/mach-at91/gpio.h
new file mode 100644
index 000000000000..eed465ab0dd7
--- /dev/null
+++ b/arch/arm/mach-at91/gpio.h
@@ -0,0 +1,214 @@
+/*
+ * arch/arm/mach-at91/include/mach/gpio.h
+ *
+ *  Copyright (C) 2005 HP Labs
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef __ASM_ARCH_AT91RM9200_GPIO_H
+#define __ASM_ARCH_AT91RM9200_GPIO_H
+
+#include <linux/kernel.h>
+#include <asm/irq.h>
+
+#define MAX_GPIO_BANKS		5
+#define NR_BUILTIN_GPIO		(MAX_GPIO_BANKS * 32)
+
+/* these pin numbers double as IRQ numbers, like AT91xxx_ID_* values */
+
+#define	AT91_PIN_PA0	(0x00 + 0)
+#define	AT91_PIN_PA1	(0x00 + 1)
+#define	AT91_PIN_PA2	(0x00 + 2)
+#define	AT91_PIN_PA3	(0x00 + 3)
+#define	AT91_PIN_PA4	(0x00 + 4)
+#define	AT91_PIN_PA5	(0x00 + 5)
+#define	AT91_PIN_PA6	(0x00 + 6)
+#define	AT91_PIN_PA7	(0x00 + 7)
+#define	AT91_PIN_PA8	(0x00 + 8)
+#define	AT91_PIN_PA9	(0x00 + 9)
+#define	AT91_PIN_PA10	(0x00 + 10)
+#define	AT91_PIN_PA11	(0x00 + 11)
+#define	AT91_PIN_PA12	(0x00 + 12)
+#define	AT91_PIN_PA13	(0x00 + 13)
+#define	AT91_PIN_PA14	(0x00 + 14)
+#define	AT91_PIN_PA15	(0x00 + 15)
+#define	AT91_PIN_PA16	(0x00 + 16)
+#define	AT91_PIN_PA17	(0x00 + 17)
+#define	AT91_PIN_PA18	(0x00 + 18)
+#define	AT91_PIN_PA19	(0x00 + 19)
+#define	AT91_PIN_PA20	(0x00 + 20)
+#define	AT91_PIN_PA21	(0x00 + 21)
+#define	AT91_PIN_PA22	(0x00 + 22)
+#define	AT91_PIN_PA23	(0x00 + 23)
+#define	AT91_PIN_PA24	(0x00 + 24)
+#define	AT91_PIN_PA25	(0x00 + 25)
+#define	AT91_PIN_PA26	(0x00 + 26)
+#define	AT91_PIN_PA27	(0x00 + 27)
+#define	AT91_PIN_PA28	(0x00 + 28)
+#define	AT91_PIN_PA29	(0x00 + 29)
+#define	AT91_PIN_PA30	(0x00 + 30)
+#define	AT91_PIN_PA31	(0x00 + 31)
+
+#define	AT91_PIN_PB0	(0x20 + 0)
+#define	AT91_PIN_PB1	(0x20 + 1)
+#define	AT91_PIN_PB2	(0x20 + 2)
+#define	AT91_PIN_PB3	(0x20 + 3)
+#define	AT91_PIN_PB4	(0x20 + 4)
+#define	AT91_PIN_PB5	(0x20 + 5)
+#define	AT91_PIN_PB6	(0x20 + 6)
+#define	AT91_PIN_PB7	(0x20 + 7)
+#define	AT91_PIN_PB8	(0x20 + 8)
+#define	AT91_PIN_PB9	(0x20 + 9)
+#define	AT91_PIN_PB10	(0x20 + 10)
+#define	AT91_PIN_PB11	(0x20 + 11)
+#define	AT91_PIN_PB12	(0x20 + 12)
+#define	AT91_PIN_PB13	(0x20 + 13)
+#define	AT91_PIN_PB14	(0x20 + 14)
+#define	AT91_PIN_PB15	(0x20 + 15)
+#define	AT91_PIN_PB16	(0x20 + 16)
+#define	AT91_PIN_PB17	(0x20 + 17)
+#define	AT91_PIN_PB18	(0x20 + 18)
+#define	AT91_PIN_PB19	(0x20 + 19)
+#define	AT91_PIN_PB20	(0x20 + 20)
+#define	AT91_PIN_PB21	(0x20 + 21)
+#define	AT91_PIN_PB22	(0x20 + 22)
+#define	AT91_PIN_PB23	(0x20 + 23)
+#define	AT91_PIN_PB24	(0x20 + 24)
+#define	AT91_PIN_PB25	(0x20 + 25)
+#define	AT91_PIN_PB26	(0x20 + 26)
+#define	AT91_PIN_PB27	(0x20 + 27)
+#define	AT91_PIN_PB28	(0x20 + 28)
+#define	AT91_PIN_PB29	(0x20 + 29)
+#define	AT91_PIN_PB30	(0x20 + 30)
+#define	AT91_PIN_PB31	(0x20 + 31)
+
+#define	AT91_PIN_PC0	(0x40 + 0)
+#define	AT91_PIN_PC1	(0x40 + 1)
+#define	AT91_PIN_PC2	(0x40 + 2)
+#define	AT91_PIN_PC3	(0x40 + 3)
+#define	AT91_PIN_PC4	(0x40 + 4)
+#define	AT91_PIN_PC5	(0x40 + 5)
+#define	AT91_PIN_PC6	(0x40 + 6)
+#define	AT91_PIN_PC7	(0x40 + 7)
+#define	AT91_PIN_PC8	(0x40 + 8)
+#define	AT91_PIN_PC9	(0x40 + 9)
+#define	AT91_PIN_PC10	(0x40 + 10)
+#define	AT91_PIN_PC11	(0x40 + 11)
+#define	AT91_PIN_PC12	(0x40 + 12)
+#define	AT91_PIN_PC13	(0x40 + 13)
+#define	AT91_PIN_PC14	(0x40 + 14)
+#define	AT91_PIN_PC15	(0x40 + 15)
+#define	AT91_PIN_PC16	(0x40 + 16)
+#define	AT91_PIN_PC17	(0x40 + 17)
+#define	AT91_PIN_PC18	(0x40 + 18)
+#define	AT91_PIN_PC19	(0x40 + 19)
+#define	AT91_PIN_PC20	(0x40 + 20)
+#define	AT91_PIN_PC21	(0x40 + 21)
+#define	AT91_PIN_PC22	(0x40 + 22)
+#define	AT91_PIN_PC23	(0x40 + 23)
+#define	AT91_PIN_PC24	(0x40 + 24)
+#define	AT91_PIN_PC25	(0x40 + 25)
+#define	AT91_PIN_PC26	(0x40 + 26)
+#define	AT91_PIN_PC27	(0x40 + 27)
+#define	AT91_PIN_PC28	(0x40 + 28)
+#define	AT91_PIN_PC29	(0x40 + 29)
+#define	AT91_PIN_PC30	(0x40 + 30)
+#define	AT91_PIN_PC31	(0x40 + 31)
+
+#define	AT91_PIN_PD0	(0x60 + 0)
+#define	AT91_PIN_PD1	(0x60 + 1)
+#define	AT91_PIN_PD2	(0x60 + 2)
+#define	AT91_PIN_PD3	(0x60 + 3)
+#define	AT91_PIN_PD4	(0x60 + 4)
+#define	AT91_PIN_PD5	(0x60 + 5)
+#define	AT91_PIN_PD6	(0x60 + 6)
+#define	AT91_PIN_PD7	(0x60 + 7)
+#define	AT91_PIN_PD8	(0x60 + 8)
+#define	AT91_PIN_PD9	(0x60 + 9)
+#define	AT91_PIN_PD10	(0x60 + 10)
+#define	AT91_PIN_PD11	(0x60 + 11)
+#define	AT91_PIN_PD12	(0x60 + 12)
+#define	AT91_PIN_PD13	(0x60 + 13)
+#define	AT91_PIN_PD14	(0x60 + 14)
+#define	AT91_PIN_PD15	(0x60 + 15)
+#define	AT91_PIN_PD16	(0x60 + 16)
+#define	AT91_PIN_PD17	(0x60 + 17)
+#define	AT91_PIN_PD18	(0x60 + 18)
+#define	AT91_PIN_PD19	(0x60 + 19)
+#define	AT91_PIN_PD20	(0x60 + 20)
+#define	AT91_PIN_PD21	(0x60 + 21)
+#define	AT91_PIN_PD22	(0x60 + 22)
+#define	AT91_PIN_PD23	(0x60 + 23)
+#define	AT91_PIN_PD24	(0x60 + 24)
+#define	AT91_PIN_PD25	(0x60 + 25)
+#define	AT91_PIN_PD26	(0x60 + 26)
+#define	AT91_PIN_PD27	(0x60 + 27)
+#define	AT91_PIN_PD28	(0x60 + 28)
+#define	AT91_PIN_PD29	(0x60 + 29)
+#define	AT91_PIN_PD30	(0x60 + 30)
+#define	AT91_PIN_PD31	(0x60 + 31)
+
+#define	AT91_PIN_PE0	(0x80 + 0)
+#define	AT91_PIN_PE1	(0x80 + 1)
+#define	AT91_PIN_PE2	(0x80 + 2)
+#define	AT91_PIN_PE3	(0x80 + 3)
+#define	AT91_PIN_PE4	(0x80 + 4)
+#define	AT91_PIN_PE5	(0x80 + 5)
+#define	AT91_PIN_PE6	(0x80 + 6)
+#define	AT91_PIN_PE7	(0x80 + 7)
+#define	AT91_PIN_PE8	(0x80 + 8)
+#define	AT91_PIN_PE9	(0x80 + 9)
+#define	AT91_PIN_PE10	(0x80 + 10)
+#define	AT91_PIN_PE11	(0x80 + 11)
+#define	AT91_PIN_PE12	(0x80 + 12)
+#define	AT91_PIN_PE13	(0x80 + 13)
+#define	AT91_PIN_PE14	(0x80 + 14)
+#define	AT91_PIN_PE15	(0x80 + 15)
+#define	AT91_PIN_PE16	(0x80 + 16)
+#define	AT91_PIN_PE17	(0x80 + 17)
+#define	AT91_PIN_PE18	(0x80 + 18)
+#define	AT91_PIN_PE19	(0x80 + 19)
+#define	AT91_PIN_PE20	(0x80 + 20)
+#define	AT91_PIN_PE21	(0x80 + 21)
+#define	AT91_PIN_PE22	(0x80 + 22)
+#define	AT91_PIN_PE23	(0x80 + 23)
+#define	AT91_PIN_PE24	(0x80 + 24)
+#define	AT91_PIN_PE25	(0x80 + 25)
+#define	AT91_PIN_PE26	(0x80 + 26)
+#define	AT91_PIN_PE27	(0x80 + 27)
+#define	AT91_PIN_PE28	(0x80 + 28)
+#define	AT91_PIN_PE29	(0x80 + 29)
+#define	AT91_PIN_PE30	(0x80 + 30)
+#define	AT91_PIN_PE31	(0x80 + 31)
+
+#ifndef __ASSEMBLY__
+/* setup setup routines, called from board init or driver probe() */
+extern int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_B_periph(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_C_periph(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_D_periph(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_gpio_input(unsigned pin, int use_pullup);
+extern int __init_or_module at91_set_gpio_output(unsigned pin, int value);
+extern int __init_or_module at91_set_deglitch(unsigned pin, int is_on);
+extern int __init_or_module at91_set_debounce(unsigned pin, int is_on, int div);
+extern int __init_or_module at91_set_multi_drive(unsigned pin, int is_on);
+extern int __init_or_module at91_set_pulldown(unsigned pin, int is_on);
+extern int __init_or_module at91_disable_schmitt_trig(unsigned pin);
+
+/* callable at any time */
+extern int at91_set_gpio_value(unsigned pin, int value);
+extern int at91_get_gpio_value(unsigned pin);
+
+/* callable only from core power-management code */
+extern void at91_gpio_suspend(void);
+extern void at91_gpio_resume(void);
+
+#endif	/* __ASSEMBLY__ */
+
+#endif
diff --git a/arch/arm/mach-at91/include/mach/gpio.h b/arch/arm/mach-at91/include/mach/gpio.h
deleted file mode 100644
index 5fc23771c154..000000000000
--- a/arch/arm/mach-at91/include/mach/gpio.h
+++ /dev/null
@@ -1,222 +0,0 @@
-/*
- * arch/arm/mach-at91/include/mach/gpio.h
- *
- *  Copyright (C) 2005 HP Labs
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#ifndef __ASM_ARCH_AT91RM9200_GPIO_H
-#define __ASM_ARCH_AT91RM9200_GPIO_H
-
-#include <linux/kernel.h>
-#include <asm/irq.h>
-
-#define MAX_GPIO_BANKS		5
-#define NR_BUILTIN_GPIO		(MAX_GPIO_BANKS * 32)
-
-/* these pin numbers double as IRQ numbers, like AT91xxx_ID_* values */
-
-#define	AT91_PIN_PA0	(0x00 + 0)
-#define	AT91_PIN_PA1	(0x00 + 1)
-#define	AT91_PIN_PA2	(0x00 + 2)
-#define	AT91_PIN_PA3	(0x00 + 3)
-#define	AT91_PIN_PA4	(0x00 + 4)
-#define	AT91_PIN_PA5	(0x00 + 5)
-#define	AT91_PIN_PA6	(0x00 + 6)
-#define	AT91_PIN_PA7	(0x00 + 7)
-#define	AT91_PIN_PA8	(0x00 + 8)
-#define	AT91_PIN_PA9	(0x00 + 9)
-#define	AT91_PIN_PA10	(0x00 + 10)
-#define	AT91_PIN_PA11	(0x00 + 11)
-#define	AT91_PIN_PA12	(0x00 + 12)
-#define	AT91_PIN_PA13	(0x00 + 13)
-#define	AT91_PIN_PA14	(0x00 + 14)
-#define	AT91_PIN_PA15	(0x00 + 15)
-#define	AT91_PIN_PA16	(0x00 + 16)
-#define	AT91_PIN_PA17	(0x00 + 17)
-#define	AT91_PIN_PA18	(0x00 + 18)
-#define	AT91_PIN_PA19	(0x00 + 19)
-#define	AT91_PIN_PA20	(0x00 + 20)
-#define	AT91_PIN_PA21	(0x00 + 21)
-#define	AT91_PIN_PA22	(0x00 + 22)
-#define	AT91_PIN_PA23	(0x00 + 23)
-#define	AT91_PIN_PA24	(0x00 + 24)
-#define	AT91_PIN_PA25	(0x00 + 25)
-#define	AT91_PIN_PA26	(0x00 + 26)
-#define	AT91_PIN_PA27	(0x00 + 27)
-#define	AT91_PIN_PA28	(0x00 + 28)
-#define	AT91_PIN_PA29	(0x00 + 29)
-#define	AT91_PIN_PA30	(0x00 + 30)
-#define	AT91_PIN_PA31	(0x00 + 31)
-
-#define	AT91_PIN_PB0	(0x20 + 0)
-#define	AT91_PIN_PB1	(0x20 + 1)
-#define	AT91_PIN_PB2	(0x20 + 2)
-#define	AT91_PIN_PB3	(0x20 + 3)
-#define	AT91_PIN_PB4	(0x20 + 4)
-#define	AT91_PIN_PB5	(0x20 + 5)
-#define	AT91_PIN_PB6	(0x20 + 6)
-#define	AT91_PIN_PB7	(0x20 + 7)
-#define	AT91_PIN_PB8	(0x20 + 8)
-#define	AT91_PIN_PB9	(0x20 + 9)
-#define	AT91_PIN_PB10	(0x20 + 10)
-#define	AT91_PIN_PB11	(0x20 + 11)
-#define	AT91_PIN_PB12	(0x20 + 12)
-#define	AT91_PIN_PB13	(0x20 + 13)
-#define	AT91_PIN_PB14	(0x20 + 14)
-#define	AT91_PIN_PB15	(0x20 + 15)
-#define	AT91_PIN_PB16	(0x20 + 16)
-#define	AT91_PIN_PB17	(0x20 + 17)
-#define	AT91_PIN_PB18	(0x20 + 18)
-#define	AT91_PIN_PB19	(0x20 + 19)
-#define	AT91_PIN_PB20	(0x20 + 20)
-#define	AT91_PIN_PB21	(0x20 + 21)
-#define	AT91_PIN_PB22	(0x20 + 22)
-#define	AT91_PIN_PB23	(0x20 + 23)
-#define	AT91_PIN_PB24	(0x20 + 24)
-#define	AT91_PIN_PB25	(0x20 + 25)
-#define	AT91_PIN_PB26	(0x20 + 26)
-#define	AT91_PIN_PB27	(0x20 + 27)
-#define	AT91_PIN_PB28	(0x20 + 28)
-#define	AT91_PIN_PB29	(0x20 + 29)
-#define	AT91_PIN_PB30	(0x20 + 30)
-#define	AT91_PIN_PB31	(0x20 + 31)
-
-#define	AT91_PIN_PC0	(0x40 + 0)
-#define	AT91_PIN_PC1	(0x40 + 1)
-#define	AT91_PIN_PC2	(0x40 + 2)
-#define	AT91_PIN_PC3	(0x40 + 3)
-#define	AT91_PIN_PC4	(0x40 + 4)
-#define	AT91_PIN_PC5	(0x40 + 5)
-#define	AT91_PIN_PC6	(0x40 + 6)
-#define	AT91_PIN_PC7	(0x40 + 7)
-#define	AT91_PIN_PC8	(0x40 + 8)
-#define	AT91_PIN_PC9	(0x40 + 9)
-#define	AT91_PIN_PC10	(0x40 + 10)
-#define	AT91_PIN_PC11	(0x40 + 11)
-#define	AT91_PIN_PC12	(0x40 + 12)
-#define	AT91_PIN_PC13	(0x40 + 13)
-#define	AT91_PIN_PC14	(0x40 + 14)
-#define	AT91_PIN_PC15	(0x40 + 15)
-#define	AT91_PIN_PC16	(0x40 + 16)
-#define	AT91_PIN_PC17	(0x40 + 17)
-#define	AT91_PIN_PC18	(0x40 + 18)
-#define	AT91_PIN_PC19	(0x40 + 19)
-#define	AT91_PIN_PC20	(0x40 + 20)
-#define	AT91_PIN_PC21	(0x40 + 21)
-#define	AT91_PIN_PC22	(0x40 + 22)
-#define	AT91_PIN_PC23	(0x40 + 23)
-#define	AT91_PIN_PC24	(0x40 + 24)
-#define	AT91_PIN_PC25	(0x40 + 25)
-#define	AT91_PIN_PC26	(0x40 + 26)
-#define	AT91_PIN_PC27	(0x40 + 27)
-#define	AT91_PIN_PC28	(0x40 + 28)
-#define	AT91_PIN_PC29	(0x40 + 29)
-#define	AT91_PIN_PC30	(0x40 + 30)
-#define	AT91_PIN_PC31	(0x40 + 31)
-
-#define	AT91_PIN_PD0	(0x60 + 0)
-#define	AT91_PIN_PD1	(0x60 + 1)
-#define	AT91_PIN_PD2	(0x60 + 2)
-#define	AT91_PIN_PD3	(0x60 + 3)
-#define	AT91_PIN_PD4	(0x60 + 4)
-#define	AT91_PIN_PD5	(0x60 + 5)
-#define	AT91_PIN_PD6	(0x60 + 6)
-#define	AT91_PIN_PD7	(0x60 + 7)
-#define	AT91_PIN_PD8	(0x60 + 8)
-#define	AT91_PIN_PD9	(0x60 + 9)
-#define	AT91_PIN_PD10	(0x60 + 10)
-#define	AT91_PIN_PD11	(0x60 + 11)
-#define	AT91_PIN_PD12	(0x60 + 12)
-#define	AT91_PIN_PD13	(0x60 + 13)
-#define	AT91_PIN_PD14	(0x60 + 14)
-#define	AT91_PIN_PD15	(0x60 + 15)
-#define	AT91_PIN_PD16	(0x60 + 16)
-#define	AT91_PIN_PD17	(0x60 + 17)
-#define	AT91_PIN_PD18	(0x60 + 18)
-#define	AT91_PIN_PD19	(0x60 + 19)
-#define	AT91_PIN_PD20	(0x60 + 20)
-#define	AT91_PIN_PD21	(0x60 + 21)
-#define	AT91_PIN_PD22	(0x60 + 22)
-#define	AT91_PIN_PD23	(0x60 + 23)
-#define	AT91_PIN_PD24	(0x60 + 24)
-#define	AT91_PIN_PD25	(0x60 + 25)
-#define	AT91_PIN_PD26	(0x60 + 26)
-#define	AT91_PIN_PD27	(0x60 + 27)
-#define	AT91_PIN_PD28	(0x60 + 28)
-#define	AT91_PIN_PD29	(0x60 + 29)
-#define	AT91_PIN_PD30	(0x60 + 30)
-#define	AT91_PIN_PD31	(0x60 + 31)
-
-#define	AT91_PIN_PE0	(0x80 + 0)
-#define	AT91_PIN_PE1	(0x80 + 1)
-#define	AT91_PIN_PE2	(0x80 + 2)
-#define	AT91_PIN_PE3	(0x80 + 3)
-#define	AT91_PIN_PE4	(0x80 + 4)
-#define	AT91_PIN_PE5	(0x80 + 5)
-#define	AT91_PIN_PE6	(0x80 + 6)
-#define	AT91_PIN_PE7	(0x80 + 7)
-#define	AT91_PIN_PE8	(0x80 + 8)
-#define	AT91_PIN_PE9	(0x80 + 9)
-#define	AT91_PIN_PE10	(0x80 + 10)
-#define	AT91_PIN_PE11	(0x80 + 11)
-#define	AT91_PIN_PE12	(0x80 + 12)
-#define	AT91_PIN_PE13	(0x80 + 13)
-#define	AT91_PIN_PE14	(0x80 + 14)
-#define	AT91_PIN_PE15	(0x80 + 15)
-#define	AT91_PIN_PE16	(0x80 + 16)
-#define	AT91_PIN_PE17	(0x80 + 17)
-#define	AT91_PIN_PE18	(0x80 + 18)
-#define	AT91_PIN_PE19	(0x80 + 19)
-#define	AT91_PIN_PE20	(0x80 + 20)
-#define	AT91_PIN_PE21	(0x80 + 21)
-#define	AT91_PIN_PE22	(0x80 + 22)
-#define	AT91_PIN_PE23	(0x80 + 23)
-#define	AT91_PIN_PE24	(0x80 + 24)
-#define	AT91_PIN_PE25	(0x80 + 25)
-#define	AT91_PIN_PE26	(0x80 + 26)
-#define	AT91_PIN_PE27	(0x80 + 27)
-#define	AT91_PIN_PE28	(0x80 + 28)
-#define	AT91_PIN_PE29	(0x80 + 29)
-#define	AT91_PIN_PE30	(0x80 + 30)
-#define	AT91_PIN_PE31	(0x80 + 31)
-
-#ifndef __ASSEMBLY__
-/* setup setup routines, called from board init or driver probe() */
-extern int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_B_periph(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_C_periph(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_D_periph(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_gpio_input(unsigned pin, int use_pullup);
-extern int __init_or_module at91_set_gpio_output(unsigned pin, int value);
-extern int __init_or_module at91_set_deglitch(unsigned pin, int is_on);
-extern int __init_or_module at91_set_debounce(unsigned pin, int is_on, int div);
-extern int __init_or_module at91_set_multi_drive(unsigned pin, int is_on);
-extern int __init_or_module at91_set_pulldown(unsigned pin, int is_on);
-extern int __init_or_module at91_disable_schmitt_trig(unsigned pin);
-
-/* callable at any time */
-extern int at91_set_gpio_value(unsigned pin, int value);
-extern int at91_get_gpio_value(unsigned pin);
-
-/* callable only from core power-management code */
-extern void at91_gpio_suspend(void);
-extern void at91_gpio_resume(void);
-
-#ifdef CONFIG_PINCTRL_AT91
-extern void at91_pinctrl_gpio_suspend(void);
-extern void at91_pinctrl_gpio_resume(void);
-#else
-static inline void at91_pinctrl_gpio_suspend(void) {}
-static inline void at91_pinctrl_gpio_resume(void) {}
-#endif
-
-#endif	/* __ASSEMBLY__ */
-
-#endif
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index f17aa3150019..56338245653a 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -104,5 +104,20 @@
 /* Clocks */
 #define AT91_SLOW_CLOCK		32768		/* slow clock */
 
+/*
+ * FIXME: this is needed to communicate between the pinctrl driver and
+ * the PM implementation in the machine. Possibly part of the PM
+ * implementation should be moved down into the pinctrl driver and get
+ * called as part of the generic suspend/resume path.
+ */
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_PINCTRL_AT91
+extern void at91_pinctrl_gpio_suspend(void);
+extern void at91_pinctrl_gpio_resume(void);
+#else
+static inline void at91_pinctrl_gpio_suspend(void) {}
+static inline void at91_pinctrl_gpio_resume(void) {}
+#endif
+#endif
 
 #endif
diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
index 3e22978b5547..77c4d8fd03fd 100644
--- a/arch/arm/mach-at91/leds.c
+++ b/arch/arm/mach-at91/leds.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 
 #include "board.h"
+#include "gpio.h"
 
 
 /* ------------------------------------------------------------------------- */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 8bda1cefdf96..e95554532987 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -32,6 +32,7 @@
 #include "at91_aic.h"
 #include "generic.h"
 #include "pm.h"
+#include "gpio.h"
 
 /*
  * Show the reason for the previous system reset.
-- 
1.8.2.2


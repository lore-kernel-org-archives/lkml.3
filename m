Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937795Ab3DKAMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:12:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937364Ab3DKAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 08/30] i2c: s3c2410: make header file local
Date: Thu, 11 Apr 2013 02:04:50 +0200
Message-Id: <1365638712-1028578-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ydMwq0qQt8QSrUBAN9Pozrt64kfk2+Ude1psQqUGWxe
 CEcAzudCW+5k8K70JWOFj1cECbcYw4B3pKAFngJ1fGjAom70aS
 4Zvjatwf6eY+VynARFzVOrnnbZQSRxxiuriFWUvtf1gkLr743f
 9rnpJYTAggUzBgitck1OdcDe25E8QrW1O5mAO7Nq5gKyow4u2d
 65SRfPHIZnN2rI4Ej/vOaArdMxxM0UwUhByzlvA67ZACO+KxMt
 8lScSLGlitXZNAUb3VAgvdQNJEdf8jIKUZEYRiPV4tXndPkHn9
 ceqxX/ttfKSSlNezm1SB1swgfxlriS2KTDN7zJXydeCHXFTK7N
 gC5o5EFbiWhESCAeN63+4/gkb+z/pVFePXoTQqbs/KwxWj6Qp+
 j9uMFL2Y/R+Ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No other file in the kernel besides i2c-s3c2410.c uses the current
plat/regs-iic.h, so we can simply move the header file to live in the
same directory as the driver, as a preparation to multiplatform builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 arch/arm/mach-s3c24xx/mach-rx1950.c                                    | 1 -
 arch/arm/plat-samsung/devs.c                                           | 1 -
 drivers/i2c/busses/i2c-s3c2410.c                                       | 3 ++-
 .../include/plat/regs-iic.h => drivers/i2c/busses/i2c-s3c2410.h        | 0
 4 files changed, 2 insertions(+), 3 deletions(-)
 rename arch/arm/plat-samsung/include/plat/regs-iic.h => drivers/i2c/busses/i2c-s3c2410.h (100%)

diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index e4d67a3..44ca018 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -56,7 +56,6 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/pm.h>
-#include <plat/regs-iic.h>
 #include <plat/regs-serial.h>
 #include <plat/samsung-time.h>
 
diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 4cf660e..78be9c0 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -62,7 +62,6 @@
 #include <linux/platform_data/usb-s3c2410_udc.h>
 #include <linux/platform_data/usb-ohci-s3c2410.h>
 #include <plat/usb-phy.h>
-#include <plat/regs-iic.h>
 #include <plat/regs-serial.h>
 #include <plat/regs-spi.h>
 #include <linux/platform_data/spi-s3c64xx.h>
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index f6b880b..d042ad0 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -42,9 +42,10 @@
 
 #include <asm/irq.h>
 
-#include <plat/regs-iic.h>
 #include <linux/platform_data/i2c-s3c2410.h>
 
+#include "i2c-s3c2410.h"
+
 /* Treat S3C2410 as baseline hardware, anything else is supported via quirks */
 #define QUIRK_S3C2440		(1 << 0)
 #define QUIRK_HDMIPHY		(1 << 1)
diff --git a/arch/arm/plat-samsung/include/plat/regs-iic.h b/drivers/i2c/busses/i2c-s3c2410.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/regs-iic.h
rename to drivers/i2c/busses/i2c-s3c2410.h
-- 
1.8.1.2


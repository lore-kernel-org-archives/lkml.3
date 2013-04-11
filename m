Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937199Ab3DKANs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:13:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937300Ab3DKAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 18/30] ASoC: samsung: move plat/ headers to local directory
Date: Thu, 11 Apr 2013 02:05:00 +0200
Message-Id: <1365638712-1028578-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:80qn5mUHdyccZbF7CN5XZMZCwyTW8IBhI4VhK60X+jD
 a3y5XgBlzEvmNhuf5r5hNao4tlwVr9529LWEDnY4aW7DKXC2Mf
 oY5P3bJ13xJTMeWnsOfYS8FZ20whvNlcA9A3uLXzKyfiwhwdvD
 Fywz+0y3NHjvkwjT6ur4WtyItPYxzRwW4t0xLmrpTjemmhD4i1
 j3aA0tJU17IUZ74siH/u1bKjyOTeNwaLdHqF/bU80CClaAMxXi
 ksSUXH28DC+lm6fCvVb1MiM1fn99GyEPdagFLJkqRhlyJbn9o5
 Jz2rPuKvYC+yisNK5jyXbmjcBpFAuqwxADrIwLNVXJRsibSE1+
 sNNVbuZIpIj+1yRETMwaU5dTq9bUr5QoTeCGdNMJOcPSacsmij
 tgm0To/3DoJfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plat/iis.h and plat/ac97.h files in the samsung platform are
only needed by the ASoC drivers, so they can be moved into the
same directory, as one more step towards a multiplatform build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 arch/arm/mach-s3c24xx/dma-s3c2410.c                                   | 2 --
 arch/arm/mach-s3c24xx/dma-s3c2412.c                                   | 2 --
 arch/arm/mach-s3c24xx/dma-s3c2440.c                                   | 2 --
 arch/arm/mach-s3c24xx/dma-s3c2443.c                                   | 2 --
 sound/soc/samsung/ac97.c                                              | 2 +-
 sound/soc/samsung/h1940_uda1380.c                                     | 2 +-
 sound/soc/samsung/neo1973_wm8753.c                                    | 2 +-
 {arch/arm/plat-samsung/include/plat => sound/soc/samsung}/regs-ac97.h | 0
 {arch/arm/plat-samsung/include/plat => sound/soc/samsung}/regs-iis.h  | 0
 sound/soc/samsung/rx1950_uda1380.c                                    | 2 +-
 sound/soc/samsung/s3c24xx-i2s.c                                       | 2 +-
 sound/soc/samsung/s3c24xx_uda134x.c                                   | 2 +-
 12 files changed, 6 insertions(+), 14 deletions(-)
 rename {arch/arm/plat-samsung/include/plat => sound/soc/samsung}/regs-ac97.h (100%)
 rename {arch/arm/plat-samsung/include/plat => sound/soc/samsung}/regs-iis.h (100%)

diff --git a/arch/arm/mach-s3c24xx/dma-s3c2410.c b/arch/arm/mach-s3c24xx/dma-s3c2410.c
index a6c94b8..30aa53f 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2410.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2410.c
@@ -25,10 +25,8 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 static struct s3c24xx_dma_map __initdata s3c2410_dma_mappings[] = {
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2412.c b/arch/arm/mach-s3c24xx/dma-s3c2412.c
index c0e8c3f..ab1700e 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2412.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2412.c
@@ -25,10 +25,8 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 #define MAP(x) { (x)| DMA_CH_VALID, (x)| DMA_CH_VALID, (x)| DMA_CH_VALID, (x)| DMA_CH_VALID }
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2440.c b/arch/arm/mach-s3c24xx/dma-s3c2440.c
index 1c08eccd..cd25de2 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2440.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2440.c
@@ -25,10 +25,8 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 static struct s3c24xx_dma_map __initdata s3c2440_dma_mappings[] = {
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2443.c b/arch/arm/mach-s3c24xx/dma-s3c2443.c
index 000e4c6..5fe3539 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2443.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2443.c
@@ -25,10 +25,8 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 #define MAP(x) { \
diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index 0df3c56..c76abdf 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -20,7 +20,7 @@
 #include <sound/soc.h>
 
 #include <mach/dma.h>
-#include <plat/regs-ac97.h>
+#include "regs-ac97.h"
 #include <linux/platform_data/asoc-s3c.h>
 
 #include "dma.h"
diff --git a/sound/soc/samsung/h1940_uda1380.c b/sound/soc/samsung/h1940_uda1380.c
index 15a3817..fa91376 100644
--- a/sound/soc/samsung/h1940_uda1380.c
+++ b/sound/soc/samsung/h1940_uda1380.c
@@ -20,7 +20,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 
-#include <plat/regs-iis.h>
+#include "regs-iis.h"
 #include <asm/mach-types.h>
 
 #include "s3c24xx-i2s.h"
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index a301d8c..ccc601d 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -21,7 +21,7 @@
 #include <sound/soc.h>
 
 #include <asm/mach-types.h>
-#include <plat/regs-iis.h>
+#include "regs-iis.h"
 #include <mach/gta02.h>
 
 #include "../codecs/wm8753.h"
diff --git a/arch/arm/plat-samsung/include/plat/regs-ac97.h b/sound/soc/samsung/regs-ac97.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/regs-ac97.h
rename to sound/soc/samsung/regs-ac97.h
diff --git a/arch/arm/plat-samsung/include/plat/regs-iis.h b/sound/soc/samsung/regs-iis.h
similarity index 100%
rename from arch/arm/plat-samsung/include/plat/regs-iis.h
rename to sound/soc/samsung/regs-iis.h
diff --git a/sound/soc/samsung/rx1950_uda1380.c b/sound/soc/samsung/rx1950_uda1380.c
index a5826ea..704460a 100644
--- a/sound/soc/samsung/rx1950_uda1380.c
+++ b/sound/soc/samsung/rx1950_uda1380.c
@@ -24,7 +24,7 @@
 #include <sound/soc.h>
 #include <sound/jack.h>
 
-#include <plat/regs-iis.h>
+#include "regs-iis.h"
 #include <asm/mach-types.h>
 
 #include "s3c24xx-i2s.h"
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index 13f6dd1..a7b17c1 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -24,7 +24,7 @@
 #include <sound/pcm_params.h>
 
 #include <mach/dma.h>
-#include <plat/regs-iis.h>
+#include "regs-iis.h"
 
 #include "dma.h"
 #include "s3c24xx-i2s.h"
diff --git a/sound/soc/samsung/s3c24xx_uda134x.c b/sound/soc/samsung/s3c24xx_uda134x.c
index 333e1b7..1b7b52b 100644
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -18,7 +18,7 @@
 #include <sound/soc.h>
 #include <sound/s3c24xx_uda134x.h>
 
-#include <plat/regs-iis.h>
+#include "regs-iis.h"
 
 #include "s3c24xx-i2s.h"
 
-- 
1.8.1.2


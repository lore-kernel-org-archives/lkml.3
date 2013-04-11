Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3DKRI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:08:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55471 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3DKRI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:08:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 18/30] ASoC: samsung: move plat/ headers to local directory
Date: Thu, 11 Apr 2013 19:08:42 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <1365638712-1028578-19-git-send-email-arnd@arndb.de> <20130411164751.GK9243@opensource.wolfsonmicro.com>
In-Reply-To: <20130411164751.GK9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201304111908.42532.arnd@arndb.de>
X-Provags-ID: V02:K0:sIdt9k3QSG28nuolLB55mo8tu6vOqH5ZmZD33RxKruB
 DYMBvjNrHxdhkDm2OZo1fsefEf7UDsta7my8rhgjIPslmlX29S
 3YHOtwPLP7/EjJme/r8JE3ZrlUQWQzg6Sk3DZ7R4lE7JNAmi4V
 YfrwKK6WgXkpyS47SB0mDO1ShhtJEBidzV0HwCOpn/G17gOC9v
 S5SP5sLZJygfMIdDW7I8+TSOAUmihwAEAW6hshyWEnQSO5xoEb
 2R0DLhbH3dzQFcz9rFcCsJPraPYY3q+2Ss/0SWTQOfYCN9lRAv
 nEPjnR//OJ1PaSHRt7j4b7OwYdJzd96N6+UwaXT+G3H84oINhZ
 rP/KlpzdMP90v7iDGzko=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Mark Brown wrote:
> On Thu, Apr 11, 2013 at 02:05:00AM +0200, Arnd Bergmann wrote:
> > The plat/iis.h and plat/ac97.h files in the samsung platform are
> > only needed by the ASoC drivers, so they can be moved into the
> > same directory, as one more step towards a multiplatform build.
> 
> This doesn't apply to my topic/samsung branch, can you please regenerate
> it against that or let me know what to apply it against?
> 

This one should work. Unfortunately I now found during testing that the
s3c24xx sound support has a few build errors at the moment, but this
patch should not add any new ones:

/git/arm-soc/sound/soc/samsung/idma.c: In function 'idma_close':
/git/arm-soc/sound/soc/samsung/idma.c:327:11: error: 'IRQ_I2S0' undeclared (first use in this function)
  free_irq(IRQ_I2S0, prtd);
           ^
make[5]: *** [sound/soc/samsung/idma.o] Error 1
make[5]: *** Waiting for unfinished jobs....

make[5]: *** [sound/soc/samsung/i2s.o] Error 1
/git/arm-soc/sound/soc/samsung/neo1973_wm8753.c:25:24: fatal error: mach/gta02.h: No such file or directory
 #include <mach/gta02.h>
                        ^


	Arnd

8<----
>From 91cb290e665b10d094729a42f9e676e2de154996 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 16 Mar 2013 09:10:15 +0100
Subject: [PATCH] ASoC: samsung: move plat/ headers to local directory

The plat/regs-iis.h and plat/regs-ac97.h files in the samsung platform
are only needed by the ASoC drivers, so they can be moved into the same
directory, as one more step towards a multiplatform build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>

diff --git a/arch/arm/mach-s3c24xx/dma-s3c2410.c b/arch/arm/mach-s3c24xx/dma-s3c2410.c
index 25d085a..a4a13c9 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2410.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2410.c
@@ -25,11 +25,9 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
 #include <mach/regs-sdi.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 static struct s3c24xx_dma_map __initdata s3c2410_dma_mappings[] = {
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2412.c b/arch/arm/mach-s3c24xx/dma-s3c2412.c
index d2408ba..6eaa7a4 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2412.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2412.c
@@ -25,11 +25,9 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
 #include <mach/regs-sdi.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 #define MAP(x) { (x)| DMA_CH_VALID, (x)| DMA_CH_VALID, (x)| DMA_CH_VALID, (x)| DMA_CH_VALID }
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2440.c b/arch/arm/mach-s3c24xx/dma-s3c2440.c
index 0b86e74..477d450 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2440.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2440.c
@@ -25,11 +25,9 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
 #include <mach/regs-sdi.h>
-#include <plat/regs-iis.h>
 #include <plat/regs-spi.h>
 
 static struct s3c24xx_dma_map __initdata s3c2440_dma_mappings[] = {
diff --git a/arch/arm/mach-s3c24xx/dma-s3c2443.c b/arch/arm/mach-s3c24xx/dma-s3c2443.c
index 0553625..80a8d56 100644
--- a/arch/arm/mach-s3c24xx/dma-s3c2443.c
+++ b/arch/arm/mach-s3c24xx/dma-s3c2443.c
@@ -25,11 +25,9 @@
 
 #include <plat/regs-serial.h>
 #include <mach/regs-gpio.h>
-#include <plat/regs-ac97.h>
 #include <plat/regs-dma.h>
 #include <mach/regs-lcd.h>
 #include <mach/regs-sdi.h>
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
 

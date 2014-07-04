Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbaGDRyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:54:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14618 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaGDRs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:48:58 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c6-53b6e9085021
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 05/19] ARM: SAMSUNG: Remove legacy clock code
Date: Fri, 04 Jul 2014 19:48:05 +0200
Message-id: <1404496099-26708-6-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xy7ocL7cFG3w+rmXxd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVcaH/E1PB
	4Y2MFcfv7WNvYFw8mbGLkZNDQsBEYtu0T+wQtpjEhXvr2boYuTiEBJYySqy6vIoZwuljkli8
	/w4bSBWbgJrE54ZHYLaIgKrE57YFQN0cHMwCt5kkWoVBwsICthIzfvWDLWABKnn3ZzELiM0r
	4CSx9P52qMVyEr3b3jCD2JwCzhIT111gArGFgGr+/J/PMoGRdwEjwypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkJD8uoNx6TGrQ4wCHIxKPLwNLduChVgTy4orcw8xSnAwK4nw/lkFFOJN
	SaysSi3Kjy8qzUktPsTIxMEp1cA4be5J3Z/Xp71uXrB0ksWrBI/sHSqMgnOnMLO67Cn98mNS
	fI55RQJ3/Y91DX+/3lKNfMd1gGX+3tU3jcrX/JhtKHxrZxf7Nfbn93z7PofMmz3/10P92+JZ
	a9vW7tFOLXK3mnPpn9reF4dcrwWecG6+/2f/+h8nSnkPr0687vPsr9NkZo3ai15655RYijMS
	DbWYi4oTAUUxq7MnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since S5PV210 now has a complete clock driver using Common Clock
Framework, there is no reason to keep the old code. Remove it together
with the whole legacy Samsung-specific clock framework which no longer
has any users.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-exynos/pm.c                          |    1 -
 arch/arm/mach-s3c24xx/common.c                     |    2 -
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |    1 -
 arch/arm/mach-s3c24xx/mach-h1940.c                 |    5 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    1 -
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |    1 -
 arch/arm/mach-s3c24xx/mach-vstms.c                 |    1 -
 arch/arm/mach-s3c24xx/s3c2410.c                    |    6 -
 arch/arm/mach-s3c24xx/s3c2412.c                    |    6 -
 arch/arm/mach-s3c24xx/s3c2442.c                    |    1 -
 arch/arm/mach-s3c24xx/s3c244x.c                    |    6 -
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    1 -
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    1 -
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    1 -
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    1 -
 arch/arm/mach-s3c64xx/mach-smartq.c                |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    1 -
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    1 -
 arch/arm/mach-s3c64xx/s3c6400.c                    |    1 -
 arch/arm/mach-s3c64xx/s3c6410.c                    |    1 -
 arch/arm/mach-s5pv210/Kconfig                      |    9 -
 arch/arm/mach-s5pv210/Makefile                     |    1 -
 arch/arm/mach-s5pv210/clock.c                      | 1365 --------------------
 arch/arm/mach-s5pv210/common.c                     |   16 +-
 arch/arm/mach-s5pv210/common.h                     |    6 -
 arch/arm/mach-s5pv210/mach-goni.c                  |    1 -
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    1 -
 arch/arm/mach-s5pv210/pm.c                         |   48 -
 arch/arm/plat-samsung/Kconfig                      |   18 -
 arch/arm/plat-samsung/Makefile                     |    5 -
 arch/arm/plat-samsung/clock-clksrc.c               |  212 ---
 arch/arm/plat-samsung/clock.c                      |  539 --------
 arch/arm/plat-samsung/include/plat/clock-clksrc.h  |   83 --
 arch/arm/plat-samsung/include/plat/clock.h         |  152 ---
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |    3 -
 arch/arm/plat-samsung/include/plat/pll.h           |  323 -----
 arch/arm/plat-samsung/include/plat/s5p-clock.h     |   65 -
 arch/arm/plat-samsung/init.c                       |    1 -
 arch/arm/plat-samsung/s5p-clock.c                  |  294 -----
 42 files changed, 6 insertions(+), 3179 deletions(-)
 delete mode 100644 arch/arm/mach-s5pv210/clock.c
 delete mode 100644 arch/arm/plat-samsung/clock-clksrc.c
 delete mode 100644 arch/arm/plat-samsung/clock.c
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock-clksrc.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/clock.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/pll.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/s5p-clock.h
 delete mode 100644 arch/arm/plat-samsung/s5p-clock.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f4396fd..c0c1c3f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -765,6 +765,7 @@ config ARCH_S5PV210
 	select ATAGS
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
+	select COMMON_CLK_SAMSUNG
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select GPIO_SAMSUNG
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 87c0d34..6035973 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -28,7 +28,6 @@
 #include <asm/suspend.h>
 
 #include <plat/pm-common.h>
-#include <plat/pll.h>
 #include <plat/regs-srom.h>
 
 #include <mach/map.h>
diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index c0763b8..44fa95d 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -49,9 +49,7 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/clock.h>
 #include <plat/cpu-freq.h>
-#include <plat/pll.h>
 #include <plat/pwm-core.h>
 #include <plat/watchdog-reset.h>
 
diff --git a/arch/arm/mach-s3c24xx/iotiming-s3c2412.c b/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
index bd064c0..28b1395 100644
--- a/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
+++ b/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
@@ -29,7 +29,6 @@
 
 #include <plat/cpu.h>
 #include <plat/cpu-freq-core.h>
-#include <plat/clock.h>
 
 #include <mach/s3c2412.h>
 
diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index fbf5487..c9a99bb 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -60,7 +60,6 @@
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <plat/gpio-cfg.h>
-#include <plat/pll.h>
 #include <plat/pm.h>
 #include <plat/samsung-time.h>
 
@@ -73,6 +72,10 @@
 
 #define H1940_LATCH_BIT(x)	(1 << ((x) + 16 - S3C_GPIO_END))
 
+#define S3C24XX_PLL_MDIV_SHIFT         (12)
+#define S3C24XX_PLL_PDIV_SHIFT         (4)
+#define S3C24XX_PLL_SDIV_SHIFT         (0)
+
 static struct map_desc h1940_iodesc[] __initdata = {
 	[0] = {
 		.virtual	= (unsigned long)H1940_LATCH,
diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index e81ea82..e647b47 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -48,7 +48,6 @@
 #include <linux/mtd/partitions.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2413.c b/arch/arm/mach-s3c24xx/mach-smdk2413.c
index fb3b80e..10726bf 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2413.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2413.c
@@ -43,7 +43,6 @@
 #include <mach/gpio-samsung.h>
 #include <mach/fb.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2416.c b/arch/arm/mach-s3c24xx/mach-smdk2416.c
index fa6f30d..24189e8 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2416.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2416.c
@@ -44,7 +44,6 @@
 #include <linux/platform_data/i2c-s3c2410.h>
 
 #include <plat/gpio-cfg.h>
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <linux/platform_data/mtd-nand-s3c2410.h>
diff --git a/arch/arm/mach-s3c24xx/mach-smdk2443.c b/arch/arm/mach-s3c24xx/mach-smdk2443.c
index ef5d5ea..0ed7761 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2443.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2443.c
@@ -38,7 +38,6 @@
 #include <mach/fb.h>
 #include <linux/platform_data/i2c-s3c2410.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c24xx/mach-vstms.c b/arch/arm/mach-s3c24xx/mach-vstms.c
index 9104c2b..9d4f647 100644
--- a/arch/arm/mach-s3c24xx/mach-vstms.c
+++ b/arch/arm/mach-s3c24xx/mach-vstms.c
@@ -42,7 +42,6 @@
 #include <linux/platform_data/i2c-s3c2410.h>
 #include <linux/platform_data/mtd-nand-s3c2410.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c24xx/s3c2410.c b/arch/arm/mach-s3c24xx/s3c2410.c
index 7eab888..5ffe828 100644
--- a/arch/arm/mach-s3c24xx/s3c2410.c
+++ b/arch/arm/mach-s3c24xx/s3c2410.c
@@ -41,8 +41,6 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/clock.h>
-#include <plat/pll.h>
 #include <plat/pm.h>
 #include <plat/watchdog-reset.h>
 
@@ -83,10 +81,6 @@ void __init s3c2410_map_io(void)
 	iotable_init(s3c2410_iodesc, ARRAY_SIZE(s3c2410_iodesc));
 }
 
-void __init_or_cpufreq s3c2410_setup_clocks(void)
-{
-}
-
 struct bus_type s3c2410_subsys = {
 	.name = "s3c2410-core",
 	.dev_name = "s3c2410-core",
diff --git a/arch/arm/mach-s3c24xx/s3c2412.c b/arch/arm/mach-s3c24xx/s3c2412.c
index d49f52f..569f3f5 100644
--- a/arch/arm/mach-s3c24xx/s3c2412.c
+++ b/arch/arm/mach-s3c24xx/s3c2412.c
@@ -37,12 +37,10 @@
 #include <mach/regs-clock.h>
 #include <mach/regs-gpio.h>
 
-#include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/cpu-freq.h>
 #include <plat/devs.h>
 #include <plat/nand-core.h>
-#include <plat/pll.h>
 #include <plat/pm.h>
 #include <plat/regs-spi.h>
 
@@ -171,10 +169,6 @@ void __init s3c2412_map_io(void)
 	iotable_init(s3c2412_iodesc, ARRAY_SIZE(s3c2412_iodesc));
 }
 
-void __init_or_cpufreq s3c2412_setup_clocks(void)
-{
-}
-
 /* need to register the subsystem before we actually register the device, and
  * we also need to ensure that it has been initialised before any of the
  * drivers even try to use it (even if not on an s3c2412 based system)
diff --git a/arch/arm/mach-s3c24xx/s3c2442.c b/arch/arm/mach-s3c24xx/s3c2442.c
index fb9da2b..7b04334 100644
--- a/arch/arm/mach-s3c24xx/s3c2442.c
+++ b/arch/arm/mach-s3c24xx/s3c2442.c
@@ -43,7 +43,6 @@
 
 #include <mach/regs-clock.h>
 
-#include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
 
diff --git a/arch/arm/mach-s3c24xx/s3c244x.c b/arch/arm/mach-s3c24xx/s3c244x.c
index 4a64bcc..d1c3e65 100644
--- a/arch/arm/mach-s3c24xx/s3c244x.c
+++ b/arch/arm/mach-s3c24xx/s3c244x.c
@@ -38,11 +38,9 @@
 #include <mach/regs-clock.h>
 #include <mach/regs-gpio.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/pm.h>
-#include <plat/pll.h>
 #include <plat/nand-core.h>
 #include <plat/watchdog-reset.h>
 
@@ -78,10 +76,6 @@ void __init s3c244x_map_io(void)
 	s3c2410_device_dclk.name = "s3c2440-dclk";
 }
 
-void __init_or_cpufreq s3c244x_setup_clocks(void)
-{
-}
-
 /* Since the S3C2442 and S3C2440 share items, put both subsystems here */
 
 struct bus_type s3c2440_subsys = {
diff --git a/arch/arm/mach-s3c64xx/mach-anw6410.c b/arch/arm/mach-s3c64xx/mach-anw6410.c
index 55eb6a6..60576df 100644
--- a/arch/arm/mach-s3c64xx/mach-anw6410.c
+++ b/arch/arm/mach-s3c64xx/mach-anw6410.c
@@ -45,7 +45,6 @@
 #include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <mach/regs-gpio.h>
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index 4b0199f..fe11633 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -58,7 +58,6 @@
 #include <linux/platform_data/spi-s3c64xx.h>
 
 #include <plat/keypad.h>
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/adc.h>
diff --git a/arch/arm/mach-s3c64xx/mach-hmt.c b/arch/arm/mach-s3c64xx/mach-hmt.c
index 72cee08..19e8feb 100644
--- a/arch/arm/mach-s3c64xx/mach-hmt.c
+++ b/arch/arm/mach-s3c64xx/mach-hmt.c
@@ -39,7 +39,6 @@
 #include <plat/fb.h>
 #include <linux/platform_data/mtd-nand-s3c2410.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c64xx/mach-ncp.c b/arch/arm/mach-s3c64xx/mach-ncp.c
index 67f06a9..4bae7dc 100644
--- a/arch/arm/mach-s3c64xx/mach-ncp.c
+++ b/arch/arm/mach-s3c64xx/mach-ncp.c
@@ -40,7 +40,6 @@
 #include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/fb.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/samsung-time.h>
diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
index 78dd6f7..b3d1353 100644
--- a/arch/arm/mach-s3c64xx/mach-smartq.c
+++ b/arch/arm/mach-s3c64xx/mach-smartq.c
@@ -28,7 +28,6 @@
 #include <mach/regs-gpio.h>
 #include <mach/gpio-samsung.h>
 
-#include <plat/clock.h>
 #include <plat/cpu.h>
 #include <plat/devs.h>
 #include <linux/platform_data/i2c-s3c2410.h>
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6400.c b/arch/arm/mach-s3c64xx/mach-smdk6400.c
index c85d1cb..9107497 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6400.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6400.c
@@ -30,7 +30,6 @@
 #include <mach/hardware.h>
 #include <mach/map.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <linux/platform_data/i2c-s3c2410.h>
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c b/arch/arm/mach-s3c64xx/mach-smdk6410.c
index c6a8b2a..1dc86d7 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -63,7 +63,6 @@
 #include <plat/fb.h>
 #include <plat/gpio-cfg.h>
 
-#include <plat/clock.h>
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/adc.h>
diff --git a/arch/arm/mach-s3c64xx/s3c6400.c b/arch/arm/mach-s3c64xx/s3c6400.c
index 8c42807..1ce48c5 100644
--- a/arch/arm/mach-s3c64xx/s3c6400.c
+++ b/arch/arm/mach-s3c64xx/s3c6400.c
@@ -39,7 +39,6 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/clock.h>
 #include <plat/sdhci.h>
 #include <plat/iic-core.h>
 #include <plat/onenand-core.h>
diff --git a/arch/arm/mach-s3c64xx/s3c6410.c b/arch/arm/mach-s3c64xx/s3c6410.c
index 5be3f09..b2a7930 100644
--- a/arch/arm/mach-s3c64xx/s3c6410.c
+++ b/arch/arm/mach-s3c64xx/s3c6410.c
@@ -40,7 +40,6 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/clock.h>
 #include <plat/sdhci.h>
 #include <plat/ata-core.h>
 #include <plat/adc-core.h>
diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 60785ce..f60f286 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -13,7 +13,6 @@ config CPU_S5PV210
 	bool
 	select ARM_AMBA
 	select PL330_DMA if DMADEVICES
-	select S5P_CLOCK if !COMMON_CLK
 	select S5P_EXT_INT
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
@@ -71,14 +70,6 @@ config S5PV210_SETUP_USB_PHY
 	help
 	  Common setup code for USB PHY controller
 
-config COMMON_CLK_S5PV210
-	bool "Common Clock Framework support"
-	default y
-	select COMMON_CLK_SAMSUNG
-	help
-	  Enable this option to use new clock driver
-	  based on Common Clock Framework.
-
 menu "S5PC110 Machines"
 
 config MACH_AQUILA
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index d1a493a..08358bb 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -13,7 +13,6 @@ obj-				:=
 # Core
 
 obj-y				+= common.o
-obj-$(CONFIG_S5P_CLOCK)		+= clock.o
 obj-$(CONFIG_PM)		+= pm.o
 
 obj-y				+= dma.o
diff --git a/arch/arm/mach-s5pv210/clock.c b/arch/arm/mach-s5pv210/clock.c
deleted file mode 100644
index ca46372..0000000
diff --git a/arch/arm/mach-s5pv210/common.c b/arch/arm/mach-s5pv210/common.c
index 2e2202a..30bd542 100644
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <clocksource/samsung_pwm.h>
@@ -37,12 +38,6 @@
 
 #include <plat/cpu.h>
 
-#ifdef CONFIG_S5P_CLOCK
-#include <plat/clock.h>
-#else
-#include <linux/clk-provider.h>
-#endif
-
 #include <plat/devs.h>
 #include <plat/sdhci.h>
 #include <plat/adc-core.h>
@@ -239,16 +234,7 @@ void __init s5pv210_map_io(void)
 
 void __init s5pv210_init_clocks(int xtal)
 {
-#ifdef CONFIG_S5P_CLOCK
-	printk(KERN_DEBUG "%s: initializing clocks\n", __func__);
-
-	s3c24xx_register_baseclocks(xtal);
-	s5p_register_clocks(xtal);
-	s5pv210_register_clocks();
-	s5pv210_setup_clocks();
-#else
 	xusbxti_f = xtal;
-#endif
 }
 
 void __init s5pv210_init_irq(void)
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index a2e85cb..083ffe7 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -14,14 +14,8 @@
 
 #include <linux/reboot.h>
 
-#ifdef CONFIG_COMMON_CLK_S5PV210
 void s5pv210_clk_init(unsigned long xxti_f, unsigned long xusbxti_f,
 		      void __iomem *reg_base);
-#else
-static inline void s5pv210_clk_init(unsigned long xxti_f,
-				    unsigned long xusbxti_f,
-				    void __iomem *reg_base) {}
-#endif
 
 void s5pv210_init_io(struct map_desc *mach_desc, int size);
 void s5pv210_init_irq(void);
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 0fc71be..315926f 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -46,7 +46,6 @@
 #include <linux/platform_data/i2c-s3c2410.h>
 #include <plat/keypad.h>
 #include <plat/sdhci.h>
-#include <plat/clock.h>
 #include <plat/samsung-time.h>
 #include <plat/mfc.h>
 
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 1bde3a3..6816ccd 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -47,7 +47,6 @@
 #include <plat/samsung-time.h>
 #include <plat/backlight.h>
 #include <plat/mfc.h>
-#include <plat/clock.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-s5pv210/pm.c b/arch/arm/mach-s5pv210/pm.c
index 3cf3f9c..dd5bfec 100644
--- a/arch/arm/mach-s5pv210/pm.c
+++ b/arch/arm/mach-s5pv210/pm.c
@@ -26,55 +26,7 @@
 #include <mach/regs-clock.h>
 
 static struct sleep_save s5pv210_core_save[] = {
-	/* Clock source */
-	SAVE_ITEM(S5P_CLK_SRC0),
-	SAVE_ITEM(S5P_CLK_SRC1),
-	SAVE_ITEM(S5P_CLK_SRC2),
-	SAVE_ITEM(S5P_CLK_SRC3),
-	SAVE_ITEM(S5P_CLK_SRC4),
-	SAVE_ITEM(S5P_CLK_SRC5),
-	SAVE_ITEM(S5P_CLK_SRC6),
-
-	/* Clock source Mask */
-	SAVE_ITEM(S5P_CLK_SRC_MASK0),
-	SAVE_ITEM(S5P_CLK_SRC_MASK1),
-
-	/* Clock Divider */
-	SAVE_ITEM(S5P_CLK_DIV0),
-	SAVE_ITEM(S5P_CLK_DIV1),
-	SAVE_ITEM(S5P_CLK_DIV2),
-	SAVE_ITEM(S5P_CLK_DIV3),
-	SAVE_ITEM(S5P_CLK_DIV4),
-	SAVE_ITEM(S5P_CLK_DIV5),
-	SAVE_ITEM(S5P_CLK_DIV6),
-	SAVE_ITEM(S5P_CLK_DIV7),
-
-	/* Clock Main Gate */
-	SAVE_ITEM(S5P_CLKGATE_MAIN0),
-	SAVE_ITEM(S5P_CLKGATE_MAIN1),
-	SAVE_ITEM(S5P_CLKGATE_MAIN2),
-
-	/* Clock source Peri Gate */
-	SAVE_ITEM(S5P_CLKGATE_PERI0),
-	SAVE_ITEM(S5P_CLKGATE_PERI1),
-
-	/* Clock source SCLK Gate */
-	SAVE_ITEM(S5P_CLKGATE_SCLK0),
-	SAVE_ITEM(S5P_CLKGATE_SCLK1),
-
-	/* Clock IP Clock gate */
-	SAVE_ITEM(S5P_CLKGATE_IP0),
-	SAVE_ITEM(S5P_CLKGATE_IP1),
-	SAVE_ITEM(S5P_CLKGATE_IP2),
-	SAVE_ITEM(S5P_CLKGATE_IP3),
-	SAVE_ITEM(S5P_CLKGATE_IP4),
-
-	/* Clock Blcok and Bus gate */
-	SAVE_ITEM(S5P_CLKGATE_BLOCK),
-	SAVE_ITEM(S5P_CLKGATE_BUS0),
-
 	/* Clock ETC */
-	SAVE_ITEM(S5P_CLK_OUT),
 	SAVE_ITEM(S5P_MDNIE_SEL),
 };
 
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 42f5d5b..f8185b5 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -23,7 +23,6 @@ config PLAT_S5P
 	select PLAT_SAMSUNG
 	select S3C_GPIO_TRACK
 	select S5P_GPIO_DRVSTR
-	select SAMSUNG_CLKSRC if !COMMON_CLK
 	help
 	  Base platform code for Samsung's S5P series SoC.
 
@@ -65,23 +64,6 @@ config SAMSUNG_ATAGS
 
 if SAMSUNG_ATAGS
 
-# clock options
-
-config SAMSUNG_CLOCK
-	bool
-	default y if !COMMON_CLK
-
-config SAMSUNG_CLKSRC
-	bool
-	help
-	  Select the clock code for the clksrc implementation
-	  used by newer systems such as the S3C64XX.
-
-config S5P_CLOCK
-	bool
-	help
-	  Support common clock part for ARCH_S5P and ARCH_EXYNOS SoCs
-
 # options for IRQ support
 
 config S5P_IRQ
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 5e5beaa..906f54b 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -16,11 +16,6 @@ obj-				:=
 
 obj-y				+= init.o cpu.o
 
-obj-$(CONFIG_SAMSUNG_CLOCK)	+= clock.o
-
-obj-$(CONFIG_SAMSUNG_CLKSRC)	+= clock-clksrc.o
-obj-$(CONFIG_S5P_CLOCK)		+= s5p-clock.o
-
 obj-$(CONFIG_S5P_IRQ)		+= s5p-irq.o
 obj-$(CONFIG_S5P_EXT_INT)	+= s5p-irq-eint.o
 obj-$(CONFIG_S5P_GPIO_INT)	+= s5p-irq-gpioint.o
diff --git a/arch/arm/plat-samsung/clock-clksrc.c b/arch/arm/plat-samsung/clock-clksrc.c
deleted file mode 100644
index 786a410..0000000
diff --git a/arch/arm/plat-samsung/clock.c b/arch/arm/plat-samsung/clock.c
deleted file mode 100644
index d103ac1..0000000
diff --git a/arch/arm/plat-samsung/include/plat/clock-clksrc.h b/arch/arm/plat-samsung/include/plat/clock-clksrc.h
deleted file mode 100644
index 50a8ca7..0000000
diff --git a/arch/arm/plat-samsung/include/plat/clock.h b/arch/arm/plat-samsung/include/plat/clock.h
deleted file mode 100644
index 63239f4..0000000
diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
index 72d4178..317c523 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
@@ -140,7 +140,6 @@ struct s3c_cpufreq_config {
  *	any frequency changes. This is really only need by devices like the
  *	S3C2410 where there is no or limited divider between the PLL and the
  *	ARMCLK.
- * @resume_clocks: Update the clocks on resume.
  * @get_iotiming: Get the current IO timing data, mainly for use at start.
  * @set_iotiming: Update the IO timings from the cached copies calculated
  *	from the @calc_iotiming entry when changing the frequency.
@@ -169,8 +168,6 @@ struct s3c_cpufreq_info {
 
 	/* driver routines */
 
-	void		(*resume_clocks)(void);
-
 	int		(*get_iotiming)(struct s3c_cpufreq_config *cfg,
 					struct s3c_iotimings *timings);
 
diff --git a/arch/arm/plat-samsung/include/plat/pll.h b/arch/arm/plat-samsung/include/plat/pll.h
deleted file mode 100644
index 357af7c..0000000
diff --git a/arch/arm/plat-samsung/include/plat/s5p-clock.h b/arch/arm/plat-samsung/include/plat/s5p-clock.h
deleted file mode 100644
index acacc4b..0000000
diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
index a1f925f..11fbbc2 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -30,7 +30,6 @@
 
 #include <plat/cpu.h>
 #include <plat/devs.h>
-#include <plat/clock.h>
 
 static struct cpu_table *cpu;
 
diff --git a/arch/arm/plat-samsung/s5p-clock.c b/arch/arm/plat-samsung/s5p-clock.c
deleted file mode 100644
index 48a1599..0000000
-- 
1.9.3


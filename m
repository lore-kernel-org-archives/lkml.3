Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3CNWNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:13:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] ARM: gemini: remove platform support
Date: Thu, 14 Mar 2013 23:12:04 +0100
Message-Id: <1363299128-8192-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Agp8/7iTqXCrmrzhc/PXEPRodtR+cZ6Geyof/sSN6Ou
 Z6zjm2ig3v8pz297yngfzs9oDOV3/k52yym2uSj3WuZi7Renez
 sYiNRYHmI4fo+qO4TBuvrmBggZUIXNO1UIP/beEGMMrksPcQXK
 FNx2nW697wVQX8zHmwX2rsrN7egQHOy4TGBF5jwDvxrcvDEdzt
 8Q4JSoWFyBTtZ4bNp2qgDHMNKWVZnhnq8tuhhVb3h4INh4ntj4
 U3h+vsNWV+Y3GADpy5KVJA+ORmEqlUPsug784M0YS3+ye5c0Qt
 PTvnvSh8UnS2zJzsgZPZubuojxQdNQY04CXPoxIY3qHlE5nH88
 2C6rZeQvfnx/YkMw5Dy/xG64bBpAf3lnPY4jZc8Bs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gemini platform has not seen any updates from its
maintainer since 2010, and has no defconfig file, which
has lead to bitrot in a number of places:

* System restart has been broken for a long time despite
  repeated attempts from Russell to get the obvious
  fix at least acknowledged by someone who can test it.
* The platform still uses mach/gpio.h, which has been
  deprecated for some time, and since Kconfig does not
  select NEED_MACH_GPIO_H, it actually failed to build
  because of this.
* A change to asm/io.h introduced a number of compiler
  warnings for gemini specific code that confuses
  physical and virtual addresses.

This removes gemini support entirely under the assumption
that nobody uses it on mainline kernels. Of course, if
there are still active users out there, they should let
us know so we can put support back in and get it better
tested.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                                     |   7 -
 arch/arm/Kconfig                                |  11 -
 arch/arm/Makefile                               |   1 -
 arch/arm/mach-gemini/Kconfig                    |  40 ----
 arch/arm/mach-gemini/Makefile                   |  13 --
 arch/arm/mach-gemini/Makefile.boot              |   9 -
 arch/arm/mach-gemini/board-nas4220b.c           | 107 ---------
 arch/arm/mach-gemini/board-rut1xx.c             |  92 --------
 arch/arm/mach-gemini/board-wbd111.c             | 134 ------------
 arch/arm/mach-gemini/board-wbd222.c             | 134 ------------
 arch/arm/mach-gemini/common.h                   |  31 ---
 arch/arm/mach-gemini/devices.c                  | 118 ----------
 arch/arm/mach-gemini/gpio.c                     | 231 --------------------
 arch/arm/mach-gemini/idle.c                     |  29 ---
 arch/arm/mach-gemini/include/mach/debug-macro.S |  21 --
 arch/arm/mach-gemini/include/mach/entry-macro.S |  33 ---
 arch/arm/mach-gemini/include/mach/global_reg.h  | 278 ------------------------
 arch/arm/mach-gemini/include/mach/gpio.h        |  20 --
 arch/arm/mach-gemini/include/mach/hardware.h    |  74 -------
 arch/arm/mach-gemini/include/mach/irqs.h        |  53 -----
 arch/arm/mach-gemini/include/mach/timex.h       |  13 --
 arch/arm/mach-gemini/include/mach/uncompress.h  |  42 ----
 arch/arm/mach-gemini/irq.c                      | 103 ---------
 arch/arm/mach-gemini/mm.c                       |  82 -------
 arch/arm/mach-gemini/reset.c                    |  23 --
 arch/arm/mach-gemini/time.c                     |  89 --------
 26 files changed, 1788 deletions(-)
 delete mode 100644 arch/arm/mach-gemini/Kconfig
 delete mode 100644 arch/arm/mach-gemini/Makefile
 delete mode 100644 arch/arm/mach-gemini/Makefile.boot
 delete mode 100644 arch/arm/mach-gemini/board-nas4220b.c
 delete mode 100644 arch/arm/mach-gemini/board-rut1xx.c
 delete mode 100644 arch/arm/mach-gemini/board-wbd111.c
 delete mode 100644 arch/arm/mach-gemini/board-wbd222.c
 delete mode 100644 arch/arm/mach-gemini/common.h
 delete mode 100644 arch/arm/mach-gemini/devices.c
 delete mode 100644 arch/arm/mach-gemini/gpio.c
 delete mode 100644 arch/arm/mach-gemini/idle.c
 delete mode 100644 arch/arm/mach-gemini/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/global_reg.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/timex.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-gemini/irq.c
 delete mode 100644 arch/arm/mach-gemini/mm.c
 delete mode 100644 arch/arm/mach-gemini/reset.c
 delete mode 100644 arch/arm/mach-gemini/time.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..4b59496 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -785,13 +785,6 @@ ARM/CORGI MACHINE SUPPORT
 M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 
-ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE
-M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-T:	git git://git.berlios.de/gemini-board
-S:	Maintained
-F:	arch/arm/mach-gemini/
-
 ARM/CSR SIRFPRIMA2 MACHINE SUPPORT
 M:	Barry Song <baohua.song@csr.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 78f31a3..b62699a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -407,15 +407,6 @@ config ARCH_CLPS711X
 	help
 	  Support for Cirrus Logic 711x/721x/731x based boards.
 
-config ARCH_GEMINI
-	bool "Cortina Systems Gemini"
-	select ARCH_REQUIRE_GPIOLIB
-	select ARCH_USES_GETTIMEOFFSET
-	select NEED_MACH_GPIO_H
-	select CPU_FA526
-	help
-	  Support for the Cortina Systems Gemini family SoCs
-
 config ARCH_SIRF
 	bool "CSR SiRF"
 	select ARCH_REQUIRE_GPIOLIB
@@ -1050,8 +1041,6 @@ source "arch/arm/mach-ep93xx/Kconfig"
 
 source "arch/arm/mach-footbridge/Kconfig"
 
-source "arch/arm/mach-gemini/Kconfig"
-
 source "arch/arm/mach-h720x/Kconfig"
 
 source "arch/arm/mach-highbank/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index ee4605f..50e755b 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -146,7 +146,6 @@ machine-$(CONFIG_ARCH_DAVINCI)		+= davinci
 machine-$(CONFIG_ARCH_DOVE)		+= dove
 machine-$(CONFIG_ARCH_EBSA110)		+= ebsa110
 machine-$(CONFIG_ARCH_EP93XX)		+= ep93xx
-machine-$(CONFIG_ARCH_GEMINI)		+= gemini
 machine-$(CONFIG_ARCH_H720X)		+= h720x
 machine-$(CONFIG_ARCH_HIGHBANK)		+= highbank
 machine-$(CONFIG_ARCH_INTEGRATOR)	+= integrator
diff --git a/arch/arm/mach-gemini/Kconfig b/arch/arm/mach-gemini/Kconfig
deleted file mode 100644
index 6f066ee..0000000
--- a/arch/arm/mach-gemini/Kconfig
+++ /dev/null
@@ -1,40 +0,0 @@
-if ARCH_GEMINI
-
-menu "Cortina Systems Gemini Implementations"
-
-config MACH_NAS4220B
-	bool "Raidsonic NAS-4220-B"
-	select GEMINI_MEM_SWAP
-	help
-	  Say Y here if you intend to run this kernel on a
-	  Raidsonic NAS-4220-B.
-
-config MACH_RUT100
-	bool "Teltonika RUT100"
-	select GEMINI_MEM_SWAP
-	help
-	  Say Y here if you intend to run this kernel on a
-	  Teltonika 3G Router RUT100.
-
-config MACH_WBD111
-	bool "Wiliboard WBD-111"
-	select GEMINI_MEM_SWAP
-	help
-	  Say Y here if you intend to run this kernel on a
-	  Wiliboard WBD-111.
-
-config MACH_WBD222
-        bool "Wiliboard WBD-222"
-        select GEMINI_MEM_SWAP
-        help
-          Say Y here if you intend to run this kernel on a
-          Wiliboard WBD-222.
-
-endmenu
-
-config GEMINI_MEM_SWAP
-	bool "Gemini memory is swapped"
-	help
-	  Say Y here if Gemini memory is swapped by bootloader.
-
-endif
diff --git a/arch/arm/mach-gemini/Makefile b/arch/arm/mach-gemini/Makefile
deleted file mode 100644
index 7963a77..0000000
--- a/arch/arm/mach-gemini/Makefile
+++ /dev/null
@@ -1,13 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-# Object file lists.
-
-obj-y			:= irq.o mm.o time.o devices.o gpio.o idle.o reset.o
-
-# Board-specific support
-obj-$(CONFIG_MACH_NAS4220B)	+= board-nas4220b.o
-obj-$(CONFIG_MACH_RUT100)	+= board-rut1xx.o
-obj-$(CONFIG_MACH_WBD111)	+= board-wbd111.o
-obj-$(CONFIG_MACH_WBD222)	+= board-wbd222.o
diff --git a/arch/arm/mach-gemini/Makefile.boot b/arch/arm/mach-gemini/Makefile.boot
deleted file mode 100644
index 683f52b..0000000
--- a/arch/arm/mach-gemini/Makefile.boot
+++ /dev/null
@@ -1,9 +0,0 @@
-ifeq ($(CONFIG_GEMINI_MEM_SWAP),y)
-   zreladdr-y	+= 0x00008000
-params_phys-y	:= 0x00000100
-initrd_phys-y	:= 0x00800000
-else
-   zreladdr-y	+= 0x10008000
-params_phys-y	:= 0x10000100
-initrd_phys-y	:= 0x10800000
-endif
diff --git a/arch/arm/mach-gemini/board-nas4220b.c b/arch/arm/mach-gemini/board-nas4220b.c
deleted file mode 100644
index ca8a25b..0000000
--- a/arch/arm/mach-gemini/board-nas4220b.c
+++ /dev/null
@@ -1,107 +0,0 @@
-/*
- *  Support for Raidsonic NAS-4220-B
- *
- *  Copyright (C) 2009 Janos Laube <janos.dev@gmail.com>
- *
- * based on rut1xx.c
- *  Copyright (C) 2008 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/leds.h>
-#include <linux/input.h>
-#include <linux/gpio_keys.h>
-#include <linux/mdio-gpio.h>
-#include <linux/io.h>
-
-#include <asm/setup.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-#include <mach/hardware.h>
-#include <mach/global_reg.h>
-
-#include "common.h"
-
-static struct gpio_led ib4220b_leds[] = {
-	{
-		.name			= "nas4220b:orange:hdd",
-		.default_trigger	= "none",
-		.gpio			= 60,
-	},
-	{
-		.name			= "nas4220b:green:os",
-		.default_trigger	= "heartbeat",
-		.gpio			= 62,
-	},
-};
-
-static struct gpio_led_platform_data ib4220b_leds_data = {
-	.num_leds	= ARRAY_SIZE(ib4220b_leds),
-	.leds		= ib4220b_leds,
-};
-
-static struct platform_device ib4220b_led_device = {
-	.name	= "leds-gpio",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &ib4220b_leds_data,
-	},
-};
-
-static struct gpio_keys_button ib4220b_keys[] = {
-	{
-		.code		= KEY_SETUP,
-		.gpio		= 61,
-		.active_low	= 1,
-		.desc		= "Backup Button",
-		.type		= EV_KEY,
-	},
-	{
-		.code		= KEY_RESTART,
-		.gpio		= 63,
-		.active_low	= 1,
-		.desc		= "Softreset Button",
-		.type		= EV_KEY,
-	},
-};
-
-static struct gpio_keys_platform_data ib4220b_keys_data = {
-	.buttons	= ib4220b_keys,
-	.nbuttons	= ARRAY_SIZE(ib4220b_keys),
-};
-
-static struct platform_device ib4220b_key_device = {
-	.name	= "gpio-keys",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &ib4220b_keys_data,
-	},
-};
-
-static void __init ib4220b_init(void)
-{
-	gemini_gpio_init();
-	platform_register_uart();
-	platform_register_pflash(SZ_16M, NULL, 0);
-	platform_device_register(&ib4220b_led_device);
-	platform_device_register(&ib4220b_key_device);
-	platform_register_rtc();
-}
-
-MACHINE_START(NAS4220B, "Raidsonic NAS IB-4220-B")
-	.atag_offset	= 0x100,
-	.map_io		= gemini_map_io,
-	.init_irq	= gemini_init_irq,
-	.init_time	= gemini_timer_init,
-	.init_machine	= ib4220b_init,
-	.restart	= gemini_restart,
-MACHINE_END
diff --git a/arch/arm/mach-gemini/board-rut1xx.c b/arch/arm/mach-gemini/board-rut1xx.c
deleted file mode 100644
index 7a675f8..0000000
--- a/arch/arm/mach-gemini/board-rut1xx.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- *  Support for Teltonika RUT1xx
- *
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/leds.h>
-#include <linux/input.h>
-#include <linux/gpio_keys.h>
-#include <linux/sizes.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-#include "common.h"
-
-static struct gpio_keys_button rut1xx_keys[] = {
-	{
-		.code		= KEY_SETUP,
-		.gpio		= 60,
-		.active_low	= 1,
-		.desc		= "Reset to defaults",
-		.type		= EV_KEY,
-	},
-};
-
-static struct gpio_keys_platform_data rut1xx_keys_data = {
-	.buttons	= rut1xx_keys,
-	.nbuttons	= ARRAY_SIZE(rut1xx_keys),
-};
-
-static struct platform_device rut1xx_keys_device = {
-	.name	= "gpio-keys",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &rut1xx_keys_data,
-	},
-};
-
-static struct gpio_led rut100_leds[] = {
-	{
-		.name			= "Power",
-		.default_trigger	= "heartbeat",
-		.gpio			= 17,
-	},
-	{
-		.name			= "GSM",
-		.default_trigger	= "default-on",
-		.gpio			= 7,
-		.active_low		= 1,
-	},
-};
-
-static struct gpio_led_platform_data rut100_leds_data = {
-	.num_leds	= ARRAY_SIZE(rut100_leds),
-	.leds		= rut100_leds,
-};
-
-static struct platform_device rut1xx_leds = {
-	.name	= "leds-gpio",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &rut100_leds_data,
-	},
-};
-
-static void __init rut1xx_init(void)
-{
-	gemini_gpio_init();
-	platform_register_uart();
-	platform_register_pflash(SZ_8M, NULL, 0);
-	platform_device_register(&rut1xx_leds);
-	platform_device_register(&rut1xx_keys_device);
-	platform_register_rtc();
-}
-
-MACHINE_START(RUT100, "Teltonika RUT100")
-	.atag_offset	= 0x100,
-	.map_io		= gemini_map_io,
-	.init_irq	= gemini_init_irq,
-	.init_time	= gemini_timer_init,
-	.init_machine	= rut1xx_init,
-	.restart	= gemini_restart,
-MACHINE_END
diff --git a/arch/arm/mach-gemini/board-wbd111.c b/arch/arm/mach-gemini/board-wbd111.c
deleted file mode 100644
index 418188c..0000000
--- a/arch/arm/mach-gemini/board-wbd111.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- *  Support for Wiliboard WBD-111
- *
- *  Copyright (C) 2009 Imre Kaloz <kaloz@openwrt.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/leds.h>
-#include <linux/input.h>
-#include <linux/skbuff.h>
-#include <linux/gpio_keys.h>
-#include <linux/mdio-gpio.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-
-#include "common.h"
-
-static struct gpio_keys_button wbd111_keys[] = {
-	{
-		.code		= KEY_SETUP,
-		.gpio		= 5,
-		.active_low	= 1,
-		.desc		= "reset",
-		.type		= EV_KEY,
-	},
-};
-
-static struct gpio_keys_platform_data wbd111_keys_data = {
-	.buttons	= wbd111_keys,
-	.nbuttons	= ARRAY_SIZE(wbd111_keys),
-};
-
-static struct platform_device wbd111_keys_device = {
-	.name	= "gpio-keys",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wbd111_keys_data,
-	},
-};
-
-static struct gpio_led wbd111_leds[] = {
-	{
-		.name			= "L3red",
-		.gpio			= 1,
-	},
-	{
-		.name			= "L4green",
-		.gpio			= 2,
-	},
-	{
-		.name			= "L4red",
-		.gpio			= 3,
-	},
-	{
-		.name			= "L3green",
-		.gpio			= 5,
-	},
-};
-
-static struct gpio_led_platform_data wbd111_leds_data = {
-	.num_leds	= ARRAY_SIZE(wbd111_leds),
-	.leds		= wbd111_leds,
-};
-
-static struct platform_device wbd111_leds_device = {
-	.name	= "leds-gpio",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wbd111_leds_data,
-	},
-};
-
-static struct mtd_partition wbd111_partitions[] = {
-	{
-		.name		= "RedBoot",
-		.offset		= 0,
-		.size		= 0x020000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "kernel",
-		.offset		= 0x020000,
-		.size		= 0x100000,
-	} , {
-		.name		= "rootfs",
-		.offset		= 0x120000,
-		.size		= 0x6a0000,
-	} , {
-		.name		= "VCTL",
-		.offset		= 0x7c0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "cfg",
-		.offset		= 0x7d0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "FIS",
-		.offset		= 0x7e0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	}
-};
-#define wbd111_num_partitions  ARRAY_SIZE(wbd111_partitions)
-
-static void __init wbd111_init(void)
-{
-	gemini_gpio_init();
-	platform_register_uart();
-	platform_register_pflash(SZ_8M, wbd111_partitions,
-				 wbd111_num_partitions);
-	platform_device_register(&wbd111_leds_device);
-	platform_device_register(&wbd111_keys_device);
-	platform_register_rtc();
-}
-
-MACHINE_START(WBD111, "Wiliboard WBD-111")
-	.atag_offset	= 0x100,
-	.map_io		= gemini_map_io,
-	.init_irq	= gemini_init_irq,
-	.init_time	= gemini_timer_init,
-	.init_machine	= wbd111_init,
-	.restart	= gemini_restart,
-MACHINE_END
diff --git a/arch/arm/mach-gemini/board-wbd222.c b/arch/arm/mach-gemini/board-wbd222.c
deleted file mode 100644
index 266b265..0000000
--- a/arch/arm/mach-gemini/board-wbd222.c
+++ /dev/null
@@ -1,134 +0,0 @@
-/*
- *  Support for Wiliboard WBD-222
- *
- *  Copyright (C) 2009 Imre Kaloz <kaloz@openwrt.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/leds.h>
-#include <linux/input.h>
-#include <linux/skbuff.h>
-#include <linux/gpio_keys.h>
-#include <linux/mdio-gpio.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/time.h>
-
-
-#include "common.h"
-
-static struct gpio_keys_button wbd222_keys[] = {
-	{
-		.code		= KEY_SETUP,
-		.gpio		= 5,
-		.active_low	= 1,
-		.desc		= "reset",
-		.type		= EV_KEY,
-	},
-};
-
-static struct gpio_keys_platform_data wbd222_keys_data = {
-	.buttons	= wbd222_keys,
-	.nbuttons	= ARRAY_SIZE(wbd222_keys),
-};
-
-static struct platform_device wbd222_keys_device = {
-	.name	= "gpio-keys",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wbd222_keys_data,
-	},
-};
-
-static struct gpio_led wbd222_leds[] = {
-	{
-		.name			= "L3red",
-		.gpio			= 1,
-	},
-	{
-		.name			= "L4green",
-		.gpio			= 2,
-	},
-	{
-		.name			= "L4red",
-		.gpio			= 3,
-	},
-	{
-		.name			= "L3green",
-		.gpio			= 5,
-	},
-};
-
-static struct gpio_led_platform_data wbd222_leds_data = {
-	.num_leds	= ARRAY_SIZE(wbd222_leds),
-	.leds		= wbd222_leds,
-};
-
-static struct platform_device wbd222_leds_device = {
-	.name	= "leds-gpio",
-	.id	= -1,
-	.dev	= {
-		.platform_data = &wbd222_leds_data,
-	},
-};
-
-static struct mtd_partition wbd222_partitions[] = {
-	{
-		.name		= "RedBoot",
-		.offset		= 0,
-		.size		= 0x020000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "kernel",
-		.offset		= 0x020000,
-		.size		= 0x100000,
-	} , {
-		.name		= "rootfs",
-		.offset		= 0x120000,
-		.size		= 0x6a0000,
-	} , {
-		.name		= "VCTL",
-		.offset		= 0x7c0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "cfg",
-		.offset		= 0x7d0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	} , {
-		.name		= "FIS",
-		.offset		= 0x7e0000,
-		.size		= 0x010000,
-		.mask_flags	= MTD_WRITEABLE,
-	}
-};
-#define wbd222_num_partitions  ARRAY_SIZE(wbd222_partitions)
-
-static void __init wbd222_init(void)
-{
-	gemini_gpio_init();
-	platform_register_uart();
-	platform_register_pflash(SZ_8M, wbd222_partitions,
-		wbd222_num_partitions);
-	platform_device_register(&wbd222_leds_device);
-	platform_device_register(&wbd222_keys_device);
-	platform_register_rtc();
-}
-
-MACHINE_START(WBD222, "Wiliboard WBD-222")
-	.atag_offset	= 0x100,
-	.map_io		= gemini_map_io,
-	.init_irq	= gemini_init_irq,
-	.init_time	= gemini_timer_init,
-	.init_machine	= wbd222_init,
-	.restart	= gemini_restart,
-MACHINE_END
diff --git a/arch/arm/mach-gemini/common.h b/arch/arm/mach-gemini/common.h
deleted file mode 100644
index 38a4526..0000000
--- a/arch/arm/mach-gemini/common.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Common Gemini architecture functions
- *
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __GEMINI_COMMON_H__
-#define __GEMINI_COMMON_H__
-
-struct mtd_partition;
-
-extern void gemini_map_io(void);
-extern void gemini_init_irq(void);
-extern void gemini_timer_init(void);
-extern void gemini_gpio_init(void);
-extern void platform_register_rtc(void);
-
-/* Common platform devices registration functions */
-extern int platform_register_uart(void);
-extern int platform_register_pflash(unsigned int size,
-				    struct mtd_partition *parts,
-				    unsigned int nr_parts);
-
-extern void gemini_restart(char mode, const char *cmd);
-
-#endif /* __GEMINI_COMMON_H__ */
diff --git a/arch/arm/mach-gemini/devices.c b/arch/arm/mach-gemini/devices.c
deleted file mode 100644
index 5cff298..0000000
--- a/arch/arm/mach-gemini/devices.c
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- * Common devices definition for Gemini
- *
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/serial_8250.h>
-#include <linux/mtd/physmap.h>
-
-#include <mach/irqs.h>
-#include <mach/hardware.h>
-#include <mach/global_reg.h>
-
-static struct plat_serial8250_port serial_platform_data[] = {
-	{
-		.membase	= (void *)IO_ADDRESS(GEMINI_UART_BASE),
-		.mapbase	= GEMINI_UART_BASE,
-		.irq		= IRQ_UART,
-		.uartclk	= UART_CLK,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM,
-		.type		= PORT_16550A,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_FIXED_TYPE,
-	},
-	{},
-};
-
-static struct platform_device serial_device = {
-	.name	= "serial8250",
-	.id	= PLAT8250_DEV_PLATFORM,
-	.dev	= {
-		.platform_data = serial_platform_data,
-	},
-};
-
-int platform_register_uart(void)
-{
-	return platform_device_register(&serial_device);
-}
-
-static struct resource flash_resource = {
-	.start	= GEMINI_FLASH_BASE,
-	.flags	= IORESOURCE_MEM,
-};
-
-static struct physmap_flash_data pflash_platform_data = {};
-
-static struct platform_device pflash_device = {
-	.name	= "physmap-flash",
-	.id	= 0,
-	.dev 	= {
-		.platform_data = &pflash_platform_data,
-	},
-	.resource = &flash_resource,
-	.num_resources = 1,
-};
-
-int platform_register_pflash(unsigned int size, struct mtd_partition *parts,
-			     unsigned int nr_parts)
-{
-	unsigned int reg;
-
-	reg = __raw_readl(IO_ADDRESS(GEMINI_GLOBAL_BASE) + GLOBAL_STATUS);
-
-	if ((reg & FLASH_TYPE_MASK) != FLASH_TYPE_PARALLEL)
-		return -ENXIO;
-
-	if (reg & FLASH_WIDTH_16BIT)
-		pflash_platform_data.width = 2;
-	else
-		pflash_platform_data.width = 1;
-
-	/* enable parallel flash pins and disable others */
-	reg = __raw_readl(IO_ADDRESS(GEMINI_GLOBAL_BASE) + GLOBAL_MISC_CTRL);
-	reg &= ~PFLASH_PADS_DISABLE;
-	reg |= SFLASH_PADS_DISABLE | NAND_PADS_DISABLE;
-	__raw_writel(reg, IO_ADDRESS(GEMINI_GLOBAL_BASE) + GLOBAL_MISC_CTRL);
-
-	flash_resource.end = flash_resource.start + size - 1;
-
-	pflash_platform_data.parts = parts;
-	pflash_platform_data.nr_parts = nr_parts;
-
-	return platform_device_register(&pflash_device);
-}
-
-static struct resource gemini_rtc_resources[] = {
-	[0] = {
-		.start  = GEMINI_RTC_BASE,
-		.end    = GEMINI_RTC_BASE + 0x24,
-		.flags  = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start  = IRQ_RTC,
-		.end    = IRQ_RTC,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device gemini_rtc_device = {
-	.name		= "rtc-gemini",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(gemini_rtc_resources),
-	.resource	= gemini_rtc_resources,
-};
-
-int __init platform_register_rtc(void)
-{
-	return platform_device_register(&gemini_rtc_device);
-}
-
diff --git a/arch/arm/mach-gemini/gpio.c b/arch/arm/mach-gemini/gpio.c
deleted file mode 100644
index 70bfa57..0000000
--- a/arch/arm/mach-gemini/gpio.c
+++ /dev/null
@@ -1,231 +0,0 @@
-/*
- * Gemini gpiochip and interrupt routines
- *
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * Based on plat-mxc/gpio.c:
- *  MXC GPIO support. (c) 2008 Daniel Mack <daniel@caiaq.de>
- *  Copyright 2008 Juergen Beisert, kernel@pengutronix.de
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/gpio.h>
-
-#include <mach/hardware.h>
-#include <mach/irqs.h>
-#include <mach/gpio.h>
-
-#define GPIO_BASE(x)		IO_ADDRESS(GEMINI_GPIO_BASE(x))
-
-/* GPIO registers definition */
-#define GPIO_DATA_OUT		0x0
-#define GPIO_DATA_IN		0x4
-#define GPIO_DIR		0x8
-#define GPIO_DATA_SET		0x10
-#define GPIO_DATA_CLR		0x14
-#define GPIO_PULL_EN		0x18
-#define GPIO_PULL_TYPE		0x1C
-#define GPIO_INT_EN		0x20
-#define GPIO_INT_STAT		0x24
-#define GPIO_INT_MASK		0x2C
-#define GPIO_INT_CLR		0x30
-#define GPIO_INT_TYPE		0x34
-#define GPIO_INT_BOTH_EDGE	0x38
-#define GPIO_INT_LEVEL		0x3C
-#define GPIO_DEBOUNCE_EN	0x40
-#define GPIO_DEBOUNCE_PRESCALE	0x44
-
-#define GPIO_PORT_NUM		3
-
-static void _set_gpio_irqenable(void __iomem *base, unsigned int index,
-				int enable)
-{
-	unsigned int reg;
-
-	reg = __raw_readl(base + GPIO_INT_EN);
-	reg = (reg & (~(1 << index))) | (!!enable << index);
-	__raw_writel(reg, base + GPIO_INT_EN);
-}
-
-static void gpio_ack_irq(struct irq_data *d)
-{
-	unsigned int gpio = irq_to_gpio(d->irq);
-	void __iomem *base = GPIO_BASE(gpio / 32);
-
-	__raw_writel(1 << (gpio % 32), base + GPIO_INT_CLR);
-}
-
-static void gpio_mask_irq(struct irq_data *d)
-{
-	unsigned int gpio = irq_to_gpio(d->irq);
-	void __iomem *base = GPIO_BASE(gpio / 32);
-
-	_set_gpio_irqenable(base, gpio % 32, 0);
-}
-
-static void gpio_unmask_irq(struct irq_data *d)
-{
-	unsigned int gpio = irq_to_gpio(d->irq);
-	void __iomem *base = GPIO_BASE(gpio / 32);
-
-	_set_gpio_irqenable(base, gpio % 32, 1);
-}
-
-static int gpio_set_irq_type(struct irq_data *d, unsigned int type)
-{
-	unsigned int gpio = irq_to_gpio(d->irq);
-	unsigned int gpio_mask = 1 << (gpio % 32);
-	void __iomem *base = GPIO_BASE(gpio / 32);
-	unsigned int reg_both, reg_level, reg_type;
-
-	reg_type = __raw_readl(base + GPIO_INT_TYPE);
-	reg_level = __raw_readl(base + GPIO_INT_LEVEL);
-	reg_both = __raw_readl(base + GPIO_INT_BOTH_EDGE);
-
-	switch (type) {
-	case IRQ_TYPE_EDGE_BOTH:
-		reg_type &= ~gpio_mask;
-		reg_both |= gpio_mask;
-		break;
-	case IRQ_TYPE_EDGE_RISING:
-		reg_type &= ~gpio_mask;
-		reg_both &= ~gpio_mask;
-		reg_level &= ~gpio_mask;
-		break;
-	case IRQ_TYPE_EDGE_FALLING:
-		reg_type &= ~gpio_mask;
-		reg_both &= ~gpio_mask;
-		reg_level |= gpio_mask;
-		break;
-	case IRQ_TYPE_LEVEL_HIGH:
-		reg_type |= gpio_mask;
-		reg_level &= ~gpio_mask;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		reg_type |= gpio_mask;
-		reg_level |= gpio_mask;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	__raw_writel(reg_type, base + GPIO_INT_TYPE);
-	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
-	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
-
-	gpio_ack_irq(d);
-
-	return 0;
-}
-
-static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
-{
-	unsigned int port = (unsigned int)irq_desc_get_handler_data(desc);
-	unsigned int gpio_irq_no, irq_stat;
-
-	irq_stat = __raw_readl(GPIO_BASE(port) + GPIO_INT_STAT);
-
-	gpio_irq_no = GPIO_IRQ_BASE + port * 32;
-	for (; irq_stat != 0; irq_stat >>= 1, gpio_irq_no++) {
-
-		if ((irq_stat & 1) == 0)
-			continue;
-
-		generic_handle_irq(gpio_irq_no);
-	}
-}
-
-static struct irq_chip gpio_irq_chip = {
-	.name = "GPIO",
-	.irq_ack = gpio_ack_irq,
-	.irq_mask = gpio_mask_irq,
-	.irq_unmask = gpio_unmask_irq,
-	.irq_set_type = gpio_set_irq_type,
-};
-
-static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
-				int dir)
-{
-	void __iomem *base = GPIO_BASE(offset / 32);
-	unsigned int reg;
-
-	reg = __raw_readl(base + GPIO_DIR);
-	if (dir)
-		reg |= 1 << (offset % 32);
-	else
-		reg &= ~(1 << (offset % 32));
-	__raw_writel(reg, base + GPIO_DIR);
-}
-
-static void gemini_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	void __iomem *base = GPIO_BASE(offset / 32);
-
-	if (value)
-		__raw_writel(1 << (offset % 32), base + GPIO_DATA_SET);
-	else
-		__raw_writel(1 << (offset % 32), base + GPIO_DATA_CLR);
-}
-
-static int gemini_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	void __iomem *base = GPIO_BASE(offset / 32);
-
-	return (__raw_readl(base + GPIO_DATA_IN) >> (offset % 32)) & 1;
-}
-
-static int gemini_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	_set_gpio_direction(chip, offset, 0);
-	return 0;
-}
-
-static int gemini_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
-					int value)
-{
-	_set_gpio_direction(chip, offset, 1);
-	gemini_gpio_set(chip, offset, value);
-	return 0;
-}
-
-static struct gpio_chip gemini_gpio_chip = {
-	.label			= "Gemini",
-	.direction_input	= gemini_gpio_direction_input,
-	.get			= gemini_gpio_get,
-	.direction_output	= gemini_gpio_direction_output,
-	.set			= gemini_gpio_set,
-	.base			= 0,
-	.ngpio			= GPIO_PORT_NUM * 32,
-};
-
-void __init gemini_gpio_init(void)
-{
-	int i, j;
-
-	for (i = 0; i < GPIO_PORT_NUM; i++) {
-		/* disable, unmask and clear all interrupts */
-		__raw_writel(0x0, GPIO_BASE(i) + GPIO_INT_EN);
-		__raw_writel(0x0, GPIO_BASE(i) + GPIO_INT_MASK);
-		__raw_writel(~0x0, GPIO_BASE(i) + GPIO_INT_CLR);
-
-		for (j = GPIO_IRQ_BASE + i * 32;
-		     j < GPIO_IRQ_BASE + (i + 1) * 32; j++) {
-			irq_set_chip_and_handler(j, &gpio_irq_chip,
-						 handle_edge_irq);
-			set_irq_flags(j, IRQF_VALID);
-		}
-
-		irq_set_chained_handler(IRQ_GPIO(i), gpio_irq_handler);
-		irq_set_handler_data(IRQ_GPIO(i), (void *)i);
-	}
-
-	BUG_ON(gpiochip_add(&gemini_gpio_chip));
-}
diff --git a/arch/arm/mach-gemini/idle.c b/arch/arm/mach-gemini/idle.c
deleted file mode 100644
index 92bbd6b..0000000
--- a/arch/arm/mach-gemini/idle.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * arch/arm/mach-gemini/idle.c
- */
-
-#include <linux/init.h>
-#include <asm/system.h>
-#include <asm/proc-fns.h>
-
-static void gemini_idle(void)
-{
-	/*
-	 * Because of broken hardware we have to enable interrupts or the CPU
-	 * will never wakeup... Acctualy it is not very good to enable
-	 * interrupts first since scheduler can miss a tick, but there is
-	 * no other way around this. Platforms that needs it for power saving
-	 * should call enable_hlt() in init code, since by default it is
-	 * disabled.
-	 */
-	local_irq_enable();
-	cpu_do_idle();
-}
-
-static int __init gemini_idle_init(void)
-{
-	arm_pm_idle = gemini_idle;
-	return 0;
-}
-
-arch_initcall(gemini_idle_init);
diff --git a/arch/arm/mach-gemini/include/mach/debug-macro.S b/arch/arm/mach-gemini/include/mach/debug-macro.S
deleted file mode 100644
index 8376707..0000000
--- a/arch/arm/mach-gemini/include/mach/debug-macro.S
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Debugging macro include header
- *
- *  Copyright (C) 1994-1999 Russell King
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <mach/hardware.h>
-
-	.macro	addruart, rp, rv, tmp
-	ldr	\rp, =GEMINI_UART_BASE			@ physical
-	ldr	\rv, =IO_ADDRESS(GEMINI_UART_BASE)	@ virtual
-	.endm
-
-#define UART_SHIFT	2
-#define FLOW_CONTROL
-#include <asm/hardware/debug-8250.S>
diff --git a/arch/arm/mach-gemini/include/mach/entry-macro.S b/arch/arm/mach-gemini/include/mach/entry-macro.S
deleted file mode 100644
index f044e43..0000000
--- a/arch/arm/mach-gemini/include/mach/entry-macro.S
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- * Low-level IRQ helper macros for Gemini platform.
- *
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- */
-#include <mach/hardware.h>
-
-#define IRQ_STATUS	0x14
-
-	.macro  get_irqnr_preamble, base, tmp
-	.endm
-
-	.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
-	ldr     \irqstat, =IO_ADDRESS(GEMINI_INTERRUPT_BASE + IRQ_STATUS)
-	ldr     \irqnr, [\irqstat]
-	cmp     \irqnr, #0
-	beq     2313f
-	mov     \tmp, \irqnr
-	mov     \irqnr, #0
-2312:
-	tst     \tmp, #1
-	bne     2313f
-	add     \irqnr, \irqnr, #1
-	mov     \tmp, \tmp, lsr #1
-	cmp     \irqnr, #31
-	bcc     2312b
-2313:
-	.endm
diff --git a/arch/arm/mach-gemini/include/mach/global_reg.h b/arch/arm/mach-gemini/include/mach/global_reg.h
deleted file mode 100644
index de7ff7e..0000000
--- a/arch/arm/mach-gemini/include/mach/global_reg.h
+++ /dev/null
@@ -1,278 +0,0 @@
-/*
- *  This file contains the hardware definitions for Gemini.
- *
- *  Copyright (C) 2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __MACH_GLOBAL_REG_H
-#define __MACH_GLOBAL_REG_H
-
-/* Global Word ID Register*/
-#define GLOBAL_ID			0x00
-
-#define CHIP_ID(reg)			((reg) >> 8)
-#define CHIP_REVISION(reg)		((reg) & 0xFF)
-
-/* Global Status Register */
-#define GLOBAL_STATUS			0x04
-
-#define CPU_BIG_ENDIAN			(1 << 31)
-#define PLL_OSC_30M			(1 << 30)	/* else 60MHz */
-
-#define OPERATION_MODE_MASK		(0xF << 26)
-#define OPM_IDDQ			(0xF << 26)
-#define OPM_NAND			(0xE << 26)
-#define OPM_RING			(0xD << 26)
-#define OPM_DIRECT_BOOT			(0xC << 26)
-#define OPM_USB1_PHY_TEST		(0xB << 26)
-#define OPM_USB0_PHY_TEST		(0xA << 26)
-#define OPM_SATA1_PHY_TEST		(0x9 << 26)
-#define OPM_SATA0_PHY_TEST		(0x8 << 26)
-#define OPM_ICE_ARM			(0x7 << 26)
-#define OPM_ICE_FARADAY			(0x6 << 26)
-#define OPM_PLL_BYPASS			(0x5 << 26)
-#define OPM_DEBUG			(0x4 << 26)
-#define OPM_BURN_IN			(0x3 << 26)
-#define OPM_MBIST			(0x2 << 26)
-#define OPM_SCAN			(0x1 << 26)
-#define OPM_REAL			(0x0 << 26)
-
-#define FLASH_TYPE_MASK			(0x3 << 24)
-#define FLASH_TYPE_NAND_2K		(0x3 << 24)
-#define FLASH_TYPE_NAND_512		(0x2 << 24)
-#define FLASH_TYPE_PARALLEL		(0x1 << 24)
-#define FLASH_TYPE_SERIAL		(0x0 << 24)
-/* if parallel */
-#define FLASH_WIDTH_16BIT		(1 << 23)	/* else 8 bit */
-/* if serial */
-#define FLASH_ATMEL			(1 << 23)	/* else STM */
-
-#define FLASH_SIZE_MASK			(0x3 << 21)
-#define NAND_256M			(0x3 << 21)	/* and more */
-#define NAND_128M			(0x2 << 21)
-#define NAND_64M			(0x1 << 21)
-#define NAND_32M			(0x0 << 21)
-#define ATMEL_16M			(0x3 << 21)	/* and more */
-#define ATMEL_8M			(0x2 << 21)
-#define ATMEL_4M_2M			(0x1 << 21)
-#define ATMEL_1M			(0x0 << 21)	/* and less */
-#define STM_32M				(1 << 22)	/* and more */
-#define STM_16M				(0 << 22)	/* and less */
-
-#define FLASH_PARALLEL_HIGH_PIN_CNT	(1 << 20)	/* else low pin cnt */
-
-#define CPU_AHB_RATIO_MASK		(0x3 << 18)
-#define CPU_AHB_1_1			(0x0 << 18)
-#define CPU_AHB_3_2			(0x1 << 18)
-#define CPU_AHB_24_13			(0x2 << 18)
-#define CPU_AHB_2_1			(0x3 << 18)
-
-#define REG_TO_AHB_SPEED(reg)		((((reg) >> 15) & 0x7) * 10 + 130)
-#define AHB_SPEED_TO_REG(x)		((((x - 130)) / 10) << 15)
-
-/* it is posible to override some settings, use >> OVERRIDE_xxxx_SHIFT */
-#define OVERRIDE_FLASH_TYPE_SHIFT	16
-#define OVERRIDE_FLASH_WIDTH_SHIFT	16
-#define OVERRIDE_FLASH_SIZE_SHIFT	16
-#define OVERRIDE_CPU_AHB_RATIO_SHIFT	15
-#define OVERRIDE_AHB_SPEED_SHIFT	15
-
-/* Global PLL Control Register */
-#define GLOBAL_PLL_CTRL			0x08
-
-#define PLL_BYPASS			(1 << 31)
-#define PLL_POWER_DOWN			(1 << 8)
-#define PLL_CONTROL_Q			(0x1F << 0)
-
-/* Global Soft Reset Control Register */
-#define GLOBAL_RESET			0x0C
-
-#define RESET_GLOBAL			(1 << 31)
-#define RESET_CPU1			(1 << 30)
-#define RESET_TVE			(1 << 28)
-#define RESET_SATA1			(1 << 27)
-#define RESET_SATA0			(1 << 26)
-#define RESET_CIR			(1 << 25)
-#define RESET_EXT_DEV			(1 << 24)
-#define RESET_WD			(1 << 23)
-#define RESET_GPIO2			(1 << 22)
-#define RESET_GPIO1			(1 << 21)
-#define RESET_GPIO0			(1 << 20)
-#define RESET_SSP			(1 << 19)
-#define RESET_UART			(1 << 18)
-#define RESET_TIMER			(1 << 17)
-#define RESET_RTC			(1 << 16)
-#define RESET_INT1			(1 << 15)
-#define RESET_INT0			(1 << 14)
-#define RESET_LCD			(1 << 13)
-#define RESET_LPC			(1 << 12)
-#define RESET_APB			(1 << 11)
-#define RESET_DMA			(1 << 10)
-#define RESET_USB1			(1 << 9)
-#define RESET_USB0			(1 << 8)
-#define RESET_PCI			(1 << 7)
-#define RESET_GMAC1			(1 << 6)
-#define RESET_GMAC0			(1 << 5)
-#define RESET_SECURITY			(1 << 4)
-#define RESET_RAID			(1 << 3)
-#define RESET_IDE			(1 << 2)
-#define RESET_FLASH			(1 << 1)
-#define RESET_DRAM			(1 << 0)
-
-/* Global IO Pad Driving Capability Control Register */
-#define GLOBAL_IO_DRIVING_CTRL		0x10
-
-#define DRIVING_CURRENT_MASK		0x3
-
-/* here 00-4mA, 01-8mA, 10-12mA, 11-16mA */
-#define GPIO1_PADS_31_28_SHIFT		28
-#define GPIO0_PADS_31_16_SHIFT		26
-#define GPIO0_PADS_15_0_SHIFT		24
-#define PCI_AND_EXT_RESET_PADS_SHIFT	22
-#define IDE_PADS_SHIFT			20
-#define GMAC1_PADS_SHIFT		18
-#define GMAC0_PADS_SHIFT		16
-/* DRAM is not in mA and poorly documented */
-#define DRAM_CLOCK_PADS_SHIFT		8
-#define DRAM_DATA_PADS_SHIFT		4
-#define DRAM_CONTROL_PADS_SHIFT		0
-
-/* Global IO Pad Slew Rate Control Register */
-#define GLOBAL_IO_SLEW_RATE_CTRL	0x14
-
-#define GPIO1_PADS_31_28_SLOW		(1 << 10)
-#define GPIO0_PADS_31_16_SLOW		(1 << 9)
-#define GPIO0_PADS_15_0_SLOW		(1 << 8)
-#define PCI_PADS_SLOW			(1 << 7)
-#define IDE_PADS_SLOW			(1 << 6)
-#define GMAC1_PADS_SLOW			(1 << 5)
-#define GMAC0_PADS_SLOW			(1 << 4)
-#define DRAM_CLOCK_PADS_SLOW		(1 << 1)
-#define DRAM_IO_PADS_SLOW		(1 << 0)
-
-/*
- * General skew control defines
- * 16 steps, each step is around 0.2ns
- */
-#define SKEW_MASK			0xF
-
-/* Global IDE PAD Skew Control Register */
-#define GLOBAL_IDE_SKEW_CTRL		0x18
-
-#define IDE1_HOST_STROBE_DELAY_SHIFT	28
-#define IDE1_DEVICE_STROBE_DELAY_SHIFT	24
-#define IDE1_OUTPUT_IO_SKEW_SHIFT	20
-#define IDE1_INPUT_IO_SKEW_SHIFT	16
-#define IDE0_HOST_STROBE_DELAY_SHIFT	12
-#define IDE0_DEVICE_STROBE_DELAY_SHIFT	8
-#define IDE0_OUTPUT_IO_SKEW_SHIFT	4
-#define IDE0_INPUT_IO_SKEW_SHIFT	0
-
-/* Global GMAC Control Pad Skew Control Register */
-#define GLOBAL_GMAC_CTRL_SKEW_CTRL	0x1C
-
-#define GMAC1_TXC_SKEW_SHIFT		28
-#define GMAC1_TXEN_SKEW_SHIFT		24
-#define GMAC1_RXC_SKEW_SHIFT		20
-#define GMAC1_RXDV_SKEW_SHIFT		16
-#define GMAC0_TXC_SKEW_SHIFT		12
-#define GMAC0_TXEN_SKEW_SHIFT		8
-#define GMAC0_RXC_SKEW_SHIFT		4
-#define GMAC0_RXDV_SKEW_SHIFT		0
-
-/* Global GMAC0 Data PAD Skew Control Register */
-#define GLOBAL_GMAC0_DATA_SKEW_CTRL	0x20
-/* Global GMAC1 Data PAD Skew Control Register */
-#define GLOBAL_GMAC1_DATA_SKEW_CTRL	0x24
-
-#define GMAC_TXD_SKEW_SHIFT(x)		(((x) * 4) + 16)
-#define GMAC_RXD_SKEW_SHIFT(x)		((x) * 4)
-
-/* CPU has two AHB busses. */
-
-/* Global Arbitration0 Control Register */
-#define GLOBAL_ARBITRATION0_CTRL	0x28
-
-#define BOOT_CONTROLLER_HIGH_PRIO	(1 << 3)
-#define DMA_BUS1_HIGH_PRIO		(1 << 2)
-#define CPU0_HIGH_PRIO			(1 << 0)
-
-/* Global Arbitration1 Control Register */
-#define GLOBAL_ARBITRATION1_CTRL	0x2C
-
-#define TVE_HIGH_PRIO			(1 << 9)
-#define PCI_HIGH_PRIO			(1 << 8)
-#define USB1_HIGH_PRIO			(1 << 7)
-#define USB0_HIGH_PRIO			(1 << 6)
-#define GMAC1_HIGH_PRIO			(1 << 5)
-#define GMAC0_HIGH_PRIO			(1 << 4)
-#define SECURITY_HIGH_PRIO		(1 << 3)
-#define RAID_HIGH_PRIO			(1 << 2)
-#define IDE_HIGH_PRIO			(1 << 1)
-#define DMA_BUS2_HIGH_PRIO		(1 << 0)
-
-/* Common bits for both arbitration registers */
-#define BURST_LENGTH_SHIFT		16
-#define BURST_LENGTH_MASK		(0x3F << 16)
-
-/* Miscellaneous Control Register */
-#define GLOBAL_MISC_CTRL		0x30
-
-#define MEMORY_SPACE_SWAP		(1 << 31)
-#define USB1_PLUG_MINIB			(1 << 30) /* else plug is mini-A */
-#define USB0_PLUG_MINIB			(1 << 29)
-#define GMAC_GMII			(1 << 28)
-#define GMAC_1_ENABLE			(1 << 27)
-/* TODO: define ATA/SATA bits */
-#define USB1_VBUS_ON			(1 << 23)
-#define USB0_VBUS_ON			(1 << 22)
-#define APB_CLKOUT_ENABLE		(1 << 21)
-#define TVC_CLKOUT_ENABLE		(1 << 20)
-#define EXT_CLKIN_ENABLE		(1 << 19)
-#define PCI_66MHZ			(1 << 18) /* else 33 MHz */
-#define PCI_CLKOUT_ENABLE		(1 << 17)
-#define LPC_CLKOUT_ENABLE		(1 << 16)
-#define USB1_WAKEUP_ON			(1 << 15)
-#define USB0_WAKEUP_ON			(1 << 14)
-/* TODO: define PCI idle detect bits */
-#define TVC_PADS_ENABLE			(1 << 9)
-#define SSP_PADS_ENABLE			(1 << 8)
-#define LCD_PADS_ENABLE			(1 << 7)
-#define LPC_PADS_ENABLE			(1 << 6)
-#define PCI_PADS_ENABLE			(1 << 5)
-#define IDE_PADS_ENABLE			(1 << 4)
-#define DRAM_PADS_POWER_DOWN		(1 << 3)
-#define NAND_PADS_DISABLE		(1 << 2)
-#define PFLASH_PADS_DISABLE		(1 << 1)
-#define SFLASH_PADS_DISABLE		(1 << 0)
-
-/* Global Clock Control Register */
-#define GLOBAL_CLOCK_CTRL		0x34
-
-#define POWER_STATE_G0			(1 << 31)
-#define POWER_STATE_S1			(1 << 30) /* else it is S3/S4 state */
-#define SECURITY_APB_AHB		(1 << 29)
-/* else Security APB clk will be 0.75xAHB */
-/* TODO: TVC clock divider */
-#define PCI_CLKRUN_ENABLE		(1 << 16)
-#define BOOT_CLK_DISABLE		(1 << 13)
-#define TVC_CLK_DISABLE			(1 << 12)
-#define FLASH_CLK_DISABLE		(1 << 11)
-#define DDR_CLK_DISABLE			(1 << 10)
-#define PCI_CLK_DISABLE			(1 << 9)
-#define IDE_CLK_DISABLE			(1 << 8)
-#define USB1_CLK_DISABLE		(1 << 7)
-#define USB0_CLK_DISABLE		(1 << 6)
-#define SATA1_CLK_DISABLE		(1 << 5)
-#define SATA0_CLK_DISABLE		(1 << 4)
-#define GMAC1_CLK_DISABLE		(1 << 3)
-#define GMAC0_CLK_DISABLE		(1 << 2)
-#define SECURITY_CLK_DISABLE		(1 << 1)
-
-/* TODO: other registers definitions if needed */
-
-#endif /* __MACH_GLOBAL_REG_H */
diff --git a/arch/arm/mach-gemini/include/mach/gpio.h b/arch/arm/mach-gemini/include/mach/gpio.h
deleted file mode 100644
index 40a0527..0000000
--- a/arch/arm/mach-gemini/include/mach/gpio.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Gemini gpiolib specific defines
- *
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __MACH_GPIO_H__
-#define __MACH_GPIO_H__
-
-#include <mach/irqs.h>
-
-#define gpio_to_irq(x)	((x) + GPIO_IRQ_BASE)
-#define irq_to_gpio(x)	((x) - GPIO_IRQ_BASE)
-
-#endif /* __MACH_GPIO_H__ */
diff --git a/arch/arm/mach-gemini/include/mach/hardware.h b/arch/arm/mach-gemini/include/mach/hardware.h
deleted file mode 100644
index 98e7b0f..0000000
--- a/arch/arm/mach-gemini/include/mach/hardware.h
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- *  This file contains the hardware definitions for Gemini.
- *
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __MACH_HARDWARE_H
-#define __MACH_HARDWARE_H
-
-/*
- * Memory Map definitions
- */
-#ifdef CONFIG_GEMINI_MEM_SWAP
-# define GEMINI_DRAM_BASE	0x00000000
-# define GEMINI_SRAM_BASE	0x70000000
-#else
-# define GEMINI_SRAM_BASE	0x00000000
-# define GEMINI_DRAM_BASE	0x10000000
-#endif
-#define GEMINI_FLASH_BASE	0x30000000
-#define GEMINI_GLOBAL_BASE	0x40000000
-#define GEMINI_WAQTCHDOG_BASE	0x41000000
-#define GEMINI_UART_BASE	0x42000000
-#define GEMINI_TIMER_BASE	0x43000000
-#define GEMINI_LCD_BASE		0x44000000
-#define GEMINI_RTC_BASE		0x45000000
-#define GEMINI_SATA_BASE	0x46000000
-#define GEMINI_LPC_HOST_BASE	0x47000000
-#define GEMINI_LPC_IO_BASE	0x47800000
-#define GEMINI_INTERRUPT_BASE	0x48000000
-/* TODO: Different interrupt controllers when SMP
- * #define GEMINI_INTERRUPT0_BASE	0x48000000
- * #define GEMINI_INTERRUPT1_BASE	0x49000000
- */
-#define GEMINI_SSP_CTRL_BASE	0x4A000000
-#define GEMINI_POWER_CTRL_BASE	0x4B000000
-#define GEMINI_CIR_BASE		0x4C000000
-#define GEMINI_GPIO_BASE(x)	(0x4D000000 + (x) * 0x1000000)
-#define GEMINI_PCI_IO_BASE	0x50000000
-#define GEMINI_PCI_MEM_BASE	0x58000000
-#define GEMINI_TOE_BASE		0x60000000
-#define GEMINI_GMAC0_BASE	0x6000A000
-#define GEMINI_GMAC1_BASE	0x6000E000
-#define GEMINI_SECURITY_BASE	0x62000000
-#define GEMINI_IDE0_BASE	0x63000000
-#define GEMINI_IDE1_BASE	0x63400000
-#define GEMINI_RAID_BASE	0x64000000
-#define GEMINI_FLASH_CTRL_BASE	0x65000000
-#define GEMINI_DRAM_CTRL_BASE	0x66000000
-#define GEMINI_GENERAL_DMA_BASE	0x67000000
-#define GEMINI_USB0_BASE	0x68000000
-#define GEMINI_USB1_BASE	0x69000000
-#define GEMINI_BIG_ENDIAN_BASE	0x80000000
-
-#define GEMINI_TIMER1_BASE	GEMINI_TIMER_BASE
-#define GEMINI_TIMER2_BASE	(GEMINI_TIMER_BASE + 0x10)
-#define GEMINI_TIMER3_BASE	(GEMINI_TIMER_BASE + 0x20)
-
-/*
- * UART Clock when System clk is 150MHz
- */
-#define UART_CLK	48000000
-
-/*
- * macro to get at IO space when running virtually
- */
-#define IO_ADDRESS(x)	IOMEM((((x) & 0xFFF00000) >> 4) | ((x) & 0x000FFFFF) | 0xF0000000)
-
-#endif
diff --git a/arch/arm/mach-gemini/include/mach/irqs.h b/arch/arm/mach-gemini/include/mach/irqs.h
deleted file mode 100644
index 06bc47e..0000000
--- a/arch/arm/mach-gemini/include/mach/irqs.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/*
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __MACH_IRQS_H__
-#define __MACH_IRQS_H__
-
-#define IRQ_SERIRQ1	31
-#define IRQ_SERIRQ0	30
-#define IRQ_PCID	29
-#define IRQ_PCIC	28
-#define IRQ_PCIB	27
-#define IRQ_PWR		26
-#define IRQ_CIR		25
-#define IRQ_GPIO(x)	(22 + (x))
-#define IRQ_SSP		21
-#define IRQ_LPC		20
-#define IRQ_LCD		19
-#define IRQ_UART	18
-#define IRQ_RTC		17
-#define IRQ_TIMER3	16
-#define IRQ_TIMER2	15
-#define IRQ_TIMER1	14
-#define IRQ_FLASH	12
-#define IRQ_USB1	11
-#define IRQ_USB0	10
-#define IRQ_DMA		9
-#define IRQ_PCI		8
-#define IRQ_IPSEC	7
-#define IRQ_RAID	6
-#define IRQ_IDE1	5
-#define IRQ_IDE0	4
-#define IRQ_WATCHDOG	3
-#define IRQ_GMAC1	2
-#define IRQ_GMAC0	1
-#define IRQ_IPI		0
-
-#define NORMAL_IRQ_NUM	32
-
-#define GPIO_IRQ_BASE	NORMAL_IRQ_NUM
-#define GPIO_IRQ_NUM	(3 * 32)
-
-#define ARCH_TIMER_IRQ	IRQ_TIMER2
-
-#define NR_IRQS		(NORMAL_IRQ_NUM + GPIO_IRQ_NUM)
-
-#endif /* __MACH_IRQS_H__ */
diff --git a/arch/arm/mach-gemini/include/mach/timex.h b/arch/arm/mach-gemini/include/mach/timex.h
deleted file mode 100644
index dc5690b..0000000
--- a/arch/arm/mach-gemini/include/mach/timex.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * Gemini timex specifications
- *
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-/* When AHB bus frequency is 150MHz */
-#define CLOCK_TICK_RATE	38000000
diff --git a/arch/arm/mach-gemini/include/mach/uncompress.h b/arch/arm/mach-gemini/include/mach/uncompress.h
deleted file mode 100644
index 02e2256..0000000
--- a/arch/arm/mach-gemini/include/mach/uncompress.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * Based on mach-pxa/include/mach/uncompress.h:
- * Copyright:	(C) 2001 MontaVista Software Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __MACH_UNCOMPRESS_H
-#define __MACH_UNCOMPRESS_H
-
-#include <linux/serial_reg.h>
-#include <mach/hardware.h>
-
-static volatile unsigned long * const UART = (unsigned long *)GEMINI_UART_BASE;
-
-/*
- * The following code assumes the serial port has already been
- * initialized by the bootloader.  If you didn't setup a port in
- * your bootloader then nothing will appear (which might be desired).
- */
-static inline void putc(char c)
-{
-	while (!(UART[UART_LSR] & UART_LSR_THRE))
-		barrier();
-	UART[UART_TX] = c;
-}
-
-static inline void flush(void)
-{
-}
-
-/*
- * nothing to do
- */
-#define arch_decomp_setup()
-
-#endif /* __MACH_UNCOMPRESS_H */
diff --git a/arch/arm/mach-gemini/irq.c b/arch/arm/mach-gemini/irq.c
deleted file mode 100644
index 30bef11..0000000
--- a/arch/arm/mach-gemini/irq.c
+++ /dev/null
@@ -1,103 +0,0 @@
-/*
- *  Interrupt routines for Gemini
- *
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/ioport.h>
-#include <linux/stddef.h>
-#include <linux/list.h>
-#include <linux/sched.h>
-#include <asm/irq.h>
-#include <asm/mach/irq.h>
-#include <asm/system_misc.h>
-#include <mach/hardware.h>
-
-#define IRQ_SOURCE(base_addr)	(base_addr + 0x00)
-#define IRQ_MASK(base_addr)	(base_addr + 0x04)
-#define IRQ_CLEAR(base_addr)	(base_addr + 0x08)
-#define IRQ_TMODE(base_addr)	(base_addr + 0x0C)
-#define IRQ_TLEVEL(base_addr)	(base_addr + 0x10)
-#define IRQ_STATUS(base_addr)	(base_addr + 0x14)
-#define FIQ_SOURCE(base_addr)	(base_addr + 0x20)
-#define FIQ_MASK(base_addr)	(base_addr + 0x24)
-#define FIQ_CLEAR(base_addr)	(base_addr + 0x28)
-#define FIQ_TMODE(base_addr)	(base_addr + 0x2C)
-#define FIQ_LEVEL(base_addr)	(base_addr + 0x30)
-#define FIQ_STATUS(base_addr)	(base_addr + 0x34)
-
-static void gemini_ack_irq(struct irq_data *d)
-{
-	__raw_writel(1 << d->irq, IRQ_CLEAR(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-}
-
-static void gemini_mask_irq(struct irq_data *d)
-{
-	unsigned int mask;
-
-	mask = __raw_readl(IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-	mask &= ~(1 << d->irq);
-	__raw_writel(mask, IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-}
-
-static void gemini_unmask_irq(struct irq_data *d)
-{
-	unsigned int mask;
-
-	mask = __raw_readl(IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-	mask |= (1 << d->irq);
-	__raw_writel(mask, IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-}
-
-static struct irq_chip gemini_irq_chip = {
-	.name		= "INTC",
-	.irq_ack	= gemini_ack_irq,
-	.irq_mask	= gemini_mask_irq,
-	.irq_unmask	= gemini_unmask_irq,
-};
-
-static struct resource irq_resource = {
-	.name	= "irq_handler",
-	.start	= GEMINI_INTERRUPT_BASE,
-	.end	= FIQ_STATUS(GEMINI_INTERRUPT_BASE) + 4,
-};
-
-void __init gemini_init_irq(void)
-{
-	unsigned int i, mode = 0, level = 0;
-
-	/*
-	 * Disable the idle handler by default since it is buggy
-	 * For more info see arch/arm/mach-gemini/idle.c
-	 */
-	disable_hlt();
-
-	request_resource(&iomem_resource, &irq_resource);
-
-	for (i = 0; i < NR_IRQS; i++) {
-		irq_set_chip(i, &gemini_irq_chip);
-		if((i >= IRQ_TIMER1 && i <= IRQ_TIMER3) || (i >= IRQ_SERIRQ0 && i <= IRQ_SERIRQ1)) {
-			irq_set_handler(i, handle_edge_irq);
-			mode |= 1 << i;
-			level |= 1 << i;
-		} else {			
-			irq_set_handler(i, handle_level_irq);
-		}
-		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
-	}
-
-	/* Disable all interrupts */
-	__raw_writel(0, IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-	__raw_writel(0, FIQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-
-	/* Set interrupt mode */
-	__raw_writel(mode, IRQ_TMODE(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-	__raw_writel(level, IRQ_TLEVEL(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
-}
diff --git a/arch/arm/mach-gemini/mm.c b/arch/arm/mach-gemini/mm.c
deleted file mode 100644
index 2c2cd28..0000000
--- a/arch/arm/mach-gemini/mm.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- *  Static mappings for Gemini
- *
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/mm.h>
-#include <linux/init.h>
-
-#include <asm/mach/map.h>
-
-#include <mach/hardware.h>
-
-/* Page table mapping for I/O region */
-static struct map_desc gemini_io_desc[] __initdata = {
-	{
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GLOBAL_BASE),
-		.pfn		=__phys_to_pfn(GEMINI_GLOBAL_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_UART_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_UART_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_TIMER_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_TIMER_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_INTERRUPT_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_INTERRUPT_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_POWER_CTRL_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_POWER_CTRL_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(0)),
-		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(0)),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(1)),
-		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(1)),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GPIO_BASE(2)),
-		.pfn		= __phys_to_pfn(GEMINI_GPIO_BASE(2)),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_FLASH_CTRL_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_FLASH_CTRL_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_DRAM_CTRL_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_DRAM_CTRL_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	}, {
-		.virtual	= (unsigned long)IO_ADDRESS(GEMINI_GENERAL_DMA_BASE),
-		.pfn		= __phys_to_pfn(GEMINI_GENERAL_DMA_BASE),
-		.length		= SZ_512K,
-		.type 		= MT_DEVICE,
-	},
-};
-
-void __init gemini_map_io(void)
-{
-	iotable_init(gemini_io_desc, ARRAY_SIZE(gemini_io_desc));
-}
diff --git a/arch/arm/mach-gemini/reset.c b/arch/arm/mach-gemini/reset.c
deleted file mode 100644
index b266597..0000000
--- a/arch/arm/mach-gemini/reset.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#ifndef __MACH_SYSTEM_H
-#define __MACH_SYSTEM_H
-
-#include <linux/io.h>
-#include <mach/hardware.h>
-#include <mach/global_reg.h>
-
-void gemini_restart(char mode, const char *cmd)
-{
-	__raw_writel(RESET_GLOBAL | RESET_CPU1,
-		     IO_ADDRESS(GEMINI_GLOBAL_BASE) + GLOBAL_RESET);
-}
-
-#endif /* __MACH_SYSTEM_H */
diff --git a/arch/arm/mach-gemini/time.c b/arch/arm/mach-gemini/time.c
deleted file mode 100644
index 21dc5a8..0000000
--- a/arch/arm/mach-gemini/time.c
+++ /dev/null
@@ -1,89 +0,0 @@
-/*
- *  Copyright (C) 2001-2006 Storlink, Corp.
- *  Copyright (C) 2008-2009 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <mach/hardware.h>
-#include <mach/global_reg.h>
-#include <asm/mach/time.h>
-
-/*
- * Register definitions for the timers
- */
-#define TIMER_COUNT(BASE_ADDR)		(BASE_ADDR  + 0x00)
-#define TIMER_LOAD(BASE_ADDR)		(BASE_ADDR  + 0x04)
-#define TIMER_MATCH1(BASE_ADDR)		(BASE_ADDR  + 0x08)
-#define TIMER_MATCH2(BASE_ADDR)		(BASE_ADDR  + 0x0C)
-#define TIMER_CR(BASE_ADDR)		(BASE_ADDR  + 0x30)
-
-#define TIMER_1_CR_ENABLE		(1 << 0)
-#define TIMER_1_CR_CLOCK		(1 << 1)
-#define TIMER_1_CR_INT			(1 << 2)
-#define TIMER_2_CR_ENABLE		(1 << 3)
-#define TIMER_2_CR_CLOCK		(1 << 4)
-#define TIMER_2_CR_INT			(1 << 5)
-#define TIMER_3_CR_ENABLE		(1 << 6)
-#define TIMER_3_CR_CLOCK		(1 << 7)
-#define TIMER_3_CR_INT			(1 << 8)
-
-/*
- * IRQ handler for the timer
- */
-static irqreturn_t gemini_timer_interrupt(int irq, void *dev_id)
-{
-	timer_tick();
-
-	return IRQ_HANDLED;
-}
-
-static struct irqaction gemini_timer_irq = {
-	.name		= "Gemini Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.handler	= gemini_timer_interrupt,
-};
-
-/*
- * Set up timer interrupt, and return the current time in seconds.
- */
-void __init gemini_timer_init(void)
-{
-	unsigned int tick_rate, reg_v;
-
-	reg_v = __raw_readl(IO_ADDRESS(GEMINI_GLOBAL_BASE + GLOBAL_STATUS));
-	tick_rate = REG_TO_AHB_SPEED(reg_v) * 1000000;
-
-	printk(KERN_INFO "Bus: %dMHz", tick_rate / 1000000);
-
-	tick_rate /= 6;		/* APB bus run AHB*(1/6) */
-
-	switch(reg_v & CPU_AHB_RATIO_MASK) {
-	case CPU_AHB_1_1:
-		printk(KERN_CONT "(1/1)\n");
-		break;
-	case CPU_AHB_3_2:
-		printk(KERN_CONT "(3/2)\n");
-		break;
-	case CPU_AHB_24_13:
-		printk(KERN_CONT "(24/13)\n");
-		break;
-	case CPU_AHB_2_1:
-		printk(KERN_CONT "(2/1)\n");
-		break;
-	}
-
-	/*
-	 * Make irqs happen for the system timer
-	 */
-	setup_irq(IRQ_TIMER2, &gemini_timer_irq);
-	/* Start the timer */
-	__raw_writel(tick_rate / HZ, TIMER_COUNT(IO_ADDRESS(GEMINI_TIMER2_BASE)));
-	__raw_writel(tick_rate / HZ, TIMER_LOAD(IO_ADDRESS(GEMINI_TIMER2_BASE)));
-	__raw_writel(TIMER_2_CR_ENABLE | TIMER_2_CR_INT, TIMER_CR(IO_ADDRESS(GEMINI_TIMER_BASE)));
-}
-- 
1.8.1.2


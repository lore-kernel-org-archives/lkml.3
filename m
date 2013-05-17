Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3EQLR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:17:58 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:46379 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3EQLRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:17:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] cris: Switch cris to drivers/Kconfig
Date: Fri, 17 May 2013 13:17:42 +0200
Message-Id: <1368789465-3761-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allmodconfig:

drivers/video/console/fonts.c:71:2: error: #error No fonts configured.

This is caused by cris not using the generic drivers/Kconfig, and thus not
traversing drivers/video/console/Kconfig.
As the build system does traverse drivers/video/console/Makefile, fonts.c
was compiled with an inconsistent configuration.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/Kconfig                  |   32 +-------------------------------
 arch/cris/arch-v32/drivers/Kconfig |    7 -------
 2 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 8769a90..9f3c543 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -637,40 +637,10 @@ endchoice
 
 endmenu
 
-source "drivers/base/Kconfig"
-
-# standard linux drivers
-source "drivers/mtd/Kconfig"
-
-source "drivers/parport/Kconfig"
-
-source "drivers/pnp/Kconfig"
-
-source "drivers/block/Kconfig"
-
-source "drivers/ide/Kconfig"
-
-source "drivers/net/Kconfig"
-
-source "drivers/i2c/Kconfig"
-
-source "drivers/rtc/Kconfig"
-
-#
-# input before char - char/joystick depends on it. As does USB.
-#
-source "drivers/input/Kconfig"
-
-source "drivers/char/Kconfig"
+source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-source "drivers/usb/Kconfig"
-
-source "drivers/uwb/Kconfig"
-
-source "drivers/staging/Kconfig"
-
 source "arch/cris/Kconfig.debug"
 
 source "security/Kconfig"
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index c55971a..f64779c 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -641,8 +641,6 @@ config ETRAX_STREAMCOPROC
 	  This option enables a driver for the stream co-processor
 	  for cryptographic operations.
 
-source drivers/mmc/Kconfig
-
 config ETRAX_MMC_IOP
 	tristate "MMC/SD host driver using IO-processor"
 	depends on ETRAX_ARCH_V32 && MMC
@@ -834,9 +832,4 @@ config ETRAX_SPI_MMC_WP_GPIO_PIN
 	  The pin to use for the SD/MMC write-protect signal for a memory
 	  card.  If defined as " " (space), the card is considered writable.
 
-# Avoid choices causing non-working configs by conditionalizing the inclusion.
-if ETRAX_SPI_MMC
-source drivers/spi/Kconfig
-endif
-
 endif
-- 
1.7.0.4


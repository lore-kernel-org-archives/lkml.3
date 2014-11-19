Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaKSKcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:32:35 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52611 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaKSKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:32:32 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/4] ARM: at91/Kconfig: remove unused config options
Date: Wed, 19 Nov 2014 11:31:14 +0100
Message-ID: <acbf0ad912a51c1508b7dab0d840604dbeb00109.1416392687.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1416392687.git.nicolas.ferre@atmel.com>
References: <cover.1416392687.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing old board !DT support, several Kconfig options were deleted.
Propagate this removal to drivers Kconfig files.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/misc/Kconfig            | 2 +-
 drivers/rtc/Kconfig             | 4 +---
 drivers/video/backlight/Kconfig | 1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index bbeb4516facf..006242c8bca0 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -75,7 +75,7 @@ config ATMEL_TCB_CLKSRC
 config ATMEL_TCB_CLKSRC_BLOCK
 	int
 	depends on ATMEL_TCB_CLKSRC
-	prompt "TC Block" if ARCH_AT91RM9200 || ARCH_AT91SAM9260 || CPU_AT32AP700X
+	prompt "TC Block" if CPU_AT32AP700X
 	default 0
 	range 0 1
 	help
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 7e024f1344c6..aa96e375915d 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1124,7 +1124,6 @@ config RTC_DRV_AT91SAM9_RTT
 	int
 	range 0 1
 	default 0
-	prompt "RTT module Number" if ARCH_AT91SAM9263
 	depends on RTC_DRV_AT91SAM9
 	help
 	  More than one RTT module is available. You can choose which
@@ -1133,8 +1132,7 @@ config RTC_DRV_AT91SAM9_RTT
 
 config RTC_DRV_AT91SAM9_GPBR
 	int
-	range 0 3 if !ARCH_AT91SAM9263
-	range 0 15 if ARCH_AT91SAM9263
+	range 0 3
 	default 0
 	prompt "Backup Register Number"
 	depends on RTC_DRV_AT91SAM9
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 8d03924749b8..efb09046a8cf 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -168,7 +168,6 @@ if BACKLIGHT_CLASS_DEVICE
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
 	depends on FB_ATMEL
-	default y if MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK
 	help
 	  This provides a backlight control internal to the Atmel LCDC
 	  driver.  If the LCD "contrast control" on your board is wired
-- 
2.1.3


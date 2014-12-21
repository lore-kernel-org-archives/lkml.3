Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaLULSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:18:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56984 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbaLULSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:18:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Alexander Stein <alexanders83@web.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        alexandre.belloni@free-electrons.com, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] ALSA: atmel: fix building the ac97 driver for at91-multiplatform
Date: Sun, 21 Dec 2014 12:18:09 +0100
Message-Id: <1419160689-20447-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

at91 will no longer export the mach/cpu.h and mach/hardware.h header files
in the future, which would break building the atmel ac97c driver.

Since the cpu_is_* check is only used to find out whether we are running
on avr32 or arm/at91, we can hardcode that check in the ARM case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: http://www.spinics.net/lists/arm-kernel/msg382068.html
---
 sound/atmel/ac97c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index b59427d5a697..83975f8d5947 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -34,10 +34,10 @@
 #include <linux/platform_data/dma-dw.h>
 #include <linux/dma/dw.h>
 
+#ifdef CONFIG_AVR32
 #include <mach/cpu.h>
-
-#ifdef CONFIG_ARCH_AT91
-#include <mach/hardware.h>
+#else
+#define cpu_is_at32ap7000() 0
 #endif
 
 #include "ac97c.h"
-- 
2.1.0


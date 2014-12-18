Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaLRXNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:13:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49407 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751701AbaLRXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:13:15 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Alexander Stein <alexanders83@web.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ALSA: atmel: fix building the ac97 driver for at91-multiplatform
Date: Fri, 19 Dec 2014 00:13:10 +0100
Message-Id: <1418944390-27719-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

at91 will no longer export the mach/cpu.h and mach/hardware.h header files
in the future, which would break building the atmel ac97c driver.

Since the cpu_is_* check is only used to find out whether we are running
on avr32 or arm/at91, we can hardcode that check in the ARM case.

Unfortunately the driver is missing other work to be useful again on ARM,
if anyone wants to actually use it, they need to add a DT binding, and
the driver should really be converted to use the ASoC framework.

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
+#define cpu_is_at32ap7000() (0)
 #endif
 
 #include "ac97c.h"
-- 
2.1.0


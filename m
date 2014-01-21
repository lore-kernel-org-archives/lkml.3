Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaAUNwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:52:45 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:48494 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaAUNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:52:40 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: u300: move timer driver to clocksource
Date: Tue, 21 Jan 2014 14:52:34 +0100
Message-Id: <1390312354-32689-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the U300 timer driver down to the clocksource driver
subsystem and keep arch/arm clean.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Daniel/tglx, if you prefer I can take this through ARM SoC
but since I'm listed as maintainer for this driver and nothing
much is happening on the U300, feel free to apply it to your
tree.
---
 MAINTAINERS                                                    | 1 +
 arch/arm/mach-u300/Makefile                                    | 2 +-
 drivers/clocksource/Makefile                                   | 1 +
 arch/arm/mach-u300/timer.c => drivers/clocksource/timer-u300.c | 4 ----
 4 files changed, 3 insertions(+), 5 deletions(-)
 rename arch/arm/mach-u300/timer.c => drivers/clocksource/timer-u300.c (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a6e4ac72287..ede1049b2aa0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1296,6 +1296,7 @@ M:	Linus Walleij <linus.walleij@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	arch/arm/mach-u300/
+F:	drivers/clocksource/timer-u300.c
 F:	drivers/i2c/busses/i2c-stu300.c
 F:	drivers/rtc/rtc-coh901331.c
 F:	drivers/watchdog/coh901327_wdt.c
diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
index 0f362b64fb87..3ec74ac95bc1 100644
--- a/arch/arm/mach-u300/Makefile
+++ b/arch/arm/mach-u300/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel, U300 machine.
 #
 
-obj-y		:= core.o timer.o
+obj-y		:= core.o
 obj-m		:=
 obj-n		:=
 obj-		:=
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 33621efb9148..dc17673d7397 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
+obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
diff --git a/arch/arm/mach-u300/timer.c b/drivers/clocksource/timer-u300.c
similarity index 99%
rename from arch/arm/mach-u300/timer.c
rename to drivers/clocksource/timer-u300.c
index 5226162fac69..79722349955e 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/drivers/clocksource/timer-u300.c
@@ -1,8 +1,4 @@
 /*
- *
- * arch/arm/mach-u300/timer.c
- *
- *
  * Copyright (C) 2007-2009 ST-Ericsson AB
  * License terms: GNU General Public License (GPL) version 2
  * Timer COH 901 328, runs the OS timer interrupt.
-- 
1.8.4.2


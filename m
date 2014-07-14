Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaGNQwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:52:49 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:58529 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaGNQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:52:41 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Mon, 14 Jul 2014 18:52:40 +0200
X-ME-IP: 109.222.66.217
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 1/4] clocksource: move PXA timer to clocksource framework
Date: Mon, 14 Jul 2014 18:52:01 +0200
Message-Id: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move time.c from arch/arm/mach-pxa/time.c to
drivers/clocksource/pxa_timer.c.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 arch/arm/mach-pxa/Makefile                                  | 2 +-
 drivers/clocksource/Makefile                                | 1 +
 arch/arm/mach-pxa/time.c => drivers/clocksource/pxa_timer.c | 0
 3 files changed, 2 insertions(+), 1 deletion(-)
 rename arch/arm/mach-pxa/time.c => drivers/clocksource/pxa_timer.c (100%)

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 648867a..2fe1824 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -4,7 +4,7 @@
 
 # Common support (must be linked before board specific support)
 obj-y				+= clock.o devices.o generic.o irq.o \
-				   time.o reset.o
+				   reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
 # Generic drivers that other drivers may depend upon
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 800b130..fc61ef8 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_ARCH_BCM2835)	+= bcm2835_timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
+obj-$(CONFIG_ARCH_PXA)		+= pxa_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
diff --git a/arch/arm/mach-pxa/time.c b/drivers/clocksource/pxa_timer.c
similarity index 100%
rename from arch/arm/mach-pxa/time.c
rename to drivers/clocksource/pxa_timer.c
-- 
2.0.0.rc2


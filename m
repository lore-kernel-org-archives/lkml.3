Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaJOMuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 08:50:20 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37117 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaJOMuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 08:50:17 -0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 1/2] clocksource: enable pxa_timer for SA-1100 platform
Date: Wed, 15 Oct 2014 16:50:04 +0400
Message-Id: <1413377405-7503-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SA-11x0 platform used the same IP block as was used on PXA. Consequently
it makes sense to have only one driver. Enable pxa_timer clocksource for
StrongARM platform.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/clocksource/Kconfig  | 6 ++++++
 drivers/clocksource/Makefile | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cfd6519..fd99b08 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -216,4 +216,10 @@ config CLKSRC_VERSATILE
 	  ARM Versatile, RealView and Versatile Express reference
 	  platforms.
 
+config CLKSRC_PXA
+	def_bool y if ARCH_PXA || ARCH_SA1100
+	help
+	  This enables OST0 support available on PXA and SA-11x0
+	  platforms.
+
 endmenu
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 7fd9fd1..6d9822e 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_ARCH_CLPS711X)	+= clps711x-timer.o
 obj-$(CONFIG_ARCH_MARCO)	+= timer-marco.o
 obj-$(CONFIG_ARCH_MOXART)	+= moxart_timer.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs_timer.o
-obj-$(CONFIG_ARCH_PXA)		+= pxa_timer.o
+obj-$(CONFIG_CLKSRC_PXA)	+= pxa_timer.o
 obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima2.o
 obj-$(CONFIG_ARCH_U300)		+= timer-u300.o
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
-- 
2.1.1


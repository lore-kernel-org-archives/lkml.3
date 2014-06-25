Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaFYNK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:10:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35688 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756418AbaFYNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:10:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 13/13] AT91: PIT: Move the driver to drivers/clocksource
Date: Wed, 25 Jun 2014 15:06:45 +0200
Message-Id: <1403701605-26678-14-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we don't depend on anyting in the mach-at91 directory, we can just
move the driver to where it belongs.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig                                     | 4 ----
 arch/arm/mach-at91/Makefile                                    | 1 -
 drivers/clocksource/Kconfig                                    | 4 ++++
 drivers/clocksource/Makefile                                   | 1 +
 {arch/arm/mach-at91 => drivers/clocksource}/at91sam926x_time.c | 0
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename {arch/arm/mach-at91 => drivers/clocksource}/at91sam926x_time.c (100%)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index a64412a020d3..b10db0990999 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -36,10 +36,6 @@ config AT91_SAM9G45_RESET
 	bool
 	default !ARCH_AT91X40
 
-config AT91_SAM9_TIME
-	select CLKSRC_OF if OF
-	bool
-
 config HAVE_AT91_SMD
 	bool
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 78e9cec282f4..1a916ececbfd 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -10,7 +10,6 @@ obj-		:=
 obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
 obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
 obj-$(CONFIG_AT91_SAM9G45_RESET) += at91sam9g45_reset.o
-obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 065131cbfcc0..cd8b73ddbef3 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -118,6 +118,10 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
 	help
 	 Use ARM global timer clock source as sched_clock
 
+config AT91_SAM9_TIME
+	select CLKSRC_OF if OF
+	bool
+
 config CLKSRC_METAG_GENERIC
 	def_bool y if METAG
 	help
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 800b1303c236..3088928070f8 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_CLKSRC_OF)	+= clksrc-of.o
 obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
+obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
 obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/drivers/clocksource/at91sam926x_time.c
similarity index 100%
rename from arch/arm/mach-at91/at91sam926x_time.c
rename to drivers/clocksource/at91sam926x_time.c
-- 
2.0.0


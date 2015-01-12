Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbbALPjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:39:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54913 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507AbbALPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:37:09 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v3 4/8] ARM: at91: time: move the system timer driver to drivers/clocksource
Date: Mon, 12 Jan 2015 16:36:59 +0100
Message-Id: <1421077023-30954-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Import at91rm9200_time.c from mach-at91 as timer-atmel-st.c. Further cleanup is
required to get rid of the mach-at91 headers.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/mach-at91/Makefile                                           | 2 +-
 drivers/clocksource/Kconfig                                           | 4 ++++
 drivers/clocksource/Makefile                                          | 1 +
 .../at91rm9200_time.c => drivers/clocksource/timer-atmel-st.c         | 0
 4 files changed, 6 insertions(+), 1 deletion(-)
 rename arch/arm/mach-at91/at91rm9200_time.c => drivers/clocksource/timer-atmel-st.c (100%)

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 7b6424d40764..5d1ee3a6f115 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -7,7 +7,7 @@ obj-y		:= setup.o sysirq_mask.o
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
-obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o at91rm9200_time.o
+obj-$(CONFIG_SOC_AT91RM9200)	+= at91rm9200.o
 obj-$(CONFIG_SOC_AT91SAM9260)	+= at91sam9260.o
 obj-$(CONFIG_SOC_AT91SAM9261)	+= at91sam9261.o
 obj-$(CONFIG_SOC_AT91SAM9263)	+= at91sam9263.o
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec27d3c8..ebc6dd77136e 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -128,6 +128,10 @@ config ATMEL_PIT
 	select CLKSRC_OF if OF
 	def_bool SOC_AT91SAM9 || SOC_SAMA5
 
+config ATMEL_ST
+	select CLKSRC_OF if OF
+	def_bool SOC_AT91RM9200
+
 config CLKSRC_METAG_GENERIC
 	def_bool y if METAG
 	help
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b24b56b..b7380ded4e4c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_CLKSRC_OF)	+= clksrc-of.o
 obj-$(CONFIG_ATMEL_PIT)		+= timer-atmel-pit.o
+obj-$(CONFIG_ATMEL_ST)		+= timer-atmel-st.o
 obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
 obj-$(CONFIG_X86_PM_TIMER)	+= acpi_pm.o
 obj-$(CONFIG_SCx200HR_TIMER)	+= scx200_hrt.o
diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/drivers/clocksource/timer-atmel-st.c
similarity index 100%
rename from arch/arm/mach-at91/at91rm9200_time.c
rename to drivers/clocksource/timer-atmel-st.c
-- 
2.1.0


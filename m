Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaEOGLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:11:08 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48837 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaEOGLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:11:03 -0400
X-Google-Original-From: Jassi Brar <jaswinder.singh@linaro.org>
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCHv5 1/4] mailbox: rename pl320-ipc specific mailbox.h
Date: Thu, 15 May 2014 11:40:05 +0530
Message-Id: <1400134205-3910-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The patch 30058677 "ARM / highbank: add support for pl320 IPC"
added a pl320 IPC specific header file as a generic mailbox.h.
This file has been renamed appropriately to allow the
introduction of the generic mailbox API framework.

Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/mach-highbank/highbank.c        | 2 +-
 drivers/cpufreq/highbank-cpufreq.c       | 2 +-
 drivers/mailbox/pl320-ipc.c              | 2 +-
 include/linux/{mailbox.h => pl320-ipc.h} | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename include/linux/{mailbox.h => pl320-ipc.h} (100%)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index c7de89b..f295cbb 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -20,7 +20,7 @@
 #include <linux/input.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index bf8902a..b464f29 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -19,7 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/of.h>
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 #include <linux/platform_device.h>
 
 #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cba..f3755e0 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 
 #define IPCMxSOURCE(m)		((m) * 0x40)
 #define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
diff --git a/include/linux/mailbox.h b/include/linux/pl320-ipc.h
similarity index 100%
rename from include/linux/mailbox.h
rename to include/linux/pl320-ipc.h
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3KTCPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:15:22 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48401 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3KTCPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:15:19 -0500
Message-ID: <1384913711.13115.2.camel@phoenix>
Subject: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
From: Axel Lin <axel.lin@ingics.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Nov 2013 10:15:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time-efm32 driver uses the clocksource MMIO functions.
Thus it needs to select CLKSRC_MMIO in Kconfig.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This fixes build error when COMPILE_TEST=y.
drivers/built-in.o: In function `efm32_clocksource_init':
drivers/clocksource/time-efm32.c:162: undefined reference to `clocksource_mmio_init'
drivers/built-in.o: In function `efm32_timer_init':
drivers/clocksource/time-efm32.c:274: undefined reference to `clocksource_mmio_readl_up'
make: *** [vmlinux] Error 1

 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index bdb953e..99763eb 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -75,6 +75,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 config CLKSRC_EFM32
 	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
 	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
+	select CLKSRC_MMIO
 	default ARCH_EFM32
 	help
 	  Support to use the timers of EFM32 SoCs as clock source and clock
-- 
1.8.1.2




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3LJTQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:16:16 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55214 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3LJTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:16:14 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/6] clocksource: time-efm32: Select CLKSRC_MMIO
Date: Tue, 10 Dec 2013 20:16:07 +0100
Message-Id: <1386702972-25565-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <52A767CB.3010501@linaro.org>
References: <52A767CB.3010501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

The time-efm32 driver uses the clocksource MMIO functions.
Thus it needs to select CLKSRC_MMIO in Kconfig.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/clocksource/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 5c07a56..634c4d6 100644
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
1.7.9.5


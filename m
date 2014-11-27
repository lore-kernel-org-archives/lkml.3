Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaK0QIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:08:23 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:54552 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaK0QIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:08:21 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 04/11] ARM: at91/Kconfig: remove ARCH_AT91RM9200 option for drivers
Date: Thu, 27 Nov 2014 17:06:32 +0100
Message-ID: <c7dbeffc8a6a4ec88b64e76da01c770526bf4358.1417103399.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1417103399.git.nicolas.ferre@atmel.com>
References: <cover.1417103399.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The precise selection is useless, so we simply remove these dependencies.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/net/ethernet/cadence/Kconfig | 2 +-
 drivers/rtc/Kconfig                  | 2 +-
 drivers/watchdog/Kconfig             | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 9e089d24466e..3564fe9d3f69 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -22,7 +22,7 @@ if NET_CADENCE
 
 config ARM_AT91_ETHER
 	tristate "AT91RM9200 Ethernet support"
-	depends on HAS_DMA && (ARCH_AT91RM9200 || COMPILE_TEST)
+	depends on HAS_DMA && (ARCH_AT91 || COMPILE_TEST)
 	select MACB
 	---help---
 	  If you wish to compile a kernel for the AT91RM9200 and enable
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index aa96e375915d..0b704889bf91 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1110,7 +1110,7 @@ config RTC_DRV_AT91RM9200
 
 config RTC_DRV_AT91SAM9
 	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"
-	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	depends on ARCH_AT91
 	help
 	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT
 	  (Real Time Timer). These timers are powered by the backup power
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d0107d424ee4..08f41add1461 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -154,14 +154,14 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on ARCH_AT91RM9200
+	depends on SOC_AT91RM9200
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
-	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	depends on ARCH_AT91
 	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
-- 
2.1.3


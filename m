Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaEZQh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:37:57 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:55423 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaEZQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:37:56 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: pebolle@tiscali.nl, galak@codeaurora.org, iivanov@mm-sol.com
Cc: arm@kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        olof@lixom.net, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2] ARM: msm: Update the references to DEBUG_MSM_UARTx
Date: Mon, 26 May 2014 19:37:40 +0300
Message-Id: <1401122260-12002-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401116287.6068.15.camel@x220>
References: <1401116287.6068.15.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART2, DEBUG_MSM_UART3,
MSM_DEBUG_UART1, MSM_DEBUG_UART2 and MSM_DEBUG_UART3 are removed, but 
they are still referenced in the following files:
	arch/arm/mach-msm/io.c,
	arch/arm/mach-msm/board-trout.c
	arch/arm/mach-msm/board-trout-gpio.c

Fix this by updating the reference to the new Kconfig option.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---

Changes since v1:
 - Fixed similar issue in board-trout.c and board-trout-gpio.c

 Applies to next-20140526.

 arch/arm/mach-msm/board-trout-gpio.c |    2 +-
 arch/arm/mach-msm/board-trout.c      |    2 +-
 arch/arm/mach-msm/io.c               |    6 ++----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
index 87e1d01..e24930e 100644
--- a/arch/arm/mach-msm/board-trout-gpio.c
+++ b/arch/arm/mach-msm/board-trout-gpio.c
@@ -94,7 +94,7 @@ static int trout_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	}
 
 static struct msm_gpio_chip msm_gpio_banks[] = {
-#if defined(CONFIG_MSM_DEBUG_UART1)
+#if defined(CONFIG_DEBUG_MSM_UART) && (CONFIG_DEBUG_UART_PHYS == 0xa9a00000)
 	/* H2W pins <-> UART1 */
 	TROUT_GPIO_BANK("MISC2", 0x00,   TROUT_GPIO_MISC2_BASE, 0x40),
 #else
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 015d544..8369dfd 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -90,7 +90,7 @@ static void __init trout_map_io(void)
 	msm_map_common_io();
 	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
 
-#ifdef CONFIG_MSM_DEBUG_UART3
+#if defined(CONFIG_DEBUG_MSM_UART) && (CONFIG_DEBUG_UART_PHYS == 0xa9c00000)
 	/* route UART3 to the "H2W" extended usb connector */
 	writeb(0x80, TROUT_CPLD_BASE + 0x00);
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 34e0947..b042dca 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -57,8 +57,7 @@ static struct map_desc msm_io_desc[] __initdata = {
 		.length =   MSM_SHARED_RAM_SIZE,
 		.type =     MT_DEVICE,
 	},
-#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
-		defined(CONFIG_DEBUG_MSM_UART3)
+#if defined(CONFIG_DEBUG_MSM_UART)
 	{
 		/* Must be last: virtual and pfn filled in by debug_ll_addr() */
 		.length = SZ_4K,
@@ -76,8 +75,7 @@ void __init msm_map_common_io(void)
 	 * pages are peripheral interface or not.
 	 */
 	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
-#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
-		defined(CONFIG_DEBUG_MSM_UART3)
+#if defined(CONFIG_DEBUG_MSM_UART)
 #ifdef CONFIG_MMU
 	debug_ll_addr(&msm_io_desc[size - 1].pfn,
 		      &msm_io_desc[size - 1].virtual);
-- 
1.7.9.5


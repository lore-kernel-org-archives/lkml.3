Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaEZN6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:58:49 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44234 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaEZN6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:58:48 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: pebolle@tiscali.nl, galak@codeaurora.org, iivanov@mm-sol.com
Cc: arm@kernel.org, khilman@linaro.org, arnd@arndb.de,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        olof@lixom.net, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, srinivas.kandagatla@linaro.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH] ARM: msm: Update the references to DEBUG_MSM_UARTx
Date: Mon, 26 May 2014 16:58:53 +0300
Message-Id: <1401112733-23649-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401108595.6068.5.camel@x220>
References: <1401108595.6068.5.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig options DEBUG_MSM_UART1, DEBUG_MSM_UART2 and DEBUG_MSM_UART3
are removed, but they are still referenced in arch/arm/mach-msm/io.c
Fix this by updating the reference to the new Kconfig option.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 arch/arm/mach-msm/io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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


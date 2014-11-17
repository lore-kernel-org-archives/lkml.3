Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKQOtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:49:49 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64403 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaKQOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:49:47 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v13 8/9] arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
Date: Mon, 17 Nov 2014 14:49:09 +0000
Message-Id: <1416235750-4766-9-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416235750-4766-1-git-send-email-daniel.thompson@linaro.org>
References: <1416235750-4766-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On EP93XX uncompress.h uses CONFIG_DEBUG_UART_PHYS instead of a hard
coded serial port. This means the build breaks when DEBUG_LL
(and DEBUG_LL_UART_PL01X) is not enabled.

This is fixed by adding a new dependency.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 3070498fb637..612bdab25f70 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1257,7 +1257,8 @@ config DEBUG_UART_PHYS
 	default 0xfffb9800 if DEBUG_OMAP1UART3 || DEBUG_OMAP7XXUART3
 	default 0xfffe8600 if DEBUG_UART_BCM63XX
 	default 0xfffff700 if ARCH_IOP33X
-	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
+	depends on ARCH_EP93XX || \
+	        DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_LL_UART_EFM32 || \
 		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_MESON_UARTAO || \
 		DEBUG_MSM_UART || DEBUG_NETX_UART || \
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaDGPz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:55:59 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49284 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbaDGPys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:54:48 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v4 4/5] arm: Seperate DEBUG_UART_PHYS from DEBUG_LL on EP93XX
Date: Mon,  7 Apr 2014 16:54:15 +0100
Message-Id: <1396886056-18132-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396886056-18132-1-git-send-email-daniel.thompson@linaro.org>
References: <1396626102-13991-1-git-send-email-daniel.thompson@linaro.org>
 <1396886056-18132-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On EP93XX uncompress.h uses CONFIG_DEBUG_UART_PHYS instead of a hard
coded serial port. This means the build breaks when DEBUG_LL
(and DEBUG_LL_UART_PL01X) is not enabled.

This is fixed by adding a new dependancy.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    Having ARCH_EP93XX on its own here looks somewhat anomalous but
    I have searched for other users of CONFIG_DEBUG_UART_PHYS/VIRT
    (outside of DEBUG_LL) but I think the EP93XX really is unique
    here.

 arch/arm/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 0702d6d..50fdc86 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1073,7 +1073,8 @@ config DEBUG_UART_PHYS
 	default 0xfffff700 if ARCH_IOP33X
 	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 		DEBUG_LL_UART_EFM32 || \
-		DEBUG_UART_8250 || DEBUG_UART_PL01X
+		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
+		ARCH_EP93XX
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
-- 
1.9.0


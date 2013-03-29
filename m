Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3C2Lri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:47:38 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63401 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169Ab3C2Lrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:47:37 -0400
Message-ID: <1364557655.1345.58.camel@x61.thuisdomein>
Subject: [PATCH] ARM: davinci: remove test for undefined Kconfig macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 12:47:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 11:47:35.0709 (UTC) FILETIME=[34AF54D0:01CE2C73]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DaVinci debugging macro contains a check for
CONFIG_DEBUG_DAVINCI_DA8XX_UART0. But there's corresponding Kconfig
symbol, so this test will always evaluate to false. That Kconfig symbol
is not needed because, as __arch_decomp_setup() shows, there are no
DaVinci DA8XX boards that use UART0 for debugging. We can remove two
lines of unneeded code.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) See commit 477099f189101a6675d93782164446015a3633bd ("ARM: davinci:
implement DEBUG_LL port choice") for the introduction of this code.

 arch/arm/mach-davinci/include/mach/debug-macro.S | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/debug-macro.S b/arch/arm/mach-davinci/include/mach/debug-macro.S
index 34290d1..b18b8eb 100644
--- a/arch/arm/mach-davinci/include/mach/debug-macro.S
+++ b/arch/arm/mach-davinci/include/mach/debug-macro.S
@@ -24,8 +24,6 @@
 
 #if defined(CONFIG_DEBUG_DAVINCI_DMx_UART0)
 #define UART_BASE	DAVINCI_UART0_BASE
-#elif defined(CONFIG_DEBUG_DAVINCI_DA8XX_UART0)
-#define UART_BASE	DA8XX_UART0_BASE
 #elif defined(CONFIG_DEBUG_DAVINCI_DA8XX_UART1)
 #define UART_BASE	DA8XX_UART1_BASE
 #elif defined(CONFIG_DEBUG_DAVINCI_DA8XX_UART2)
-- 
1.7.11.7


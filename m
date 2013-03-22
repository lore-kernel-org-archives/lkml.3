Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3CVAPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:15:10 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:63063 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab3CVAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:15:09 -0400
Message-ID: <1363911302.1390.167.camel@x61.thuisdomein>
Subject: [PATCH] cpuimx27 and mbimx27: prepend CONFIG_ to Kconfig macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Mar 2013 01:15:02 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2013 00:15:02.0934 (UTC) FILETIME=[4C68CB60:01CE2692]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2d66c7803595da0d4bcd949825d598575f5de9e6 ("cpuimx27 and mbimx27:
allow fine control of UART4 and SDHC2 usage") added the Kconfig symbol
MACH_EUKREA_CPUIMX27_USEUART4. But it forgot to prepend CONFIG_ to the
use of its macro. Add that prefix now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. This needs testing, obviously. Or a rethink, because these
typos have been in the tree since v2.6.36!

 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c | 4 ++--
 arch/arm/mach-imx/mach-cpuimx27.c            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
index b4c7002..b2f08bf 100644
--- a/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
@@ -46,7 +46,7 @@ static const int eukrea_mbimx27_pins[] __initconst = {
 	PE10_PF_UART3_CTS,
 	PE11_PF_UART3_RTS,
 	/* UART4 */
-#if !defined(MACH_EUKREA_CPUIMX27_USEUART4)
+#if !defined(CONFIG_MACH_EUKREA_CPUIMX27_USEUART4)
 	PB26_AF_UART4_RTS,
 	PB28_AF_UART4_TXD,
 	PB29_AF_UART4_CTS,
@@ -306,7 +306,7 @@ void __init eukrea_mbimx27_baseboard_init(void)
 
 	imx27_add_imx_uart1(&uart_pdata);
 	imx27_add_imx_uart2(&uart_pdata);
-#if !defined(MACH_EUKREA_CPUIMX27_USEUART4)
+#if !defined(CONFIG_MACH_EUKREA_CPUIMX27_USEUART4)
 	imx27_add_imx_uart3(&uart_pdata);
 #endif
 
diff --git a/arch/arm/mach-imx/mach-cpuimx27.c b/arch/arm/mach-imx/mach-cpuimx27.c
index 1465593..ea50870 100644
--- a/arch/arm/mach-imx/mach-cpuimx27.c
+++ b/arch/arm/mach-imx/mach-cpuimx27.c
@@ -48,7 +48,7 @@ static const int eukrea_cpuimx27_pins[] __initconst = {
 	PE14_PF_UART1_CTS,
 	PE15_PF_UART1_RTS,
 	/* UART4 */
-#if defined(MACH_EUKREA_CPUIMX27_USEUART4)
+#if defined(CONFIG_MACH_EUKREA_CPUIMX27_USEUART4)
 	PB26_AF_UART4_RTS,
 	PB28_AF_UART4_TXD,
 	PB29_AF_UART4_CTS,
@@ -272,7 +272,7 @@ static void __init eukrea_cpuimx27_init(void)
 	/* SDHC2 can be used for Wifi */
 	imx27_add_mxc_mmc(1, NULL);
 #endif
-#if defined(MACH_EUKREA_CPUIMX27_USEUART4)
+#if defined(CONFIG_MACH_EUKREA_CPUIMX27_USEUART4)
 	/* in which case UART4 is also used for Bluetooth */
 	imx27_add_imx_uart3(&uart_pdata);
 #endif
-- 
1.7.11.7


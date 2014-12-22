Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaLVQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:57:55 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51670 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaLVQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:57:51 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Paul Bolle <pebolle@tiscali.nl>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 3.19-rc1 v14 3/8] arm: Remove DEBUG_LL_UART_NONE
Date: Mon, 22 Dec 2014 16:57:20 +0000
Message-Id: <1419267445-8330-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
References: <1419267445-8330-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only a very small handful of platforms support DEBUG_LL_UART_NONE but it
lurks in the menus of every single platform config ready to break the
build. This is an especial problem for defconfig/oldconfig since it is
often selected by default.

This patch solves the problem by removing this option. Any platforms
still depending upon this option must be migrated.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/Kconfig.debug | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index c5648cc1466d..6ee9b0d361ee 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1031,15 +1031,6 @@ choice
 		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
 		  devices, including VT8500, WM8505, WM8650 and WM8850.
 
-	config DEBUG_LL_UART_NONE
-		bool "No low-level debugging UART"
-		depends on !ARCH_MULTIPLATFORM
-		help
-		  Say Y here if your platform doesn't provide a UART option
-		  above. This relies on your platform choosing the right UART
-		  definition internally in order for low-level debugging to
-		  work.
-
 	config DEBUG_ICEDCC
 		bool "Kernel low-level debugging via EmbeddedICE DCC channel"
 		help
-- 
1.9.3


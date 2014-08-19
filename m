Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaHSPRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:17:10 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56393 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaHSPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:17:07 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v9 3/9] arm: Remove DEBUG_LL_UART_NONE
Date: Tue, 19 Aug 2014 16:16:41 +0100
Message-Id: <1408461407-10429-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
References: <1408459715-10151-1-git-send-email-daniel.thompson@linaro.org>
 <1408461407-10429-1-git-send-email-daniel.thompson@linaro.org>
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
index b11ad54..9c46729 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -877,15 +877,6 @@ choice
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


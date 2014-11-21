Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaKUL1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:27:41 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:34660 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbaKUL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:27:39 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/2] ARM: at91/Kconfig: remove useless fbdev Kconfig options
Date: Fri, 21 Nov 2014 12:27:09 +0100
Message-ID: <4fdfb67f24b64844ac110622bb51b2ee0f894492.1416568804.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <2e591e7b3ac20c8f686a6099d236d09964d08406.1416568804.git.nicolas.ferre@atmel.com>
References: <2e591e7b3ac20c8f686a6099d236d09964d08406.1416568804.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Kconfig options used nowhere.
The removal of CONFIG_ARCH_AT91SAM9261 option allowed to spot this oddness.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/fbdev/Kconfig | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index c7bf606a8706..c78bfd1d1b34 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -999,23 +999,6 @@ config FB_ATMEL
 	help
 	  This enables support for the AT91/AT32 LCD Controller.
 
-config FB_INTSRAM
-	bool "Frame Buffer in internal SRAM"
-	depends on FB_ATMEL && ARCH_AT91SAM9261
-	help
-	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
-	  to let frame buffer in external SDRAM.
-
-config FB_ATMEL_STN
-	bool "Use a STN display with AT91/AT32 LCD Controller"
-	depends on FB_ATMEL && (MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK)
-	default n
-	help
-	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
-	  Controller. Say N if you want to connect a TFT.
-
-	  If unsure, say N.
-
 config FB_NVIDIA
 	tristate "nVidia Framebuffer Support"
 	depends on FB && PCI
-- 
2.1.3


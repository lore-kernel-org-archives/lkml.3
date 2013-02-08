Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab3BHQfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:35:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:35782 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218Ab3BHQfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:35:43 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <FlorianSchandinat@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <jhovold@gmail.com>,
        <jacmet@sunsite.dk>, <stable@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/5] ARM: at91/neocore926: fix LCD-wiring mode
Date: Fri, 8 Feb 2013 17:35:15 +0100
Message-ID: <37f30edd2bdd0a132e0f6ab6df4176ac79f0e203.1360340791.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

Fix regression introduced by commit 787f9fd23283 ("atmel_lcdfb: support
16bit BGR:565 mode, remove unsupported 15bit modes") which broke 16-bpp
modes for older SOCs which use IBGR:555 (msb is intensity) rather than
BGR:565.

The above commit also removed the RGB:555-wiring hack without fixing the
neocore926 board which used it. Fix by specifying RGB-wiring and let the
driver handle the final SOC-dependant layout.

Remove the no longer used ATMEL_LCDC_WIRING_RGB555 define.

Compile-only tested.

Cc: <stable@vger.kernel.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/board-neocore926.c | 2 +-
 include/video/atmel_lcdc.h            | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/board-neocore926.c b/arch/arm/mach-at91/board-neocore926.c
index bc7a1c4..4726297 100644
--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@ -266,7 +266,7 @@ static struct atmel_lcdfb_info __initdata neocore926_lcdc_data = {
 	.default_monspecs		= &at91fb_default_monspecs,
 	.atmel_lcdfb_power_control	= at91_lcdc_power_control,
 	.guard_time			= 1,
-	.lcd_wiring_mode		= ATMEL_LCDC_WIRING_RGB555,
+	.lcd_wiring_mode		= ATMEL_LCDC_WIRING_RGB,
 };
 
 #else
diff --git a/include/video/atmel_lcdc.h b/include/video/atmel_lcdc.h
index 5f0e234..8deb226 100644
--- a/include/video/atmel_lcdc.h
+++ b/include/video/atmel_lcdc.h
@@ -30,7 +30,6 @@
  */
 #define ATMEL_LCDC_WIRING_BGR	0
 #define ATMEL_LCDC_WIRING_RGB	1
-#define ATMEL_LCDC_WIRING_RGB555	2
 
 
  /* LCD Controller info data structure, stored in device platform_data */
-- 
1.8.0


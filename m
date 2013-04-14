Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3DNHRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 03:17:08 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42833 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804Ab3DNHRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 03:17:06 -0400
Date: Sun, 14 Apr 2013 09:17:03 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [GIT PULL REQUEST] watchdog - v3.9-rc6 Fixes
Message-ID: <20130414071702.GH14155@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

It will fix compile errors for teh at91rm9200_wdt driver.

This will update the following files:

 Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

with these Changes:

commit 09549cd01726a7ff8b102a93e46b059531583ab6
Author: Nicolas Ferre <nicolas.ferre@atmel.com>
Date:   Wed Apr 10 14:36:22 2013 +0200

    watchdog: Revert the AT91RM9200_WATCHDOG dependency
    
    Compiling the at91rm9200_wdt.c driver without at91rm9200
    support was leading to several errors:
    
    drivers/built-in.o: In function `at91_wdt_close':
    at91_adc.c:(.text+0xc9fe4): undefined reference to `at91_st_base'
    drivers/built-in.o: In function `at91_wdt_write':
    at91_adc.c:(.text+0xca004): undefined reference to `at91_st_base'
    drivers/built-in.o: In function `at91wdt_shutdown':
    at91_adc.c:(.text+0xca01c): undefined reference to `at91_st_base'
    drivers/built-in.o: In function `at91wdt_suspend':
    at91_adc.c:(.text+0xca038): undefined reference to `at91_st_base'
    drivers/built-in.o: In function `at91_wdt_open':
    at91_adc.c:(.text+0xca0cc): undefined reference to `at91_st_base'
    drivers/built-in.o:at91_adc.c:(.text+0xca2c8): more undefined references to
    `at91_st_base' follow
    
    So, reverting the modification of the "depends" Kconfig line
    introduced by patch a6a1bcd37 (watchdog: at91rm9200: add DT support)
    seems to be the good solution.
    
    Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Acked-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9fcc70c..e89fc31 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -117,7 +117,7 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on ARCH_AT91
+	depends on ARCH_AT91RM9200
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.

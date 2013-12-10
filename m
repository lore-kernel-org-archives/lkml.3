Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3LJHxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:53:24 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:45751 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789Ab3LJHxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:53:22 -0500
Date: Tue, 10 Dec 2013 08:53:17 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [GIT PULL REQUEST] watchdog - v3.13-rc3 Fixes
Message-ID: <20131210075317.GB10136@spo001.leaseweb.com>
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

It will drop the unnecessary miscdevice.h includes that we forgot in
commit 487722cf2 and fix an oops for the sc1200_wdt driver.

This will update the following files:

 bcm2835_wdt.c      |    1 -
 ep93xx_wdt.c       |    1 -
 ie6xx_wdt.c        |    1 -
 jz4740_wdt.c       |    1 -
 kempld_wdt.c       |    1 -
 max63xx_wdt.c      |    1 -
 orion_wdt.c        |    1 -
 pnx4008_wdt.c      |    1 -
 rt2880_wdt.c       |    1 -
 sc1200wdt.c        |    3 ++-
 shwdt.c            |    1 -
 softdog.c          |    1 -
 stmp3xxx_rtc_wdt.c |    1 -
 txx9wdt.c          |    1 -
 ux500_wdt.c        |    1 -
 15 files changed, 2 insertions(+), 15 deletions(-)

with these Changes:

commit dace8bbfccfd9e4fcccfffcfbd82881fda3e756f
Author: Alan <gnomes@lxorguk.ukuu.org.uk>
Date:   Wed Dec 4 15:31:52 2013 +0000

    sc1200_wdt: Fix oops
    
    If loaded with isapnp = 0 the driver explodes. This is catching
    people out now and then. What should happen in the working case is
    a complete mystery and the code appears terminally confused, but we
    can at least make the error path work properly.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Partially-Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=53991

commit 9539210e17dc09ea1472076c297d461c7507a5bb
Author: Guenter Roeck <linux@roeck-us.net>
Date:   Tue Nov 19 13:26:17 2013 -0800

    watchdog: Drop unnecessary include of miscdevice.h
    
    After commit 487722cf2 (watchdog: Get rid of MODULE_ALIAS_MISCDEV
    statements) the affected drivers no longer need to include miscdevice.h.
    Only exception is rt2880_wdt.c which never needed it.
    
    Signed-off-by: Guenter Roeck <linux@roeck-us.net>
    Reviewed-by: Jean Delvare <jdelvare@suse.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/bcm2835_wdt.c b/drivers/watchdog/bcm2835_wdt.c
index a6a2ceb..cafa973 100644
--- a/drivers/watchdog/bcm2835_wdt.c
+++ b/drivers/watchdog/bcm2835_wdt.c
@@ -19,7 +19,6 @@
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
-#include <linux/miscdevice.h>
 
 #define PM_RSTC				0x1c
 #define PM_WDOG				0x24
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 833e813..d1d07f2 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -28,7 +28,6 @@
 
 #include <linux/platform_device.h>
 #include <linux/module.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
 #include <linux/io.h>
diff --git a/drivers/watchdog/ie6xx_wdt.c b/drivers/watchdog/ie6xx_wdt.c
index 70a2402..07f88f5 100644
--- a/drivers/watchdog/ie6xx_wdt.c
+++ b/drivers/watchdog/ie6xx_wdt.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <linux/miscdevice.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index 2de486a..3aa50cf 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -17,7 +17,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
index a1a3638..20dc738 100644
--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/miscdevice.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 6d4f399..bdb3f4a 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -19,7 +19,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 44edca6..f7722a4 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 1bdcc31..5bec20f 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -23,7 +23,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff --git a/drivers/watchdog/rt2880_wdt.c b/drivers/watchdog/rt2880_wdt.c
index 53d37fe..d92c2d5 100644
--- a/drivers/watchdog/rt2880_wdt.c
+++ b/drivers/watchdog/rt2880_wdt.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/watchdog.h>
-#include <linux/miscdevice.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 3b9fff9..131193a 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -409,8 +409,9 @@ static int __init sc1200wdt_init(void)
 #if defined CONFIG_PNP
 	/* now that the user has specified an IO port and we haven't detected
 	 * any devices, disable pnp support */
+	if (isapnp)
+		pnp_unregister_driver(&scl200wdt_pnp_driver);
 	isapnp = 0;
-	pnp_unregister_driver(&scl200wdt_pnp_driver);
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index f9b8e06..af3528f 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/pm_runtime.h>
 #include <linux/fs.h>
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index ef2638f..c04a1aa 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -42,7 +42,6 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/timer.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
diff --git a/drivers/watchdog/stmp3xxx_rtc_wdt.c b/drivers/watchdog/stmp3xxx_rtc_wdt.c
index d667f6b..bb64ae3 100644
--- a/drivers/watchdog/stmp3xxx_rtc_wdt.c
+++ b/drivers/watchdog/stmp3xxx_rtc_wdt.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
 #include <linux/stmp3xxx_rtc_wdt.h>
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 0fd0e8a..6a447e3 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
-#include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
diff --git a/drivers/watchdog/ux500_wdt.c b/drivers/watchdog/ux500_wdt.c
index e029b57..5aed9d7 100644
--- a/drivers/watchdog/ux500_wdt.c
+++ b/drivers/watchdog/ux500_wdt.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
-#include <linux/miscdevice.h>
 #include <linux/err.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>

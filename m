Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3CNNMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:12:14 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34883 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab3CNNMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:12:08 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 06/10] drivers: input: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 14:11:27 +0100
Message-Id: <1363266691-15757-8-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers to use the
module_platform_driver_probe() macro which makes the code smaller and
a bit simpler.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/amikbd.c             | 14 +-------------
 drivers/input/keyboard/davinci_keyscan.c    | 12 +-----------
 drivers/input/keyboard/nomadik-ske-keypad.c | 12 +-----------
 drivers/input/misc/twl4030-pwrbutton.c      | 13 +------------
 drivers/input/mouse/amimouse.c              | 14 +-------------
 drivers/input/serio/at32psif.c              | 13 +------------
 drivers/input/serio/q40kbd.c                | 13 +------------
 drivers/input/touchscreen/atmel-wm97xx.c    | 12 +-----------
 drivers/input/touchscreen/mc13783_ts.c      | 12 +-----------
 9 files changed, 9 insertions(+), 106 deletions(-)

diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
index 79172af..ba0b36f 100644
--- a/drivers/input/keyboard/amikbd.c
+++ b/drivers/input/keyboard/amikbd.c
@@ -260,18 +260,6 @@ static struct platform_driver amikbd_driver = {
 	},
 };
 
-static int __init amikbd_init(void)
-{
-	return platform_driver_probe(&amikbd_driver, amikbd_probe);
-}
-
-module_init(amikbd_init);
-
-static void __exit amikbd_exit(void)
-{
-	platform_driver_unregister(&amikbd_driver);
-}
-
-module_exit(amikbd_exit);
+module_platform_driver_probe(amikbd_driver, amikbd_probe);
 
 MODULE_ALIAS("platform:amiga-keyboard");
diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
index 4e4e453..8297537 100644
--- a/drivers/input/keyboard/davinci_keyscan.c
+++ b/drivers/input/keyboard/davinci_keyscan.c
@@ -329,17 +329,7 @@ static struct platform_driver davinci_ks_driver = {
 	.remove	= davinci_ks_remove,
 };
 
-static int __init davinci_ks_init(void)
-{
-	return platform_driver_probe(&davinci_ks_driver, davinci_ks_probe);
-}
-module_init(davinci_ks_init);
-
-static void __exit davinci_ks_exit(void)
-{
-	platform_driver_unregister(&davinci_ks_driver);
-}
-module_exit(davinci_ks_exit);
+module_platform_driver_probe(davinci_ks_driver, davinci_ks_probe);
 
 MODULE_AUTHOR("Miguel Aguilar");
 MODULE_DESCRIPTION("Texas Instruments DaVinci Key Scan Driver");
diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 0e6a815..c7d505c 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -430,17 +430,7 @@ static struct platform_driver ske_keypad_driver = {
 	.remove = ske_keypad_remove,
 };
 
-static int __init ske_keypad_init(void)
-{
-	return platform_driver_probe(&ske_keypad_driver, ske_keypad_probe);
-}
-module_init(ske_keypad_init);
-
-static void __exit ske_keypad_exit(void)
-{
-	platform_driver_unregister(&ske_keypad_driver);
-}
-module_exit(ske_keypad_exit);
+module_platform_driver_probe(ske_keypad_driver, ske_keypad_probe);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Naveen Kumar <naveen.gaddipati@stericsson.com> / Sundar Iyer <sundar.iyer@stericsson.com>");
diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index 27c2bc8..1700947 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -114,18 +114,7 @@ static struct platform_driver twl4030_pwrbutton_driver = {
 	},
 };
 
-static int __init twl4030_pwrbutton_init(void)
-{
-	return platform_driver_probe(&twl4030_pwrbutton_driver,
-			twl4030_pwrbutton_probe);
-}
-module_init(twl4030_pwrbutton_init);
-
-static void __exit twl4030_pwrbutton_exit(void)
-{
-	platform_driver_unregister(&twl4030_pwrbutton_driver);
-}
-module_exit(twl4030_pwrbutton_exit);
+module_platform_driver_probe(twl4030_pwrbutton_driver, twl4030_pwrbutton_probe);
 
 MODULE_ALIAS("platform:twl4030_pwrbutton");
 MODULE_DESCRIPTION("Triton2 Power Button");
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index 5fa9934..b55d5af 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -146,18 +146,6 @@ static struct platform_driver amimouse_driver = {
 	},
 };
 
-static int __init amimouse_init(void)
-{
-	return platform_driver_probe(&amimouse_driver, amimouse_probe);
-}
-
-module_init(amimouse_init);
-
-static void __exit amimouse_exit(void)
-{
-	platform_driver_unregister(&amimouse_driver);
-}
-
-module_exit(amimouse_exit);
+module_platform_driver_probe(amimouse_driver, amimouse_probe);
 
 MODULE_ALIAS("platform:amiga-mouse");
diff --git a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
index 36e799c..190ce35 100644
--- a/drivers/input/serio/at32psif.c
+++ b/drivers/input/serio/at32psif.c
@@ -359,18 +359,7 @@ static struct platform_driver psif_driver = {
 	},
 };
 
-static int __init psif_init(void)
-{
-	return platform_driver_probe(&psif_driver, psif_probe);
-}
-
-static void __exit psif_exit(void)
-{
-	platform_driver_unregister(&psif_driver);
-}
-
-module_init(psif_init);
-module_exit(psif_exit);
+module_platform_driver_probe(psif_driver, psif_probe);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index 70fe542..436a343 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -193,15 +193,4 @@ static struct platform_driver q40kbd_driver = {
 	.remove		= q40kbd_remove,
 };
 
-static int __init q40kbd_init(void)
-{
-	return platform_driver_probe(&q40kbd_driver, q40kbd_probe);
-}
-
-static void __exit q40kbd_exit(void)
-{
-	platform_driver_unregister(&q40kbd_driver);
-}
-
-module_init(q40kbd_init);
-module_exit(q40kbd_exit);
+module_platform_driver_probe(q40kbd_driver, q40kbd_probe);
diff --git a/drivers/input/touchscreen/atmel-wm97xx.c b/drivers/input/touchscreen/atmel-wm97xx.c
index c5c2dbb..2c1e46b 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -432,17 +432,7 @@ static struct platform_driver atmel_wm97xx_driver = {
 	},
 };
 
-static int __init atmel_wm97xx_init(void)
-{
-	return platform_driver_probe(&atmel_wm97xx_driver, atmel_wm97xx_probe);
-}
-module_init(atmel_wm97xx_init);
-
-static void __exit atmel_wm97xx_exit(void)
-{
-	platform_driver_unregister(&atmel_wm97xx_driver);
-}
-module_exit(atmel_wm97xx_exit);
+module_platform_driver_probe(atmel_wm97xx_driver, atmel_wm97xx_probe);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("wm97xx continuous touch driver for Atmel AT91 and AVR32");
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index 02103b6..89308fe 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -250,17 +250,7 @@ static struct platform_driver mc13783_ts_driver = {
 	},
 };
 
-static int __init mc13783_ts_init(void)
-{
-	return platform_driver_probe(&mc13783_ts_driver, &mc13783_ts_probe);
-}
-module_init(mc13783_ts_init);
-
-static void __exit mc13783_ts_exit(void)
-{
-	platform_driver_unregister(&mc13783_ts_driver);
-}
-module_exit(mc13783_ts_exit);
+module_platform_driver_probe(mc13783_ts_driver, mc13783_ts_probe);
 
 MODULE_DESCRIPTION("MC13783 input touchscreen driver");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
-- 
1.8.1.5


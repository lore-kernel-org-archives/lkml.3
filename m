Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaKRVAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:00:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52716 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbaKRU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:59:14 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] staging: panel: Remove more magic number comparison
Date: Tue, 18 Nov 2014 21:56:13 +0100
Message-Id: <1416344174-9155-9-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a macro instead of magic number comparison for checking
whether a module param value has been set.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index ee48bca..268ad2e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -136,6 +136,7 @@
 #define NOT_SET			-1
 
 #define IS_NOT_SET(x)	(x == NOT_SET)
+#define IS_SET(x)		(x > NOT_SET)
 
 /* macros to simplify use of the parallel port */
 #define r_ctr(x)        (parport_read_control((x)->port))
@@ -1496,17 +1497,17 @@ static void lcd_init(void)
 	}
 
 	/* Overwrite with module params set on loading */
-	if (lcd_height > -1)
+	if (IS_SET(lcd_height))
 		lcd.height = lcd_height;
-	if (lcd_width > -1)
+	if (IS_SET(lcd_width))
 		lcd.width = lcd_width;
-	if (lcd_bwidth > -1)
+	if (IS_SET(lcd_bwidth))
 		lcd.bwidth = lcd_bwidth;
-	if (lcd_hwidth > -1)
+	if (IS_SET(lcd_hwidth))
 		lcd.hwidth = lcd_hwidth;
-	if (lcd_charset > -1)
+	if (IS_SET(lcd_charset))
 		lcd.charset = lcd_charset;
-	if (lcd_proto > -1)
+	if (IS_SET(lcd_proto))
 		lcd.proto = lcd_proto;
 	if (lcd_e_pin != PIN_NOT_SET)
 		lcd.pins.e = lcd_e_pin;
@@ -2306,16 +2307,16 @@ static int __init panel_init_module(void)
 	 * Overwrite selection with module param values (both keypad and lcd),
 	 * where the deprecated params have lower prio.
 	 */
-	if (keypad_enabled > -1)
+	if (IS_SET(keypad_enabled))
 		selected_keypad_type = keypad_enabled;
-	if (keypad_type > -1)
+	if (IS_SET(keypad_type))
 		selected_keypad_type = keypad_type;
 
 	keypad.enabled = (selected_keypad_type > 0);
 
-	if (lcd_enabled > -1)
+	if (IS_SET(lcd_enabled))
 		selected_lcd_type = lcd_enabled;
-	if (lcd_type > -1)
+	if (IS_SET(lcd_type))
 		selected_lcd_type = lcd_type;
 
 	lcd.enabled = (selected_lcd_type > 0);
-- 
2.1.3


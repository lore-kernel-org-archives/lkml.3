Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaKSUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:47:57 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35803 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaKSUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:47:18 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/9] staging: panel: Remove more magic number comparison
Date: Wed, 19 Nov 2014 21:38:50 +0100
Message-Id: <1416429531-11088-9-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a defined value instead of magic number comparison
for checking whether a module param value has been set.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
v2: Don't introduce new macros for param value check

 drivers/staging/panel/panel.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 0bdb447..19f6767 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1494,17 +1494,17 @@ static void lcd_init(void)
 	}
 
 	/* Overwrite with module params set on loading */
-	if (lcd_height > -1)
+	if (lcd_height != NOT_SET)
 		lcd.height = lcd_height;
-	if (lcd_width > -1)
+	if (lcd_width != NOT_SET)
 		lcd.width = lcd_width;
-	if (lcd_bwidth > -1)
+	if (lcd_bwidth != NOT_SET)
 		lcd.bwidth = lcd_bwidth;
-	if (lcd_hwidth > -1)
+	if (lcd_hwidth != NOT_SET)
 		lcd.hwidth = lcd_hwidth;
-	if (lcd_charset > -1)
+	if (lcd_charset != NOT_SET)
 		lcd.charset = lcd_charset;
-	if (lcd_proto > -1)
+	if (lcd_proto != NOT_SET)
 		lcd.proto = lcd_proto;
 	if (lcd_e_pin != PIN_NOT_SET)
 		lcd.pins.e = lcd_e_pin;
@@ -2304,16 +2304,16 @@ static int __init panel_init_module(void)
 	 * Overwrite selection with module param values (both keypad and lcd),
 	 * where the deprecated params have lower prio.
 	 */
-	if (keypad_enabled > -1)
+	if (keypad_enabled != NOT_SET)
 		selected_keypad_type = keypad_enabled;
-	if (keypad_type > -1)
+	if (keypad_type != NOT_SET)
 		selected_keypad_type = keypad_type;
 
 	keypad.enabled = (selected_keypad_type > 0);
 
-	if (lcd_enabled > -1)
+	if (lcd_enabled != NOT_SET)
 		selected_lcd_type = lcd_enabled;
-	if (lcd_type > -1)
+	if (lcd_type != NOT_SET)
 		selected_lcd_type = lcd_type;
 
 	lcd.enabled = (selected_lcd_type > 0);
-- 
2.1.3


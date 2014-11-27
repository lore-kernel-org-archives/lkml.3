Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK0VjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:39:05 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54091 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaK0Vh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:29 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/9] staging: panel: Use defined value or checking module params state
Date: Thu, 27 Nov 2014 22:36:48 +0100
Message-Id: <1417124213-23409-5-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid magic number and use a comparison with a defined value instead
that checks whether module param has been set by the user to some
value at loading time.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 86 +++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 1b4a211..5288990 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1411,29 +1411,29 @@ static void lcd_init(void)
 	switch (lcd_type) {
 	case LCD_TYPE_OLD:
 		/* parallel mode, 8 bits */
-		if (lcd_proto < 0)
+		if (lcd_proto == NOT_SET)
 			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset < 0)
+		if (lcd_charset == NOT_SET)
 			lcd_charset = LCD_CHARSET_NORMAL;
 		if (lcd_e_pin == PIN_NOT_SET)
 			lcd_e_pin = PIN_STROBE;
 		if (lcd_rs_pin == PIN_NOT_SET)
 			lcd_rs_pin = PIN_AUTOLF;
 
-		if (lcd_width < 0)
+		if (lcd_width == NOT_SET)
 			lcd_width = 40;
-		if (lcd_bwidth < 0)
+		if (lcd_bwidth == NOT_SET)
 			lcd_bwidth = 40;
-		if (lcd_hwidth < 0)
+		if (lcd_hwidth == NOT_SET)
 			lcd_hwidth = 64;
-		if (lcd_height < 0)
+		if (lcd_height == NOT_SET)
 			lcd_height = 2;
 		break;
 	case LCD_TYPE_KS0074:
 		/* serial mode, ks0074 */
-		if (lcd_proto < 0)
+		if (lcd_proto == NOT_SET)
 			lcd_proto = LCD_PROTO_SERIAL;
-		if (lcd_charset < 0)
+		if (lcd_charset == NOT_SET)
 			lcd_charset = LCD_CHARSET_KS0074;
 		if (lcd_bl_pin == PIN_NOT_SET)
 			lcd_bl_pin = PIN_AUTOLF;
@@ -1442,20 +1442,20 @@ static void lcd_init(void)
 		if (lcd_da_pin == PIN_NOT_SET)
 			lcd_da_pin = PIN_D0;
 
-		if (lcd_width < 0)
+		if (lcd_width == NOT_SET)
 			lcd_width = 16;
-		if (lcd_bwidth < 0)
+		if (lcd_bwidth == NOT_SET)
 			lcd_bwidth = 40;
-		if (lcd_hwidth < 0)
+		if (lcd_hwidth == NOT_SET)
 			lcd_hwidth = 16;
-		if (lcd_height < 0)
+		if (lcd_height == NOT_SET)
 			lcd_height = 2;
 		break;
 	case LCD_TYPE_NEXCOM:
 		/* parallel mode, 8 bits, generic */
-		if (lcd_proto < 0)
+		if (lcd_proto == NOT_SET)
 			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset < 0)
+		if (lcd_charset == NOT_SET)
 			lcd_charset = LCD_CHARSET_NORMAL;
 		if (lcd_e_pin == PIN_NOT_SET)
 			lcd_e_pin = PIN_AUTOLF;
@@ -1464,42 +1464,42 @@ static void lcd_init(void)
 		if (lcd_rw_pin == PIN_NOT_SET)
 			lcd_rw_pin = PIN_INITP;
 
-		if (lcd_width < 0)
+		if (lcd_width == NOT_SET)
 			lcd_width = 16;
-		if (lcd_bwidth < 0)
+		if (lcd_bwidth == NOT_SET)
 			lcd_bwidth = 40;
-		if (lcd_hwidth < 0)
+		if (lcd_hwidth == NOT_SET)
 			lcd_hwidth = 64;
-		if (lcd_height < 0)
+		if (lcd_height == NOT_SET)
 			lcd_height = 2;
 		break;
 	case LCD_TYPE_CUSTOM:
 		/* customer-defined */
-		if (lcd_proto < 0)
+		if (lcd_proto == NOT_SET)
 			lcd_proto = DEFAULT_LCD_PROTO;
-		if (lcd_charset < 0)
+		if (lcd_charset == NOT_SET)
 			lcd_charset = DEFAULT_LCD_CHARSET;
 		/* default geometry will be set later */
 		break;
 	case LCD_TYPE_HANTRONIX:
 		/* parallel mode, 8 bits, hantronix-like */
 	default:
-		if (lcd_proto < 0)
+		if (lcd_proto == NOT_SET)
 			lcd_proto = LCD_PROTO_PARALLEL;
-		if (lcd_charset < 0)
+		if (lcd_charset == NOT_SET)
 			lcd_charset = LCD_CHARSET_NORMAL;
 		if (lcd_e_pin == PIN_NOT_SET)
 			lcd_e_pin = PIN_STROBE;
 		if (lcd_rs_pin == PIN_NOT_SET)
 			lcd_rs_pin = PIN_SELECP;
 
-		if (lcd_width < 0)
+		if (lcd_width == NOT_SET)
 			lcd_width = 16;
-		if (lcd_bwidth < 0)
+		if (lcd_bwidth == NOT_SET)
 			lcd_bwidth = 40;
-		if (lcd_hwidth < 0)
+		if (lcd_hwidth == NOT_SET)
 			lcd_hwidth = 64;
-		if (lcd_height < 0)
+		if (lcd_height == NOT_SET)
 			lcd_height = 2;
 		break;
 	}
@@ -1557,7 +1557,7 @@ static void lcd_init(void)
 	if (lcd_da_pin == PIN_NOT_SET)
 		lcd_da_pin = PIN_NONE;
 
-	if (lcd_charset < 0)
+	if (lcd_charset == NOT_SET)
 		lcd_charset = DEFAULT_LCD_CHARSET;
 
 	if (lcd_charset == LCD_CHARSET_KS0074)
@@ -2227,58 +2227,58 @@ static struct parport_driver panel_driver = {
 static int __init panel_init_module(void)
 {
 	/* for backwards compatibility */
-	if (keypad_type < 0)
+	if (keypad_type == NOT_SET)
 		keypad_type = keypad_enabled;
 
-	if (lcd_type < 0)
+	if (lcd_type == NOT_SET)
 		lcd_type = lcd_enabled;
 
 	/* take care of an eventual profile */
 	switch (profile) {
 	case PANEL_PROFILE_CUSTOM:
 		/* custom profile */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = DEFAULT_KEYPAD_TYPE;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = DEFAULT_LCD_TYPE;
 		break;
 	case PANEL_PROFILE_OLD:
 		/* 8 bits, 2*16, old keypad */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = KEYPAD_TYPE_OLD;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = LCD_TYPE_OLD;
-		if (lcd_width < 0)
+		if (lcd_width == NOT_SET)
 			lcd_width = 16;
-		if (lcd_hwidth < 0)
+		if (lcd_hwidth == NOT_SET)
 			lcd_hwidth = 16;
 		break;
 	case PANEL_PROFILE_NEW:
 		/* serial, 2*16, new keypad */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = KEYPAD_TYPE_NEW;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = LCD_TYPE_KS0074;
 		break;
 	case PANEL_PROFILE_HANTRONIX:
 		/* 8 bits, 2*16 hantronix-like, no keypad */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = KEYPAD_TYPE_NONE;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = LCD_TYPE_HANTRONIX;
 		break;
 	case PANEL_PROFILE_NEXCOM:
 		/* generic 8 bits, 2*16, nexcom keypad, eg. Nexcom. */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = KEYPAD_TYPE_NEXCOM;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = LCD_TYPE_NEXCOM;
 		break;
 	case PANEL_PROFILE_LARGE:
 		/* 8 bits, 2*40, old keypad */
-		if (keypad_type < 0)
+		if (keypad_type == NOT_SET)
 			keypad_type = KEYPAD_TYPE_OLD;
-		if (lcd_type < 0)
+		if (lcd_type == NOT_SET)
 			lcd_type = LCD_TYPE_OLD;
 		break;
 	}
-- 
2.1.3


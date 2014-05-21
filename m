Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaEUMKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:10:39 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:39018 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaEUMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:10:23 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH 3/3] staging: panel: (coding style) Multiple assignments
Date: Wed, 21 May 2014 14:10:01 +0200
Message-Id: <1400674201-9560-3-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to comply with checkpatch.pl --strict --file. 
. Breaks down compound assignments.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
Apply on linux-next tree, above:
commit 4151fa6adc65da14673ece623bbb2acc6936f8be
"Add linux-next specific files for 20140516"

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 1ac5e25..8d15b04 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -664,8 +664,8 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 {
 	int d_bit, c_bit, inv;
 
-	d_val[0] = c_val[0] = d_val[1] = c_val[1] = 0;
-	d_val[2] = c_val[2] = 0xFF;
+	d_val[0] = 0 ; c_val[0] = 0 ; d_val[1] = 0 ; c_val[1] = 0;
+	d_val[2] = 0xFF; c_val[2] = 0xFF;
 
 	if (pin == 0)
 		return;
@@ -674,7 +674,7 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 	if (inv)
 		pin = -pin;
 
-	d_bit = c_bit = 0;
+	d_bit = 0; c_bit = 0;
 
 	switch (pin) {
 	case PIN_STROBE:	/* strobe, inverted */
@@ -867,7 +867,7 @@ static void lcd_clear_fast_s(void)
 {
 	int pos;
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -879,7 +879,7 @@ static void lcd_clear_fast_s(void)
 	}
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 }
 
@@ -888,7 +888,7 @@ static void lcd_clear_fast_p8(void)
 {
 	int pos;
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -915,7 +915,7 @@ static void lcd_clear_fast_p8(void)
 	}
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 }
 
@@ -924,7 +924,7 @@ static void lcd_clear_fast_tilcd(void)
 {
 	int pos;
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 
 	spin_lock_irq(&pprt_lock);
@@ -936,7 +936,7 @@ static void lcd_clear_fast_tilcd(void)
 
 	spin_unlock_irq(&pprt_lock);
 
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	lcd_gotoxy();
 }
 
@@ -944,7 +944,7 @@ static void lcd_clear_fast_tilcd(void)
 static void lcd_clear_display(void)
 {
 	lcd_write_cmd(0x01);	/* clear display */
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	/* we must wait a few milliseconds (15) */
 	long_sleep(15);
 }
@@ -1292,7 +1292,7 @@ static void lcd_write_char(char c)
 			processed = 1;
 		} else if (!strcmp(lcd_escape, "[H")) {
 			/* cursor to home */
-			lcd_addr_x = lcd_addr_y = 0;
+			lcd_addr_x = 0; lcd_addr_y = 0;
 			lcd_gotoxy();
 			processed = 1;
 		}
@@ -1576,7 +1576,7 @@ static void lcd_init(void)
 	panel_lcd_print("\x1b[Lc\x1b[Lb\x1b[L*Linux-" UTS_RELEASE "\nPanel-"
 			PANEL_VERSION);
 #endif
-	lcd_addr_x = lcd_addr_y = 0;
+	lcd_addr_x = 0; lcd_addr_y = 0;
 	/* clear the display on the next device opening */
 	lcd_must_clear = 1;
 	lcd_gotoxy();
@@ -1953,7 +1953,7 @@ static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 	char im, om;
 	pmask_t m, v;
 
-	om = im = m = v = 0ULL;
+	om = 0ULL; im = 0ULL; m = 0ULL; v = 0ULL;
 	while (*name) {
 		int in, out, bit, neg;
 

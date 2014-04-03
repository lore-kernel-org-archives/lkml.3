Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaDCRHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:07:10 -0400
Received: from smtpout5.laposte.net ([193.253.67.230]:48354 "EHLO
	smtpout.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaDCRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:07:06 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2014 13:07:05 EDT
Date: Thu, 3 Apr 2014 18:59:09 +0200
From: armand.bastien@laposte.net
To: willy@meta-x.org, gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        jake.champlin.27@gmail.com, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging : panel : fix checkpatch warnings (linux-next)
Message-ID: <20140403165859.GA10253@plop.dartybox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "Missing a blank line after declarations" checkpatch warning in panel.c.


Signed-off-by: "Bastien Armand <armand.bastien@laposte.net>"
---
 drivers/staging/panel/panel.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 08f9a48..7b390ea 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -867,6 +867,7 @@ static void lcd_print(char c)
 static void lcd_clear_fast_s(void)
 {
 	int pos;
+
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
@@ -887,6 +888,7 @@ static void lcd_clear_fast_s(void)
 static void lcd_clear_fast_p8(void)
 {
 	int pos;
+
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
@@ -922,6 +924,7 @@ static void lcd_clear_fast_p8(void)
 static void lcd_clear_fast_tilcd(void)
 {
 	int pos;
+
 	lcd_addr_x = lcd_addr_y = 0;
 	lcd_gotoxy();
 
@@ -1092,6 +1095,7 @@ static inline int handle_lcd_special_code(void)
 		break;
 	case 'k': {	/* kill end of line */
 		int x;
+
 		for (x = lcd_addr_x; x < lcd_bwidth; x++)
 			lcd_write_data(' ');
 
@@ -1747,16 +1751,20 @@ static inline int input_state_high(struct logical_input *input)
 
 			if (input->high_timer == 0) {
 				char *press_str = input->u.kbd.press_str;
+
 				if (press_str[0]) {
 					int s = sizeof(input->u.kbd.press_str);
+
 					keypad_send_key(press_str, s);
 				}
 			}
 
 			if (input->u.kbd.repeat_str[0]) {
 				char *repeat_str = input->u.kbd.repeat_str;
+
 				if (input->high_timer >= KEYPAD_REP_START) {
 					int s = sizeof(input->u.kbd.repeat_str);
+
 					input->high_timer -= KEYPAD_REP_DELAY;
 					keypad_send_key(repeat_str, s);
 				}
@@ -1794,8 +1802,10 @@ static inline void input_state_falling(struct logical_input *input)
 
 			if (input->u.kbd.repeat_str[0]) {
 				char *repeat_str = input->u.kbd.repeat_str;
+
 				if (input->high_timer >= KEYPAD_REP_START) {
 					int s = sizeof(input->u.kbd.repeat_str);
+
 					input->high_timer -= KEYPAD_REP_DELAY;
 					keypad_send_key(repeat_str, s);
 				}
@@ -1811,12 +1821,15 @@ static inline void input_state_falling(struct logical_input *input)
 		/* call release event */
 		if (input->type == INPUT_TYPE_STD) {
 			void (*release_fct)(int) = input->u.std.release_fct;
+
 			if (release_fct != NULL)
 				release_fct(input->u.std.release_data);
 		} else if (input->type == INPUT_TYPE_KBD) {
 			char *release_str = input->u.kbd.release_str;
+
 			if (release_str[0]) {
 				int s = sizeof(input->u.kbd.release_str);
+
 				keypad_send_key(release_str, s);
 			}
 		}
@@ -1933,6 +1946,7 @@ static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 	om = im = m = v = 0ULL;
 	while (*name) {
 		int in, out, bit, neg;
+
 		for (in = 0; (in < sizeof(sigtab)) &&
 			     (sigtab[in] != *name); in++)
 			;
@@ -2040,6 +2054,7 @@ static struct logical_input *panel_bind_callback(char *name,
 static void keypad_init(void)
 {
 	int keynum;
+
 	init_waitqueue_head(&keypad_read_wait);
 	keypad_buflen = 0;	/* flushes any eventual noisy keystroke */
 

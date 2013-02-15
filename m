Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100Ab3BODiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:38:10 -0500
Received: from mout.gmx.net ([212.227.15.19]:60073 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab3BODiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:38:08 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18oSmsP4DMoEt6XnzdACS19e2yz0xpOl8WnQE+fQ0
	AOvt5IIUehGUL8
From: Peter Huewe <peterhuewe@gmx.de>
To: Willy Tarreau <willy@meta-x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshiaki Yamane <yamanetoshi@gmail.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>, David Howells <dhowells@redhat.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/panel: Mark local functions as static (fix smatch warnings)
Date: Fri, 15 Feb 2013 04:42:31 +0100
Message-Id: <1360899751-24377-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smatch complains about the following functions:
panel.c:188:1: warning: symbol 'logical_inputs' was not declared. Should it be static?
panel.c:569:6: warning: symbol 'old_keypad_profile' was not declared. Should it be static?
panel.c:580:6: warning: symbol 'new_keypad_profile' was not declared. Should it be static?
panel.c:593:6: warning: symbol 'nexcom_keypad_profile' was not declared. Should it be static?
panel.c:672:6: warning: symbol 'pin_to_bits' was not declared. Should it be static?
panel.c:1375:6: warning: symbol 'panel_lcd_print' was not declared. Should it be static?
panel.c:1382:6: warning: symbol 'lcd_init' was not declared. Should it be static?
panel.c:2181:5: warning: symbol 'panel_init' was not declared. Should it be static?

Add the static keyword to silence these warnings and make smatch happy.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/panel/panel.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index e3113ec..3b9a110 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -185,7 +185,7 @@ struct logical_input {
 	} u;
 };
 
-LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
+static LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
 
 /* physical contacts history
  * Physical contacts are a 45 bits string of 9 groups of 5 bits each.
@@ -566,7 +566,7 @@ static unsigned char lcd_char_conv_ks0074[256] = {
 	/* 0xF8 */ 0xac, 0xa6, 0xea, 0xef, 0x7e, 0xeb, 0xb2, 0x79,
 };
 
-char old_keypad_profile[][4][9] = {
+static char old_keypad_profile[][4][9] = {
 	{"S0", "Left\n", "Left\n", ""},
 	{"S1", "Down\n", "Down\n", ""},
 	{"S2", "Up\n", "Up\n", ""},
@@ -577,7 +577,7 @@ char old_keypad_profile[][4][9] = {
 };
 
 /* signals, press, repeat, release */
-char new_keypad_profile[][4][9] = {
+static char new_keypad_profile[][4][9] = {
 	{"S0", "Left\n", "Left\n", ""},
 	{"S1", "Down\n", "Down\n", ""},
 	{"S2", "Up\n", "Up\n", ""},
@@ -590,7 +590,7 @@ char new_keypad_profile[][4][9] = {
 };
 
 /* signals, press, repeat, release */
-char nexcom_keypad_profile[][4][9] = {
+static char nexcom_keypad_profile[][4][9] = {
 	{"a-p-e-", "Down\n", "Down\n", ""},
 	{"a-p-E-", "Ret\n", "Ret\n", ""},
 	{"a-P-E-", "Esc\n", "Esc\n", ""},
@@ -669,7 +669,7 @@ static void panel_set_bits(void)
  *   out(dport, in(dport) & d_val[2] | d_val[signal_state])
  *   out(cport, in(cport) & c_val[2] | c_val[signal_state])
  */
-void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
+static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 {
 	int d_bit, c_bit, inv;
 
@@ -1372,14 +1372,14 @@ static struct miscdevice lcd_dev = {
 };
 
 /* public function usable from the kernel for any purpose */
-void panel_lcd_print(char *s)
+static void panel_lcd_print(char *s)
 {
 	if (lcd_enabled && lcd_initialized)
 		lcd_write(NULL, s, strlen(s), NULL);
 }
 
 /* initialize the LCD driver */
-void lcd_init(void)
+static void lcd_init(void)
 {
 	switch (lcd_type) {
 	case LCD_TYPE_OLD:
@@ -2178,7 +2178,7 @@ static struct parport_driver panel_driver = {
 };
 
 /* init function */
-int panel_init(void)
+static int panel_init(void)
 {
 	/* for backwards compatibility */
 	if (keypad_type < 0)
-- 
1.7.8.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935891Ab3BOMmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:42:42 -0500
Received: from mout.gmx.net ([212.227.17.21]:51757 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935876Ab3BOMmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:42:40 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19XSsEVamlXwphBUnx51kS4NoM/8rylXWH6nXjzRw
	J4cIKUwIkkh11i
From: Peter Huewe <peterhuewe@gmx.de>
To: Willy Tarreau <willy@meta-x.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshiaki Yamane <yamanetoshi@gmail.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>, David Howells <dhowells@redhat.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging/panel: Mark local functions/structs static and add const if applicable (fix sparse warnings)
Date: Fri, 15 Feb 2013 13:47:05 +0100
Message-Id: <1360932425-7957-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <12246.1360925745@warthog.procyon.org.uk>
References: <12246.1360925745@warthog.procyon.org.uk>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse complains about the following functions:
panel.c:188:1: warning: symbol 'logical_inputs' was not declared. Should it be static?
panel.c:569:6: warning: symbol 'old_keypad_profile' was not declared. Should it be static?
panel.c:580:6: warning: symbol 'new_keypad_profile' was not declared. Should it be static?
panel.c:593:6: warning: symbol 'nexcom_keypad_profile' was not declared. Should it be static?
panel.c:672:6: warning: symbol 'pin_to_bits' was not declared. Should it be static?
panel.c:1375:6: warning: symbol 'panel_lcd_print' was not declared. Should it be static?
panel.c:1382:6: warning: symbol 'lcd_init' was not declared. Should it be static?
panel.c:2181:5: warning: symbol 'panel_init' was not declared. Should it be static?

Add the static keyword to silence these warnings and make sparse happy.

If structs or function parameters are used readonly they are also marked
as const.

CC: David Howells <dhowells@redhat.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
v2: Included feedback about const by David Howells. Thanks David.

 drivers/staging/panel/panel.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index e3113ec..c54df39 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -185,7 +185,7 @@ struct logical_input {
 	} u;
 };
 
-LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
+static LIST_HEAD(logical_inputs);	/* list of all defined logical inputs */
 
 /* physical contacts history
  * Physical contacts are a 45 bits string of 9 groups of 5 bits each.
@@ -527,10 +527,10 @@ MODULE_PARM_DESC(lcd_cl_pin,
 		 "# of the // port pin connected to serial LCD 'SCL' "
 		 "signal, with polarity (-17..17)");
 
-static unsigned char *lcd_char_conv;
+static const unsigned char *lcd_char_conv;
 
 /* for some LCD drivers (ks0074) we need a charset conversion table. */
-static unsigned char lcd_char_conv_ks0074[256] = {
+static const unsigned char lcd_char_conv_ks0074[256] = {
 	/*          0|8   1|9   2|A   3|B   4|C   5|D   6|E   7|F */
 	/* 0x00 */ 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
 	/* 0x08 */ 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
@@ -566,7 +566,7 @@ static unsigned char lcd_char_conv_ks0074[256] = {
 	/* 0xF8 */ 0xac, 0xa6, 0xea, 0xef, 0x7e, 0xeb, 0xb2, 0x79,
 };
 
-char old_keypad_profile[][4][9] = {
+static const char old_keypad_profile[][4][9] = {
 	{"S0", "Left\n", "Left\n", ""},
 	{"S1", "Down\n", "Down\n", ""},
 	{"S2", "Up\n", "Up\n", ""},
@@ -577,7 +577,7 @@ char old_keypad_profile[][4][9] = {
 };
 
 /* signals, press, repeat, release */
-char new_keypad_profile[][4][9] = {
+static const char new_keypad_profile[][4][9] = {
 	{"S0", "Left\n", "Left\n", ""},
 	{"S1", "Down\n", "Down\n", ""},
 	{"S2", "Up\n", "Up\n", ""},
@@ -590,7 +590,7 @@ char new_keypad_profile[][4][9] = {
 };
 
 /* signals, press, repeat, release */
-char nexcom_keypad_profile[][4][9] = {
+static const char nexcom_keypad_profile[][4][9] = {
 	{"a-p-e-", "Down\n", "Down\n", ""},
 	{"a-p-E-", "Ret\n", "Ret\n", ""},
 	{"a-P-E-", "Esc\n", "Esc\n", ""},
@@ -599,7 +599,7 @@ char nexcom_keypad_profile[][4][9] = {
 	{"", "", "", ""}
 };
 
-static char (*keypad_profile)[4][9] = old_keypad_profile;
+static const char (*keypad_profile)[4][9] = old_keypad_profile;
 
 /* FIXME: this should be converted to a bit array containing signals states */
 static struct {
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
+static void panel_lcd_print(const char *s)
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
@@ -1638,7 +1638,7 @@ static struct miscdevice keypad_dev = {
 	&keypad_fops
 };
 
-static void keypad_send_key(char *string, int max_len)
+static void keypad_send_key(const char *string, int max_len)
 {
 	if (init_in_progress)
 		return;
@@ -1929,7 +1929,7 @@ static void init_scan_timer(void)
  * corresponding to out and in bits respectively.
  * returns 1 if ok, 0 if error (in which case, nothing is written).
  */
-static int input_name2mask(char *name, pmask_t *mask, pmask_t *value,
+static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 			   char *imask, char *omask)
 {
 	static char sigtab[10] = "EeSsPpAaBb";
@@ -1977,8 +1977,9 @@ static int input_name2mask(char *name, pmask_t *mask, pmask_t *value,
  * strings <press>, <repeat>, <release> for these respective events.
  * Returns the pointer to the new key if ok, NULL if the key could not be bound.
  */
-static struct logical_input *panel_bind_key(char *name, char *press,
-					    char *repeat, char *release)
+static struct logical_input *panel_bind_key(const char *name, const char *press,
+					    const char *repeat,
+					    const char *release)
 {
 	struct logical_input *key;
 
@@ -2178,7 +2179,7 @@ static struct parport_driver panel_driver = {
 };
 
 /* init function */
-int panel_init(void)
+static int panel_init(void)
 {
 	/* for backwards compatibility */
 	if (keypad_type < 0)
-- 
1.7.8.6


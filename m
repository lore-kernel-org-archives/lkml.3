Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaEUMKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:10:24 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:39017 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEUMKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:10:23 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH 2/3] staging: panel: (coding style) Line alignments and malloc sizeof
Date: Wed, 21 May 2014 14:10:00 +0200
Message-Id: <1400674201-9560-2-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to comply with checkpatch.pl --strict --file. 
. Correctly realigns the lines that needed to be ;
. Suppress useless blank rows ;
. Fix sizeof() issues in various -malloc() functions.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
Apply on linux-next tree, above:
commit 4151fa6adc65da14673ece623bbb2acc6936f8be
"Add linux-next specific files for 20140516"

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 136671a..1ac5e25 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -462,7 +462,7 @@ MODULE_PARM_DESC(lcd_type,
 static int lcd_proto = -1;
 module_param(lcd_proto, int, 0000);
 MODULE_PARM_DESC(lcd_proto,
-		"LCD communication: 0=parallel (//), 1=serial, 2=TI LCD Interface");
+		 "LCD communication: 0=parallel (//), 1=serial, 2=TI LCD Interface");
 
 static int lcd_charset = -1;
 module_param(lcd_charset, int, 0000);
@@ -951,7 +950,6 @@ static void lcd_clear_display(void)
 
 static void lcd_init_display(void)
 {
-
 	lcd_flags = ((lcd_height > 1) ? LCD_FLAG_N : 0)
 	    | LCD_FLAG_D | LCD_FLAG_C | LCD_FLAG_B;
 
@@ -1313,7 +1312,7 @@ static void lcd_write_char(char c)
 }
 
 static ssize_t lcd_write(struct file *file,
-	const char __user *buf, size_t count, loff_t *ppos)
+			 const char __user *buf, size_t count, loff_t *ppos)
 {
 	const char __user *tmp = buf;
 	char c;
@@ -1590,7 +1589,6 @@ static void lcd_init(void)
 static ssize_t keypad_read(struct file *file,
 			   char __user *buf, size_t count, loff_t *ppos)
 {
-
 	unsigned i = *ppos;
 	char __user *tmp = buf;
 
@@ -1615,7 +1613,6 @@ static ssize_t keypad_read(struct file *file,
 
 static int keypad_open(struct inode *inode, struct file *file)
 {
-
 	if (keypad_open_cnt)
 		return -EBUSY;	/* open only once at a time */
 
@@ -1745,8 +1742,8 @@ static inline int input_state_high(struct logical_input *input)
 	 * release function.
 	 * eg: 0 -(press A)-> A -(press B)-> AB : don't match A's release.
 	 */
-	if (((phys_prev & input->mask) == input->value)
-	    && ((phys_curr & input->mask) > input->value)) {
+	if (((phys_prev & input->mask) == input->value) &&
+	    ((phys_curr & input->mask) >  input->value)) {
 		input->state = INPUT_ST_LOW; /* invalidate */
 		return 1;
 	}
@@ -1801,8 +1798,8 @@ static inline void input_state_falling(struct logical_input *input)
 {
 #if 0
 	/* FIXME !!! same comment as in input_state_high */
-	if (((phys_prev & input->mask) == input->value)
-	    && ((phys_curr & input->mask) > input->value)) {
+	if (((phys_prev & input->mask) == input->value) &&
+	    ((phys_curr & input->mask) >  input->value)) {
 		input->state = INPUT_ST_LOW;	/* invalidate */
 		return;
 	}
@@ -1960,9 +1957,10 @@ static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 	while (*name) {
 		int in, out, bit, neg;
 
-		for (in = 0; (in < sizeof(sigtab)) &&
-			     (sigtab[in] != *name); in++)
+		for (in = 0; (in < sizeof(sigtab)) && (sigtab[in] != *name);
+		     in++)
 			;
+
 		if (in >= sizeof(sigtab))
 			return 0;	/* input name not found */
 		neg = (in & 1);	/* odd (lower) names are negated */
@@ -2005,7 +2004,7 @@ static struct logical_input *panel_bind_key(const char *name, const char *press,
 {
 	struct logical_input *key;
 
-	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
 	if (!key)
 		return NULL;

@@ -2043,7 +2042,7 @@ static struct logical_input *panel_bind_callback(char *name,
 {
 	struct logical_input *callback;
 
-	callback = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
+	callback = kmalloc(sizeof(*callback), GFP_KERNEL);
 	if (!callback)
 		return NULL;


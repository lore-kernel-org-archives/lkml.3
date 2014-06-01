Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbaFAKUv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:20:51 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36011 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaFAKUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:20:49 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: willy@meta-x.org, gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        arnd@arndb.de, me@vincentheuken.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: panel: fixed checkpatch errors in panel.c
Date: Sun,  1 Jun 2014 03:20:55 -0700
Message-Id: <1401618055-24546-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply fixes the style errors in panel.c
that scripts/checkpatch.pl reported

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/panel/panel.c | 244 +++++++++++++++++++++---------------------
 1 file changed, 121 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 08f9a48..04f0157 100644
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
@@ -488,7 +488,7 @@ MODULE_PARM_DESC(profile,
  * WARNING! no check will be performed about collisions with keypad !
  */
 
-static int lcd_e_pin  = PIN_NOT_SET;
+static int lcd_e_pin = PIN_NOT_SET;
 module_param(lcd_e_pin, int, 0000);
 MODULE_PARM_DESC(lcd_e_pin,
 		 "# of the // port pin connected to LCD 'E' signal, with polarity (-17..17)");
@@ -594,12 +594,12 @@ static const char (*keypad_profile)[4][9] = old_keypad_profile;
 
 /* FIXME: this should be converted to a bit array containing signals states */
 static struct {
-	unsigned char e;  /* parallel LCD E (data latch on falling edge) */
-	unsigned char rs; /* parallel LCD RS  (0 = cmd, 1 = data) */
-	unsigned char rw; /* parallel LCD R/W (0 = W, 1 = R) */
-	unsigned char bl; /* parallel LCD backlight (0 = off, 1 = on) */
-	unsigned char cl; /* serial LCD clock (latch on rising edge) */
-	unsigned char da; /* serial LCD data */
+	unsigned char e;	/* parallel LCD E (data latch on falling edge) */
+	unsigned char rs;	/* parallel LCD RS  (0 = cmd, 1 = data) */
+	unsigned char rw;	/* parallel LCD R/W (0 = W, 1 = R) */
+	unsigned char bl;	/* parallel LCD backlight (0 = off, 1 = on) */
+	unsigned char cl;	/* serial LCD clock (latch on rising edge) */
+	unsigned char da;	/* serial LCD data */
 } bits;
 
 static void init_scan_timer(void);
@@ -681,14 +681,14 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 		c_bit = PNL_PSTROBE;
 		inv = !inv;
 		break;
-	case PIN_D0...PIN_D7:	/* D0 - D7 = 2 - 9 */
+	case PIN_D0 ... PIN_D7:	/* D0 - D7 = 2 - 9 */
 		d_bit = 1 << (pin - 2);
 		break;
 	case PIN_AUTOLF:	/* autofeed, inverted */
 		c_bit = PNL_PAUTOLF;
 		inv = !inv;
 		break;
-	case PIN_INITP:		/* init, direct */
+	case PIN_INITP:	/* init, direct */
 		c_bit = PNL_PINITP;
 		break;
 	case PIN_SELECP:	/* select_in, inverted */
@@ -733,10 +733,10 @@ static void lcd_send_serial(int byte)
 		panel_set_bits();
 		bits.da = byte & 1;
 		panel_set_bits();
-		udelay(2);  /* maintain the data during 2 us before CLK up */
+		udelay(2);	/* maintain the data during 2 us before CLK up */
 		bits.cl = BIT_SET;	/* CLK high */
 		panel_set_bits();
-		udelay(1);  /* maintain the strobe during 1 us */
+		udelay(1);	/* maintain the strobe during 1 us */
 		byte >>= 1;
 	}
 }
@@ -782,19 +782,19 @@ static void lcd_write_cmd_p8(int cmd)
 	spin_lock_irq(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, cmd);
-	udelay(20);	/* maintain the data during 20 us before the strobe */
+	udelay(20);		/* maintain the data during 20 us before the strobe */
 
 	bits.e = BIT_SET;
 	bits.rs = BIT_CLR;
 	bits.rw = BIT_CLR;
 	set_ctrl_bits();
 
-	udelay(40);	/* maintain the strobe during 40 us */
+	udelay(40);		/* maintain the strobe during 40 us */
 
 	bits.e = BIT_CLR;
 	set_ctrl_bits();
 
-	udelay(120);	/* the shortest command takes at least 120 us */
+	udelay(120);		/* the shortest command takes at least 120 us */
 	spin_unlock_irq(&pprt_lock);
 }
 
@@ -804,19 +804,19 @@ static void lcd_write_data_p8(int data)
 	spin_lock_irq(&pprt_lock);
 	/* present the data to the data port */
 	w_dtr(pprt, data);
-	udelay(20);	/* maintain the data during 20 us before the strobe */
+	udelay(20);		/* maintain the data during 20 us before the strobe */
 
 	bits.e = BIT_SET;
 	bits.rs = BIT_SET;
 	bits.rw = BIT_CLR;
 	set_ctrl_bits();
 
-	udelay(40);	/* maintain the strobe during 40 us */
+	udelay(40);		/* maintain the strobe during 40 us */
 
 	bits.e = BIT_CLR;
 	set_ctrl_bits();
 
-	udelay(45);	/* the shortest data takes at least 45 us */
+	udelay(45);		/* the shortest data takes at least 45 us */
 	spin_unlock_irq(&pprt_lock);
 }
 
@@ -1005,35 +1005,35 @@ static inline int handle_lcd_special_code(void)
 
 	/* check for display mode flags */
 	switch (*esc) {
-	case 'D':	/* Display ON */
+	case 'D':		/* Display ON */
 		lcd_flags |= LCD_FLAG_D;
 		processed = 1;
 		break;
-	case 'd':	/* Display OFF */
+	case 'd':		/* Display OFF */
 		lcd_flags &= ~LCD_FLAG_D;
 		processed = 1;
 		break;
-	case 'C':	/* Cursor ON */
+	case 'C':		/* Cursor ON */
 		lcd_flags |= LCD_FLAG_C;
 		processed = 1;
 		break;
-	case 'c':	/* Cursor OFF */
+	case 'c':		/* Cursor OFF */
 		lcd_flags &= ~LCD_FLAG_C;
 		processed = 1;
 		break;
-	case 'B':	/* Blink ON */
+	case 'B':		/* Blink ON */
 		lcd_flags |= LCD_FLAG_B;
 		processed = 1;
 		break;
-	case 'b':	/* Blink OFF */
+	case 'b':		/* Blink OFF */
 		lcd_flags &= ~LCD_FLAG_B;
 		processed = 1;
 		break;
-	case '+':	/* Back light ON */
+	case '+':		/* Back light ON */
 		lcd_flags |= LCD_FLAG_L;
 		processed = 1;
 		break;
-	case '-':	/* Back light OFF */
+	case '-':		/* Back light OFF */
 		lcd_flags &= ~LCD_FLAG_L;
 		processed = 1;
 		break;
@@ -1046,22 +1046,22 @@ static inline int handle_lcd_special_code(void)
 		}
 		processed = 1;
 		break;
-	case 'f':	/* Small Font */
+	case 'f':		/* Small Font */
 		lcd_flags &= ~LCD_FLAG_F;
 		processed = 1;
 		break;
-	case 'F':	/* Large Font */
+	case 'F':		/* Large Font */
 		lcd_flags |= LCD_FLAG_F;
 		processed = 1;
 		break;
-	case 'n':	/* One Line */
+	case 'n':		/* One Line */
 		lcd_flags &= ~LCD_FLAG_N;
 		processed = 1;
 		break;
-	case 'N':	/* Two Lines */
+	case 'N':		/* Two Lines */
 		lcd_flags |= LCD_FLAG_N;
 		break;
-	case 'l':	/* Shift Cursor Left */
+	case 'l':		/* Shift Cursor Left */
 		if (lcd_addr_x > 0) {
 			/* back one char if not at end of line */
 			if (lcd_addr_x < lcd_bwidth)
@@ -1070,103 +1070,102 @@ static inline int handle_lcd_special_code(void)
 		}
 		processed = 1;
 		break;
-	case 'r':	/* shift cursor right */
+	case 'r':		/* shift cursor right */
 		if (lcd_addr_x < lcd_width) {
 			/* allow the cursor to pass the end of the line */
-			if (lcd_addr_x <
-			    (lcd_bwidth - 1))
+			if (lcd_addr_x < (lcd_bwidth - 1))
 				lcd_write_cmd(0x14);
 			lcd_addr_x++;
 		}
 		processed = 1;
 		break;
-	case 'L':	/* shift display left */
+	case 'L':		/* shift display left */
 		lcd_left_shift++;
 		lcd_write_cmd(0x18);
 		processed = 1;
 		break;
-	case 'R':	/* shift display right */
+	case 'R':		/* shift display right */
 		lcd_left_shift--;
 		lcd_write_cmd(0x1C);
 		processed = 1;
 		break;
-	case 'k': {	/* kill end of line */
-		int x;
-		for (x = lcd_addr_x; x < lcd_bwidth; x++)
-			lcd_write_data(' ');
+	case 'k':{		/* kill end of line */
+			int x;
+			for (x = lcd_addr_x; x < lcd_bwidth; x++)
+				lcd_write_data(' ');
 
-		/* restore cursor position */
-		lcd_gotoxy();
-		processed = 1;
-		break;
-	}
-	case 'I':	/* reinitialize display */
+			/* restore cursor position */
+			lcd_gotoxy();
+			processed = 1;
+			break;
+		}
+	case 'I':		/* reinitialize display */
 		lcd_init_display();
 		lcd_left_shift = 0;
 		processed = 1;
 		break;
-	case 'G': {
-		/* Generator : LGcxxxxx...xx; must have <c> between '0'
-		 * and '7', representing the numerical ASCII code of the
-		 * redefined character, and <xx...xx> a sequence of 16
-		 * hex digits representing 8 bytes for each character.
-		 * Most LCDs will only use 5 lower bits of the 7 first
-		 * bytes.
-		 */
+	case 'G':{
+			/* Generator : LGcxxxxx...xx; must have <c> between '0'
+			 * and '7', representing the numerical ASCII code of the
+			 * redefined character, and <xx...xx> a sequence of 16
+			 * hex digits representing 8 bytes for each character.
+			 * Most LCDs will only use 5 lower bits of the 7 first
+			 * bytes.
+			 */
 
-		unsigned char cgbytes[8];
-		unsigned char cgaddr;
-		int cgoffset;
-		int shift;
-		char value;
-		int addr;
+			unsigned char cgbytes[8];
+			unsigned char cgaddr;
+			int cgoffset;
+			int shift;
+			char value;
+			int addr;
 
-		if (strchr(esc, ';') == NULL)
-			break;
+			if (strchr(esc, ';') == NULL)
+				break;
 
-		esc++;
+			esc++;
 
-		cgaddr = *(esc++) - '0';
-		if (cgaddr > 7) {
-			processed = 1;
-			break;
-		}
+			cgaddr = *(esc++) - '0';
+			if (cgaddr > 7) {
+				processed = 1;
+				break;
+			}
+
+			cgoffset = 0;
+			shift = 0;
+			value = 0;
+			while (*esc && cgoffset < 8) {
+				shift ^= 4;
+				if (*esc >= '0' && *esc <= '9')
+					value |= (*esc - '0') << shift;
+				else if (*esc >= 'A' && *esc <= 'Z')
+					value |= (*esc - 'A' + 10) << shift;
+				else if (*esc >= 'a' && *esc <= 'z')
+					value |= (*esc - 'a' + 10) << shift;
+				else {
+					esc++;
+					continue;
+				}
+
+				if (shift == 0) {
+					cgbytes[cgoffset++] = value;
+					value = 0;
+				}
 
-		cgoffset = 0;
-		shift = 0;
-		value = 0;
-		while (*esc && cgoffset < 8) {
-			shift ^= 4;
-			if (*esc >= '0' && *esc <= '9')
-				value |= (*esc - '0') << shift;
-			else if (*esc >= 'A' && *esc <= 'Z')
-				value |= (*esc - 'A' + 10) << shift;
-			else if (*esc >= 'a' && *esc <= 'z')
-				value |= (*esc - 'a' + 10) << shift;
-			else {
 				esc++;
-				continue;
 			}
 
-			if (shift == 0) {
-				cgbytes[cgoffset++] = value;
-				value = 0;
-			}
+			lcd_write_cmd(0x40 | (cgaddr * 8));
+			for (addr = 0; addr < cgoffset; addr++)
+				lcd_write_data(cgbytes[addr]);
 
-			esc++;
+			/* ensures that we stop writing to CGRAM */
+			lcd_gotoxy();
+			processed = 1;
+			break;
 		}
-
-		lcd_write_cmd(0x40 | (cgaddr * 8));
-		for (addr = 0; addr < cgoffset; addr++)
-			lcd_write_data(cgbytes[addr]);
-
-		/* ensures that we stop writing to CGRAM */
-		lcd_gotoxy();
-		processed = 1;
-		break;
-	}
-	case 'x':	/* gotoxy : LxXXX[yYYY]; */
-	case 'y':	/* gotoxy : LyYYY[xXXX]; */
+	case 'x':		/* gotoxy : LxXXX[yYYY]; */
+	case 'y':		/* gotoxy : LyYYY[xXXX]; */
 		if (strchr(esc, ';') == NULL)
 			break;
 
@@ -1194,14 +1193,12 @@ static inline int handle_lcd_special_code(void)
 		if ((oldflags ^ lcd_flags) &
 		    (LCD_FLAG_B | LCD_FLAG_C | LCD_FLAG_D))
 			/* set display mode */
-			lcd_write_cmd(0x08
-				      | ((lcd_flags & LCD_FLAG_D) ? 4 : 0)
+			lcd_write_cmd(0x08 | ((lcd_flags & LCD_FLAG_D) ? 4 : 0)
 				      | ((lcd_flags & LCD_FLAG_C) ? 2 : 0)
 				      | ((lcd_flags & LCD_FLAG_B) ? 1 : 0));
 		/* check whether one of F,N flags was changed */
 		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_F | LCD_FLAG_N))
-			lcd_write_cmd(0x30
-				      | ((lcd_flags & LCD_FLAG_F) ? 4 : 0)
+			lcd_write_cmd(0x30 | ((lcd_flags & LCD_FLAG_F) ? 4 : 0)
 				      | ((lcd_flags & LCD_FLAG_N) ? 8 : 0));
 		/* check whether L flag was changed */
 		else if ((oldflags ^ lcd_flags) & (LCD_FLAG_L)) {
@@ -1321,7 +1318,7 @@ static ssize_t lcd_write(struct file *file,
 			   or if it is getting too long. */
 			if (processed || (lcd_escape_len >= LCD_ESCAPE_LEN))
 				lcd_escape_len = -1;
-		} /* escape codes */
+		}		/* escape codes */
 	}
 
 	return tmp - buf;
@@ -1350,10 +1347,10 @@ static int lcd_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lcd_fops = {
-	.write   = lcd_write,
-	.open    = lcd_open,
+	.write = lcd_write,
+	.open = lcd_open,
 	.release = lcd_release,
-	.llseek  = no_llseek,
+	.llseek = no_llseek,
 };
 
 static struct miscdevice lcd_dev = {
@@ -1586,8 +1583,7 @@ static ssize_t keypad_read(struct file *file,
 			return -EINTR;
 	}
 
-	for (; count-- > 0 && (keypad_buflen > 0);
-	     ++i, ++tmp, --keypad_buflen) {
+	for (; count-- > 0 && (keypad_buflen > 0); ++i, ++tmp, --keypad_buflen) {
 		put_user(keypad_buffer[keypad_start], tmp);
 		keypad_start = (keypad_start + 1) % KEYPAD_BUFFER;
 	}
@@ -1617,10 +1613,10 @@ static int keypad_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations keypad_fops = {
-	.read    = keypad_read,		/* read */
-	.open    = keypad_open,		/* open */
+	.read = keypad_read,	/* read */
+	.open = keypad_open,	/* open */
 	.release = keypad_release,	/* close */
-	.llseek  = default_llseek,
+	.llseek = default_llseek,
 };
 
 static struct miscdevice keypad_dev = {
@@ -1705,7 +1701,7 @@ static void phys_scan_contacts(void)
 	/* this is easy: use old bits when they are flapping,
 	 * use new ones when stable */
 	phys_curr = (phys_prev & (phys_read ^ phys_read_prev)) |
-		    (phys_read & ~(phys_read ^ phys_read_prev));
+	    (phys_read & ~(phys_read ^ phys_read_prev));
 }
 
 static inline int input_state_high(struct logical_input *input)
@@ -1730,14 +1726,13 @@ static inline int input_state_high(struct logical_input *input)
 	 */
 	if (((phys_prev & input->mask) == input->value)
 	    && ((phys_curr & input->mask) > input->value)) {
-		input->state = INPUT_ST_LOW; /* invalidate */
+		input->state = INPUT_ST_LOW;	/* invalidate */
 		return 1;
 	}
 #endif
 
 	if ((phys_curr & input->mask) == input->value) {
-		if ((input->type == INPUT_TYPE_STD) &&
-		    (input->high_timer == 0)) {
+		if ((input->type == INPUT_TYPE_STD) && (input->high_timer == 0)) {
 			input->high_timer++;
 			if (input->u.std.press_fct != NULL)
 				input->u.std.press_fct(input->u.std.press_data);
@@ -1933,9 +1928,10 @@ static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 	om = im = m = v = 0ULL;
 	while (*name) {
 		int in, out, bit, neg;
-		for (in = 0; (in < sizeof(sigtab)) &&
-			     (sigtab[in] != *name); in++)
-			;
+		for
+		     (in = 0;
+		     (in < sizeof(sigtab)) &&
+		     (sigtab[in] != *name); in++);
 		if (in >= sizeof(sigtab))
 			return 0;	/* input name not found */
 		neg = (in & 1);	/* odd (lower) names are negated */
@@ -2100,13 +2096,14 @@ static void panel_attach(struct parport *port)
 		return;
 	}
 
-	pprt = parport_register_device(port, "panel", NULL, NULL,  /* pf, kf */
+	pprt = parport_register_device(port, "panel", NULL, NULL,	/* pf, kf */
 				       NULL,
 				       /*PARPORT_DEV_EXCL */
 				       0, (void *)&pprt);
 	if (pprt == NULL) {
-		pr_err("%s: port->number=%d parport=%d, parport_register_device() failed\n",
-		       __func__, port->number, parport);
+		pr_err
+		    ("%s: port->number=%d parport=%d, parport_register_device() failed\n",
+		     __func__, port->number, parport);
 		return;
 	}
 
@@ -2146,8 +2143,9 @@ static void panel_detach(struct parport *port)
 		return;
 
 	if (!pprt) {
-		pr_err("%s: port->number=%d parport=%d, nothing to unregister.\n",
-		       __func__, port->number, parport);
+		pr_err
+		    ("%s: port->number=%d parport=%d, nothing to unregister.\n",
+		     __func__, port->number, parport);
 		return;
 	}
 
-- 
1.9.3


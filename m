Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaEUMKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 08:10:44 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:48293 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaEUMKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 08:10:38 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH 1/3] staging: panel: (coding style) Matching braces
Date: Wed, 21 May 2014 14:09:59 +0200
Message-Id: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to comply with checkpatch.pl --strict --file. 
. Adds every missing brace in condition statements.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
Apply on linux-next tree, above:
commit 4151fa6adc65da14673ece623bbb2acc6936f8be
"Add linux-next specific files for 20140516"

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 136671a..1ac5e25 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -711,10 +711,9 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
 /* sleeps that many milliseconds with a reschedule */
 static void long_sleep(int ms)
 {
-
-	if (in_interrupt())
+	if (in_interrupt()) {
 		mdelay(ms);
-	else {
+	} else {
 		current->state = TASK_INTERRUPTIBLE;
 		schedule_timeout((ms * HZ + 999) / 1000);
 	}
@@ -1141,13 +1139,13 @@ static inline int handle_lcd_special_code(void)
 		value = 0;
 		while (*esc && cgoffset < 8) {
 			shift ^= 4;
-			if (*esc >= '0' && *esc <= '9')
+			if (*esc >= '0' && *esc <= '9') {
 				value |= (*esc - '0') << shift;
-			else if (*esc >= 'A' && *esc <= 'Z')
+			} else if (*esc >= 'A' && *esc <= 'Z') {
 				value |= (*esc - 'A' + 10) << shift;
-			else if (*esc >= 'a' && *esc <= 'z')
+			} else if (*esc >= 'a' && *esc <= 'z') {
 				value |= (*esc - 'a' + 10) << shift;
-			else {
+			} else {
 				esc++;
 				continue;
 			}
@@ -1183,8 +1181,9 @@ static inline int handle_lcd_special_code(void)
 				esc++;
 				if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
 					break;
-			} else
+			} else {
 				break;
+			}
 		}
 
 		lcd_gotoxy();
@@ -1973,10 +1971,11 @@ static int input_name2mask(const char *name, pmask_t *mask, pmask_t *value,
 		if (isdigit(*name)) {
 			out = *name - '0';
 			om |= (1 << out);
-		} else if (*name == '-')
+		} else if (*name == '-') {
 			out = 8;
-		else
+		} else {
 			return 0;	/* unknown bit name */
+		}
 
 		bit = (out * 5) + in;
 

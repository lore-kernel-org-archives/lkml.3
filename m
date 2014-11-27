Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaK0Vha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:30 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40130 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaK0Vh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:27 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/9] staging: panel: Remove magic numbers
Date: Thu, 27 Nov 2014 22:36:47 +0100
Message-Id: <1417124213-23409-4-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of magic numbers indicating that the value of a module param
is not set. Use a defined value instead.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 0d3f09e..1b4a211 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -133,6 +133,8 @@
 #define LCD_ESCAPE_LEN		24	/* max chars for LCD escape command */
 #define LCD_ESCAPE_CHAR	27	/* use char 27 for escape command */
 
+#define NOT_SET			-1
+
 /* macros to simplify use of the parallel port */
 #define r_ctr(x)        (parport_read_control((x)->port))
 #define r_dtr(x)        (parport_read_data((x)->port))
@@ -439,37 +441,37 @@ MODULE_PARM_DESC(profile,
 		 "1=16x2 old kp; 2=serial 16x2, new kp; 3=16x2 hantronix; "
 		 "4=16x2 nexcom; default=40x2, old kp");
 
-static int keypad_type = -1;
+static int keypad_type = NOT_SET;
 module_param(keypad_type, int, 0000);
 MODULE_PARM_DESC(keypad_type,
 		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, 3=nexcom 4 keys");
 
-static int lcd_type = -1;
+static int lcd_type = NOT_SET;
 module_param(lcd_type, int, 0000);
 MODULE_PARM_DESC(lcd_type,
 		 "LCD type: 0=none, 1=old //, 2=serial ks0074, 3=hantronix //, 4=nexcom //, 5=compiled-in");
 
-static int lcd_height = -1;
+static int lcd_height = NOT_SET;
 module_param(lcd_height, int, 0000);
 MODULE_PARM_DESC(lcd_height, "Number of lines on the LCD");
 
-static int lcd_width = -1;
+static int lcd_width = NOT_SET;
 module_param(lcd_width, int, 0000);
 MODULE_PARM_DESC(lcd_width, "Number of columns on the LCD");
 
-static int lcd_bwidth = -1;	/* internal buffer width (usually 40) */
+static int lcd_bwidth = NOT_SET;	/* internal buffer width (usually 40) */
 module_param(lcd_bwidth, int, 0000);
 MODULE_PARM_DESC(lcd_bwidth, "Internal LCD line width (40)");
 
-static int lcd_hwidth = -1;	/* hardware buffer width (usually 64) */
+static int lcd_hwidth = NOT_SET;	/* hardware buffer width (usually 64) */
 module_param(lcd_hwidth, int, 0000);
 MODULE_PARM_DESC(lcd_hwidth, "LCD line hardware address (64)");
 
-static int lcd_charset = -1;
+static int lcd_charset = NOT_SET;
 module_param(lcd_charset, int, 0000);
 MODULE_PARM_DESC(lcd_charset, "LCD character set: 0=standard, 1=KS0074");
 
-static int lcd_proto = -1;
+static int lcd_proto = NOT_SET;
 module_param(lcd_proto, int, 0000);
 MODULE_PARM_DESC(lcd_proto,
 		 "LCD communication: 0=parallel (//), 1=serial, 2=TI LCD Interface");
@@ -515,11 +517,11 @@ MODULE_PARM_DESC(lcd_bl_pin,
 
 /* Deprecated module parameters - consider not using them anymore */
 
-static int lcd_enabled = -1;
+static int lcd_enabled = NOT_SET;
 module_param(lcd_enabled, int, 0000);
 MODULE_PARM_DESC(lcd_enabled, "Deprecated option, use lcd_type instead");
 
-static int keypad_enabled = -1;
+static int keypad_enabled = NOT_SET;
 module_param(keypad_enabled, int, 0000);
 MODULE_PARM_DESC(keypad_enabled, "Deprecated option, use keypad_type instead");
 
-- 
2.1.3


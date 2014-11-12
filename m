Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaKLBKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:10:23 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39838 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaKLBKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:20 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: panel: Reorder module parameter declarations
Date: Wed, 12 Nov 2014 02:08:08 +0100
Message-Id: <1415754489-9097-4-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
References: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of the module parameter declarations
so that it matches the Kconfig order.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 73 ++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4434c1d..05b0d1e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -433,6 +433,22 @@ static int parport = -1;
 module_param(parport, int, 0000);
 MODULE_PARM_DESC(parport, "Parallel port index (0=lpt1, 1=lpt2, ...)");
 
+static int profile = DEFAULT_PROFILE;
+module_param(profile, int, 0000);
+MODULE_PARM_DESC(profile,
+		 "1=16x2 old kp; 2=serial 16x2, new kp; 3=16x2 hantronix; "
+		 "4=16x2 nexcom; default=40x2, old kp");
+
+static int keypad_type = -1;
+module_param(keypad_type, int, 0000);
+MODULE_PARM_DESC(keypad_type,
+		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, 3=nexcom 4 keys");
+
+static int lcd_type = -1;
+module_param(lcd_type, int, 0000);
+MODULE_PARM_DESC(lcd_type,
+		 "LCD type: 0=none, 1=old //, 2=serial ks0074, 3=hantronix //, 4=nexcom //, 5=compiled-in");
+
 static int lcd_height = -1;
 module_param(lcd_height, int, 0000);
 MODULE_PARM_DESC(lcd_height, "Number of lines on the LCD");
@@ -449,39 +465,15 @@ static int lcd_hwidth = -1;	/* hardware buffer width (usually 64) */
 module_param(lcd_hwidth, int, 0000);
 MODULE_PARM_DESC(lcd_hwidth, "LCD line hardware address (64)");
 
-static int lcd_enabled = -1;
-module_param(lcd_enabled, int, 0000);
-MODULE_PARM_DESC(lcd_enabled, "Deprecated option, use lcd_type instead");
-
-static int keypad_enabled = -1;
-module_param(keypad_enabled, int, 0000);
-MODULE_PARM_DESC(keypad_enabled, "Deprecated option, use keypad_type instead");
-
-static int lcd_type = -1;
-module_param(lcd_type, int, 0000);
-MODULE_PARM_DESC(lcd_type,
-		 "LCD type: 0=none, 1=old //, 2=serial ks0074, 3=hantronix //, 4=nexcom //, 5=compiled-in");
+static int lcd_charset = -1;
+module_param(lcd_charset, int, 0000);
+MODULE_PARM_DESC(lcd_charset, "LCD character set: 0=standard, 1=KS0074");
 
 static int lcd_proto = -1;
 module_param(lcd_proto, int, 0000);
 MODULE_PARM_DESC(lcd_proto,
 		 "LCD communication: 0=parallel (//), 1=serial, 2=TI LCD Interface");
 
-static int lcd_charset = -1;
-module_param(lcd_charset, int, 0000);
-MODULE_PARM_DESC(lcd_charset, "LCD character set: 0=standard, 1=KS0074");
-
-static int keypad_type = -1;
-module_param(keypad_type, int, 0000);
-MODULE_PARM_DESC(keypad_type,
-		 "Keypad type: 0=none, 1=old 6 keys, 2=new 6+1 keys, 3=nexcom 4 keys");
-
-static int profile = DEFAULT_PROFILE;
-module_param(profile, int, 0000);
-MODULE_PARM_DESC(profile,
-		 "1=16x2 old kp; 2=serial 16x2, new kp; 3=16x2 hantronix; "
-		 "4=16x2 nexcom; default=40x2, old kp");
-
 /*
  * These are the parallel port pins the LCD control signals are connected to.
  * Set this to 0 if the signal is not used. Set it to its opposite value
@@ -506,20 +498,31 @@ module_param(lcd_rw_pin, int, 0000);
 MODULE_PARM_DESC(lcd_rw_pin,
 		 "# of the // port pin connected to LCD 'RW' signal, with polarity (-17..17)");
 
-static int lcd_bl_pin = PIN_NOT_SET;
-module_param(lcd_bl_pin, int, 0000);
-MODULE_PARM_DESC(lcd_bl_pin,
-		 "# of the // port pin connected to LCD backlight, with polarity (-17..17)");
+static int lcd_cl_pin = PIN_NOT_SET;
+module_param(lcd_cl_pin, int, 0000);
+MODULE_PARM_DESC(lcd_cl_pin,
+		 "# of the // port pin connected to serial LCD 'SCL' signal, with polarity (-17..17)");
 
 static int lcd_da_pin = PIN_NOT_SET;
 module_param(lcd_da_pin, int, 0000);
 MODULE_PARM_DESC(lcd_da_pin,
 		 "# of the // port pin connected to serial LCD 'SDA' signal, with polarity (-17..17)");
 
-static int lcd_cl_pin = PIN_NOT_SET;
-module_param(lcd_cl_pin, int, 0000);
-MODULE_PARM_DESC(lcd_cl_pin,
-		 "# of the // port pin connected to serial LCD 'SCL' signal, with polarity (-17..17)");
+static int lcd_bl_pin = PIN_NOT_SET;
+module_param(lcd_bl_pin, int, 0000);
+MODULE_PARM_DESC(lcd_bl_pin,
+		 "# of the // port pin connected to LCD backlight, with polarity (-17..17)");
+
+/* Deprecated module parameters - consider not using them anymore */
+
+static int lcd_enabled = -1;
+module_param(lcd_enabled, int, 0000);
+MODULE_PARM_DESC(lcd_enabled, "Deprecated option, use lcd_type instead");
+
+static int keypad_enabled = -1;
+module_param(keypad_enabled, int, 0000);
+MODULE_PARM_DESC(keypad_enabled, "Deprecated option, use keypad_type instead");
+
 
 static const unsigned char *lcd_char_conv;
 
-- 
2.1.3


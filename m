Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaKLBK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:10:26 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55588 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaKLBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:21 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: panel: Use better names for two defined values
Date: Wed, 12 Nov 2014 02:08:09 +0100
Message-Id: <1415754489-9097-5-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
References: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give DEFAULT_KEYPAD and DEFAULT_LCD defines better names,
so that their meaning is emphasized.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 05b0d1e..c6eeddf 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -304,8 +304,8 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
  */
 #define DEFAULT_PARPORT         0
 #define DEFAULT_PROFILE         PANEL_PROFILE_LARGE
-#define DEFAULT_KEYPAD          KEYPAD_TYPE_OLD
-#define DEFAULT_LCD             LCD_TYPE_OLD
+#define DEFAULT_KEYPAD_TYPE     KEYPAD_TYPE_OLD
+#define DEFAULT_LCD_TYPE        LCD_TYPE_OLD
 #define DEFAULT_LCD_HEIGHT      2
 #define DEFAULT_LCD_WIDTH       40
 #define DEFAULT_LCD_BWIDTH      40
@@ -332,13 +332,13 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 
 #if DEFAULT_PROFILE == 0	/* custom */
 #ifdef CONFIG_PANEL_KEYPAD
-#undef DEFAULT_KEYPAD
-#define DEFAULT_KEYPAD CONFIG_PANEL_KEYPAD
+#undef DEFAULT_KEYPAD_TYPE
+#define DEFAULT_KEYPAD_TYPE CONFIG_PANEL_KEYPAD
 #endif
 
 #ifdef CONFIG_PANEL_LCD
-#undef DEFAULT_LCD
-#define DEFAULT_LCD CONFIG_PANEL_LCD
+#undef DEFAULT_LCD_TYPE
+#define DEFAULT_LCD_TYPE CONFIG_PANEL_LCD
 #endif
 
 #ifdef CONFIG_PANEL_LCD_HEIGHT
@@ -2239,9 +2239,9 @@ static int panel_init(void)
 	case PANEL_PROFILE_CUSTOM:
 		/* custom profile */
 		if (keypad_type < 0)
-			keypad_type = DEFAULT_KEYPAD;
+			keypad_type = DEFAULT_KEYPAD_TYPE;
 		if (lcd_type < 0)
-			lcd_type = DEFAULT_LCD;
+			lcd_type = DEFAULT_LCD_TYPE;
 		break;
 	case PANEL_PROFILE_OLD:
 		/* 8 bits, 2*16, old keypad */
-- 
2.1.3


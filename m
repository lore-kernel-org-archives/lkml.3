Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaKLBK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:10:59 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33446 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaKLBKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:18 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: panel: Reorder DEFAULT_* values redefines
Date: Wed, 12 Nov 2014 02:08:07 +0100
Message-Id: <1415754489-9097-3-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
References: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the order of the DEFAULT_* values redefines so that it
matches the Kconfig order.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 530f7e1..4434c1d 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -320,16 +320,16 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #define DEFAULT_LCD_PIN_SDA     PIN_D0
 #define DEFAULT_LCD_PIN_BL      PIN_NOT_SET
 
-#ifdef CONFIG_PANEL_PROFILE
-#undef DEFAULT_PROFILE
-#define DEFAULT_PROFILE CONFIG_PANEL_PROFILE
-#endif
-
 #ifdef CONFIG_PANEL_PARPORT
 #undef DEFAULT_PARPORT
 #define DEFAULT_PARPORT CONFIG_PANEL_PARPORT
 #endif
 
+#ifdef CONFIG_PANEL_PROFILE
+#undef DEFAULT_PROFILE
+#define DEFAULT_PROFILE CONFIG_PANEL_PROFILE
+#endif
+
 #if DEFAULT_PROFILE == 0	/* custom */
 #ifdef CONFIG_PANEL_KEYPAD
 #undef DEFAULT_KEYPAD
@@ -341,6 +341,11 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #define DEFAULT_LCD CONFIG_PANEL_LCD
 #endif
 
+#ifdef CONFIG_PANEL_LCD_HEIGHT
+#undef DEFAULT_LCD_HEIGHT
+#define DEFAULT_LCD_HEIGHT CONFIG_PANEL_LCD_HEIGHT
+#endif
+
 #ifdef CONFIG_PANEL_LCD_WIDTH
 #undef DEFAULT_LCD_WIDTH
 #define DEFAULT_LCD_WIDTH CONFIG_PANEL_LCD_WIDTH
@@ -356,9 +361,9 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #define DEFAULT_LCD_HWIDTH CONFIG_PANEL_LCD_HWIDTH
 #endif
 
-#ifdef CONFIG_PANEL_LCD_HEIGHT
-#undef DEFAULT_LCD_HEIGHT
-#define DEFAULT_LCD_HEIGHT CONFIG_PANEL_LCD_HEIGHT
+#ifdef CONFIG_PANEL_LCD_CHARSET
+#undef DEFAULT_LCD_CHARSET
+#define DEFAULT_LCD_CHARSET CONFIG_PANEL_LCD_CHARSET
 #endif
 
 #ifdef CONFIG_PANEL_LCD_PROTO
@@ -396,11 +401,6 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 #define DEFAULT_LCD_PIN_BL CONFIG_PANEL_LCD_PIN_BL
 #endif
 
-#ifdef CONFIG_PANEL_LCD_CHARSET
-#undef DEFAULT_LCD_CHARSET
-#define DEFAULT_LCD_CHARSET CONFIG_PANEL_LCD_CHARSET
-#endif
-
 #endif /* DEFAULT_PROFILE == 0 */
 
 /* global variables */
-- 
2.1.3


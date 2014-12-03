Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaLCSyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:54:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46123 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaLCSyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:54:23 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: panel: Remove unused variable
Date: Wed,  3 Dec 2014 19:53:47 +0100
Message-Id: <1417632827-17343-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove lcd.left_shift because it is only written to at some places but
never read from.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 98325b7..b68a9c3 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -228,9 +228,6 @@ static struct {
 	bool initialized;
 	bool must_clear;
 
-	/* TODO: use bool here? */
-	char left_shift;
-
 	int height;
 	int width;
 	int bwidth;
@@ -1135,12 +1132,10 @@ static inline int handle_lcd_special_code(void)
 		processed = 1;
 		break;
 	case 'L':	/* shift display left */
-		lcd.left_shift++;
 		lcd_write_cmd(0x18);
 		processed = 1;
 		break;
 	case 'R':	/* shift display right */
-		lcd.left_shift--;
 		lcd_write_cmd(0x1C);
 		processed = 1;
 		break;
@@ -1157,7 +1152,6 @@ static inline int handle_lcd_special_code(void)
 	}
 	case 'I':	/* reinitialize display */
 		lcd_init_display();
-		lcd.left_shift = 0;
 		processed = 1;
 		break;
 	case 'G': {
-- 
2.1.3


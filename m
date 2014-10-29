Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbaJ2WdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:33:05 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38570 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaJ2WdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:33:03 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: panel: Use designated initializers
Date: Wed, 29 Oct 2014 23:32:30 +0100
Message-Id: <1414621950-3510-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "warning: missing initializer [-Wmissing-field-initializers]"
by using designated struct initializers.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 6d1a320..98556ce 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1375,9 +1375,9 @@ static const struct file_operations lcd_fops = {
 };
 
 static struct miscdevice lcd_dev = {
-	LCD_MINOR,
-	"lcd",
-	&lcd_fops
+	.minor	= LCD_MINOR,
+	.name	= "lcd",
+	.fops	= &lcd_fops,
 };
 
 /* public function usable from the kernel for any purpose */
@@ -1652,9 +1652,9 @@ static const struct file_operations keypad_fops = {
 };
 
 static struct miscdevice keypad_dev = {
-	KEYPAD_MINOR,
-	"keypad",
-	&keypad_fops
+	.minor	= KEYPAD_MINOR,
+	.name	= "keypad",
+	.fops	= &keypad_fops,
 };
 
 static void keypad_send_key(const char *string, int max_len)
-- 
2.1.2


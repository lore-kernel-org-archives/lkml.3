Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbaDXPr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:47:28 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34121 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbaDXPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:47:25 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: jg1.han@samsung.com, cooloney@gmail.com, lee.jones@linaro.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] video/backlight: Fix string type mismatch in s6e63m0.c
Date: Fri, 25 Apr 2014 00:47:16 +0900
Message-Id: <1398354436-25467-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.26.g779792a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix string type mismatch in s6e63m0_sysfs_show_gamma_table().
gamma_table_count is defined as unsigned int.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/video/backlight/s6e63m0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 510a1bc..2d6d481 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -703,7 +703,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
 	struct s6e63m0 *lcd = dev_get_drvdata(dev);
 	char temp[3];
 
-	sprintf(temp, "%d\n", lcd->gamma_table_count);
+	sprintf(temp, "%u\n", lcd->gamma_table_count);
 	strcpy(buf, temp);
 
 	return strlen(buf);
-- 
2.0.0.rc0.26.g779792a


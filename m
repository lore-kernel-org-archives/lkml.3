Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaJKSba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:31:30 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61265 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaJKSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:31:29 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: EXPORT_SYMBOL should immediately follow its function
Date: Sun, 12 Oct 2014 00:01:16 +0530
Message-Id: <1413052276-2575-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch.pl warning
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 3111e86..75b6de9 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -226,6 +226,7 @@ int misc_register(struct miscdevice *misc)
 	mutex_unlock(&misc_mtx);
 	return err;
 }
+EXPORT_SYMBOL(misc_register);
 
 /**
  *	misc_deregister - unregister a miscellaneous device
@@ -252,8 +253,6 @@ int misc_deregister(struct miscdevice *misc)
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
-
-EXPORT_SYMBOL(misc_register);
 EXPORT_SYMBOL(misc_deregister);
 
 static char *misc_devnode(struct device *dev, umode_t *mode)
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaHRWxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 18:53:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64911 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaHRWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:53:47 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tomoki.sekiyama@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: misc: yurex: remove useless casting of private_data
Date: Tue, 19 Aug 2014 04:23:34 +0530
Message-Id: <1408402414-1600-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/usb/misc/yurex.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 1472805..c3a45da 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -358,7 +358,7 @@ static int yurex_fasync(int fd, struct file *file, int on)
 {
 	struct usb_yurex *dev;
 
-	dev = (struct usb_yurex *)file->private_data;
+	dev = file->private_data;
 	return fasync_helper(fd, file, on, &dev->async_queue);
 }
 
@@ -401,7 +401,7 @@ static int yurex_release(struct inode *inode, struct file *file)
 {
 	struct usb_yurex *dev;
 
-	dev = (struct usb_yurex *)file->private_data;
+	dev = file->private_data;
 	if (dev == NULL)
 		return -ENODEV;
 
@@ -418,7 +418,7 @@ static ssize_t yurex_read(struct file *file, char *buffer, size_t count, loff_t
 	char in_buffer[20];
 	unsigned long flags;
 
-	dev = (struct usb_yurex *)file->private_data;
+	dev = file->private_data;
 
 	mutex_lock(&dev->io_mutex);
 	if (!dev->interface) {		/* already disconnected */
@@ -455,7 +455,7 @@ static ssize_t yurex_write(struct file *file, const char *user_buffer, size_t co
 	DEFINE_WAIT(wait);
 
 	count = min(sizeof(buffer), count);
-	dev = (struct usb_yurex *)file->private_data;
+	dev = file->private_data;
 
 	/* verify that we actually have some data to write */
 	if (count == 0)
-- 
1.8.1.msysgit.1


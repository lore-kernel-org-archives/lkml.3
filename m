Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaJJMt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:49:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55270 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaJJMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:49:55 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: yurex: fixed sparse warning of incorrect type
Date: Fri, 10 Oct 2014 18:19:45 +0530
Message-Id: <1412945386-4781-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed sparse warning of
	1) incorrect type (different address spaces)
	2) incorrect type in initializer

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/usb/misc/yurex.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index c3a45da..343fa6f 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -410,7 +410,8 @@ static int yurex_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t yurex_read(struct file *file, char *buffer, size_t count, loff_t *ppos)
+static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
+			  loff_t *ppos)
 {
 	struct usb_yurex *dev;
 	int retval = 0;
@@ -444,7 +445,8 @@ exit:
 	return retval;
 }
 
-static ssize_t yurex_write(struct file *file, const char *user_buffer, size_t count, loff_t *ppos)
+static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
+			   size_t count, loff_t *ppos)
 {
 	struct usb_yurex *dev;
 	int i, set = 0, retval = 0;
-- 
1.8.1.2


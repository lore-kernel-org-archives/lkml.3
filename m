Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaJKScI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:32:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58783 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaJKScF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:32:05 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] char: misc: use pr_err instead of printk
Date: Sun, 12 Oct 2014 00:01:51 +0530
Message-Id: <1413052311-2646-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/char/misc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 75b6de9..a6b96b1 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -280,12 +280,12 @@ static int __init misc_init(void)
 
 	err = -EIO;
 	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
-		goto fail_printk;
+		goto fail_pr_err;
 	misc_class->devnode = misc_devnode;
 	return 0;
 
-fail_printk:
-	printk("unable to get major %d for misc devices\n", MISC_MAJOR);
+fail_pr_err:
+	pr_err("unable to get major %d for misc devices\n", MISC_MAJOR);
 	class_destroy(misc_class);
 fail_remove:
 	remove_proc_entry("misc", NULL);
-- 
1.8.3.2


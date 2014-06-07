Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaFGN6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 09:58:13 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:53126 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaFGN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 09:58:12 -0400
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH] Staging: comedi: check the return value of kobject_set_name
Date: Sat,  7 Jun 2014 17:56:55 +0400
Message-Id: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a check of the return value of the kobject_set_name function.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9d99fb3..dfeefa2 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2597,7 +2597,14 @@ static int __init comedi_init(void)
 		return -EIO;
 	cdev_init(&comedi_cdev, &comedi_fops);
 	comedi_cdev.owner = THIS_MODULE;
-	kobject_set_name(&comedi_cdev.kobj, "comedi");
+
+	retval = kobject_set_name(&comedi_cdev.kobj, "comedi");
+	if (retval) {
+		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
+					 COMEDI_NUM_MINORS);
+		return retval;
+	}
+
 	if (cdev_add(&comedi_cdev, MKDEV(COMEDI_MAJOR, 0), COMEDI_NUM_MINORS)) {
 		unregister_chrdev_region(MKDEV(COMEDI_MAJOR, 0),
 					 COMEDI_NUM_MINORS);
-- 
1.8.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbbAIDsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:48:07 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35006 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbbAIDsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:48:05 -0500
From: Gigi Joseph <gigi.joseph@gmail.com>
X-Google-Original-From: Gigi Joseph <gigi.joseph@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        Robin van der Gracht <robin@protonic.nl>, linux-kernel@vger.kernel.org
Cc: Gigi Joseph <gigi.joseph@ti.com>, Eyal Reizer <eyalr@ti.com>
Subject: [PATCH 4/6] drivers: misc: ti-st: fix debugfs creation error handling
Date: Fri,  9 Jan 2015 03:47:51 +0000
Message-Id: <1420775271-24787-1-git-send-email-gigi.joseph@ti.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the debugfs creation fails the whole init process was failing.
There is no need to do this as the shared transport can work without it.
Fix it so it just reports the failure and continue.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
---
 drivers/misc/ti-st/st_kim.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index f2c1071..878956a 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -836,8 +836,7 @@ static int kim_probe(struct platform_device *pdev)
 	kim_debugfs_dir = debugfs_create_dir("ti-st", NULL);
 	if (!kim_debugfs_dir) {
 		pr_err(" debugfs entries creation failed ");
-		err = -EIO;
-		goto err_debugfs_dir;
+		return 0;
 	}
 
 	debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
@@ -846,9 +845,6 @@ static int kim_probe(struct platform_device *pdev)
 				kim_gdata, &list_debugfs_fops);
 	return 0;
 
-err_debugfs_dir:
-	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
-
 err_sysfs_group:
 	st_core_exit(kim_gdata->core_data);
 
-- 
1.9.1


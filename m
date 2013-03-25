Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3CYFi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:38:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51693 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab3CYFiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:38:25 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: martyn.welch@ge.com
Cc: manohar.vanga@gmail.com, gregkh@linuxfoundation.org, yamanetoshi@gmail.com,
        joe@perches.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: vme: fix for a potential NULL pointer dereference
Date: Sun, 24 Mar 2013 22:37:48 -0700
Message-Id: <1364189869-9275-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audit the return value of cdev_alloc and hence fixes a potential NULL pointer
dereferencing.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index d074b1e..da7f759 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -710,6 +710,10 @@ static int vme_user_probe(struct vme_dev *vdev)
 
 	/* Register the driver as a char device */
 	vme_user_cdev = cdev_alloc();
+	if (!vme_user_cdev) {
+		err = -ENOMEM;
+		goto err_char;
+	}
 	vme_user_cdev->ops = &vme_user_fops;
 	vme_user_cdev->owner = THIS_MODULE;
 	err = cdev_add(vme_user_cdev, MKDEV(VME_MAJOR, 0), VME_DEVS);
-- 
1.7.9.5


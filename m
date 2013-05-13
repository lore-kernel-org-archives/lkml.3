Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3EMGFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 02:05:42 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:52666 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3EMGFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 02:05:39 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 14:05:38 +0800
Message-ID: <CAPgLHd9MXzrkvKBtJYG6GZ2Xn9fBi6TO7NzJQDLgw2jCGqDupQ@mail.gmail.com>
Subject: [PATCH] staging: vme: fix error return code in vme_user_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        wfp5p@virginia.edu, yamanetoshi@gmail.com, gmate.amit@gmail.com,
        joe@perches.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the resource alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/vme/devices/vme_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index da7f759..5fe224d3 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -734,6 +734,7 @@ static int vme_user_probe(struct vme_dev *vdev)
 		if (image[i].resource == NULL) {
 			dev_warn(&vdev->dev,
 				 "Unable to allocate slave resource\n");
+			err = -ENOMEM;
 			goto err_slave;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
@@ -760,6 +761,7 @@ static int vme_user_probe(struct vme_dev *vdev)
 		if (image[i].resource == NULL) {
 			dev_warn(&vdev->dev,
 				 "Unable to allocate master resource\n");
+			err = -ENOMEM;
 			goto err_master;
 		}
 		image[i].size_buf = PCI_BUF_SIZE;


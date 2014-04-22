Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937AbaDVEAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:00:11 -0400
Received: from ozlabs.org ([103.22.144.67]:39541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Lindar Liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 4/9] drivers/scsi/pm8001/pm8001_ctl.c: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:27 +0930
Message-Id: <1398137612-9714-5-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Lindar Liu <lindar_liu@usish.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 28b4e8139153..62c884e79409 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -729,7 +729,7 @@ static ssize_t pm8001_show_update_fw(struct device *cdev,
 			flash_error_table[i].reason);
 }
 
-static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
+static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
 	pm8001_show_update_fw, pm8001_store_update_fw);
 struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_interface_rev,
-- 
1.8.3.2


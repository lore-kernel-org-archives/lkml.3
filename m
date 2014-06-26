Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbaFZRn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:43:58 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49272 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758180AbaFZRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:43:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUHAI5arFNXQz8N/2dsb2JhbABagw2rSgEBAQEBAQUBbZh/AYEMF3WEBAEFJy8jEFE5HhmIRgHCKReFZIkcB4RDBZpZizqIO4NEOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/4] drivers/s390/block/dasd.c: replace pr_warning by pr_warn
Date: Thu, 26 Jun 2014 19:41:48 +0200
Message-Id: <1403804509-9565-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403804509-9565-1-git-send-email-fabf@skynet.be>
References: <1403804509-9565-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
"WARNING: Prefer pr_warn(... to pr_warning(..."
+ coalesce formats.

Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/block/dasd.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 32650fd..baae088 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3221,8 +3221,8 @@ static void dasd_generic_auto_online(void *data, async_cookie_t cookie)
 
 	ret = ccw_device_set_online(cdev);
 	if (ret)
-		pr_warning("%s: Setting the DASD online failed with rc=%d\n",
-			   dev_name(&cdev->dev), ret);
+		pr_warn("%s: Setting the DASD online failed with rc=%d\n",
+			dev_name(&cdev->dev), ret);
 }
 
 /*
@@ -3319,9 +3319,8 @@ int dasd_generic_set_online(struct ccw_device *cdev,
 	discipline = base_discipline;
 	if (device->features & DASD_FEATURE_USEDIAG) {
 	  	if (!dasd_diag_discipline_pointer) {
-			pr_warning("%s Setting the DASD online failed because "
-				   "of missing DIAG discipline\n",
-				   dev_name(&cdev->dev));
+			pr_warn("%s Setting the DASD online failed because of missing DIAG discipline\n",
+				dev_name(&cdev->dev));
 			dasd_delete_device(device);
 			return -ENODEV;
 		}
@@ -3342,9 +3341,8 @@ int dasd_generic_set_online(struct ccw_device *cdev,
 	/* check_device will allocate block device if necessary */
 	rc = discipline->check_device(device);
 	if (rc) {
-		pr_warning("%s Setting the DASD online with discipline %s "
-			   "failed with rc=%i\n",
-			   dev_name(&cdev->dev), discipline->name, rc);
+		pr_warn("%s Setting the DASD online with discipline %s failed with rc=%i\n",
+			dev_name(&cdev->dev), discipline->name, rc);
 		module_put(discipline->owner);
 		module_put(base_discipline->owner);
 		dasd_delete_device(device);
@@ -3353,8 +3351,8 @@ int dasd_generic_set_online(struct ccw_device *cdev,
 
 	dasd_set_target_state(device, DASD_STATE_ONLINE);
 	if (device->state <= DASD_STATE_KNOWN) {
-		pr_warning("%s Setting the DASD online failed because of a "
-			   "missing discipline\n", dev_name(&cdev->dev));
+		pr_warn("%s Setting the DASD online failed because of a missing discipline\n",
+			dev_name(&cdev->dev));
 		rc = -ENODEV;
 		dasd_set_target_state(device, DASD_STATE_NEW);
 		if (device->block)
@@ -3393,13 +3391,11 @@ int dasd_generic_set_offline(struct ccw_device *cdev)
 		open_count = atomic_read(&device->block->open_count);
 		if (open_count > max_count) {
 			if (open_count > 0)
-				pr_warning("%s: The DASD cannot be set offline "
-					   "with open count %i\n",
-					   dev_name(&cdev->dev), open_count);
+				pr_warn("%s: The DASD cannot be set offline with open count %i\n",
+					dev_name(&cdev->dev), open_count);
 			else
-				pr_warning("%s: The DASD cannot be set offline "
-					   "while it is in use\n",
-					   dev_name(&cdev->dev));
+				pr_warn("%s: The DASD cannot be set offline while it is in use\n",
+					dev_name(&cdev->dev));
 			clear_bit(DASD_FLAG_OFFLINE, &device->flags);
 			dasd_put_device(device);
 			return -EBUSY;
-- 
1.8.4.5


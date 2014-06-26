Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbaFZRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:43:32 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:42214 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbaFZRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:43:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUHAI5arFNXQz8N/2dsb2JhbABagw2rSgEBAQEBAQUBbZh/AYEMF3WEBAEFJy8jEFE5HhmIRgHCKReFZIkcBxaELQWaWYs6iDuCAIFEOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/4] drivers/s390/block/dasd.c: remove unnecessary null test before debugfs_remove
Date: Thu, 26 Jun 2014 19:41:46 +0200
Message-Id: <1403804509-9565-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1403804509-9565-1-git-send-email-fabf@skynet.be>
References: <1403804509-9565-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes checkpatch warning:
"WARNING: debugfs_remove(NULL) is safe this check is probably not required"

Cc: Stefan Weinhuber <wein@de.ibm.com>
Cc: Stefan Haberland <stefan.haberland@de.ibm.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/s390/block/dasd.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 1eef0f5..ea2729f 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -283,8 +283,7 @@ static int dasd_state_basic_to_known(struct dasd_device *device)
 
 	if (device->block) {
 		dasd_profile_exit(&device->block->profile);
-		if (device->block->debugfs_dentry)
-			debugfs_remove(device->block->debugfs_dentry);
+		debugfs_remove(device->block->debugfs_dentry);
 		dasd_gendisk_free(device->block);
 		dasd_block_clear_timer(device->block);
 	}
@@ -293,9 +292,7 @@ static int dasd_state_basic_to_known(struct dasd_device *device)
 		return rc;
 	dasd_device_clear_timer(device);
 	dasd_profile_exit(&device->profile);
-	if (device->debugfs_dentry)
-		debugfs_remove(device->debugfs_dentry);
-
+	debugfs_remove(device->debugfs_dentry);
 	DBF_DEV_EVENT(DBF_EMERG, device, "%p debug area deleted", device);
 	if (device->debug_area != NULL) {
 		debug_unregister(device->debug_area);
@@ -1111,23 +1108,17 @@ static void dasd_profile_init(struct dasd_profile *profile,
 static void dasd_profile_exit(struct dasd_profile *profile)
 {
 	dasd_profile_off(profile);
-	if (profile->dentry) {
-		debugfs_remove(profile->dentry);
-		profile->dentry = NULL;
-	}
+	debugfs_remove(profile->dentry);
+	profile->dentry = NULL;
 }
 
 static void dasd_statistics_removeroot(void)
 {
 	dasd_global_profile_level = DASD_PROFILE_OFF;
-	if (dasd_global_profile_dentry) {
-		debugfs_remove(dasd_global_profile_dentry);
-		dasd_global_profile_dentry = NULL;
-	}
-	if (dasd_debugfs_global_entry)
-		debugfs_remove(dasd_debugfs_global_entry);
-	if (dasd_debugfs_root_entry)
-		debugfs_remove(dasd_debugfs_root_entry);
+	debugfs_remove(dasd_global_profile_dentry);
+	dasd_global_profile_dentry = NULL;
+	debugfs_remove(dasd_debugfs_global_entry);
+	debugfs_remove(dasd_debugfs_root_entry);
 }
 
 static void dasd_statistics_createroot(void)
-- 
1.8.4.5


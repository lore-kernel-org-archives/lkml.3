Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037Ab3LIJip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:38:45 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62393 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3LIJio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:38:44 -0500
From: Ethan Zhao <ethan.kernel@gmail.com>
To: konrad.wilk@oracle.com, michaelc@cs.wisc.edu, pjones@redhat.com
Cc: linux-kernel@vger.kernel.org, "Ethan Zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] [SCSI] iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()
Date: Mon,  9 Dec 2013 17:37:11 +0800
Message-Id: <1386581831-312-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ethan Zhao" <ethan.kernel@gmail.com>

Load and unload iscsi_ibft module will cause kernel memory leak, fix it
in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
 drivers/scsi/iscsi_boot_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index 14c1c8f..680bf6f 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
 		iscsi_boot_remove_kobj(boot_kobj);
 
 	kset_unregister(boot_kset->kset);
+	kfree(boot_kset);
 }
 EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
-- 
1.8.3.4 (Apple Git-47)


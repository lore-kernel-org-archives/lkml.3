Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3LCOvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:25 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50631 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LCOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:20 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/9] staging/lustre/obdclass: lprocfs_{alloc_stats,register} always defined
Date: Tue,  3 Dec 2013 22:42:00 +0800
Message-Id: <1386081729-9481-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to surround them with #ifdef LPROCFS.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    4 ++--
 drivers/staging/lustre/lustre/obdclass/genops.c    |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 4afd962..4fb1ecd 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -516,7 +516,7 @@ static int __init init_obdclass(void)
 
 	spin_lock_init(&obd_types_lock);
 	obd_zombie_impexp_init();
-#ifdef LPROCFS
+
 	obd_memory = lprocfs_alloc_stats(OBD_STATS_NUM,
 					 LPROCFS_STATS_FLAG_NONE |
 					 LPROCFS_STATS_FLAG_IRQ_SAFE);
@@ -531,7 +531,7 @@ static int __init init_obdclass(void)
 	lprocfs_counter_init(obd_memory, OBD_MEMORY_PAGES_STAT,
 			     LPROCFS_CNTR_AVGMINMAX,
 			     "pagesused", "pages");
-#endif
+
 	err = obd_init_checks();
 	if (err == -EOVERFLOW)
 		return err;
diff --git a/drivers/staging/lustre/lustre/obdclass/genops.c b/drivers/staging/lustre/lustre/obdclass/genops.c
index f6fae16..d9f750d 100644
--- a/drivers/staging/lustre/lustre/obdclass/genops.c
+++ b/drivers/staging/lustre/lustre/obdclass/genops.c
@@ -193,7 +193,6 @@ int class_register_type(struct obd_ops *dt_ops, struct md_ops *md_ops,
 	strcpy(type->typ_name, name);
 	spin_lock_init(&type->obd_type_lock);
 
-#ifdef LPROCFS
 	type->typ_procroot = lprocfs_register(type->typ_name, proc_lustre_root,
 					      vars, type);
 	if (IS_ERR(type->typ_procroot)) {
@@ -201,7 +200,7 @@ int class_register_type(struct obd_ops *dt_ops, struct md_ops *md_ops,
 		type->typ_procroot = NULL;
 		GOTO (failed, rc);
 	}
-#endif
+
 	if (ldt != NULL) {
 		type->typ_lu = ldt;
 		rc = lu_device_type_init(ldt);
-- 
1.7.9.5


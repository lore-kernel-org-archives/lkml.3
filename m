Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3LCOva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:30 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49575 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LCOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:26 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 4/9] staging/lustre/obdclass: move obd_sysctl_init out of class_procfs_init
Date: Tue,  3 Dec 2013 22:42:02 +0800
Message-Id: <1386081729-9481-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not strictly related to procfs. Besides, we already call obd_sysctl_clean
outside of class_procfs_clean.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |    3 +++
 .../lustre/lustre/obdclass/linux/linux-module.c    |    1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index 4fb1ecd..7b1d1b6 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -564,6 +564,9 @@ static int __init init_obdclass(void)
 	err = obd_init_caches();
 	if (err)
 		return err;
+
+	obd_sysctl_init();
+
 	err = class_procfs_init();
 	if (err)
 		return err;
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index d1a57eb..2efc437 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -380,7 +380,6 @@ int class_procfs_init(void)
 {
 	int rc = 0;
 
-	obd_sysctl_init();
 	proc_lustre_root = lprocfs_register("fs/lustre", NULL,
 					    lprocfs_base, NULL);
 	if (IS_ERR(proc_lustre_root)) {
-- 
1.7.9.5


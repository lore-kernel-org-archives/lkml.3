Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3KUObs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:31:48 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35444 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3KUObp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:45 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/10] staging/lustre/libcfs: remove filp_fsync
Date: Thu, 21 Nov 2013 22:28:23 +0800
Message-Id: <1385044111-3129-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can just call generic vfs_fsync().

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |    6 ------
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    2 +-
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index 8fabe4b..e523004 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -52,18 +52,12 @@
 #include <linux/backing-dev.h>
 #include <linux/posix_acl_xattr.h>
 
-# define do_fsync(fp, flag)				\
-	((fp)->f_op->fsync(fp, 0, LLONG_MAX, flag))
-
 #define filp_read(fp, buf, size, pos)			\
 	((fp)->f_op->read((fp), (buf), (size), pos))
 
 #define filp_write(fp, buf, size, pos)			\
 	((fp)->f_op->write((fp), (buf), (size), pos))
 
-#define filp_fsync(fp)					\
-	do_fsync(fp, 1)
-
 #define flock_type(fl)			((fl)->fl_type)
 #define flock_set_type(fl, type)	do { (fl)->fl_type = (type); } while (0)
 #define flock_pid(fl)			((fl)->fl_pid)
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 0ce4aac..4c3dad6 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -721,7 +721,7 @@ int cfs_tracefile_dump_all_pages(char *filename)
 		cfs_tage_free(tage);
 	}
 	MMSPACE_CLOSE;
-	rc = filp_fsync(filp);
+	rc = vfs_fsync(filp, 1);
 	if (rc)
 		printk(KERN_ERR "sync returns %d\n", rc);
 close:
-- 
1.7.9.5


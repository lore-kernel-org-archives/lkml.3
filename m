Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaAVNsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:48:10 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40459 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaAVNsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:48:06 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/6] staging/lustre/libcfs: remove cfs_curproc_groups_nr
Date: Wed, 22 Jan 2014 21:47:33 +0800
Message-Id: <1390398457-31140-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
References: <1390398457-31140-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no user.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |    7 -------
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   11 -----------
 2 files changed, 18 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index 507d16b..9e52393 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -44,13 +44,6 @@
 #define __LIBCFS_CURPROC_H__
 
 /*
- * Portable API to access common characteristics of "current" UNIX process.
- *
- * Implemented in portals/include/libcfs/<os>/
- */
-int    cfs_curproc_groups_nr(void);
-
-/*
  * Plus, platform-specific constant
  *
  * CFS_CURPROC_COMM_MAX,
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index a2ef64c..0137062 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -55,16 +55,6 @@
  * for Linux kernel.
  */
 
-int    cfs_curproc_groups_nr(void)
-{
-	int nr;
-
-	task_lock(current);
-	nr = current_cred()->group_info->ngroups;
-	task_unlock(current);
-	return nr;
-}
-
 /* Currently all the CFS_CAP_* defines match CAP_* ones. */
 #define cfs_cap_pack(cap) (cap)
 #define cfs_cap_unpack(cap) (cap)
@@ -292,7 +282,6 @@ out:
 }
 EXPORT_SYMBOL(cfs_get_environ);
 
-EXPORT_SYMBOL(cfs_curproc_groups_nr);
 EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
 EXPORT_SYMBOL(cfs_cap_raised);
-- 
1.7.9.5


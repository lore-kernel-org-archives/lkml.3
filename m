Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaAVNsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:48:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42893 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaAVNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:48:14 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/6] staging/lustre/libcfs: remove cfs_curproc_cap_unpack
Date: Wed, 22 Jan 2014 21:47:34 +0800
Message-Id: <1390398457-31140-3-git-send-email-bergwolf@gmail.com>
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
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   10 ----------
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index 9e52393..d12cfb1 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -84,7 +84,6 @@ void cfs_cap_raise(cfs_cap_t cap);
 void cfs_cap_lower(cfs_cap_t cap);
 int cfs_cap_raised(cfs_cap_t cap);
 cfs_cap_t cfs_curproc_cap_pack(void);
-void cfs_curproc_cap_unpack(cfs_cap_t cap);
 int cfs_capable(cfs_cap_t cap);
 
 /* __LIBCFS_CURPROC_H__ */
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 0137062..65cb2fa 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -116,15 +116,6 @@ cfs_cap_t cfs_curproc_cap_pack(void)
 	return cap;
 }
 
-void cfs_curproc_cap_unpack(cfs_cap_t cap)
-{
-	struct cred *cred;
-	if ((cred = prepare_creds())) {
-		cfs_kernel_cap_unpack(&cred->cap_effective, cap);
-		commit_creds(cred);
-	}
-}
-
 int cfs_capable(cfs_cap_t cap)
 {
 	return capable(cfs_cap_unpack(cap));
@@ -286,7 +277,6 @@ EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
 EXPORT_SYMBOL(cfs_cap_raised);
 EXPORT_SYMBOL(cfs_curproc_cap_pack);
-EXPORT_SYMBOL(cfs_curproc_cap_unpack);
 EXPORT_SYMBOL(cfs_capable);
 
 /*
-- 
1.7.9.5


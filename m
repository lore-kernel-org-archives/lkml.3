Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3JXPtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:49:53 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46013 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab3JXPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:49:48 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/34] sysfs: honor bin_attr.attr.ignore_lockdep
Date: Thu, 24 Oct 2013 11:49:08 -0400
Message-Id: <1382629780-10006-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ignore_lockdep is currently honored only for regular files.  There's
no reason to ignore it for bin files.  Update sysfs_ignore_lockdep()
so that bin_attr.attr.ignore_lockdep works too.

While this doesn't have any in-kernel user, this unifies the behaviors
between regular and bin files and will help later changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/sysfs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c095d952..bdce845 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -114,7 +114,9 @@ do {								\
 /* Test for attributes that want to ignore lockdep for read-locking */
 static inline bool sysfs_ignore_lockdep(struct sysfs_dirent *sd)
 {
-	return sysfs_type(sd) == SYSFS_KOBJ_ATTR &&
+	int type = sysfs_type(sd);
+
+	return (type == SYSFS_KOBJ_ATTR || type == SYSFS_KOBJ_BIN_ATTR) &&
 		sd->s_attr.attr->ignore_lockdep;
 }
 
-- 
1.8.3.1


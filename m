Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3KCKD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:03:26 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37036 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3KCJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:24 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/39] sysfs: make __sysfs_add_one() fail if the parent isn't a directory
Date: Sun,  3 Nov 2013 04:52:40 -0500
Message-Id: <1383472398-17812-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kobject based interface guarantees that a parent
sysfs_dirent is always a directory; however, the planned kernfs
interface will be directly based on sysfs_dirents and the caller may
specify non-directory node as the parent.  Add an explicit check in
__sysfs_add_one() so that such attempts fail with -EINVAL.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 08c6696..f192c41 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -432,6 +432,9 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
 
+	if (sysfs_type(parent_sd) != SYSFS_DIR)
+		return -EINVAL;
+
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
 	sd->s_parent = sysfs_get(parent_sd);
 
-- 
1.8.3.1


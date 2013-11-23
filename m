Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab3KWWWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:22:43 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:52627 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3KWWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:22:33 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/41] sysfs: make __sysfs_add_one() fail if the parent isn't a directory
Date: Sat, 23 Nov 2013 17:21:47 -0500
Message-Id: <1385245346-856-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385245346-856-1-git-send-email-tj@kernel.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
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
index b3cf61d..98701c0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -429,6 +429,9 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		return -EINVAL;
 	}
 
+	if (sysfs_type(parent_sd) != SYSFS_DIR)
+		return -EINVAL;
+
 	sd->s_hash = sysfs_name_hash(sd->s_name, sd->s_ns);
 	sd->s_parent = sysfs_get(parent_sd);
 
-- 
1.8.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbbA0AWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:22:05 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:32995 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbbA0AWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:22:03 -0500
Message-ID: <1422318099.6710.3.camel@j-VirtualBox>
Subject: [PATCH] cgroup: Initialize root in cgroup_mount
From: Jason Low <jason.low2@hp.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, aswin@hp.com, Jason Low <jason.low2@hp.com>
Date: Mon, 26 Jan 2015 16:21:39 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling kernel/ causes warnings:

    ... ‘root’ may be used uninitialized in this function
    ... ‘root’ was declared here

This isn't an issue since there is already logic to not use
root if we goto out_unlock without setting root.

Explicitly initialize root to NULL to suppress this so that we can
focus on catching warnings that can potentially cause bigger issues.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bb263d0..66684f3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1738,8 +1738,8 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 void *data)
 {
 	struct super_block *pinned_sb = NULL;
+	struct cgroup_root *root = NULL;
 	struct cgroup_subsys *ss;
-	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
-- 
1.7.1




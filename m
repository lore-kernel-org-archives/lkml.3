Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab3K1T7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:59:00 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59844 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522Ab3K1Tz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:27 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/34] sysfs, kernfs: drop unused params from sysfs_fill_super()
Date: Thu, 28 Nov 2013 14:54:36 -0500
Message-Id: <1385668487-10181-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_fill_super() takes three params - @sb, @data and @silent - but
uses only @sb.  Drop the latter two.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 852d115..21070c2 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -41,7 +41,7 @@ struct sysfs_dirent sysfs_root = {
 	.s_ino		= 1,
 };
 
-static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
+static int sysfs_fill_super(struct super_block *sb)
 {
 	struct inode *inode;
 	struct dentry *root;
@@ -123,7 +123,7 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	if (IS_ERR(sb))
 		return ERR_CAST(sb);
 	if (!sb->s_root) {
-		error = sysfs_fill_super(sb, data, flags & MS_SILENT ? 1 : 0);
+		error = sysfs_fill_super(sb);
 		if (error) {
 			deactivate_locked_super(sb);
 			return ERR_PTR(error);
-- 
1.8.4.2


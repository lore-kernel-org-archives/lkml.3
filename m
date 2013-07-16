Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab3GPT3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:29:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3GPT31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:29:27 -0400
Date: Tue, 16 Jul 2013 14:29:20 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] allow some kernel filesystems to be mounted in a user
 namespace
Message-ID: <20130716192920.GA8980@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the files will be owned by host root, so there's no security
concern in allowing this.

(These are mounted by default by mountall, and if permission is
denied then by default container boot will hang)

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/debugfs/inode.c | 1 +
 fs/fuse/control.c  | 1 +
 security/inode.c   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4888cb3..8632432 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -298,6 +298,7 @@ static struct file_system_type debug_fs_type = {
 	.name =		"debugfs",
 	.mount =	debug_mount,
 	.kill_sb =	kill_litter_super,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("debugfs");
 
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index a0b0855..4991441 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -340,6 +340,7 @@ static struct file_system_type fuse_ctl_fs_type = {
 	.name		= "fusectl",
 	.mount		= fuse_ctl_mount,
 	.kill_sb	= fuse_ctl_kill_sb,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fusectl");
 
diff --git a/security/inode.c b/security/inode.c
index 43ce6e1..ec18abd 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -49,6 +49,7 @@ static struct file_system_type fs_type = {
 	.name =		"securityfs",
 	.mount =	get_sb,
 	.kill_sb =	kill_litter_super,
+	.fs_flags	= FS_USERNS_MOUNT,
 };
 
 /**
-- 
1.8.3.2


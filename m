Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbaELN0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:26:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:35643 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbaELN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:26:02 -0400
X-Nat-Received: from [202.181.97.72]:26719 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399901153.24955
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com,
        selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
Message-Id: <201405122225.CIE09825.MFHOtOOSQVFFLJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 22:25:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12052014 #7893288, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 479d305929c4ef600de99948f42ed633b24458b0 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 May 2014 22:02:30 +0900
Subject: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.

Since all LSM modules are now ready to handle the rename flags,
security_inode_rename() and security_path_rename() no longer need to
call each LSM module with reversed arguments.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/security.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/security/security.c b/security/security.c
index 81d7ffe..fbc4968 100644
--- a/security/security.c
+++ b/security/security.c
@@ -439,15 +439,6 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
 	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
 		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->path_rename(new_dir, new_dentry,
-						    old_dir, old_dentry,
-						    flags);
-		if (err)
-			return err;
-	}
-
 	return security_ops->path_rename(old_dir, old_dentry, new_dir,
 					 new_dentry, flags);
 }
@@ -540,15 +531,6 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
         if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
             (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
 		return 0;
-
-	if (flags & RENAME_EXCHANGE) {
-		int err = security_ops->inode_rename(new_dir, new_dentry,
-						     old_dir, old_dentry,
-						     flags);
-		if (err)
-			return err;
-	}
-
 	return security_ops->inode_rename(old_dir, old_dentry,
 					  new_dir, new_dentry, flags);
 }
-- 
1.7.1

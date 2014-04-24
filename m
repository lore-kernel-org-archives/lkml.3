Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaDXL0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:26:31 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:28054 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaDXL0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:26:25 -0400
X-Nat-Received: from [202.181.97.72]:25711 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1398338782.11243
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu
Subject: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
In-Reply-To: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
Message-Id: <201404242026.DFE51568.QMFOLOJtOFVFHS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 24 Apr 2014 20:26:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042014 #7805673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fe5ea6a9442c95725d3c27eddfde754acd8c9785 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 24 Apr 2014 20:09:57 +0900
Subject: [PATCH (for 3.15) 5/5] LSM: Remove duplicated rename handling.

Since all LSM modules are now ready to handle the rename flags,
security_inode_rename() and security_path_rename() no longer need to
call each LSM module with reversed arguments.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/security.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/security/security.c b/security/security.c
index 65ceef3..96f9437 100644
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
1.7.9.5

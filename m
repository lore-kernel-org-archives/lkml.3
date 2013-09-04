Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab3IDAzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:55:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42171 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934185Ab3IDAzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:55:15 -0400
X-Sasl-enc: b+TtfcNWblFRbHCbMupO8QKxvnU7ajOplPmSev2xZhIj 1378256114
Subject: [PATCH 3/3] autofs: use IS_ROOT to replace root dentry checks
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 04 Sep 2013 08:55:11 +0800
Message-ID: <20130904005510.5025.56622.stgit@perseus.fritz.box>
In-Reply-To: <20130904005456.5025.94309.stgit@perseus.fritz.box>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rui Xiang <rui.xiang@huawei.com>

Use the helper macro !IS_ROOT to replace parent != dentry->d_parent.
Just clean up.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Acked-by: Ian Kent <raven@themaw.net>
---
 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 92ef341..2caf36a 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -558,7 +558,7 @@ static int autofs4_dir_symlink(struct inode *dir,
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 
 	dir->i_mtime = CURRENT_TIME;
@@ -593,7 +593,7 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
-		if (p_ino && dentry->d_parent != dentry)
+		if (p_ino && !IS_ROOT(dentry))
 			atomic_dec(&p_ino->count);
 	}
 	dput(ino->dentry);
@@ -732,7 +732,7 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, umode_t m
 	dget(dentry);
 	atomic_inc(&ino->count);
 	p_ino = autofs4_dentry_ino(dentry->d_parent);
-	if (p_ino && dentry->d_parent != dentry)
+	if (p_ino && !IS_ROOT(dentry))
 		atomic_inc(&p_ino->count);
 	inc_nlink(dir);
 	dir->i_mtime = CURRENT_TIME;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983AbaDNGhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 02:37:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:56388 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDNGhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 02:37:08 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove redundant null check in btrfs_dentry_release()
Date: Mon, 14 Apr 2014 15:37:02 +0900
Message-ID: <3662362.sLylFx3ZAR@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It doesn't need to check NULL for kfree()

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/btrfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 06e9a41..d9f54b0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5141,8 +5141,7 @@ static int btrfs_dentry_delete(const struct dentry *dentry)
 
 static void btrfs_dentry_release(struct dentry *dentry)
 {
-	if (dentry->d_fsdata)
-		kfree(dentry->d_fsdata);
+	kfree(dentry->d_fsdata);
 }
 
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
-- 
1.7.4.4



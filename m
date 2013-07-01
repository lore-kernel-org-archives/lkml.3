Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3GAKtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3GAKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:49:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Thomas Meyer <thomas@m3y3r.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/12] GFS2: Cocci spatch "ptr_ret.spatch"
Date: Mon,  1 Jul 2013 10:33:06 +0100
Message-Id: <1372671195-3472-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Use PTR_RET in place of open coding this function.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 62b484e..5fbb8df 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -588,7 +588,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		inode = gfs2_lookupi(dir, &dentry->d_name, 0);
 		gfs2_glock_dq_uninit(ghs);
 		d_instantiate(dentry, inode);
-		return IS_ERR(inode) ? PTR_ERR(inode) : 0;
+		return PTR_RET(inode);
 	}
 	if (error)
 		goto fail_gunlock;
-- 
1.7.4


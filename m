Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3HSJOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3HSJOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/5] GFS2: Fix typo in gfs2_create_inode()
Date: Mon, 19 Aug 2013 09:48:03 +0100
Message-Id: <1376902087-7783-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
References: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTR_RET should be PTR_ERR

Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index bbb2715..a01b8fd 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -594,7 +594,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		}
 		gfs2_glock_dq_uninit(ghs);
 		if (IS_ERR(d))
-			return PTR_RET(d);
+			return PTR_ERR(d);
 		return error;
 	} else if (error != -ENOENT) {
 		goto fail_gunlock;
-- 
1.7.4


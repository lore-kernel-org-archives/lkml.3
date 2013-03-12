Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3CLPmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:42:42 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34603 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031Ab3CLPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:39 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz,
        Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
Subject: [PATCH 09/13] overlayfs-fix-possible-leak-in-ovl_new_inode
Date: Tue, 12 Mar 2013 16:41:44 +0100
Message-Id: <1363102908-28956-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
References: <1363102908-28956-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <hao.bigrat@gmail.com>

After allocating a new inode, if the mode of inode is incorrect, we should
release it by iput().

Signed-off-by: Robin Dong <sanbai@taobao.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 0dfa8a4..033de6f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -371,6 +371,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 
 	default:
 		WARN(1, "illegal file type: %i\n", mode);
+		iput(inode);
 		inode = NULL;
 	}
 
-- 
1.7.10.4


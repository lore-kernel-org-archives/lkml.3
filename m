Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaKDK2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:28:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaKDK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:27:58 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] fs: Remove i_devices list head
Date: Tue,  4 Nov 2014 11:27:31 +0100
Message-Id: <1415096851-17209-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1415096851-17209-1-git-send-email-jack@suse.cz>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noone uses i_devices anymore. Remove it (thus saving two pointers in
every inode).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 1 -
 include/linux/fs.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 26753ba7b6d6..cb7acd45dce5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -366,7 +366,6 @@ void inode_init_once(struct inode *inode)
 {
 	memset(inode, 0, sizeof(*inode));
 	INIT_HLIST_NODE(&inode->i_hash);
-	INIT_LIST_HEAD(&inode->i_devices);
 	INIT_LIST_HEAD(&inode->i_wb_list);
 	INIT_LIST_HEAD(&inode->i_lru);
 	address_space_init_once(&inode->i_data);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d7fd7959a933..8c4f5678e75e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -595,7 +595,6 @@ struct inode {
 #ifdef CONFIG_QUOTA
 	struct dquot		*i_dquot[MAXQUOTAS];
 #endif
-	struct list_head	i_devices;
 	union {
 		struct pipe_inode_info	*i_pipe;
 		struct block_device	*i_bdev;
-- 
1.8.1.4


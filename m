Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab3GSI1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:27:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab3GSI1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:27:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947789"
Message-ID: <51E8F7A6.7030708@cn.fujitsu.com>
Date: Fri, 19 Jul 2013 16:24:06 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: use list_for_each rather than list_for_each_safe, in
 remove_orphan_inode()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:25:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 16:25:45,
	Serialize complete at 2013/07/19 16:25:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we remove the target single node, so list_for_each is enought, in order to
clean up, we use list_for_each_entry instead.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 290db04..87f7bc2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -237,13 +237,12 @@ out:
 
 void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
-	struct list_head *this, *next, *head;
+	struct list_head *head;
 	struct orphan_inode_entry *orphan;
 
 	mutex_lock(&sbi->orphan_inode_mutex);
 	head = &sbi->orphan_inode_list;
-	list_for_each_safe(this, next, head) {
-		orphan = list_entry(this, struct orphan_inode_entry, list);
+	list_for_each_entry(orphan, head, list) {
 		if (orphan->ino == ino) {
 			list_del(&orphan->list);
 			kmem_cache_free(orphan_entry_slab, orphan);
-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3FTJzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:55:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29029 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756558Ab3FTJzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:55:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614480"
Message-ID: <51C2D0E7.3020403@cn.fujitsu.com>
Date: Thu, 20 Jun 2013 17:52:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: [PATCH] fs/f2fs: Code cleanup and simplify in func {find/add}_gc_inode
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 17:54:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 17:54:28,
	Serialize complete at 2013/06/20 17:54:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/gc.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 1496159..0b8b439 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -314,28 +314,21 @@ static const struct victim_selection default_v_ops = {

 static struct inode *find_gc_inode(nid_t ino, struct list_head *ilist)
 {
-       struct list_head *this;
        struct inode_entry *ie;

-       list_for_each(this, ilist) {
-               ie = list_entry(this, struct inode_entry, list);
+       list_for_each_entry(ie, ilist, list)
                if (ie->inode->i_ino == ino)
                        return ie->inode;
-       }
        return NULL;
 }

 static void add_gc_inode(struct inode *inode, struct list_head *ilist)
 {
-       struct list_head *this;
-       struct inode_entry *new_ie, *ie;
+       struct inode_entry *new_ie;

-       list_for_each(this, ilist) {
-               ie = list_entry(this, struct inode_entry, list);
-               if (ie->inode == inode) {
-                       iput(inode);
-                       return;
-               }
+       if (inode == find_gc_inode(inode->i_ino, ilist)) {
+               iput(inode);
+               return;
        }
 repeat:
        new_ie = kmem_cache_alloc(winode_slab, GFP_NOFS);
-- 
1.7.7

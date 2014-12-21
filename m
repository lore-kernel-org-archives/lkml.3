Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaLUQg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:36:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:52585 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaLUQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:35:33 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/6] f2fs: activate f2fs_trace_pid
Date: Sun, 21 Dec 2014 08:35:21 -0800
Message-Id: <1419179723-3234-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch activates f2fs_trace_pid.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 3 +++
 fs/f2fs/node.c       | 2 ++
 fs/f2fs/segment.c    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0ac7c39..3999933 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -20,6 +20,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include "trace.h"
 #include <trace/events/f2fs.h>
 
 static struct kmem_cache *ino_entry_slab;
@@ -301,6 +302,7 @@ static int f2fs_set_meta_page_dirty(struct page *page)
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
 		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_META);
+		f2fs_trace_pid(page);
 		return 1;
 	}
 	return 0;
@@ -712,6 +714,7 @@ void update_dirty_page(struct inode *inode, struct page *page)
 		kmem_cache_free(inode_entry_slab, new);
 out:
 	SetPagePrivate(page);
+	f2fs_trace_pid(page);
 }
 
 void add_dirty_dir_inode(struct inode *inode)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index adc35c9..a7cb0db 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -19,6 +19,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include "trace.h"
 #include <trace/events/f2fs.h>
 
 #define on_build_free_nids(nmi) mutex_is_locked(&nm_i->build_lock)
@@ -1362,6 +1363,7 @@ static int f2fs_set_node_page_dirty(struct page *page)
 		__set_page_dirty_nobuffers(page);
 		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_NODES);
 		SetPagePrivate(page);
+		f2fs_trace_pid(page);
 		return 1;
 	}
 	return 0;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c726f86..b688991 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -20,6 +20,7 @@
 #include "f2fs.h"
 #include "segment.h"
 #include "node.h"
+#include "trace.h"
 #include <trace/events/f2fs.h>
 
 #define __reverse_ffz(x) __reverse_ffs(~(x))
@@ -181,6 +182,7 @@ void register_inmem_page(struct inode *inode, struct page *page)
 	int err;
 
 	SetPagePrivate(page);
+	f2fs_trace_pid(page);
 
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
-- 
2.1.1


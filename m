Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaDHUMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:12:16 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:35823 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768AbaDHUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:12:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArANACVXRFNXQwqv/2dsb2JhbABZgwaDS8F+AgKBIRd0gmYcIxiBAiQTiAABymeObIQ/AQOOXol+AZJAgzI7
Date: Tue, 8 Apr 2014 22:13:42 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH 1/1] OCFS2: Remove NULL assignments on static
Message-Id: <20140408221342.9759bea1dd852f2787f82586@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ocfs2/cluster/tcp.c   | 2 +-
 fs/ocfs2/dlm/dlmdebug.c  | 2 +-
 fs/ocfs2/dlm/dlmlock.c   | 2 +-
 fs/ocfs2/dlm/dlmmaster.c | 6 +++---
 fs/ocfs2/stackglue.c     | 2 +-
 fs/ocfs2/super.c         | 4 ++--
 fs/ocfs2/uptodate.c      | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index eb649d2..161fb1e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -108,7 +108,7 @@ static struct rb_root o2net_handler_tree = RB_ROOT;
 static struct o2net_node o2net_nodes[O2NM_MAX_NODES];
 
 /* XXX someday we'll need better accounting */
-static struct socket *o2net_listen_sock = NULL;
+static struct socket *o2net_listen_sock;
 
 /*
  * listen work is only queued by the listening socket callbacks on the
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index e33cd7a..18f13c2 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -338,7 +338,7 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 
 #ifdef CONFIG_DEBUG_FS
 
-static struct dentry *dlm_debugfs_root = NULL;
+static struct dentry *dlm_debugfs_root;
 
 #define DLM_DEBUGFS_DIR				"o2dlm"
 #define DLM_DEBUGFS_DLM_STATE			"dlm_state"
diff --git a/fs/ocfs2/dlm/dlmlock.c b/fs/ocfs2/dlm/dlmlock.c
index 5d32f75..66c2a49 100644
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -52,7 +52,7 @@
 #define MLOG_MASK_PREFIX ML_DLM
 #include "cluster/masklog.h"
 
-static struct kmem_cache *dlm_lock_cache = NULL;
+static struct kmem_cache *dlm_lock_cache;
 
 static DEFINE_SPINLOCK(dlm_cookie_lock);
 static u64 dlm_next_cookie = 1;
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index af3f7aa..fd07ef9 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -82,9 +82,9 @@ static inline int dlm_mle_equal(struct dlm_ctxt *dlm,
 	return 1;
 }
 
-static struct kmem_cache *dlm_lockres_cache = NULL;
-static struct kmem_cache *dlm_lockname_cache = NULL;
-static struct kmem_cache *dlm_mle_cache = NULL;
+static struct kmem_cache *dlm_lockres_cache;
+static struct kmem_cache *dlm_lockname_cache;
+static struct kmem_cache *dlm_mle_cache;
 
 static void dlm_mle_release(struct kref *kref);
 static void dlm_init_mle(struct dlm_master_list_entry *mle,
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 83f1a66..5d965e8 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -709,7 +709,7 @@ static struct ctl_table ocfs2_root_table[] = {
 	{ }
 };
 
-static struct ctl_table_header *ocfs2_table_header = NULL;
+static struct ctl_table_header *ocfs2_table_header;
 
 
 /*
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index a7cdd56..9027729 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -75,7 +75,7 @@
 
 #include "buffer_head_io.h"
 
-static struct kmem_cache *ocfs2_inode_cachep = NULL;
+static struct kmem_cache *ocfs2_inode_cachep;
 struct kmem_cache *ocfs2_dquot_cachep;
 struct kmem_cache *ocfs2_qf_chunk_cachep;
 
@@ -85,7 +85,7 @@ struct kmem_cache *ocfs2_qf_chunk_cachep;
  * workqueue and schedule on our own. */
 struct workqueue_struct *ocfs2_wq = NULL;
 
-static struct dentry *ocfs2_debugfs_root = NULL;
+static struct dentry *ocfs2_debugfs_root;
 
 MODULE_AUTHOR("Oracle");
 MODULE_LICENSE("GPL");
diff --git a/fs/ocfs2/uptodate.c b/fs/ocfs2/uptodate.c
index 52eaf33..82e17b0 100644
--- a/fs/ocfs2/uptodate.c
+++ b/fs/ocfs2/uptodate.c
@@ -67,7 +67,7 @@ struct ocfs2_meta_cache_item {
 	sector_t	c_block;
 };
 
-static struct kmem_cache *ocfs2_uptodate_cachep = NULL;
+static struct kmem_cache *ocfs2_uptodate_cachep;
 
 u64 ocfs2_metadata_cache_owner(struct ocfs2_caching_info *ci)
 {
-- 
1.8.4.5


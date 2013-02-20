Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab3BTAWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:22:48 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49143 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab3BTAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:22:46 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk
Subject: [PATCH 01/27] block: Reorder struct bio_set
Date: Tue, 19 Feb 2013 16:22:15 -0800
Message-Id: <1361319761-23873-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is prep work for the next patch, which embeds a struct bio_list in
struct bio_set.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 include/linux/bio.h | 66 ++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 820e7aa..93d3d17 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -298,39 +298,6 @@ static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
 static inline void bio_disassociate_task(struct bio *bio) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
-/*
- * bio_set is used to allow other portions of the IO system to
- * allocate their own private memory pools for bio and iovec structures.
- * These memory pools in turn all allocate from the bio_slab
- * and the bvec_slabs[].
- */
-#define BIO_POOL_SIZE 2
-#define BIOVEC_NR_POOLS 6
-#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
-
-struct bio_set {
-	struct kmem_cache *bio_slab;
-	unsigned int front_pad;
-
-	mempool_t *bio_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t *bio_integrity_pool;
-#endif
-	mempool_t *bvec_pool;
-};
-
-struct biovec_slab {
-	int nr_vecs;
-	char *name;
-	struct kmem_cache *slab;
-};
-
-/*
- * a small number of entries is fine, not going to be performance critical.
- * basically we just need to survive
- */
-#define BIO_SPLIT_ENTRIES 2
-
 #ifdef CONFIG_HIGHMEM
 /*
  * remember never ever reenable interrupts between a bvec_kmap_irq and
@@ -527,6 +494,39 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+/*
+ * bio_set is used to allow other portions of the IO system to
+ * allocate their own private memory pools for bio and iovec structures.
+ * These memory pools in turn all allocate from the bio_slab
+ * and the bvec_slabs[].
+ */
+#define BIO_POOL_SIZE 2
+#define BIOVEC_NR_POOLS 6
+#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
+
+struct bio_set {
+	struct kmem_cache *bio_slab;
+	unsigned int front_pad;
+
+	mempool_t *bio_pool;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_t *bio_integrity_pool;
+#endif
+	mempool_t *bvec_pool;
+};
+
+struct biovec_slab {
+	int nr_vecs;
+	char *name;
+	struct kmem_cache *slab;
+};
+
+/*
+ * a small number of entries is fine, not going to be performance critical.
+ * basically we just need to survive
+ */
+#define BIO_SPLIT_ENTRIES 2
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-- 
1.7.12


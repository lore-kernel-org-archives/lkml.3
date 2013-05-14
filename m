Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3ENBWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:22:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:57435 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3ENBTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:22 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 13/21] block: prep work for batch completion
Date: Mon, 13 May 2013 18:18:50 -0700
Message-Id: <1368494338-7069-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a struct batch_complete * argument to bi_end_io; infrastructure to
make use of it comes in the next patch.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 block/blk-flush.c                   |  3 ++-
 block/blk-lib.c                     |  3 ++-
 drivers/block/drbd/drbd_bitmap.c    |  3 ++-
 drivers/block/drbd/drbd_worker.c    |  9 ++++++---
 drivers/block/drbd/drbd_wrappers.h  |  9 ++++++---
 drivers/block/floppy.c              |  3 ++-
 drivers/block/pktcdvd.c             |  9 ++++++---
 drivers/block/xen-blkback/blkback.c |  3 ++-
 drivers/md/bcache/alloc.c           |  3 ++-
 drivers/md/bcache/btree.c           |  3 ++-
 drivers/md/bcache/debug.c           |  3 ++-
 drivers/md/bcache/io.c              |  6 ++++--
 drivers/md/bcache/journal.c         |  9 ++++++---
 drivers/md/bcache/movinggc.c        |  3 ++-
 drivers/md/bcache/request.c         |  9 ++++++---
 drivers/md/bcache/request.h         |  3 +--
 drivers/md/bcache/super.c           | 11 +++++++----
 drivers/md/bcache/writeback.c       |  8 +++++---
 drivers/md/dm-bufio.c               |  9 +++++----
 drivers/md/dm-cache-target.c        |  3 ++-
 drivers/md/dm-crypt.c               |  3 ++-
 drivers/md/dm-io.c                  |  2 +-
 drivers/md/dm-snap.c                |  3 ++-
 drivers/md/dm-thin.c                |  3 ++-
 drivers/md/dm-verity.c              |  3 ++-
 drivers/md/dm.c                     |  6 ++++--
 drivers/md/faulty.c                 |  3 ++-
 drivers/md/md.c                     |  9 ++++++---
 drivers/md/multipath.c              |  3 ++-
 drivers/md/raid1.c                  | 12 ++++++++----
 drivers/md/raid10.c                 | 18 ++++++++++++------
 drivers/md/raid5.c                  | 15 ++++++++++-----
 drivers/target/target_core_iblock.c |  6 ++++--
 drivers/target/target_core_pscsi.c  |  3 ++-
 fs/bio-integrity.c                  |  3 ++-
 fs/bio.c                            | 17 +++++++++++------
 fs/btrfs/check-integrity.c          | 14 +++++++++-----
 fs/btrfs/compression.c              |  6 ++++--
 fs/btrfs/disk-io.c                  |  6 ++++--
 fs/btrfs/extent_io.c                | 12 ++++++++----
 fs/btrfs/inode.c                    | 13 ++++++++-----
 fs/btrfs/raid56.c                   |  9 ++++++---
 fs/btrfs/scrub.c                    | 18 ++++++++++++------
 fs/btrfs/volumes.c                  |  5 +++--
 fs/buffer.c                         |  3 ++-
 fs/direct-io.c                      |  9 +++------
 fs/ext4/page-io.c                   |  3 ++-
 fs/f2fs/data.c                      |  2 +-
 fs/f2fs/segment.c                   |  3 ++-
 fs/gfs2/lops.c                      |  3 ++-
 fs/gfs2/ops_fstype.c                |  3 ++-
 fs/hfsplus/wrapper.c                |  3 ++-
 fs/jfs/jfs_logmgr.c                 |  4 ++--
 fs/jfs/jfs_metapage.c               |  6 ++++--
 fs/logfs/dev_bdev.c                 |  8 +++++---
 fs/mpage.c                          |  2 +-
 fs/nfs/blocklayout/blocklayout.c    | 17 ++++++++++-------
 fs/nilfs2/segbuf.c                  |  3 ++-
 fs/ocfs2/cluster/heartbeat.c        |  4 ++--
 fs/xfs/xfs_aops.c                   |  3 ++-
 fs/xfs/xfs_buf.c                    |  3 ++-
 include/linux/bio.h                 |  2 +-
 include/linux/blk_types.h           |  3 ++-
 include/linux/fs.h                  |  2 +-
 include/linux/swap.h                |  9 ++++++---
 mm/bounce.c                         | 12 ++++++++----
 mm/page_io.c                        |  8 +++++---
 67 files changed, 267 insertions(+), 152 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index cc2b827..762cfca 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -384,7 +384,8 @@ void blk_abort_flushes(struct request_queue *q)
 	}
 }
 
-static void bio_end_flush(struct bio *bio, int err)
+static void bio_end_flush(struct bio *bio, int err,
+			  struct batch_complete *batch)
 {
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
diff --git a/block/blk-lib.c b/block/blk-lib.c
index d6f50d5..279f9de 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -15,7 +15,8 @@ struct bio_batch {
 	struct completion	*wait;
 };
 
-static void bio_batch_end_io(struct bio *bio, int err)
+static void bio_batch_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	struct bio_batch *bb = bio->bi_private;
 
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 64fbb83..046aa17 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -948,7 +948,8 @@ static void bm_aio_ctx_destroy(struct kref *kref)
 }
 
 /* bv_page may be a copy, or may be the original */
-static void bm_async_io_complete(struct bio *bio, int error)
+static void bm_async_io_complete(struct bio *bio, int error,
+				 struct batch_complete *batch)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_conf *mdev = ctx->mdev;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 891c0ec..04a80af 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -64,7 +64,8 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_io_complete(struct bio *bio, int error)
+void drbd_md_io_complete(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	struct drbd_md_io *md_io;
 	struct drbd_conf *mdev;
@@ -167,7 +168,8 @@ static void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __rel
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error)
+void drbd_peer_request_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -203,7 +205,8 @@ void drbd_peer_request_endio(struct bio *bio, int error)
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_request_endio(struct bio *bio, int error)
+void drbd_request_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index 328f18e..d443dc0 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -20,9 +20,12 @@ static inline void drbd_set_my_capacity(struct drbd_conf *mdev,
 #define drbd_bio_uptodate(bio) bio_flagged(bio, BIO_UPTODATE)
 
 /* bi_end_io handlers */
-extern void drbd_md_io_complete(struct bio *bio, int error);
-extern void drbd_peer_request_endio(struct bio *bio, int error);
-extern void drbd_request_endio(struct bio *bio, int error);
+extern void drbd_md_io_complete(struct bio *bio, int error,
+				struct batch_complete *batch);
+extern void drbd_peer_request_endio(struct bio *bio, int error,
+				    struct batch_complete *batch);
+extern void drbd_request_endio(struct bio *bio, int error,
+			       struct batch_complete *batch);
 
 /*
  * used to submit our private bio
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 04ceb7e..d528753 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3746,7 +3746,8 @@ static unsigned int floppy_check_events(struct gendisk *disk,
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio, int err)
+static void floppy_rb0_complete(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 3c08983..898fa74 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -980,7 +980,8 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
 	}
 }
 
-static void pkt_end_io_read(struct bio *bio, int err)
+static void pkt_end_io_read(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -998,7 +999,8 @@ static void pkt_end_io_read(struct bio *bio, int err)
 	pkt_bio_finished(pd);
 }
 
-static void pkt_end_io_packet_write(struct bio *bio, int err)
+static void pkt_end_io_packet_write(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -2337,7 +2339,8 @@ static void pkt_close(struct gendisk *disk, fmode_t mode)
 }
 
 
-static void pkt_end_io_read_cloned(struct bio *bio, int err)
+static void pkt_end_io_read_cloned(struct bio *bio, int err,
+				   struct batch_complete *batch)
 {
 	struct packet_stacked_data *psd = bio->bi_private;
 	struct pktcdvd_device *pd = psd->pd;
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index dd5b2fe..990c1d8 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -741,7 +741,8 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 /*
  * bio callback.
  */
-static void end_block_io_op(struct bio *bio, int error)
+static void end_block_io_op(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	__end_block_io_op(bio->bi_private, error);
 	bio_put(bio);
diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 048f294..1f75edd 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -156,7 +156,8 @@ static void discard_finish(struct work_struct *w)
 	closure_put(&ca->set->cl);
 }
 
-static void discard_endio(struct bio *bio, int error)
+static void discard_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct discard *d = container_of(bio, struct discard, bio);
 	schedule_work(&d->work);
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 7a5658f..36688d6 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -134,7 +134,8 @@ static uint64_t btree_csum_set(struct btree *b, struct bset *i)
 	return crc ^ 0xffffffffffffffffULL;
 }
 
-static void btree_bio_endio(struct bio *bio, int error)
+static void btree_bio_endio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree *b = container_of(cl, struct btree, io.cl);
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 89fd520..3a32b06 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -177,7 +177,8 @@ void bch_btree_verify(struct btree *b, struct bset *new)
 	mutex_unlock(&b->c->verify_lock);
 }
 
-static void data_verify_endio(struct bio *bio, int error)
+static void data_verify_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 48efd4d..29f344b 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -9,7 +9,8 @@
 #include "bset.h"
 #include "debug.h"
 
-static void bch_bi_idx_hack_endio(struct bio *bio, int error)
+static void bch_bi_idx_hack_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct bio *p = bio->bi_private;
 
@@ -206,7 +207,8 @@ static void bch_bio_submit_split_done(struct closure *cl)
 	mempool_free(s, s->p->bio_split_hook);
 }
 
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
+static void bch_bio_submit_split_endio(struct bio *bio, int error,
+				       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 8c8dfdc..bff194b 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -22,7 +22,8 @@
  * bit.
  */
 
-static void journal_read_endio(struct bio *bio, int error)
+static void journal_read_endio(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -390,7 +391,8 @@ found:
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio, int error)
+static void journal_discard_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct journal_device *ja =
 		container_of(bio, struct journal_device, discard_bio);
@@ -535,7 +537,8 @@ void bch_journal_next(struct journal *j)
 		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
 }
 
-static void journal_write_endio(struct bio *bio, int error)
+static void journal_write_endio(struct bio *bio, int error,
+				struct batch_complete *batch)
 {
 	struct journal_write *w = bio->bi_private;
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 8589512..8bf7ae1 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -61,7 +61,8 @@ static void write_moving_finish(struct closure *cl)
 	closure_return_with_destructor(cl, moving_io_destructor);
 }
 
-static void read_moving_endio(struct bio *bio, int error)
+static void read_moving_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct moving_io *io = container_of(bio->bi_private,
 					    struct moving_io, s.cl);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index e5ff12e..bc837ed 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -456,7 +456,8 @@ static void bch_insert_data_error(struct closure *cl)
 	bch_journal(cl);
 }
 
-static void bch_insert_data_endio(struct bio *bio, int error)
+static void bch_insert_data_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree_op *op = container_of(cl, struct btree_op, cl);
@@ -621,7 +622,8 @@ void bch_btree_insert_async(struct closure *cl)
 
 /* Common code for the make_request functions */
 
-static void request_endio(struct bio *bio, int error)
+static void request_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 
@@ -636,7 +638,8 @@ static void request_endio(struct bio *bio, int error)
 	closure_put(cl);
 }
 
-void bch_cache_read_endio(struct bio *bio, int error)
+void bch_cache_read_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct closure *cl = bio->bi_private;
diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
index 254d9ab..3b79462 100644
--- a/drivers/md/bcache/request.h
+++ b/drivers/md/bcache/request.h
@@ -29,11 +29,10 @@ struct search {
 	struct btree_op		op;
 };
 
-void bch_cache_read_endio(struct bio *, int);
+void bch_cache_read_endio(struct bio *, int, struct batch_complete *batch);
 int bch_get_congested(struct cache_set *);
 void bch_insert_data(struct closure *cl);
 void bch_btree_insert_async(struct closure *);
-void bch_cache_read_endio(struct bio *, int);
 
 void bch_open_buckets_free(struct cache_set *);
 int bch_open_buckets_alloc(struct cache_set *);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c8046bc..76c7f6c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -224,7 +224,8 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -285,7 +286,8 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	closure_return(cl);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
@@ -326,7 +328,7 @@ void bcache_write_super(struct cache_set *c)
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write.cl);
@@ -490,7 +492,8 @@ static struct uuid_entry *uuid_find_empty(struct cache_set *c)
  * disk.
  */
 
-static void prio_endio(struct bio *bio, int error)
+static void prio_endio(struct bio *bio, int error,
+		       struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 93e7e31..daf9347 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -253,7 +253,8 @@ static void write_dirty_finish(struct closure *cl)
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
-static void dirty_endio(struct bio *bio, int error)
+static void dirty_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -281,7 +282,8 @@ static void write_dirty(struct closure *cl)
 	continue_at(cl, write_dirty_finish, dirty_wq);
 }
 
-static void read_dirty_endio(struct bio *bio, int error)
+static void read_dirty_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -289,7 +291,7 @@ static void read_dirty_endio(struct bio *bio, int error)
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
 			    error, "reading dirty data from cache");
 
-	dirty_endio(bio, error);
+	dirty_endio(bio, error, NULL);
 }
 
 static void read_dirty_submit(struct closure *cl)
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 0387e05..d489dfd 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -494,7 +494,7 @@ static void dmio_complete(unsigned long error, void *context)
 {
 	struct dm_buffer *b = context;
 
-	b->bio.bi_end_io(&b->bio, error ? -EIO : 0);
+	b->bio.bi_end_io(&b->bio, error ? -EIO : 0, NULL);
 }
 
 static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
@@ -525,7 +525,7 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 
 	r = dm_io(&io_req, 1, &region, NULL);
 	if (r)
-		end_io(&b->bio, r);
+		end_io(&b->bio, r, NULL);
 }
 
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
@@ -592,7 +592,8 @@ static void submit_io(struct dm_buffer *b, int rw, sector_t block,
  * Set the error, clear B_WRITING bit and wake anyone who was waiting on
  * it.
  */
-static void write_endio(struct bio *bio, int error)
+static void write_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
@@ -965,7 +966,7 @@ found_buffer:
  * The endio routine for reading: set the error, clear the bit and wake up
  * anyone waiting on the buffer.
  */
-static void read_endio(struct bio *bio, int error)
+static void read_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index df44b60..53fb7b2 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -653,7 +653,8 @@ static void defer_writethrough_bio(struct cache *cache, struct bio *bio)
 	wake_worker(cache);
 }
 
-static void writethrough_endio(struct bio *bio, int err)
+static void writethrough_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 	bio->bi_end_io = pb->saved_bi_end_io;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6d2d41a..ec0e3c0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -929,7 +929,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
  * The work is done per CPU global for all dm-crypt instances.
  * They should not depend on each other and do not block.
  */
-static void crypt_endio(struct bio *clone, int error)
+static void crypt_endio(struct bio *clone, int error,
+			struct batch_complete *batch)
 {
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->cc;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index ea49834..a727b26 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -136,7 +136,7 @@ static void dec_count(struct io *io, unsigned int region, int error)
 	}
 }
 
-static void endio(struct bio *bio, int error)
+static void endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct io *io;
 	unsigned region;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c434e5a..fb3ea3c 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1486,7 +1486,8 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, copy_callback, pe);
 }
 
-static void full_bio_end_io(struct bio *bio, int error)
+static void full_bio_end_io(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	void *callback_data = bio->bi_private;
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 759cffc..0390a03 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -553,7 +553,8 @@ static void copy_complete(int read_err, unsigned long write_err, void *context)
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
-static void overwrite_endio(struct bio *bio, int err)
+static void overwrite_endio(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	unsigned long flags;
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index b948fd8..b373bb7 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -413,7 +413,8 @@ static void verity_work(struct work_struct *w)
 	verity_finish_io(io, verity_verify_io(io));
 }
 
-static void verity_end_io(struct bio *bio, int error)
+static void verity_end_io(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d5370a9..9101124 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -615,7 +615,8 @@ static void dec_pending(struct dm_io *io, int error)
 	}
 }
 
-static void clone_endio(struct bio *bio, int error)
+static void clone_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
@@ -650,7 +651,8 @@ static void clone_endio(struct bio *bio, int error)
 /*
  * Partial completion handling for request-based dm
  */
-static void end_clone_bio(struct bio *clone, int error)
+static void end_clone_bio(struct bio *clone, int error,
+			  struct batch_complete *batch)
 {
 	struct dm_rq_clone_bio_info *info = clone->bi_private;
 	struct dm_rq_target_io *tio = info->tio;
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 3193aef..ac8af52 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -70,7 +70,8 @@
 #include <linux/seq_file.h>
 
 
-static void faulty_fail(struct bio *bio, int error)
+static void faulty_fail(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct bio *b = bio->bi_private;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 681d109..9a02686 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -379,7 +379,8 @@ EXPORT_SYMBOL(mddev_congested);
  * Generic flush handling for md
  */
 
-static void md_end_flush(struct bio *bio, int err)
+static void md_end_flush(struct bio *bio, int err,
+			 struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -756,7 +757,8 @@ void md_rdev_clear(struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(md_rdev_clear);
 
-static void super_written(struct bio *bio, int error)
+static void super_written(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -807,7 +809,8 @@ void md_super_wait(struct mddev *mddev)
 	finish_wait(&mddev->sb_wait, &wq);
 }
 
-static void bi_complete(struct bio *bio, int error)
+static void bi_complete(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	complete((struct completion*)bio->bi_private);
 }
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 1642eae..fecad70 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -83,7 +83,8 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
 	mempool_free(mp_bh, conf->pool);
 }
 
-static void multipath_end_request(struct bio *bio, int error)
+static void multipath_end_request(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh *mp_bh = bio->bi_private;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5595118..d55d0d9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -294,7 +294,8 @@ static int find_bio_disk(struct r1bio *r1_bio, struct bio *bio)
 	return mirror;
 }
 
-static void raid1_end_read_request(struct bio *bio, int error)
+static void raid1_end_read_request(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -379,7 +380,8 @@ static void r1_bio_write_done(struct r1bio *r1_bio)
 	}
 }
 
-static void raid1_end_write_request(struct bio *bio, int error)
+static void raid1_end_write_request(struct bio *bio, int error,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
@@ -1612,7 +1614,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r1bio *r1_bio = bio->bi_private;
 
@@ -1630,7 +1633,8 @@ static void end_sync_read(struct bio *bio, int error)
 		reschedule_retry(r1_bio);
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 59d4daa..6c63406 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -101,7 +101,8 @@ static int enough(struct r10conf *conf, int ignore);
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 				int *skipped);
 static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
-static void end_reshape_write(struct bio *bio, int error);
+static void end_reshape_write(struct bio *bio, int error,
+			      struct batch_complete *batch);
 static void end_reshape(struct r10conf *conf);
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
@@ -358,7 +359,8 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 	return r10_bio->devs[slot].devnum;
 }
 
-static void raid10_end_read_request(struct bio *bio, int error)
+static void raid10_end_read_request(struct bio *bio, int error,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -441,7 +443,8 @@ static void one_write_done(struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_end_write_request(struct bio *bio, int error)
+static void raid10_end_write_request(struct bio *bio, int error,
+				     struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -1912,7 +1915,8 @@ abort:
 }
 
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct r10bio *r10_bio = bio->bi_private;
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -1973,7 +1977,8 @@ static void end_sync_request(struct r10bio *r10_bio)
 	}
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
@@ -4598,7 +4603,8 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	return 0;
 }
 
-static void end_reshape_write(struct bio *bio, int error)
+static void end_reshape_write(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9359828..d014b66 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -532,9 +532,11 @@ static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
 }
 
 static void
-raid5_end_read_request(struct bio *bi, int error);
+raid5_end_read_request(struct bio *bi, int error,
+		       struct batch_complete *batch);
 static void
-raid5_end_write_request(struct bio *bi, int error);
+raid5_end_write_request(struct bio *bi, int error,
+			struct batch_complete *batch);
 
 static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 {
@@ -1713,7 +1715,8 @@ static void shrink_stripes(struct r5conf *conf)
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error)
+static void raid5_end_read_request(struct bio *bi, int error,
+				   struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -1833,7 +1836,8 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	release_stripe(sh);
 }
 
-static void raid5_end_write_request(struct bio *bi, int error)
+static void raid5_end_write_request(struct bio *bi, int error,
+				    struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
@@ -3904,7 +3908,8 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
  *  first).
  *  If the read failed..
  */
-static void raid5_align_endio(struct bio *bi, int error)
+static void raid5_align_endio(struct bio *bi, int error,
+			      struct batch_complete *batch)
 {
 	struct bio* raid_bi  = bi->bi_private;
 	struct mddev *mddev;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 07f5f94..4e842cb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -271,7 +271,8 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	kfree(ibr);
 }
 
-static void iblock_bio_done(struct bio *bio, int err)
+static void iblock_bio_done(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
@@ -335,7 +336,8 @@ static void iblock_submit_bios(struct bio_list *list, int rw)
 	blk_finish_plug(&plug);
 }
 
-static void iblock_end_io_flush(struct bio *bio, int err)
+static void iblock_end_io_flush(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct se_cmd *cmd = bio->bi_private;
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e992b27..1e98731 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -835,7 +835,8 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
 	return bl;
 }
 
-static void pscsi_bi_endio(struct bio *bio, int error)
+static void pscsi_bi_endio(struct bio *bio, int error,
+			   struct batch_complete *batch)
 {
 	bio_put(bio);
 }
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8fb4291..69f6f80 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -510,7 +510,8 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  * in process context.	This function postpones completion
  * accordingly.
  */
-void bio_integrity_endio(struct bio *bio, int error)
+void bio_integrity_endio(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
diff --git a/fs/bio.c b/fs/bio.c
index 94bbc04..e082907 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -760,7 +760,8 @@ struct submit_bio_ret {
 	int error;
 };
 
-static void submit_bio_wait_endio(struct bio *bio, int error)
+static void submit_bio_wait_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct submit_bio_ret *ret = bio->bi_private;
 
@@ -1414,7 +1415,8 @@ void bio_unmap_user(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_unmap_user);
 
-static void bio_map_kern_endio(struct bio *bio, int err)
+static void bio_map_kern_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	bio_put(bio);
 }
@@ -1486,7 +1488,8 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 }
 EXPORT_SYMBOL(bio_map_kern);
 
-static void bio_copy_kern_endio(struct bio *bio, int err)
+static void bio_copy_kern_endio(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct bio_vec *bvec;
 	const int read = bio_data_dir(bio) == READ;
@@ -1707,7 +1710,7 @@ void bio_endio(struct bio *bio, int error)
 		error = -EIO;
 
 	if (bio->bi_end_io)
-		bio->bi_end_io(bio, error);
+		bio->bi_end_io(bio, error, NULL);
 }
 EXPORT_SYMBOL(bio_endio);
 
@@ -1722,7 +1725,8 @@ void bio_pair_release(struct bio_pair *bp)
 }
 EXPORT_SYMBOL(bio_pair_release);
 
-static void bio_pair_end_1(struct bio *bi, int err)
+static void bio_pair_end_1(struct bio *bi, int err,
+			   struct batch_complete *batch)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
 
@@ -1732,7 +1736,8 @@ static void bio_pair_end_1(struct bio *bi, int err)
 	bio_pair_release(bp);
 }
 
-static void bio_pair_end_2(struct bio *bi, int err)
+static void bio_pair_end_2(struct bio *bi, int err,
+			   struct batch_complete *batch)
 {
 	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
 
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 18af6f4..3c617b3 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -323,7 +323,8 @@ static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx);
 static int btrfsic_read_block(struct btrfsic_state *state,
 			      struct btrfsic_block_data_ctx *block_ctx);
 static void btrfsic_dump_database(struct btrfsic_state *state);
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err);
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err,
+					struct batch_complete *batch);
 static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 				     char **datav, unsigned int num_pages);
 static void btrfsic_process_written_block(struct btrfsic_dev_state *dev_state,
@@ -336,7 +337,8 @@ static int btrfsic_process_written_superblock(
 		struct btrfsic_state *state,
 		struct btrfsic_block *const block,
 		struct btrfs_super_block *const super_hdr);
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status);
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status,
+			       struct batch_complete *batch);
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate);
 static int btrfsic_is_block_ref_by_superblock(const struct btrfsic_state *state,
 					      const struct btrfsic_block *block,
@@ -1751,7 +1753,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 	return block_ctx->len;
 }
 
-static void btrfsic_complete_bio_end_io(struct bio *bio, int err)
+static void btrfsic_complete_bio_end_io(struct bio *bio, int err,
+					struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -2294,7 +2297,8 @@ continue_loop:
 	goto again;
 }
 
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
+static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status,
+			       struct batch_complete *batch)
 {
 	struct btrfsic_block *block = (struct btrfsic_block *)bp->bi_private;
 	int iodone_w_error;
@@ -2342,7 +2346,7 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 		block = next_block;
 	} while (NULL != block);
 
-	bp->bi_end_io(bp, bio_error_status);
+	bp->bi_end_io(bp, bio_error_status, batch);
 }
 
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b189bd1..2298567 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -156,7 +156,8 @@ fail:
  * The compressed pages are freed here, and it must be run
  * in process context
  */
-static void end_compressed_bio_read(struct bio *bio, int err)
+static void end_compressed_bio_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
@@ -266,7 +267,8 @@ static noinline void end_compressed_writeback(struct inode *inode, u64 start,
  * This also calls the writeback end hooks for the file pages so that
  * metadata and checksums can be updated in the file.
  */
-static void end_compressed_bio_write(struct bio *bio, int err)
+static void end_compressed_bio_write(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4e9ebe1..4166099 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -685,7 +685,8 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	return -EIO;	/* we fixed nothing */
 }
 
-static void end_workqueue_bio(struct bio *bio, int err)
+static void end_workqueue_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
@@ -3072,7 +3073,8 @@ static int write_dev_supers(struct btrfs_device *device,
  * endio for the write_dev_flush, this will wake anyone waiting
  * for the barrier when it is done
  */
-static void btrfs_end_empty_barrier(struct bio *bio, int err)
+static void btrfs_end_empty_barrier(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	if (err) {
 		if (err == -EOPNOTSUPP)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 32d67a8..84d8b4d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2012,7 +2012,8 @@ static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
 	return err;
 }
 
-static void repair_io_failure_callback(struct bio *bio, int err)
+static void repair_io_failure_callback(struct bio *bio, int err,
+				       struct batch_complete *batch)
 {
 	complete(bio->bi_private);
 }
@@ -2392,7 +2393,8 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+static void end_bio_extent_writepage(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
@@ -2438,7 +2440,8 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_readpage(struct bio *bio, int err)
+static void end_bio_extent_readpage(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -3262,7 +3265,8 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
 }
 
-static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
+static void end_bio_extent_buffer_writepage(struct bio *bio, int err,
+					    struct batch_complete *batch)
 {
 	int uptodate = err == 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b31b3b..551c8bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6931,7 +6931,8 @@ struct btrfs_dio_private {
 	struct bio *orig_bio;
 };
 
-static void btrfs_endio_direct_read(struct bio *bio, int err)
+static void btrfs_endio_direct_read(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -6984,10 +6985,11 @@ failed:
 	/* If we had a csum failure make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	dio_end_io(bio, err);
+	dio_end_io(bio, err, batch);
 }
 
-static void btrfs_endio_direct_write(struct bio *bio, int err)
+static void btrfs_endio_direct_write(struct bio *bio, int err,
+				     struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
@@ -7029,7 +7031,7 @@ out_done:
 	/* If we had an error make sure to clear the uptodate flag */
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	dio_end_io(bio, err);
+	dio_end_io(bio, err, batch);
 }
 
 static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
@@ -7043,7 +7045,8 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 	return 0;
 }
 
-static void btrfs_end_dio_bio(struct bio *bio, int err)
+static void btrfs_end_dio_bio(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0740621..6927575 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -850,7 +850,8 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_end_io(struct bio *bio, int err)
+static void raid_write_end_io(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1384,7 +1385,8 @@ static void set_bio_pages_uptodate(struct bio *bio)
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid_rmw_end_io(struct bio *bio, int err)
+static void raid_rmw_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1905,7 +1907,8 @@ cleanup_io:
  * This is called only for stripes we've read from disk to
  * reconstruct the parity.
  */
-static void raid_recover_end_io(struct bio *bio, int err)
+static void raid_recover_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f489e24..ac4a48f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -200,7 +200,8 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 					 int is_metadata, int have_csum,
 					 const u8 *csum, u64 generation,
 					 u16 csum_size);
-static void scrub_complete_bio_end_io(struct bio *bio, int err);
+static void scrub_complete_bio_end_io(struct bio *bio, int err,
+				      struct batch_complete *batch);
 static int scrub_repair_block_from_good_copy(struct scrub_block *sblock_bad,
 					     struct scrub_block *sblock_good,
 					     int force_write);
@@ -223,7 +224,8 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, struct btrfs_device *dev, u64 flags,
 		       u64 gen, int mirror_num, u8 *csum, int force,
 		       u64 physical_for_dev_replace);
-static void scrub_bio_end_io(struct bio *bio, int err);
+static void scrub_bio_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch);
 static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
@@ -240,7 +242,8 @@ static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
-static void scrub_wr_bio_end_io(struct bio *bio, int err);
+static void scrub_wr_bio_end_io(struct bio *bio, int err,
+				struct batch_complete *batch);
 static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
@@ -1384,7 +1387,8 @@ static void scrub_recheck_block_checksum(struct btrfs_fs_info *fs_info,
 		sblock->checksum_error = 1;
 }
 
-static void scrub_complete_bio_end_io(struct bio *bio, int err)
+static void scrub_complete_bio_end_io(struct bio *bio, int err,
+				      struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -1584,7 +1588,8 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 	btrfsic_submit_bio(WRITE, sbio->bio);
 }
 
-static void scrub_wr_bio_end_io(struct bio *bio, int err)
+static void scrub_wr_bio_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
@@ -2053,7 +2058,8 @@ leave_nomem:
 	return 0;
 }
 
-static void scrub_bio_end_io(struct bio *bio, int err)
+static void scrub_bio_end_io(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e925ce..7299b55 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5044,7 +5044,8 @@ static unsigned int extract_stripe_index_from_bio_private(void *bi_private)
 	return (unsigned int)((uintptr_t)bi_private) & 3;
 }
 
-static void btrfs_end_bio(struct bio *bio, int err)
+static void btrfs_end_bio(struct bio *bio, int err,
+			  struct batch_complete *batch)
 {
 	struct btrfs_bio *bbio = extract_bbio_from_bio_private(bio->bi_private);
 	int is_orig_bio = 0;
@@ -5101,7 +5102,7 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		}
 		kfree(bbio);
 
-		bio_endio(bio, err);
+		bio_endio_batch(bio, err, batch);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
diff --git a/fs/buffer.c b/fs/buffer.c
index d2a4d1b..c410422 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2882,7 +2882,8 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 }
 EXPORT_SYMBOL(generic_block_bmap);
 
-static void end_bio_bh_io_sync(struct bio *bio, int err)
+static void end_bio_bh_io_sync(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct buffer_head *bh = bio->bi_private;
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7ab90f5..331fd5c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -324,12 +324,12 @@ static void dio_bio_end_io(struct bio *bio, int error)
  * so that the DIO specific endio actions are dealt with after the filesystem
  * has done it's completion work.
  */
-void dio_end_io(struct bio *bio, int error)
+void dio_end_io(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct dio *dio = bio->bi_private;
 
 	if (dio->is_async)
-		dio_bio_end_aio(bio, error);
+		dio_bio_end_aio(bio, error, batch);
 	else
 		dio_bio_end_io(bio, error);
 }
@@ -350,10 +350,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
-	if (dio->is_async)
-		bio->bi_end_io = dio_bio_end_aio;
-	else
-		bio->bi_end_io = dio_bio_end_io;
+	bio->bi_end_io = dio_end_io;
 
 	sdio->bio = bio;
 	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 19599bd..0f56709 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -258,7 +258,8 @@ static void buffer_io_error(struct buffer_head *bh)
 			(unsigned long long)bh->b_blocknr);
 }
 
-static void ext4_end_bio(struct bio *bio, int error)
+static void ext4_end_bio(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
 	struct inode *inode;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 91ff93b..454fca9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -330,7 +330,7 @@ repeat:
 	return page;
 }
 
-static void read_end_io(struct bio *bio, int err)
+static void read_end_io(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d8e84e4..e36793c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -633,7 +633,8 @@ static const struct segment_allocation default_salloc_ops = {
 	.allocate_segment = allocate_segment_by_default,
 };
 
-static void f2fs_end_io_write(struct bio *bio, int err)
+static void f2fs_end_io_write(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index c5fa758..91a5ebb 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -200,7 +200,8 @@ static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct bio_vec *bvec,
  *
  */
 
-static void gfs2_end_log_write(struct bio *bio, int error)
+static void gfs2_end_log_write(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct gfs2_sbd *sdp = bio->bi_private;
 	struct bio_vec *bvec;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 60ede2a..86eb657 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -155,7 +155,8 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 	return -EINVAL;
 }
 
-static void end_bio_io_page(struct bio *bio, int error)
+static void end_bio_io_page(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index b51a607..96375a5 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -24,7 +24,8 @@ struct hfsplus_wd {
 	u16 embed_count;
 };
 
-static void hfsplus_end_io_sync(struct bio *bio, int err)
+static void hfsplus_end_io_sync(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	if (err)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index c57499d..b02926c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2153,7 +2153,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_size = 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio, 0, NULL);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
@@ -2191,7 +2191,7 @@ static int lbmIOWait(struct lbuf * bp, int flag)
  *
  * executed at INTIODONE level
  */
-static void lbmIODone(struct bio *bio, int error)
+static void lbmIODone(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct lbuf *bp = bio->bi_private;
 	struct lbuf *nextbp, *tail;
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 6740d34..6ba6757 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -283,7 +283,8 @@ static void last_read_complete(struct page *page)
 	unlock_page(page);
 }
 
-static void metapage_read_end_io(struct bio *bio, int err)
+static void metapage_read_end_io(struct bio *bio, int err,
+				 struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
@@ -338,7 +339,8 @@ static void last_write_complete(struct page *page)
 	end_page_writeback(page);
 }
 
-static void metapage_write_end_io(struct bio *bio, int err)
+static void metapage_write_end_io(struct bio *bio, int err,
+				  struct batch_complete *batch)
 {
 	struct page *page = bio->bi_private;
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 550475c..0ae2254 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -14,7 +14,8 @@
 
 #define PAGE_OFS(ofs) ((ofs) & (PAGE_SIZE-1))
 
-static void request_complete(struct bio *bio, int err)
+static void request_complete(struct bio *bio, int err,
+			     struct batch_complete *batch)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -64,7 +65,8 @@ static int bdev_readpage(void *_sb, struct page *page)
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
-static void writeseg_end_io(struct bio *bio, int err)
+static void writeseg_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -168,7 +170,7 @@ static void bdev_writeseg(struct super_block *sb, u64 ofs, size_t len)
 }
 
 
-static void erase_end_io(struct bio *bio, int err) 
+static void erase_end_io(struct bio *bio, int err, struct batch_complete *batch)
 { 
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags); 
 	struct super_block *sb = bio->bi_private; 
diff --git a/fs/mpage.c b/fs/mpage.c
index 0face1c..a4089bb 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -41,7 +41,7 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 434b93e..76cf695 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -143,7 +143,7 @@ bl_submit_bio(int rw, struct bio *bio)
 
 static struct bio *bl_alloc_init_bio(int npg, sector_t isect,
 				     struct pnfs_block_extent *be,
-				     void (*end_io)(struct bio *, int err),
+				     bio_end_io_t *end_io,
 				     struct parallel_io *par)
 {
 	struct bio *bio;
@@ -167,7 +167,7 @@ static struct bio *bl_alloc_init_bio(int npg, sector_t isect,
 static struct bio *do_add_page_to_bio(struct bio *bio, int npg, int rw,
 				      sector_t isect, struct page *page,
 				      struct pnfs_block_extent *be,
-				      void (*end_io)(struct bio *, int err),
+				      bio_end_io_t *end_io,
 				      struct parallel_io *par,
 				      unsigned int offset, int len)
 {
@@ -190,7 +190,7 @@ retry:
 static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
 				      sector_t isect, struct page *page,
 				      struct pnfs_block_extent *be,
-				      void (*end_io)(struct bio *, int err),
+				      bio_end_io_t *end_io,
 				      struct parallel_io *par)
 {
 	return do_add_page_to_bio(bio, npg, rw, isect, page, be,
@@ -198,7 +198,8 @@ static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
 }
 
 /* This is basically copied from mpage_end_io_read */
-static void bl_end_io_read(struct bio *bio, int err)
+static void bl_end_io_read(struct bio *bio, int err,
+			   struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -380,7 +381,8 @@ static void mark_extents_written(struct pnfs_block_layout *bl,
 	}
 }
 
-static void bl_end_io_write_zero(struct bio *bio, int err)
+static void bl_end_io_write_zero(struct bio *bio, int err,
+				 struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -408,7 +410,8 @@ static void bl_end_io_write_zero(struct bio *bio, int err)
 	put_parallel(par);
 }
 
-static void bl_end_io_write(struct bio *bio, int err)
+static void bl_end_io_write(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct parallel_io *par = bio->bi_private;
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -487,7 +490,7 @@ map_block(struct buffer_head *bh, sector_t isect, struct pnfs_block_extent *be)
 }
 
 static void
-bl_read_single_end_io(struct bio *bio, int error)
+bl_read_single_end_io(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct page *page = bvec->bv_page;
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index dc9a913..680b65b 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -338,7 +338,8 @@ void nilfs_add_checksums_on_logs(struct list_head *logs, u32 seed)
 /*
  * BIO operations
  */
-static void nilfs_end_bio_write(struct bio *bio, int err)
+static void nilfs_end_bio_write(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct nilfs_segment_buffer *segbuf = bio->bi_private;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 42252bf..73ed9d6 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -380,8 +380,8 @@ static void o2hb_wait_on_io(struct o2hb_region *reg,
 	wait_for_completion(&wc->wc_io_complete);
 }
 
-static void o2hb_bio_end_io(struct bio *bio,
-			   int error)
+static void o2hb_bio_end_io(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2b2691b..f64ee71 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -380,7 +380,8 @@ xfs_imap_valid(
 STATIC void
 xfs_end_bio(
 	struct bio		*bio,
-	int			error)
+	int			error,
+	struct batch_complete *batch)
 {
 	xfs_ioend_t		*ioend = bio->bi_private;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 82b70bd..cee0e42 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1224,7 +1224,8 @@ _xfs_buf_ioend(
 STATIC void
 xfs_buf_bio_end_io(
 	struct bio		*bio,
-	int			error)
+	int			error,
+	struct batch_complete *batch)
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ef24466..7f3089f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -580,7 +580,7 @@ extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
+extern void bio_integrity_endio(struct bio *, int, struct batch_complete *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fa1abeb..b3195e3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -16,7 +16,8 @@ struct page;
 struct block_device;
 struct io_context;
 struct cgroup_subsys_state;
-typedef void (bio_end_io_t) (struct bio *, int);
+struct batch_complete;
+typedef void (bio_end_io_t) (struct bio *, int, struct batch_complete *);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 43db02e..0a9a6766 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2453,7 +2453,7 @@ enum {
 	DIO_SKIP_HOLES	= 0x02,
 };
 
-void dio_end_io(struct bio *bio, int error);
+void dio_end_io(struct bio *bio, int error, struct batch_complete *batch);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1701ce4..ca031f7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -330,11 +330,14 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_write(struct bio *bio, int err);
+extern void end_swap_bio_write(struct bio *bio, int err,
+			       struct batch_complete *batch);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int));
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch));
 extern int swap_set_page_dirty(struct page *page);
-extern void end_swap_bio_read(struct bio *bio, int err);
+extern void end_swap_bio_read(struct bio *bio, int err,
+			      struct batch_complete *batch);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
diff --git a/mm/bounce.c b/mm/bounce.c
index c9f0a43..708c1e9 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -147,12 +147,14 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 	bio_put(bio);
 }
 
-static void bounce_end_io_write(struct bio *bio, int err)
+static void bounce_end_io_write(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	bounce_end_io(bio, page_pool, err);
 }
 
-static void bounce_end_io_write_isa(struct bio *bio, int err)
+static void bounce_end_io_write_isa(struct bio *bio, int err,
+				    struct batch_complete *batch)
 {
 
 	bounce_end_io(bio, isa_page_pool, err);
@@ -168,12 +170,14 @@ static void __bounce_end_io_read(struct bio *bio, mempool_t *pool, int err)
 	bounce_end_io(bio, pool, err);
 }
 
-static void bounce_end_io_read(struct bio *bio, int err)
+static void bounce_end_io_read(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	__bounce_end_io_read(bio, page_pool, err);
 }
 
-static void bounce_end_io_read_isa(struct bio *bio, int err)
+static void bounce_end_io_read_isa(struct bio *bio, int err,
+				   struct batch_complete *batch)
 {
 	__bounce_end_io_read(bio, isa_page_pool, err);
 }
diff --git a/mm/page_io.c b/mm/page_io.c
index 3db0f5f..e39237d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -42,7 +42,8 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 	return bio;
 }
 
-void end_swap_bio_write(struct bio *bio, int err)
+void end_swap_bio_write(struct bio *bio, int err,
+			struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -68,7 +69,7 @@ void end_swap_bio_write(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-void end_swap_bio_read(struct bio *bio, int err)
+void end_swap_bio_read(struct bio *bio, int err, struct batch_complete *batch)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
@@ -203,7 +204,8 @@ out:
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int))
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch))
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
-- 
1.8.2.1


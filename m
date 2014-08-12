Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaHLVJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:09:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29267 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbaHLVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:09:07 -0400
Date: Tue, 12 Aug 2014 15:09:06 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block drivers bits for 3.17-rc1
Message-ID: <20140812210906.GB2294@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-12_07:2014-08-12,2014-08-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.12577208666309e-09 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=11
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408120218
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On top of the core pull request, here's the block driver pull request
for 3.17-rc1. Nothing out of the ordinary here, this pull request
contains:

- A big round of fixes for bcache from Kent Overstreet, Slava Pestov,
  and Surbhi Palande. No new features, just a lot of fixes.

- The usual round of drbd updates from Andreas Gruenbacher, Lars
  Ellenberg, and Philipp Reisner.

- virtio_blk was converted to blk-mq back in 3.13, but now Ming Lei has
  taken it one step further and added support for actually using more
  than one queue.

- Addition of an explicit SG_FLAG_Q_AT_HEAD for block/bsg, to compliment
  the the default behavior of adding to the tail of the queue. From
  Douglas Gilbert.


  git://git.kernel.dk/linux-block.git for-3.17/drivers

Please pull!


----------------------------------------------------------------

Andreas Gruenbacher (1):
      drbd: Remove unnecessary/unused code

Dan Carpenter (1):
      drbd: silence underflow warning in read_in_block()

Douglas Gilbert (1):
      block SG_IO: add SG_FLAG_Q_AT_HEAD flag

Jens Axboe (1):
      Merge branch 'for-jens' of http://evilpiepirate.org/git/linux-bcache into for-3.17/drivers

Jianjian Huo (1):
      bcache: add mutex lock for bch_is_open

Joe Perches (1):
      block: Convert last uses of __FUNCTION__ to __func__

Kent Overstreet (7):
      bcache: Fix a bug when detaching
      bcache: Fix a journal replay bug
      bcache: Make sure to pass GFP_WAIT to mempool_alloc()
      bcache: Allocate bounce buffers with GFP_NOWAIT
      bcache: Fix an infinite loop in journal replay
      bcache: Fix more early shutdown bugs
      bcache: Drop unneeded blk_sync_queue() calls

Lars Ellenberg (52):
      drbd: reduce number of spinlock drop/re-aquire cycles
      drbd: refactor use of first_peer_device()
      drbd: allow write-ordering policy to be bumped up again
      drbd: get rid of atomic update on disk bitmap works
      drbd: fix a race stopping the worker thread
      drbd: fix resync finished detection
      drbd: stop the meta data sync timer before open coded meta data sync
      drbd: re-add lost conf_mutex protection in drbd_set_role
      drbd: trigger tcp_push_pending_frames() for PING and PING_ACK
      drbd: move set_disk_ro() to after we persisted the new role
      drbd: explicitly submit meta data requests with REQ_NOIDLE
      drbd: close race when detaching from disk
      drbd: make sure disk cleanup happens in worker context
      drbd: use drbd_device_post_work() in more places
      drbd: get rid of drbd_queue_work_front
      drbd: drop wrong debugging aid
      drbd: silence -Wmissing-prototypes warnings
      drbd: fix bogus resync stats in /proc/drbd
      drbd: don't implicitly resize Diskless node beyond end of device
      drbd: implement csums-after-crash-only
      drbd: application writes may set-in-sync in protocol != C
      drbd: short-circuit in maybe_pull_ahead
      drbd: improve resync request throttling due to sendbuf size
      drbd: clear CRASHED_PRIMARY only after successful resync
      drbd: cosmetic: change all printk(level, ...) to pr_<level>(...)
      drbd: drbd_rs_number_requests: fix unit mismatch in comparison
      drbd: add drbd_queue_work_if_unqueued helper
      drbd: drop drbd_md_flush
      drbd: consistently use list_add_tail for peer_request tracking
      drbd: also keep track of trim -> zero-out fallback peer_requests
      drbd: poison free'd device, resource and connection structs
      drbd: fix drbd_destroy_device reference count updates
      drbd: track meta data IO intent, start and submit time
      drbd: gather detailed timing statistics for drbd_requests
      drbd: add lists to find oldest pending requests
      drbd: add caching oldest request pointers for replication stages
      drbd: improve throttling decisions of background resynchronisation
      drbd: track timing details of peer_requests
      drbd: register peer requests on read_ee early
      drbd: track details of bitmap IO
      drbd: debugfs: add basic hierarchy
      drbd: debugfs: add in_flight_summary data
      drbd: debugfs: deal with destructor racing with open of debugfs file
      drbd: debugfs: Add in_flight_summary
      drbd: debugfs: add callback_history
      drbd: debugfs: add per volume oldest_requests
      drbd: debugfs: add version tag to debugfs files
      drbd: debugfs: add per connection oldest requests
      drbd: debugfs: add per device data_gen_id
      drbd: resync should only lock out specific ranges
      drbd: drop spurious parameters from _drbd_md_sync_page_io
      drbd: implicitly truncate cpu-mask

Ming Lei (2):
      include/uapi/linux/virtio_blk.h: introduce feature of VIRTIO_BLK_F_MQ
      block: virtio-blk: support multi virt queues per virtio-blk device

Monam Agarwal (1):
      drivers/block: Use RCU_INIT_POINTER(x, NULL) in drbd/drbd_state.c

Philipp Reisner (5):
      drbd: Move write_ordering from connection to resource
      drbd: device->ldev is not guaranteed on an D_ATTACHING disk
      drbd: rename drbd_free_bc() to drbd_free_ldev()
      drbd: Limit the time we are waiting for the first packet on an accepted socket
      drbd: New net configuration option socket-check-timeout

Slava Pestov (12):
      bcache allocator: send discards with correct size
      bcache: fix lockdep warnings on shutdown
      bcache: fix crash on shutdown in passthrough mode
      bcache: wait for buckets when allocating new btree root
      bcache: fix uninterruptible sleep in writeback thread
      bcache: fix typo in bch_bkey_equal_header
      bcache: bcache_write tracepoint was crashing
      bcache: fix crash in bcache_btree_node_alloc_fail tracepoint
      bcache: fix use-after-free in btree_gc_coalesce()
      bcache: fix crash with incomplete cache set
      bcache: fix memory corruption in init error path
      bcache: try to set b->parent properly

Surbhi Palande (2):
      bcache: Fix to remove the rcu_sched stalls.
      bcache: Correct printing of btree_gc_max_duration_ms

 block/scsi_ioctl.c                 |   5 +-
 drivers/block/drbd/Makefile        |   1 +
 drivers/block/drbd/drbd_actlog.c   | 518 ++++++++------------
 drivers/block/drbd/drbd_bitmap.c   | 150 ++----
 drivers/block/drbd/drbd_debugfs.c  | 958 +++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_debugfs.h  |  39 ++
 drivers/block/drbd/drbd_int.h      | 383 ++++++++++-----
 drivers/block/drbd/drbd_interval.h |   4 +-
 drivers/block/drbd/drbd_main.c     | 302 +++++-------
 drivers/block/drbd/drbd_nl.c       | 110 +++--
 drivers/block/drbd/drbd_proc.c     | 125 +++--
 drivers/block/drbd/drbd_receiver.c | 316 ++++++++----
 drivers/block/drbd/drbd_req.c      | 527 +++++++++++++-------
 drivers/block/drbd/drbd_req.h      |   1 +
 drivers/block/drbd/drbd_state.c    |  90 ++--
 drivers/block/drbd/drbd_worker.c   | 348 +++++++++++---
 drivers/block/virtio_blk.c         | 104 +++-
 drivers/md/bcache/alloc.c          |   2 +-
 drivers/md/bcache/bcache.h         |   4 +
 drivers/md/bcache/bset.c           |   2 +-
 drivers/md/bcache/bset.h           |   2 +-
 drivers/md/bcache/btree.c          |  50 +-
 drivers/md/bcache/btree.h          |   5 +-
 drivers/md/bcache/extents.c        |  13 +-
 drivers/md/bcache/extents.h        |   1 +
 drivers/md/bcache/journal.c        |  24 +-
 drivers/md/bcache/request.c        |   3 +-
 drivers/md/bcache/super.c          |  57 ++-
 drivers/md/bcache/util.h           |   4 +-
 drivers/md/bcache/writeback.c      |  14 +-
 drivers/md/bcache/writeback.h      |   3 +-
 include/linux/drbd.h               |   4 +-
 include/linux/drbd_genl.h          |   4 +
 include/linux/drbd_limits.h        |   6 +
 include/scsi/sg.h                  |   3 +
 include/trace/events/bcache.h      |  21 +-
 include/uapi/linux/bsg.h           |  11 +-
 include/uapi/linux/virtio_blk.h    |   5 +
 lib/lru_cache.c                    |  23 +-
 39 files changed, 2932 insertions(+), 1310 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_debugfs.c
 create mode 100644 drivers/block/drbd/drbd_debugfs.h

-- 
Jens Axboe


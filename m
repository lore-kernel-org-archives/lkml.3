Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaGJQsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:48:01 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:51299 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGJQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:48:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD updates for your for-3.17/drivers branch
Date: Thu, 10 Jul 2014 18:47:56 +0200
Message-ID: <1620384.qJGGe2kQsK@fat-tyre>
User-Agent: KMail/4.13.2 (Linux/3.13.0-24-lowlatency; KDE/4.13.2; x86_64; ; )
In-Reply-To: <14195494.KgRksUidBS@fat-tyre>
References: <14195494.KgRksUidBS@fat-tyre>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

shame on me. The previous pull request had a mistake in commit 
7 'drbd: get rid of atomic update on disk bitmap works'. 
It missed the function drbd_bm_write_lazy() in drbd_bitmap.c.
My test procedure only had a module build, but that does not
unveil a completely missed function. 

Here is a branch with that mistake corrected.

The following changes since commit 6a27b656fc0210e976db362e1368c56db05c8f08:

  block: virtio-blk: support multi virt queues per virtio-blk device (2014-07-01 10:51:03 -0600)

are available in the git repository at:

  git://git.linbit.com/linux-drbd.git for-3.17v2

for you to fetch changes up to bf0d6e4a1138e71cafdbbb99cde430eee50c4ff1:

  drbd: silence underflow warning in read_in_block() (2014-07-10 18:35:23 +0200)

----------------------------------------------------------------
Andreas Gruenbacher (1):
      drbd: Remove unnecessary/unused code

Dan Carpenter (1):
      drbd: silence underflow warning in read_in_block()

Joe Perches (1):
      block: Convert last uses of __FUNCTION__ to __func__

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

Monam Agarwal (1):
      drivers/block: Use RCU_INIT_POINTER(x, NULL) in drbd/drbd_state.c

Philipp Reisner (5):
      drbd: Move write_ordering from connection to resource
      drbd: device->ldev is not guaranteed on an D_ATTACHING disk
      drbd: rename drbd_free_bc() to drbd_free_ldev()
      drbd: Limit the time we are waiting for the first packet on an accepted socket
      drbd: New net configuration option socket-check-timeout

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
 include/linux/drbd.h               |   4 +-
 include/linux/drbd_genl.h          |   4 +
 include/linux/drbd_limits.h        |   6 +
 lib/lru_cache.c                    |  23 +-
 19 files changed, 2699 insertions(+), 1210 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_debugfs.c
 create mode 100644 drivers/block/drbd/drbd_debugfs.h


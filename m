Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaDATJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:09:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25040 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbaDATJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:09:06 -0400
Date: Tue, 1 Apr 2014 13:09:02 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linuxpatches@star.c10r.facebook.com>
Subject: [GIT PULL] Block drivers bits for 3.15
Message-ID: <20140401190902.GB30970@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_06:2014-04-01,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.82000525761339e-11 kscore.compositescore=0
 circleOfTrustscore=7.0302659978126 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=3
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404010101
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On top of the core pull request, here's the pull request for the driver
related changes for 3.15. It contains:

- Improvements for msi-x registration for block drivers (mtip32xx, skd,
  cciss, nvme) from Alexander Gordeev.

- A round of cleanups and improvements for drbd from Andreas
  Gruenbacher and Rashika Kheria.

- A round of clanups and improvements for bcache from Kent.

- Removal of sleep_on() and friends in DAC960, ataflop, swim3 from Arnd
  Bergmann.

- Bug fix for a bug in the mtip32xx async completion code from Sam
  Bradshaw.

- Bug fix for accidentally bouncing IO on 32-bit platforms with mtip32xx
  from Felipe Franciosi.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.15/drivers

for you to fetch changes up to e84987a1f941b8e2e3173bb38510ddf25cc8c7f0:

  Merge branch 'bcache-for-3.15' of git://evilpiepirate.org/~kent/linux-bcache into for-3.15/drivers (2014-03-18 13:57:01 -0600)

----------------------------------------------------------------

Alexander Gordeev (9):
      mtip32xx: Remove superfluous call to pci_disable_msi()
      mtip32xx: Use pci_enable_msix_range() instead of pci_enable_msix()
      skd: Fix out of array boundary access
      skd: Fix incomplete cleanup of MSI-X interrupt
      skd: Use unified access to skdev->msix_entries throughout the code
      skd: Use pci_enable_msix_range() instead of pci_enable_msix()
      mtip32xx: Use pci_enable_msi() instead of pci_enable_msi_range()
      cciss: Fallback to MSI rather than to INTx if MSI-X failed
      nvme: Use pci_enable_msi_range() and pci_enable_msix_range()

Andreas Gruenbacher (53):
      idr: Add new function idr_is_empty()
      drbd: Describe the future high-level structure of DRBD
      drbd: Split off on-the-wire protocol definitions
      drbd: Rename struct drbd_conf -> struct drbd_device
      drbd: Rename "mdev" to "device"
      drbd: Rename drbd_tconn -> drbd_connection
      drbd: Introduce "peer_device" object between "device" and "connection"
      drbd: Improve some function and variable naming
      drbd: Add struct drbd_resource
      drbd: drbd_adm_down(): Move valid resource name check to drbd_adm_prepare()
      drbd: Add struct drbd_device->resource
      drbd: Minor cleanup in conn_new_minor()
      drbd: Add struct drbd_resource->devices
      drbd: Replace conn_get_by_name() with drbd_find_resource()
      drbd: conn_try_disconnect(): Use parameter instead of the global variable
      drbd: Move resource options from connection to resource
      drbd: Turn connection->volumes into connection->peer_devices
      drbd: Remove the terrible DEV hack
      drbd: Turn drbd_printk() into a polymorphic macro
      drbd: Replace and remove the obsolete conn_() macros
      drbd: Add explicit device parameter to D_ASSERT
      drbd: Rename drbd_{create,delete}_minor -> drbd_{create,delete}_device
      drbd: get_one_status(): Iterate over resource->devices instead of connection->peer_devices
      drbd: drbd_adm_new_resource(): Check if resource exists, not if it has any connections
      drbd: drbd_create_device(): Take a resource instead of a connection argument
      drbd: Rename net_conf variables old_conf -> old_net_conf and new_conf -> new_net_conf
      drbd: Iterate over all connections
      drbd: drbd_adm_prepare(): Only set adm_ctx.connection when a connection is requested
      drbd: Move conf_mutex from connection to resource
      drbd: Move susp, susp_nod, susp_fen from connection to resource
      drbd: Define the size of res_opts->cpu_mask in a single place
      drbd: Move cpu_mask from connection to resource
      drbd: Rename drbdd_init() -> drbd_receiver()
      drbd: Function prototype cleanups
      drbd: drbd_csum_bio(), drbd_csum_ee(): Remove unused device argument
      drbd: Replace vnr_to_mdev() with conn_peer_device()
      drbd: Pass a peer device to a number of fuctions
      drbd: Kill drbd_task_to_thread_name()
      drbd: Remove useless assertion
      drbd: Move string function prototypes from linux/drbd.h to drbd_string.h
      drbd: Rename w_prev_work_done -> w_complete
      drbd: Create a dedicated struct drbd_device_work
      drbd: Turn conn_flush_workqueue() into drbd_flush_workqueue()
      drbd: struct after_conn_state_chg_work: Use drbd_work instead of drbd_device_work
      drbd: struct drbd_peer_request: Use drbd_work instead of drbd_device_work
      drbd: Make w_make_resync_request() static
      drbd: Turn w_make_ov_request and make_resync_request into "normal" functions
      drbd: In the worker thread, process drbd_work instead of drbd_device_work items
      drbd: Get rid of first_peer_device() in handle_write_conflicts()
      drbd: Remove unused parameter of wire_flags_to_bio()
      drbd: Use the right peer device
      drbd: Add drbd_thread->resource and make drbd_thread->connection optional
      drbd: Fix future possible NULL pointer dereference

Arnd Bergmann (3):
      DAC960: remove sleep_on usage
      ataflop: fix sleep_on races
      swim3: fix interruptible_sleep_on race

Felipe Franciosi (2):
      mtip32xx: Set queue bounce limit
      mtip32xx: Unmap the DMA segments before completing the IO request

Jens Axboe (1):
      Merge branch 'bcache-for-3.15' of git://evilpiepirate.org/~kent/linux-bcache into for-3.15/drivers

John Sheu (1):
      bcache: remove nested function usage

Kent Overstreet (21):
      bcache: Fix another compiler warning on m68k
      bcache: Fix flash_dev_cache_miss() for real this time
      bcache: Fix a shutdown bug
      bcache: Fix a lockdep splat in an error path
      bcache: Fix a null ptr deref in journal replay
      bcache: Fix a journalling reclaim after recovery bug
      bcache: Fix a bug recovering from unclean shutdown
      bcache: Fix another bug recovering from unclean shutdown
      bcache: Fix discard granularity
      bcache: Fix moving_pred()
      bcache: Kill dead cgroup code
      bcache: Better alloc tracepoints
      bcache: Improve priority_stats
      bcache: Add bch_keylist_init_single()
      bcache: Add a real GC_MARK_RECLAIMABLE
      bcache: Fix a race when freeing btree nodes
      bcache: btree locking rework
      bcache: Kill btree_io_wq
      bcache: Rework btree cache reserve handling
      bcache: Kill unused freelist
      bcache: Kill bucket->gc_gen

Nicholas Swenson (2):
      bcache: Fix moving_gc deadlocking with a foreground write
      bcache: stop moving_gc marking buckets that can't be moved.

Philipp Reisner (1):
      drbd: Add missing error goto

Rashika Kheria (10):
      drivers: block: Mark functions as static in drbd_main.c
      drivers: block: Mark functions as static in drbd_nl.c
      drivers: block: Mark function as static in drbd_actlog.c
      drivers: block: Move prototype declaration of function tl_abort_disk_io() to appropriate header file from drbd_state.c
      drivers: block: Mark functions as static in drbd_req.c
      drivers: block: Mark functions as static in drbd_receiver.c
      drivers: block: Move prototype declaration to appropriate header file from drbd_main.c
      drivers: block: Mark the function as static in drbd_worker.c
      drivers: block: Mark function seq_printf_with_thousands_grouping() as static in drbd_proc.c
      drivers: block: Remove unused function drbd_bm_write_lazy() in drbd_bitmap.c

Sam Bradshaw (1):
      mtip32xx: mtip_async_complete() bug fixes

 Documentation/blockdev/drbd/data-structure-v9.txt |   38 +
 drivers/block/DAC960.c                            |   34 +-
 drivers/block/ataflop.c                           |   16 +-
 drivers/block/cciss.c                             |    2 -
 drivers/block/drbd/drbd_actlog.c                  |  629 ++---
 drivers/block/drbd/drbd_bitmap.c                  |  368 ++-
 drivers/block/drbd/drbd_int.h                     | 1130 ++++-----
 drivers/block/drbd/drbd_main.c                    | 2009 ++++++++--------
 drivers/block/drbd/drbd_nl.c                      | 1653 +++++++-------
 drivers/block/drbd/drbd_proc.c                    |  140 +-
 drivers/block/drbd/drbd_protocol.h                |  295 +++
 drivers/block/drbd/drbd_receiver.c                | 2532 +++++++++++----------
 drivers/block/drbd/drbd_req.c                     |  464 ++--
 drivers/block/drbd/drbd_req.h                     |   20 +-
 drivers/block/drbd/drbd_state.c                   |  859 +++----
 drivers/block/drbd/drbd_state.h                   |   40 +-
 drivers/block/drbd/drbd_strings.c                 |    1 +
 drivers/block/drbd/drbd_strings.h                 |    9 +
 drivers/block/drbd/drbd_worker.c                  |  944 ++++----
 drivers/block/drbd/drbd_wrappers.h                |   14 +-
 drivers/block/mtip32xx/mtip32xx.c                 |   92 +-
 drivers/block/mtip32xx/mtip32xx.h                 |    2 +-
 drivers/block/nvme-core.c                         |   33 +-
 drivers/block/skd_main.c                          |   67 +-
 drivers/block/swim3.c                             |   18 +-
 drivers/md/bcache/Kconfig                         |    8 -
 drivers/md/bcache/alloc.c                         |  173 +-
 drivers/md/bcache/bcache.h                        |   56 +-
 drivers/md/bcache/bset.c                          |    4 +-
 drivers/md/bcache/bset.h                          |    6 +
 drivers/md/bcache/btree.c                         |  592 +++--
 drivers/md/bcache/btree.h                         |   12 +-
 drivers/md/bcache/extents.c                       |   36 +-
 drivers/md/bcache/journal.c                       |   46 +-
 drivers/md/bcache/journal.h                       |    1 +
 drivers/md/bcache/movinggc.c                      |   18 +-
 drivers/md/bcache/request.c                       |  201 +-
 drivers/md/bcache/request.h                       |   19 +-
 drivers/md/bcache/stats.c                         |    3 -
 drivers/md/bcache/super.c                         |   64 +-
 drivers/md/bcache/sysfs.c                         |  155 +-
 drivers/md/bcache/trace.c                         |    2 +-
 include/linux/drbd.h                              |    8 +-
 include/linux/drbd_genl.h                         |    6 +-
 include/linux/idr.h                               |    1 +
 include/trace/events/bcache.h                     |   52 +-
 lib/idr.c                                         |   10 +
 47 files changed, 6603 insertions(+), 6279 deletions(-)
 create mode 100644 Documentation/blockdev/drbd/data-structure-v9.txt
 create mode 100644 drivers/block/drbd/drbd_protocol.h
 create mode 100644 drivers/block/drbd/drbd_strings.h

-- 
Jens Axboe


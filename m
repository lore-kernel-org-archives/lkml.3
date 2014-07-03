Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaGCIxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:53:00 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:45859 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaGCInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:43:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 00/23] RFC DRBD fixes
Date: Thu,  3 Jul 2014 10:42:52 +0200
Message-Id: <1404376995-4877-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds a debugfs hierarchy to DRBD. It unveils a lot
of information about timing of states/stages of IO requests.

This information helps a lot while optimizing DRBD for SSD
based IO stacks.

Dan Carpenter (1):
  drbd: silence underflow warning in read_in_block()

Lars Ellenberg (22):
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

 drivers/block/drbd/Makefile        |   1 +
 drivers/block/drbd/drbd_actlog.c   |  80 +++-
 drivers/block/drbd/drbd_bitmap.c   |  70 ++-
 drivers/block/drbd/drbd_debugfs.c  | 958 +++++++++++++++++++++++++++++++++++++
 drivers/block/drbd/drbd_debugfs.h  |  39 ++
 drivers/block/drbd/drbd_int.h      | 175 ++++++-
 drivers/block/drbd/drbd_main.c     | 116 +++--
 drivers/block/drbd/drbd_nl.c       |   4 +-
 drivers/block/drbd/drbd_proc.c     |   3 +
 drivers/block/drbd/drbd_receiver.c | 138 ++++--
 drivers/block/drbd/drbd_req.c      | 411 +++++++++++-----
 drivers/block/drbd/drbd_worker.c   |  59 ++-
 include/linux/drbd.h               |   2 +-
 lib/lru_cache.c                    |  21 +-
 14 files changed, 1784 insertions(+), 293 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_debugfs.c
 create mode 100644 drivers/block/drbd/drbd_debugfs.h

-- 
1.9.1


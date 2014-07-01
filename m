Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbaGAQQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:16:54 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53061 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbaGAQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 00/20] RFC DRBD fixes
Date: Tue,  1 Jul 2014 18:16:30 +0200
Message-Id: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series has a number of fixes to DRBD in random places. In this
empties the queue before the debug-fs part.

These patches are targeted at the 3.17 merge window, after review.


Andreas Gruenbacher (1):
  drbd: Remove unnecessary/unused code

Joe Perches (1):
  block: Convert last uses of __FUNCTION__ to __func__

Lars Ellenberg (15):
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

Monam Agarwal (1):
  drivers/block: Use RCU_INIT_POINTER(x, NULL) in drbd/drbd_state.c

Philipp Reisner (2):
  drbd: Limit the time we are waiting for the first packet on an
    accepted socket
  drbd: New net configuration option socket-check-timeout

 drivers/block/drbd/drbd_bitmap.c   |  13 ++--
 drivers/block/drbd/drbd_int.h      |  93 ++++++----------------------
 drivers/block/drbd/drbd_interval.h |   4 +-
 drivers/block/drbd/drbd_main.c     |  53 ++++++----------
 drivers/block/drbd/drbd_nl.c       |   6 +-
 drivers/block/drbd/drbd_proc.c     | 122 +++++++++++++++++++++++--------------
 drivers/block/drbd/drbd_receiver.c |  92 +++++++++++++++++++++-------
 drivers/block/drbd/drbd_req.c      |  71 ++++++++++++---------
 drivers/block/drbd/drbd_req.h      |   1 +
 drivers/block/drbd/drbd_state.c    |  11 ++--
 drivers/block/drbd/drbd_worker.c   |  70 ++++++++++++++-------
 include/linux/drbd_genl.h          |   4 ++
 include/linux/drbd_limits.h        |   6 ++
 lib/lru_cache.c                    |   2 +-
 14 files changed, 301 insertions(+), 247 deletions(-)

-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaIKM3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:29:21 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47770 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbaIKM3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/9] DRBD updates for 3.18
Date: Thu, 11 Sep 2014 14:29:04 +0200
Message-Id: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

please consider to put these patches into your (future) for-3.18/drivers
branch. I have posted it for review on August 28. It consists mainly of
minor cleanups, and an important performance improvement. With that
DRBD was seen to write with 160k IOPS, on SSDs.

You may take the patches from this posting, or pull them from
http://git.drbd.org/linux-2.6-drbd.git for-3.18-rc1
the branch there is based on Linux 3.17-rc4.

Andreas Gruenbacher (5):
  drbd: Use better variable names
  drbd: Use consistent names for all the bi_end_io callbacks
  drbd: Avoid inconsistent locking warning
  drbd: Get rid of the __no_warn and __cond_lock macros
  drbd: Get rid of the WORK_PENDING macro

Lars Ellenberg (2):
  drbd: Improve asender performance
  drbd: reduce lock contention in drbd_worker

Philipp Marek (1):
  drbd: Remove superfluous newline from "resync_extents" debugfs entry.

Philipp Reisner (1):
  drbd: Add missing newline in resync progress display in /proc/drbd

 drivers/block/drbd/drbd_actlog.c   |  4 +--
 drivers/block/drbd/drbd_bitmap.c   |  6 ++---
 drivers/block/drbd/drbd_debugfs.c  |  2 +-
 drivers/block/drbd/drbd_int.h      | 19 +++++++-------
 drivers/block/drbd/drbd_main.c     | 28 ++++++++++----------
 drivers/block/drbd/drbd_proc.c     |  4 ++-
 drivers/block/drbd/drbd_receiver.c | 52 +++++++++++++++++++++-----------------
 drivers/block/drbd/drbd_req.c      |  2 +-
 drivers/block/drbd/drbd_state.c    | 18 ++++++-------
 drivers/block/drbd/drbd_worker.c   | 51 +++++++++++++++----------------------
 10 files changed, 93 insertions(+), 93 deletions(-)

-- 
1.9.1


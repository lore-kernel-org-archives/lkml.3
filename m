Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaHYNZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:25:05 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:56661 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaHYNZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:25:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/8] RFC DRBD cleanups and performance work
Date: Mon, 25 Aug 2014 15:16:30 +0200
Message-Id: <1408972598-16650-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these patches are cleanup work. The exception are the two
patches from Lars Ellenberg. These two can bring DRBD's performance
into the area of 160k IOPs. (On fitting hardware of course).

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

 drivers/block/drbd/drbd_actlog.c   |  4 +--
 drivers/block/drbd/drbd_bitmap.c   |  6 ++---
 drivers/block/drbd/drbd_debugfs.c  |  2 +-
 drivers/block/drbd/drbd_int.h      | 19 +++++++-------
 drivers/block/drbd/drbd_main.c     | 28 ++++++++++----------
 drivers/block/drbd/drbd_receiver.c | 52 +++++++++++++++++++++-----------------
 drivers/block/drbd/drbd_req.c      |  2 +-
 drivers/block/drbd/drbd_state.c    | 18 ++++++-------
 drivers/block/drbd/drbd_worker.c   | 51 +++++++++++++++----------------------
 9 files changed, 90 insertions(+), 92 deletions(-)

-- 
1.9.1


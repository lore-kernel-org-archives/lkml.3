Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaF3PxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:53:17 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:49991 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaF3PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 00/18] RFC DRBD fixes
Date: Mon, 30 Jun 2014 17:52:49 +0200
Message-Id: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series has a number of fixes to DRBD in random places. The most
interesting change is "get rid of atomic update on disk bitmap works".

These patches are targeted at the 3.17 merge window, after review.

There will be one more post containing "random stuff", and a final
one that adds debug-fs support to DRBD.

best,
 Phil

Lars Ellenberg (15):
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

Philipp Reisner (3):
  drbd: Move write_ordering from connection to resource
  drbd: device->ldev is not guaranteed on an D_ATTACHING disk
  drbd: rename drbd_free_bc() to drbd_free_ldev()

 drivers/block/drbd/drbd_actlog.c   | 438 ++++++++++++-------------------------
 drivers/block/drbd/drbd_bitmap.c   |  57 +----
 drivers/block/drbd/drbd_int.h      | 123 ++++++-----
 drivers/block/drbd/drbd_main.c     | 133 ++---------
 drivers/block/drbd/drbd_nl.c       | 100 +++++----
 drivers/block/drbd/drbd_proc.c     |   2 +-
 drivers/block/drbd/drbd_receiver.c |  86 +++++---
 drivers/block/drbd/drbd_req.c      |  47 ++--
 drivers/block/drbd/drbd_state.c    |  79 ++++---
 drivers/block/drbd/drbd_worker.c   | 231 +++++++++++++++----
 include/linux/drbd.h               |   2 +-
 11 files changed, 615 insertions(+), 683 deletions(-)

-- 
1.9.1


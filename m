Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaKJQVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:21:36 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:54036 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaKJQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:21:18 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 0/7] DRBD updates for the 3.19 merge window
Date: Mon, 10 Nov 2014 17:21:08 +0100
Message-Id: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

please take these patches for you for-3.19/drivers branch.
They where posted for review on 2014-10-29.

Some cleanups and 3 fixes. Two of them marked for stable:
0005-drbd-merge_bvec_fn-properly-remap-bvm-bi_bdev.patch and
0006-drbd-Fix-state-change-in-case-of-connection-timeout.patch
(marked for stable)

Thanks!


Andreas Gruenbacher (2):
  drbd: Minor cleanups
  drbd: Only use drbd_msg_put_info() in drbd_nl.c

Lars Ellenberg (2):
  drbd: fix resync throttling initialization
  drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Philipp Reisner (3):
  drbd: fix race between role change and handshake
  drbd: Fix state change in case of connection timeout
  drbd: Remove an useless copy of kernel_setsockopt()

 drivers/block/drbd/drbd_actlog.c   |  3 +-
 drivers/block/drbd/drbd_int.h      | 39 +++++------------------
 drivers/block/drbd/drbd_main.c     | 23 ++++----------
 drivers/block/drbd/drbd_nl.c       | 64 +++++++++++++++++---------------------
 drivers/block/drbd/drbd_receiver.c |  2 +-
 drivers/block/drbd/drbd_req.c      |  3 +-
 drivers/block/drbd/drbd_state.c    | 42 ++++++++++++++++++++-----
 drivers/block/drbd/drbd_state.h    |  5 +++
 drivers/block/drbd/drbd_worker.c   |  5 ++-
 include/linux/drbd.h               |  2 +-
 10 files changed, 90 insertions(+), 98 deletions(-)

-- 
1.9.1


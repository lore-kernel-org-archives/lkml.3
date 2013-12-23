Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab3LWV7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:59:07 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60675 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab3LWV67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 00/27] DRBD code reorganization
Date: Mon, 23 Dec 2013 22:50:29 +0100
Message-Id: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we are preparing DRBD for the ability to have multiple connections,
in other words the ability to mirror a single block device to multiple
peers concurrently.

This patch set is the second half of a preparation step. With part 1
it introduces a new in memory object (struct drbd_resource),
and renames the current in memory objects for clarity.

This patch set does not introduce any new functionality.


Andreas Gruenbacher (27):
  drbd: Rename net_conf variables old_conf -> old_net_conf and new_conf
    -> new_net_conf
  drbd: Iterate over all connections
  drbd: drbd_adm_prepare(): Only set adm_ctx.connection when a
    connection is requested
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
  drbd: Move string function prototypes from linux/drbd.h to
    drbd_string.h
  drbd: Rename w_prev_work_done -> w_complete
  drbd: Create a dedicated struct drbd_device_work
  drbd: Turn conn_flush_workqueue() into drbd_flush_workqueue()
  drbd: struct after_conn_state_chg_work: Use drbd_work instead of
    drbd_device_work
  drbd: struct drbd_peer_request: Use drbd_work instead of
    drbd_device_work
  drbd: Make w_make_resync_request() static
  drbd: Turn w_make_ov_request and make_resync_request into "normal"
    functions
  drbd: In the worker thread, process drbd_work instead of
    drbd_device_work items
  drbd: Get rid of first_peer_device() in handle_write_conflicts()
  drbd: Remove unused parameter of wire_flags_to_bio()
  drbd: Use the right peer device
  drbd: Add drbd_thread->resource and make drbd_thread->connection
    optional

 drivers/block/drbd/drbd_actlog.c   |   16 +-
 drivers/block/drbd/drbd_bitmap.c   |   16 +-
 drivers/block/drbd/drbd_int.h      |  148 ++++-----
 drivers/block/drbd/drbd_main.c     |  558 ++++++++++++++++++---------------
 drivers/block/drbd/drbd_nl.c       |  260 +++++++--------
 drivers/block/drbd/drbd_receiver.c |  608 ++++++++++++++++++++----------------
 drivers/block/drbd/drbd_req.c      |   59 ++--
 drivers/block/drbd/drbd_req.h      |    8 +-
 drivers/block/drbd/drbd_state.c    |  116 +++----
 drivers/block/drbd/drbd_strings.c  |    1 +
 drivers/block/drbd/drbd_strings.h  |    9 +
 drivers/block/drbd/drbd_worker.c   |  216 ++++++-------
 include/linux/drbd.h               |    8 +-
 include/linux/drbd_genl.h          |    2 +-
 14 files changed, 1074 insertions(+), 951 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_strings.h

-- 
1.7.9.5


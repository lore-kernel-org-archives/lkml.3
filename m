Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3JNSWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:22:51 -0400
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:38243 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750738Ab3JNSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:22:50 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 14:22:50 EDT
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 14 Oct 2013 11:16:15 -0700
Message-Id: <1381774575-8817-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Last batch of IB changes for 3.12: many mlx5 hardware driver fixes plus
one trivial semicolon cleanup.

----------------------------------------------------------------
Eli Cohen (12):
      IB/mlx5: Fix send work queue size calculation
      mlx5: Remove checksum on command interface commands
      IB/mlx5: Decrease memory consumption of mr caches
      IB/mlx5: Avoid async events on invalid port number
      mlx5: Keep polling to reclaim pages while any returned
      mlx5: Fix layout of struct mlx5_init_seg
      IB/mlx5: Disable atomic operations
      mlx5: Fix opt param mask for sq err to rts transition
      IB/mlx5: Fix opt param mask according to firmware spec
      mlx5: Fix error code translation from firmware to driver
      IB/mlx5: Fix alignment of reg umr gather buffers
      IB/mlx5: Ensure proper synchronization accessing memory

Joe Perches (1):
      IB: Remove unnecessary semicolons

Moshe Lazer (2):
      IB/mlx5: Flush cache workqueue before destroying it
      IB/mlx5: Fix memory leak in mlx5_ib_create_srq

Roland Dreier (1):
      Merge branch 'misc' into for-next

Sagi Grimberg (1):
      IB/mlx5: Fix eq names to display nicely in /proc/interrupts

 drivers/infiniband/hw/amso1100/c2_ae.c             |  2 +-
 drivers/infiniband/hw/mlx5/main.c                  | 16 +++--
 drivers/infiniband/hw/mlx5/mr.c                    | 70 +++++++++----------
 drivers/infiniband/hw/mlx5/qp.c                    | 80 ++++++++--------------
 drivers/infiniband/hw/mlx5/srq.c                   |  4 +-
 drivers/infiniband/hw/mthca/mthca_eq.c             |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |  6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 28 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 21 ++----
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 16 ++++-
 include/linux/mlx5/device.h                        |  4 +-
 include/linux/mlx5/driver.h                        |  6 +-
 15 files changed, 126 insertions(+), 141 deletions(-)

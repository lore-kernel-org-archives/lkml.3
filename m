Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaBNRwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:52:04 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:39145 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538AbaBNRwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:52:00 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 14 Feb 2014 09:51:51 -0800
Message-Id: <1392400311-14879-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

RDMA/InfiniBand fixes for 3.14-rc3:
 - Fix some rough edges from the "IP addressing for IBoE" merge
 - Other misc fixes, mostly to hardware drivers

----------------------------------------------------------------
Dan Carpenter (1):
      IB/iser: Fix use after free in iser_snd_completion()

Devesh Sharma (2):
      RDMA/ocrdma: Fix traffic class shift
      RDMA/ocrdma: Fix load time panic during GID table init

Eli Cohen (4):
      IB/mlx5: Fix RC transport send queue overhead computation
      IB/mlx5: Fix binary compatibility with libmlx5
      IB/mlx5: Don't set "block multicast loopback" capability
      IB/mlx5: Remove dependency on X86

Julia Lawall (2):
      RDMA/nes: Fix error return code
      RDMA/amso1100: Fix error return code

Kumar Sanghvi (1):
      RDMA/cxgb4: Add missing neigh_release in LE-Workaround path

Matan Barak (1):
      IB/mlx4: Don't allocate range of steerable UD QPs for Ethernet-only device

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Moni Shoua (6):
      IB/mlx4: Make sure GID index 0 is always occupied
      IB/mlx4: Move rtnl locking to the right place
      IB/mlx4: Do IBoE locking earlier when initializing the GID table
      IB/mlx4: Do IBoE GID table resets per-port
      IB/mlx4: Build the port IBoE GID table properly under bonding
      IB: Report using RoCE IP based gids in port caps

Roi Dayan (1):
      IB/iser: Avoid dereferencing iscsi_iser conn object when not bound to iser connection

Roland Dreier (2):
      mlx5: Add include of <linux/slab.h> because of kzalloc()/kfree() use
      Merge branches 'cma', 'cxgb4', 'iser', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'usnic' into for-next

Upinder Malhi (1):
      IB/usnic: Fix smatch endianness error

 drivers/infiniband/hw/amso1100/c2.c             |   4 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c        |   3 +-
 drivers/infiniband/hw/cxgb4/cm.c                |   1 +
 drivers/infiniband/hw/mlx4/main.c               | 185 +++++++++++++++++-------
 drivers/infiniband/hw/mlx5/Kconfig              |   2 +-
 drivers/infiniband/hw/mlx5/main.c               |  22 ++-
 drivers/infiniband/hw/mlx5/qp.c                 |  18 ++-
 drivers/infiniband/hw/mlx5/user.h               |   7 +
 drivers/infiniband/hw/nes/nes.c                 |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c      |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c     |   4 +-
 drivers/infiniband/hw/qib/qib_iba7322.c         |   5 +
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c   |   9 +-
 drivers/infiniband/ulp/iser/iser_initiator.c    |   3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c        |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig |   2 +-
 include/linux/mlx5/driver.h                     |   3 +
 include/rdma/ib_verbs.h                         |   3 +-
 18 files changed, 214 insertions(+), 74 deletions(-)

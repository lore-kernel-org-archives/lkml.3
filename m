Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3HBQMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:12:15 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:35757 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754386Ab3HBQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:12:12 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri,  2 Aug 2013 09:12:05 -0700
Message-Id: <1375459925-585-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

InfiniBand/RDMA fixes for 3.11-rc:
 - Fixes for the newly merged mlx5 hardware driver
 - Stack info leak fixes from Dan Carpenter
 - Fixes for pkey table handling with SR-IOV
 - A few other small things

----------------------------------------------------------------
Andi Shyti (1):
      mlx5_core: Variable may be used uninitialized

Dan Carpenter (6):
      RDMA/cxgb4: Fix stack info leak in c4iw_create_qp()
      RDMA/ocrdma: Fix several stack info leaks
      RDMA/nes: Fix info leaks in nes_create_qp() and nes_create_cq()
      RDMA/cxgb3: Fix stack info leak in iwch_create_cq()
      IB/mlx5: Fix stack info leak in mlx5_ib_alloc_ucontext()
      mlx5_core: Fix use after free in mlx5_cmd_comp_handler()

Eli Cohen (1):
      mlx5_core: Implement new initialization sequence

Erez Shitrit (1):
      IPoIB: Fix pkey change flow for virtualization environments

Jack Morgenstein (2):
      IB/mlx4: Use default pkey when creating tunnel QPs
      IB/core: Create QP1 using the pkey index which contains the default pkey

Mike Marciniszyn (1):
      IB/qib: Add err_decode() call for ring dump

Or Gerlitz (1):
      IPoIB: Make sure child devices use valid/proper pkeys

Paul Bolle (1):
      RDMA/cma: Fix gcc warning

Roland Dreier (3):
      RDMA/ocrdma: Remove unused include
      Revert "RDMA/nes: Fix compilation error when nes_debug is enabled"
      Merge branches 'cma', 'cxgb3', 'cxgb4', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma' and 'qib' into for-next

Sean Hefty (2):
      RDMA/cma: Fix accessing invalid private data for UD
      RDMA/cma: Only call cma_save_ib_info() for CM REQs

Wei Yongjun (1):
      IB/mlx5: Fix error return code in init_one()

 drivers/infiniband/core/cma.c                      | 29 +++++----
 drivers/infiniband/core/mad.c                      |  8 ++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  1 +
 drivers/infiniband/hw/cxgb4/qp.c                   |  2 +
 drivers/infiniband/hw/mlx4/mad.c                   | 10 ++-
 drivers/infiniband/hw/mlx5/main.c                  | 11 ++--
 drivers/infiniband/hw/mlx5/qp.c                    |  2 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |  4 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |  3 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  5 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |  2 +
 drivers/infiniband/hw/qib/qib_sdma.c               |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            | 76 ++++++++++++++++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |  9 +++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 19 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 69 ++++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 20 ++++--
 include/linux/mlx5/device.h                        | 20 ++++++
 include/linux/mlx5/driver.h                        |  4 +-
 21 files changed, 239 insertions(+), 60 deletions(-)

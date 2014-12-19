Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaLSALR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:11:17 -0500
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:34646 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751158AbaLSALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:11:16 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2014 19:11:16 EST
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 18 Dec 2014 16:03:56 -0800
Message-Id: <1418947436-10812-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Main batch of InfiniBand/RDMA changes for 3.19:

 - On-demand paging support in core midlayer and mlx5 driver.  This lets
   userspace create non-pinned memory regions and have the adapter HW
   trigger page faults.
 - iSER and IPoIB updates and fixes.
 - Low-level HW driver updates for cxgb4, mlx4 and ocrdma.
 - Other miscellaneous fixes.

----------------------------------------------------------------
Ariel Nahum (2):
      IB/iser: Collapse cleanup and disconnect handlers
      IB/iser: Fix possible NULL derefernce ib_conn->device in session_create

Devesh Sharma (1):
      RDMA/ocrdma: Always resolve destination mac from GRH for UD QPs

Doug Ledford (8):
      IPoIB: Consolidate rtnl_lock tasks in workqueue
      IPoIB: Make the carrier_on_task race aware
      IPoIB: fix MCAST_FLAG_BUSY usage
      IPoIB: fix mcast_dev_flush/mcast_restart_task race
      IPoIB: change init sequence ordering
      IPoIB: Use dedicated workqueues per interface
      IPoIB: Make ipoib_mcast_stop_thread flush the workqueue
      IPoIB: No longer use flush as a parameter

Eli Cohen (1):
      IB/core: Add support for extended query device caps

Haggai Eran (14):
      IB/mlx5: Remove per-MR pas and dma pointers
      IB/mlx5: Enhance UMR support to allow partial page table update
      IB/core: Replace ib_umem's offset field with a full address
      IB/core: Add umem function to read data from user-space
      IB/mlx5: Add function to read WQE from user-space
      IB/core: Implement support for MMU notifiers regarding on demand paging regions
      mlx5_core: Add support for page faults events and low level handling
      IB/mlx5: Implement the ODP capability query verb
      IB/mlx5: Changes in memory region creation to support on-demand paging
      IB/mlx5: Add mlx5_ib_update_mtt to update page tables after creation
      IB/mlx5: Page faults handling infrastructure
      IB/mlx5: Handle page faults
      IB/mlx5: Add support for RDMA read/write responder page faults
      IB/mlx5: Implement on demand paging by adding support for MMU notifiers

Hariprasad S (1):
      RDMA/cxgb4: Handle NET_XMIT return codes

Hariprasad Shenai (2):
      RDMA/cxgb4: Fix locking issue in process_mpa_request
      RDMA/cxgb4: Limit MRs to < 8GB for T4/T5 devices

Jack Morgenstein (2):
      IB/core: Fix mgid key handling in SA agent multicast data-base
      IB/mlx4: Fix an incorrectly shadowed variable in mlx4_ib_rereg_user_mr

Max Gurtovoy (1):
      IB/iser: Fix possible SQ overflow

Minh Tran (1):
      IB/iser: Re-adjust CQ and QP send ring sizes to HW limits

Mitesh Ahuja (1):
      RDMA/ocrdma: Fix ocrdma_query_qp() to report q_key value for UD QPs

Moni Shoua (1):
      IB/core: Do not resolve VLAN if already resolved

Or Gerlitz (1):
      IB/iser: Bump version to 1.5

Or Kehati (1):
      IB/addr: Improve address resolution callback scheduling

Pramod Kumar (2):
      RDMA/cxgb4: Increase epd buff size for debug interface
      RDMA/cxgb4: Configure 0B MRs to match HW implementation

Roland Dreier (2):
      mlx5_core: Re-add MLX5_DEV_CAP_FLAG_ON_DMND_PG flag
      Merge branches 'core', 'cxgb4', 'ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next

Sagi Grimberg (13):
      IB/iser: Fix catastrophic error flow hang
      IB/iser: Decrement CQ's active QPs accounting when QP creation fails
      IB/iser: Fix sparse warnings
      IB/iser: Fix race between iser connection teardown and scsi TMFs
      IB/iser: Terminate connection before cleaning inflight tasks
      IB/iser: Centralize memory region invalidation to a function
      IB/iser: Remove redundant is_mr indicator
      IB/iser: Use more completion queues
      IB/iser: Micro-optimize iser logging
      IB/iser: Micro-optimize iser_handle_wc
      IB/iser: DIX update
      IB/core: Add flags for on demand paging support
      IB/srp: Allow newline separator for connection string

Shachar Raindel (1):
      IB/core: Add support for on demand paging regions

Steve Wise (1):
      RDMA/cxgb4: Wake up waiters after flushing the qp

Yuval Shaia (1):
      mlx4_core: Check for DPDP violation only when DPDP is not supported

 drivers/infiniband/Kconfig                     |  11 +
 drivers/infiniband/core/Makefile               |   1 +
 drivers/infiniband/core/addr.c                 |   4 +-
 drivers/infiniband/core/multicast.c            |  11 +-
 drivers/infiniband/core/umem.c                 |  72 ++-
 drivers/infiniband/core/umem_odp.c             | 668 +++++++++++++++++++++
 drivers/infiniband/core/umem_rbtree.c          |  94 +++
 drivers/infiniband/core/uverbs.h               |   1 +
 drivers/infiniband/core/uverbs_cmd.c           | 171 ++++--
 drivers/infiniband/core/uverbs_main.c          |   5 +-
 drivers/infiniband/core/verbs.c                |   3 +-
 drivers/infiniband/hw/amso1100/c2_provider.c   |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c               |   7 +-
 drivers/infiniband/hw/cxgb4/device.c           |   2 +-
 drivers/infiniband/hw/cxgb4/mem.c              |  28 +-
 drivers/infiniband/hw/cxgb4/qp.c               |   2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c         |   2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c         |   2 +-
 drivers/infiniband/hw/mlx4/mr.c                |   1 -
 drivers/infiniband/hw/mlx5/Makefile            |   1 +
 drivers/infiniband/hw/mlx5/main.c              |  45 +-
 drivers/infiniband/hw/mlx5/mem.c               |  69 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h           | 116 +++-
 drivers/infiniband/hw/mlx5/mr.c                | 323 ++++++++--
 drivers/infiniband/hw/mlx5/odp.c               | 798 +++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c                | 197 ++++--
 drivers/infiniband/hw/nes/nes_verbs.c          |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |   4 +-
 drivers/infiniband/hw/qib/qib_mr.c             |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |  19 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  27 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  49 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 239 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  22 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       | 104 +++-
 drivers/infiniband/ulp/iser/iscsi_iser.h       |  30 +-
 drivers/infiniband/ulp/iser/iser_initiator.c   |   6 +-
 drivers/infiniband/ulp/iser/iser_memory.c      | 102 +---
 drivers/infiniband/ulp/iser/iser_verbs.c       |  91 ++-
 drivers/infiniband/ulp/srp/ib_srp.c            |   2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c      |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   |  40 ++
 drivers/net/ethernet/mellanox/mlx5/core/qp.c   | 119 ++++
 include/linux/mlx5/device.h                    |  72 ++-
 include/linux/mlx5/driver.h                    |  14 +-
 include/linux/mlx5/qp.h                        |  65 ++
 include/rdma/ib_umem.h                         |  34 +-
 include/rdma/ib_umem_odp.h                     | 160 +++++
 include/rdma/ib_verbs.h                        |  54 +-
 include/uapi/rdma/ib_user_verbs.h              |  29 +-
 53 files changed, 3511 insertions(+), 457 deletions(-)
 create mode 100644 drivers/infiniband/core/umem_odp.c
 create mode 100644 drivers/infiniband/core/umem_rbtree.c
 create mode 100644 drivers/infiniband/hw/mlx5/odp.c
 create mode 100644 include/rdma/ib_umem_odp.h

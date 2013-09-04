Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763161Ab3IDREF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:04:05 -0400
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:57082 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754751Ab3IDRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:03:45 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed,  4 Sep 2013 10:03:38 -0700
Message-Id: <1378314218-28021-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.12 merge window:

 - Large ocrdma HW driver update: add "fast register" work requests,
   fixes, cleanups
 - Add receive flow steering support for raw QPs
 - Fix IPoIB neighbour race that leads to crash
 - iSER updates including support for using "fast register" memory
   registration
 - IPv6 support for iWARP
 - XRC transport fixes

----------------------------------------------------------------
CQ Tang (1):
      IB/qib: Improve SDMA performance

Hadar Hen Zion (3):
      IB/core: Add receive flow steering support
      IB/core: Export ib_create/destroy_flow through uverbs
      IB/mlx4: Add receive flow steering support

Igor Ivanov (1):
      IB/core: Infrastructure for extensible uverbs commands

Ira Weiny (1):
      IB/qib: Move COUNTER_MASK definition within qib_mad.h header guards

Jim Foraker (1):
      IPoIB: Fix race in deleting ipoib_neigh entries

Matan Barak (1):
      IB/core: Better checking of userspace values for receive flow steering

Naresh Gottumukkala (19):
      RDMA/ocrdma: Style and redundant code cleanup
      RDMA/ocrdma: Remove redundant dev reference
      RDMA/ocrdma: Don't allow zero/invalid sgid usage
      RDMA/ocrdma: Remove driver QP state machine
      RDMA/ocrdma: Remove __packed
      RDMA/ocrdma: Cache recv DB until QP moved to RTR
      RDMA/ocrdma: Create IRD queue fix
      RDMA/ocrdma: Add support for fast register work requests (FRWR)
      RDMA/ocrdma: Remove the MTU check based on Ethernet MTU
      RDMA/ocrdma: Fix to work with even a single MSI-X vector
      RDMA/ocrdma: For ERX2 irrespective of Qid, num_posted offset is 24
      RDMA/ocrdma: FRMA code cleanup
      RDMA/ocrdma: Dont use PD 0 for userpace CQ DB
      RDMA/ocrdma: Increase STAG array size
      RDMA/ocrdma: Fix for displaying proper link speed
      RDMA/ocrdma: Consider multiple SGES in case of DPP
      RDMA/ocrdma: Add ABI versioning support
      RDMA/ocrdma: Fill PVID in UMC case
      RDMA/ocrdma: Fix passing wrong opcode to modify_srq

Or Gerlitz (1):
      IB/iser: Use proper debug level value for info prints

Paul Bolle (1):
      IB/qib: Make qib_driver static

Roi Dayan (1):
      IB/iser: Fix possible memory leak in iser_create_frwr_pool()

Roland Dreier (2):
      RDMA/ocrdma: Fix compiler warning about int/pointer size mismatch
      Merge branches 'cxgb4', 'flowsteer', 'ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next

Sagi Grimberg (5):
      IB/iser: Generalize rdma memory registration
      IB/iser: Handle unaligned SG in separate function
      IB/iser: Place the fmr pool into a union in iser's IB conn struct
      IB/iser: Introduce fast memory registration model (FRWR)
      IB/iser: Fix redundant pointer check in dealloc flow

Shlomo Pongratz (2):
      IB/iser: Restructure allocation/deallocation of connection resources
      IB/iser: Accept session->cmds_max from user space

Steve Wise (9):
      RDMA/cma: Add IPv6 support for iWARP
      RDMA/cxgb4: Use correct bit shift macros for vlan filter tuples
      RDMA/cxgb4: Handle newer firmware changes
      RDMA/cxgb4: Fix QP flush logic
      RDMA/cxgb4: Fix accounting for unsignaled SQ WRs to deal with wrap
      RDMA/cxgb4: Set arp error handler for PASS_ACCEPT_RPL messages
      RDMA/cxgb4: Always do GTS write if cidx_inc == CIDXINC_MASK
      RDMA/cxgb4: Advertise ~0ULL as max MR size
      RDMA/cxgb4: Issue RI.FINI before closing when entering TERM

Vipul Pandya (3):
      cxgb4: Add routines to create and remove listening IPv6 servers
      cxgb4: Add CLIP support to store compressed IPv6 address
      RDMA/cxgb4: Add support for active and passive open connection with IPv6 address

Yijing Wang (1):
      IB/qib: Clean up unnecessary MSI/MSI-X capability find

Yishai Hadas (3):
      mlx4_core: Fix XRC QPs detection in the resource tracker
      IB/core: Add locking around event dispatching on XRC target QPs
      IB/core: Fixes to XRC reference counting in uverbs

 drivers/infiniband/core/cma.c                      |  44 +-
 drivers/infiniband/core/uverbs.h                   |   4 +
 drivers/infiniband/core/uverbs_cmd.c               | 250 +++++-
 drivers/infiniband/core/uverbs_main.c              |  42 +-
 drivers/infiniband/core/verbs.c                    |  30 +
 drivers/infiniband/hw/amso1100/c2_ae.c             |  18 +-
 drivers/infiniband/hw/amso1100/c2_cm.c             |  16 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |  46 +-
 drivers/infiniband/hw/cxgb4/Kconfig                |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c                   | 860 ++++++++++++-------
 drivers/infiniband/hw/cxgb4/cq.c                   | 329 +++++---
 drivers/infiniband/hw/cxgb4/device.c               | 116 ++-
 drivers/infiniband/hw/cxgb4/ev.c                   |  10 -
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   9 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  41 +-
 drivers/infiniband/hw/cxgb4/t4.h                   |  29 +-
 drivers/infiniband/hw/mlx4/main.c                  | 235 ++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  12 +
 drivers/infiniband/hw/nes/nes_cm.c                 | 153 ++--
 drivers/infiniband/hw/ocrdma/ocrdma.h              |  22 +-
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h          |  32 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |  14 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           | 458 +++++------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h           |  13 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   7 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          | 210 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        | 878 ++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   6 +
 drivers/infiniband/hw/qib/qib.h                    |   5 +-
 drivers/infiniband/hw/qib/qib_common.h             |  32 +-
 drivers/infiniband/hw/qib/qib_file_ops.c           |   2 +-
 drivers/infiniband/hw/qib/qib_init.c               |   2 +-
 drivers/infiniband/hw/qib/qib_mad.h                |   3 +-
 drivers/infiniband/hw/qib/qib_pcie.c               |  10 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |   8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          | 909 ++++++++++++++++-----
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |   3 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   9 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  19 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  73 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       | 139 +++-
 drivers/infiniband/ulp/iser/iser_memory.c          | 231 +++++-
 drivers/infiniband/ulp/iser/iser_verbs.c           | 292 +++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 288 ++++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   5 +
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  17 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |  23 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   3 +-
 include/linux/mlx4/device.h                        |   5 -
 include/rdma/ib_verbs.h                            | 128 ++-
 include/rdma/iw_cm.h                               |   8 +-
 include/uapi/rdma/ib_user_verbs.h                  |  99 ++-
 53 files changed, 4643 insertions(+), 1557 deletions(-)

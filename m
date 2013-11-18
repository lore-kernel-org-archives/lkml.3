Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3KRTBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:01:16 -0500
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:54823 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752650Ab3KRSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:45 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 18 Nov 2013 10:40:32 -0800
Message-Id: <1384800032-14755-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.13:

 - Re-enable flow steering verbs with new improved userspace ABI
 - Fixes for slow connection due to GID lookup scalability
 - IPoIB fixes
 - Many fixes to HW drivers including mlx4, mlx5, ocrdma and qib
 - Further improvements to SRP error handling
 - Add new transport type for Cisco usNIC

----------------------------------------------------------------
Bart Van Assche (11):
      IB/srp: Keep rport as long as the IB transport layer
      scsi_transport_srp: Add transport layer error handling
      IB/srp: Use SRP transport layer error recovery
      IB/srp: Start timers if a transport layer error occurs
      scsi_transport_srp: Add periodic reconnect support
      IB/srp: Add periodic reconnect functionality
      IB/srp: Export sgid to sysfs
      IB/srp: Introduce srp_alloc_req_data()
      IB/srp: Make queue size configurable
      IB/srp: Avoid offlining operational SCSI devices
      IB/srp: Report receive errors correctly

Ben Hutchings (1):
      IB/cxgb4: Fix formatting of physical address

Dan Carpenter (1):
      RDMA/ocrdma: Silence an integer underflow warning

Dave Jones (1):
      RDMA/nes: Remove self-assignment from nes_query_qp()

Doug Ledford (2):
      IB/cma: Use cached gids
      IB/cma: Check for GID on listening device first

Eli Cohen (17):
      IB/mlx5: Fix check of number of entries in create CQ
      IB/mlx5: Multithreaded create MR
      IB/mlx5: Fix overflow check in IB_WR_FAST_REG_MR
      IB/mlx5: Simplify mlx5_ib_destroy_srq
      mlx5: Fix cleanup flow when DMA mapping fails
      mlx5: Support communicating arbitrary host page size to firmware
      mlx5: Clear reserved area in set_hca_cap()
      IB/mlx5: Remove dead code in mr.c
      IB/mlx5: Remove "Always false" comparison
      IB/mlx5: Update opt param mask for RTS2RTS
      mlx5: Use enum to indicate adapter page size
      IB/mlx4: Fix endless loop in resize CQ
      IB/core: Encorce MR access rights rules on kernel consumers
      IB/mlx5: Remove dead code
      IB/mlx5: Fix list_del of empty list
      IB/mlx4: Fix device max capabilities check
      IB/mlx5: Fix page shift in create CQ for userspace

Erez Shitrit (6):
      IPoIB: Fix crash in dev_open error flow
      IPoIB: Fix deadlock between dev_change_flags() and __ipoib_dev_flush()
      IPoIB: Avoid flushing the driver workqueue on dev_down
      IPoIB: Fix usage of uninitialized multicast objects
      IPoIB: Add path query flushing in ipoib_ib_dev_cleanup
      IPoIB: Start multicast join process only on active ports

Jack Wang (1):
      IB/srp: Add change_queue_depth and change_queue_type support

Jan Kara (2):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

Joe Perches (1):
      IB/ucma: Convert use of typedef ctl_table to struct ctl_table

Latchesar Ionkov (1):
      IB/core: Pass imm_data from ib_uverbs_send_wr to ib_send_wr correctly

Matan Barak (2):
      IB/core: clarify overflow/underflow checks on ib_create/destroy_flow
      IB/core: Re-enable create_flow/destroy_flow uverbs

Mathias Krause (1):
      IB/netlink: Remove superfluous RDMA_NL_GET_OP() masking

Michal Nazarewicz (1):
      RDMA/cma: Remove unused argument and minor dead code

Michal Schmidt (1):
      IPoIB: lower NAPI weight

Mike Marciniszyn (2):
      IB/qib: Fix checkpatch __packed warnings
      IB/qib: Fix txselect regression

Moshe Lazer (2):
      IB/mlx5: Fix srq free in destroy qp
      mlx5_core: Change optimal_reclaimed_pages for better performance

Naresh Gottumukkala (2):
      RDMA/ocrdma: Fix a crash in rmmod
      RDMA/ocrdma: Remove redundant check in ocrdma_build_fr()

Roland Dreier (1):
      Merge branches 'cma', 'cxgb4', 'flowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp' into for-next

Sean Hefty (1):
      RDMA/ucma: Discard events for IDs not yet claimed by user space

Tal Alon (1):
      IPoIB: Change CM skb memory allocation to be non-atomic during init

Upinder Malhi \(umalhi\) (1):
      IB/core: Add Cisco usNIC rdma node and transport types

Vu Pham (2):
      IB/srp: Make transport layer retry count configurable
      IB/srp: Remove target from list before freeing Scsi_Host structure

Yann Droneaud (5):
      IB/core: Rename 'flow' structs to match other uverbs structs
      IB/core: Make uverbs flow structure use names like verbs ones
      IB/core: Use a common header for uverbs flow_specs
      IB/core: Remove ib_uverbs_flow_spec structure from userspace
      IB/core: extended command: an improved infrastructure for uverbs commands

Zhao Hongjiang (1):
      IB/cm: Convert to using idr_alloc_cyclic()

 Documentation/ABI/stable/sysfs-driver-ib_srp       |  13 +
 Documentation/ABI/stable/sysfs-transport-srp       |  39 ++
 drivers/infiniband/Kconfig                         |  11 -
 drivers/infiniband/core/cm.c                       |   5 +-
 drivers/infiniband/core/cma.c                      |  68 ++-
 drivers/infiniband/core/netlink.c                  |   2 +-
 drivers/infiniband/core/sysfs.c                    |   1 +
 drivers/infiniband/core/ucma.c                     |   4 +-
 drivers/infiniband/core/uverbs.h                   |  36 +-
 drivers/infiniband/core/uverbs_cmd.c               | 109 ++---
 drivers/infiniband/core/uverbs_main.c              | 128 +++--
 drivers/infiniband/core/verbs.c                    |  17 +
 drivers/infiniband/hw/cxgb4/device.c               |   4 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c      |   7 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   9 +-
 drivers/infiniband/hw/mlx4/main.c                  |   8 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  25 +-
 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   6 +
 drivers/infiniband/hw/mlx5/mr.c                    | 167 +++++--
 drivers/infiniband/hw/mlx5/qp.c                    |  21 +-
 drivers/infiniband/hw/mlx5/srq.c                   |   8 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h              |  53 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |   7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   6 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |  11 +-
 drivers/infiniband/hw/qib/qib_mad.h                |  14 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   6 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |  10 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  14 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  24 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  12 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  29 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |  10 +-
 drivers/infiniband/ulp/srp/ib_srp.c                | 500 +++++++++++++++----
 drivers/infiniband/ulp/srp/ib_srp.h                |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 106 ++--
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  35 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  32 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 196 +++++---
 drivers/scsi/scsi_transport_srp.c                  | 540 ++++++++++++++++++++-
 include/linux/mlx5/device.h                        |  13 +-
 include/linux/mlx5/driver.h                        |  18 +-
 include/rdma/ib_verbs.h                            |  20 +-
 include/scsi/scsi_transport_srp.h                  |  83 +++-
 include/uapi/rdma/ib_user_verbs.h                  |  95 ++--
 52 files changed, 1973 insertions(+), 595 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3GKXwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:52:47 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:41276 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756418Ab3GKXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:52:44 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 11 Jul 2013 16:52:38 -0700
Message-Id: <1373586758-3380-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main (updated) batch of InfiniBand/RDMA changes for 3.11 merge window:

 - AF_IB (native IB addressing) for CMA from Sean Hefty
 - New mlx5 driver for Mellanox Connect-IB adapters (including post merge request fixes)
 - SRP fixes from Bart Van Assche (including fix to first merge request)
 - qib HW driver updates
 - Resurrection of ocrdma HW driver development
 - uverbs conversion to create fds with O_CLOEXEC set
 - Other small changes and fixes

----------------------------------------------------------------
Bart Van Assche (6):
      IB/srp: Avoid skipping srp_reset_host() after a transport error
      IB/srp: Skip host settle delay
      IB/srp: Fail I/O fast if target offline
      IB/srp: Maintain a single connection per I_T nexus
      IB/srp: Make HCA completion vector configurable
      IB/srp: Let srp_abort() return FAST_IO_FAIL if TL offline

Dan Carpenter (2):
      RDMA/cxgb3: Timeout condition is never true
      mlx5: Return -EFAULT instead of -EPERM

Dean Luick (1):
      IB/qib: Log all SDMA errors unconditionally

Dotan Barak (1):
      IB/srp: Fix remove_one crash due to resource exhaustion

Eli Cohen (1):
      mlx5: Add driver for Mellanox Connect-IB adapters

Gottumukkala, Naresh (1):
      RDMA/ocrdma: Remove use_cnt for queues

Jack Morgenstein (1):
      IB/core: Add reserved values to enums for low-level driver use

Mike Marciniszyn (7):
      IB/qib: Add DCA support
      IB/qib: Remove atomic_inc_not_zero() from QP RCU
      IB/qib: Optimize CQ callbacks
      IB/qib: Convert opcode counters to per-context
      IB/qib: Add per-context stats interface
      IB/qib: Add qp_stats debug file
      IB/qib: Fix module-level leak

Mitko Haralanov (1):
      IB/qib: New transmitter tunning settings for Dell 1.1 backplane

Moshe Lazer (1):
      mlx5_core: Adjust hca_cap.uar_page_sz to conform to Connect-IB spec

Naresh Gottumukkala (5):
      RDMA/ocrdma: Use MCC_CREATE_EXT_V1 for MCC create
      RDMA/ocrdma: Replace ocrdma_err with pr_err
      RDMA/ocrdma: Set bad_wr in error case
      RDMA/ocrdma: Change macros to inline funtions
      RDMA/ocrdma: Reorg structures to avoid padding

Ramkrishna Vepa (2):
      IB/qib: Add optional NUMA affinity
      IB/qib: Add dual-rail NUMA awareness for PSM processes

Roland Dreier (6):
      mlx5: Fix parameter type of health_handler_t
      IB/mlx5: Make profile[] static in main.c
      mlx5_core: Fixes for sparse warnings
      IB/uverbs: Use get_unused_fd_flags(O_CLOEXEC) instead of get_unused_fd()
      Merge branches 'af_ib', 'cxgb4', 'misc', 'mlx5', 'ocrdma', 'qib' and 'srp' into for-next
      Merge branches 'mlx5', 'qib' and 'srp' into for-next

Sean Hefty (28):
      RDMA/cma: Define native IB address
      RDMA/cma: Allow enabling reuseaddr in any state
      RDMA/cma: Include AF_IB in loopback and any address checks
      IB/addr: Add AF_IB support to ip_addr_size
      RDMA/cma: Update port reservation to support AF_IB
      RDMA/cma: Allow user to specify AF_IB when binding
      RDMA/cma: Do not modify sa_family when setting loopback address
      RDMA/cma: Add helper functions to return id address information
      RDMA/cma: Restrict AF_IB loopback to binding to IB devices only
      RDMA/cma: Verify that source and dest sa_family are the same
      RDMA/cma: Add support for AF_IB to rdma_resolve_addr()
      RDMA/cma: Add support for AF_IB to rdma_resolve_route()
      RDMA/cma: Add support for AF_IB to cma_get_service_id()
      RDMA/cma: Remove unused SDP related code
      RDMA/cma: Merge cma_get/save_net_info
      RDMA/cma: Expose private data when using AF_IB
      RDMA/cma: Set qkey for AF_IB
      RDMA/cma: Only listen on IB devices when using AF_IB
      RDMA/ucma: Support querying for AF_IB addresses
      IB/sa: Export function to pack a path record into wire format
      RDMA/ucma: Support querying when IB paths are not reversible
      RDMA/cma: Export cma_get_service_id()
      RDMA/ucma: Add ability to query GID addresses
      RDMA/ucma: Name changes to indicate only IP addresses supported
      RDMA/ucma: Allow user space to bind to AF_IB
      RDMA/ucma: Allow user space to pass AF_IB into resolve
      RDMA/ucma: Allow user space to specify AF_IB when joining multicast
      RDMA/cma: Export AF_IB statistics

Vinit Agnihotri (1):
      IB/qib: Update minor version number

Vu Pham (1):
      IB/srp: Bump driver version and release date

Wei Yongjun (3):
      IB/ehca: Fix error return code in ehca_create_slab_caches()
      RDMA/ocrdma: Fix error return code in ocrdma_set_create_qp_rq_cmd()
      IB/core: Fix error return code in add_port()

 Documentation/ABI/stable/sysfs-driver-ib_srp       |    7 +
 MAINTAINERS                                        |   22 +
 drivers/infiniband/Kconfig                         |    1 +
 drivers/infiniband/Makefile                        |    1 +
 drivers/infiniband/core/addr.c                     |   20 +-
 drivers/infiniband/core/cma.c                      |  906 ++++---
 drivers/infiniband/core/sa_query.c                 |    6 +
 drivers/infiniband/core/sysfs.c                    |    8 +-
 drivers/infiniband/core/ucma.c                     |  321 ++-
 drivers/infiniband/core/uverbs_cmd.c               |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |    3 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |    1 +
 drivers/infiniband/hw/mlx5/Kconfig                 |   10 +
 drivers/infiniband/hw/mlx5/Makefile                |    3 +
 drivers/infiniband/hw/mlx5/ah.c                    |   92 +
 drivers/infiniband/hw/mlx5/cq.c                    |  843 +++++++
 drivers/infiniband/hw/mlx5/doorbell.c              |  100 +
 drivers/infiniband/hw/mlx5/mad.c                   |  139 ++
 drivers/infiniband/hw/mlx5/main.c                  | 1504 ++++++++++++
 drivers/infiniband/hw/mlx5/mem.c                   |  162 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  545 +++++
 drivers/infiniband/hw/mlx5/mr.c                    | 1007 ++++++++
 drivers/infiniband/hw/mlx5/qp.c                    | 2524 ++++++++++++++++++++
 drivers/infiniband/hw/mlx5/srq.c                   |  473 ++++
 drivers/infiniband/hw/mlx5/user.h                  |  121 +
 drivers/infiniband/hw/ocrdma/ocrdma.h              |   63 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |   86 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          |   35 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  135 +-
 drivers/infiniband/hw/qib/Kconfig                  |    8 +
 drivers/infiniband/hw/qib/Makefile                 |    1 +
 drivers/infiniband/hw/qib/qib.h                    |   63 +-
 drivers/infiniband/hw/qib/qib_common.h             |    2 +-
 drivers/infiniband/hw/qib/qib_cq.c                 |   67 +-
 drivers/infiniband/hw/qib/qib_debugfs.c            |  283 +++
 drivers/infiniband/hw/qib/qib_debugfs.h            |   45 +
 drivers/infiniband/hw/qib/qib_driver.c             |    1 -
 drivers/infiniband/hw/qib/qib_file_ops.c           |  176 +-
 drivers/infiniband/hw/qib/qib_iba6120.c            |   10 +
 drivers/infiniband/hw/qib/qib_iba7220.c            |   10 +
 drivers/infiniband/hw/qib/qib_iba7322.c            |  507 +++-
 drivers/infiniband/hw/qib/qib_init.c               |  145 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |  123 +-
 drivers/infiniband/hw/qib/qib_sdma.c               |   56 +
 drivers/infiniband/hw/qib/qib_verbs.c              |    8 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |   33 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   89 +-
 drivers/infiniband/ulp/srp/ib_srp.h                |    1 +
 drivers/net/ethernet/mellanox/Kconfig              |    1 +
 drivers/net/ethernet/mellanox/Makefile             |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   18 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |  238 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 1515 ++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  224 ++
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  583 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  521 ++++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  185 ++
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  227 ++
 drivers/net/ethernet/mellanox/mlx5/core/mad.c      |   78 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  475 ++++
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c      |  106 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   73 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  136 ++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  435 ++++
 drivers/net/ethernet/mellanox/mlx5/core/pd.c       |  101 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  104 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  301 +++
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      |  223 ++
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |  223 ++
 include/linux/mlx5/cmd.h                           |   51 +
 include/linux/mlx5/cq.h                            |  165 ++
 include/linux/mlx5/device.h                        |  893 +++++++
 include/linux/mlx5/doorbell.h                      |   79 +
 include/linux/mlx5/driver.h                        |  769 ++++++
 include/linux/mlx5/qp.h                            |  467 ++++
 include/linux/mlx5/srq.h                           |   41 +
 include/linux/socket.h                             |    2 +
 include/rdma/ib.h                                  |   89 +
 include/rdma/ib_addr.h                             |    6 +-
 include/rdma/ib_sa.h                               |    7 +
 include/rdma/ib_verbs.h                            |   35 +-
 include/rdma/rdma_cm.h                             |   13 +
 include/uapi/rdma/rdma_user_cm.h                   |   73 +-
 85 files changed, 18436 insertions(+), 803 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/Kconfig
 create mode 100644 drivers/infiniband/hw/mlx5/Makefile
 create mode 100644 drivers/infiniband/hw/mlx5/ah.c
 create mode 100644 drivers/infiniband/hw/mlx5/cq.c
 create mode 100644 drivers/infiniband/hw/mlx5/doorbell.c
 create mode 100644 drivers/infiniband/hw/mlx5/mad.c
 create mode 100644 drivers/infiniband/hw/mlx5/main.c
 create mode 100644 drivers/infiniband/hw/mlx5/mem.c
 create mode 100644 drivers/infiniband/hw/mlx5/mlx5_ib.h
 create mode 100644 drivers/infiniband/hw/mlx5/mr.c
 create mode 100644 drivers/infiniband/hw/mlx5/qp.c
 create mode 100644 drivers/infiniband/hw/mlx5/srq.c
 create mode 100644 drivers/infiniband/hw/mlx5/user.h
 create mode 100644 drivers/infiniband/hw/qib/qib_debugfs.c
 create mode 100644 drivers/infiniband/hw/qib/qib_debugfs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/Kconfig
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/alloc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/cmd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/cq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/eq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/health.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mad.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/main.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mcg.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mr.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/pd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/port.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/srq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/uar.c
 create mode 100644 include/linux/mlx5/cmd.h
 create mode 100644 include/linux/mlx5/cq.h
 create mode 100644 include/linux/mlx5/device.h
 create mode 100644 include/linux/mlx5/doorbell.h
 create mode 100644 include/linux/mlx5/driver.h
 create mode 100644 include/linux/mlx5/qp.h
 create mode 100644 include/linux/mlx5/srq.h
 create mode 100644 include/rdma/ib.h

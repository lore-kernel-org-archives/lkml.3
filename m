Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaFJRO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:14:28 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:52865 "HELO
	na3sys010aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752040AbaFJROZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:14:25 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 10 Jun 2014 10:14:10 -0700
Message-Id: <1402420450-11409-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.16:

 - Add iWARP port mapper to avoid conflicts between RDMA and normal
   stack TCP connections.

 - Fixes for i386 / x86-64 structure padding differences (ABI
   compatibility for 32-on-64) from Yann Droneaud.

 - A pile of SRP initiator fixes from Bart Van Assche.

 - Fixes for a writeback / memory allocation deadlock with NFS over
   IPoIB connected mode from Jiri Kosina.

 - The usual fixes and cleanups to mlx4, mlx5, cxgb4 and other
   low-level drivers.

----------------------------------------------------------------
Ariel Nahum (2):
      IB/iser: Simplify connection management
      IB/iser: Fix a possible race in iser connection states transition

Bart Van Assche (11):
      IB/srp: Fix a sporadic crash triggered by cable pulling
      IB/srp: Fix kernel-doc warnings
      IB/srp: Introduce an additional local variable
      IB/srp: Introduce srp_map_fmr()
      IB/srp: Introduce srp_finish_mapping()
      IB/srp: Introduce the 'register_always' kernel module parameter
      IB/srp: One FMR pool per SRP connection
      IB/srp: Rename FMR-related variables
      IB/srp: Add fast registration support
      IB/umad: Fix error handling
      IB/umad: Fix use-after-free on close

Christoph Jaeger (1):
      RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths

Colin Ian King (1):
      IB/mlx4: fix unitialised variable is_mcast

Dan Carpenter (2):
      RDMA/cxgb3: Fix information leak in send_abort()
      RDMA/cxgb3: Remove a couple unneeded conditions

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt

Dotan Barak (1):
      mlx4_core: Fix memory leaks in SR-IOV error paths

Duan Jiong (1):
      RDMA/ocrdma: Convert to use simple_open()

Haggai Eran (7):
      IB/mlx5: Fix error handling in reg_umr
      IB/mlx5: Add MR to radix tree in reg_mr_callback
      mlx5_core: Store MR attributes in mlx5_mr_core during creation and after UMR
      IB/mlx5: Set QP offsets and parameters for user QPs and not just for kernel QPs
      IB/core: Remove unneeded kobject_get/put calls
      IB/core: Fix port kobject deletion during error flow
      IB/core: Fix kobject leak on device register error flow

Jack Morgenstein (5):
      mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP
      IB/mlx4: SET_PORT called by mlx4_ib_modify_port should be wrapped
      IB/mlx4: Preparation for VFs to issue/receive SMI (QP0) requests/responses
      mlx4: Add infrastructure for selecting VFs to enable QP0 via MLX proxy QPs
      IB/mlx4: Add interface for selecting VFs to enable QP0 via MLX proxy QPs

Jiri Kosina (2):
      IB/mlx4: Implement IB_QP_CREATE_USE_GFP_NOIO
      IB/mlx4: Fix gfp passing in create_qp_common()

Joe Perches (1):
      IB/srp: Avoid problems if a header uses pr_fmt

Manuel Schölling (1):
      IB/ipath: Use time_before()/_after()

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event

Or Gerlitz (3):
      IB/iser: Bump version to 1.4
      IB: Return error for unsupported QP creation flags
      IB: Add a QP creation flag to use GFP_NOIO allocations

Roi Dayan (1):
      IB/iser: Add missing newlines to logging messages

Roland Dreier (6):
      IB/mlx5: Fix warning about cast of wr_id back to pointer on 32 bits
      mlx4_core: Move handling of MLX4_QP_ST_MLX to proper switch statement
      IB/mad: Fix sparse warning about gfp_t use
      IB/core: Fix sparse warnings about redeclared functions
      mlx4_core: Fix GFP flags parameters to be gfp_t
      Merge branches 'core', 'cxgb3', 'cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 'srp' and 'usnic' into for-next

Sagi Grimberg (3):
      mlx5_core: Fix signature handover operation for interleaved buffers
      mlx5_core: Simplify signature handover wqe for interleaved buffers
      mlx5_core: Copy DIF fields only when input and output space values match

Shachar Raindel (1):
      IB/mlx5: Refactor UMR to have its own context struct

Steve Wise (2):
      RDMA/cxgb4: Fix vlan support
      RDMA/cxgb4: Add support for iWARP Port Mapper user space service

Tatyana Nikolova (2):
      RDMA/core: Add support for iWARP Port Mapper user space service
      RDMA/nes: Add support for iWARP Port Mapper user space service

Upinder Malhi (1):
      IB/usnic: Fix source file missing copyright and license

Vinit Agnihotri (1):
      IB/qib: Additional Intel branding changes

Yann Droneaud (5):
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_cq
      IB/mlx5: add missing padding at end of struct mlx5_ib_create_srq
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp
      IB: Allow build of hw/ and ulp/ subdirectories independently
      RDMA/cxgb4: add missing padding at end of struct c4iw_alloc_ucontext_resp

 drivers/infiniband/Makefile                        |  19 +-
 drivers/infiniband/core/Makefile                   |   2 +-
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/core/iwpm_msg.c                 | 685 +++++++++++++++++++++
 drivers/infiniband/core/iwpm_util.c                | 607 ++++++++++++++++++
 drivers/infiniband/core/iwpm_util.h                | 238 +++++++
 drivers/infiniband/core/netlink.c                  |  18 +-
 drivers/infiniband/core/sa_query.c                 |   2 +-
 drivers/infiniband/core/sysfs.c                    |  85 +--
 drivers/infiniband/core/user_mad.c                 |  75 ++-
 drivers/infiniband/core/verbs.c                    |   8 +-
 drivers/infiniband/hw/Makefile                     |  12 +
 drivers/infiniband/hw/cxgb3/cxio_hal.c             |   6 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   1 +
 drivers/infiniband/hw/cxgb4/cm.c                   | 197 ++++--
 drivers/infiniband/hw/cxgb4/cq.c                   |   4 +-
 drivers/infiniband/hw/cxgb4/device.c               |  83 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  44 ++
 drivers/infiniband/hw/cxgb4/provider.c             |   5 +-
 drivers/infiniband/hw/cxgb4/user.h                 |   2 +
 drivers/infiniband/hw/ipath/ipath_diag.c           |   4 +
 drivers/infiniband/hw/ipath/ipath_intr.c           |   4 +-
 drivers/infiniband/hw/ipath/ipath_sdma.c           |   4 +-
 drivers/infiniband/hw/mlx4/ah.c                    |   2 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   6 +-
 drivers/infiniband/hw/mlx4/mad.c                   |  40 +-
 drivers/infiniband/hw/mlx4/main.c                  |  26 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   1 +
 drivers/infiniband/hw/mlx4/qp.c                    | 102 +--
 drivers/infiniband/hw/mlx4/srq.c                   |   7 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 | 105 +++-
 drivers/infiniband/hw/mlx5/cq.c                    |  13 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  13 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  76 ++-
 drivers/infiniband/hw/mlx5/qp.c                    |  42 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  14 +-
 drivers/infiniband/hw/mlx5/user.h                  |   2 +
 drivers/infiniband/hw/nes/nes.c                    |  25 +-
 drivers/infiniband/hw/nes/nes.h                    |   3 +
 drivers/infiniband/hw/nes/nes_cm.c                 | 320 ++++++++--
 drivers/infiniband/hw/nes/nes_cm.h                 |  12 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c        |   9 +-
 drivers/infiniband/hw/qib/qib_init.c               |   8 +-
 drivers/infiniband/hw/qib/qib_mad.c                |   2 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   3 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |   3 +
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c |  18 +
 drivers/infiniband/ulp/Makefile                    |   5 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |  18 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           | 105 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.h           |  10 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  89 ++-
 drivers/infiniband/ulp/srp/ib_srp.c                | 672 +++++++++++++++-----
 drivers/infiniband/ulp/srp/ib_srp.h                |  94 ++-
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |  27 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |  92 ++-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   6 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  46 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   1 +
 drivers/net/ethernet/mellanox/mlx4/icm.c           |   7 +-
 drivers/net/ethernet/mellanox/mlx4/icm.h           |   3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  30 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  12 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |  17 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  20 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  30 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   4 +
 include/linux/mlx4/device.h                        |  15 +-
 include/linux/mlx5/driver.h                        |   1 -
 include/rdma/ib_verbs.h                            |  11 +-
 include/rdma/iw_portmap.h                          | 199 ++++++
 include/rdma/rdma_netlink.h                        |  23 +-
 include/uapi/rdma/rdma_netlink.h                   |  96 ++-
 76 files changed, 3870 insertions(+), 733 deletions(-)
 create mode 100644 drivers/infiniband/core/iwpm_msg.c
 create mode 100644 drivers/infiniband/core/iwpm_util.c
 create mode 100644 drivers/infiniband/core/iwpm_util.h
 create mode 100644 drivers/infiniband/hw/Makefile
 create mode 100644 drivers/infiniband/ulp/Makefile
 create mode 100644 include/rdma/iw_portmap.h

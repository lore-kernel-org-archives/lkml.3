Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaAXTob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:44:31 -0500
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:40503 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752288AbaAXTo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:44:27 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 24 Jan 2014 11:43:47 -0800
Message-Id: <1390592627-13487-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.14:
 - Flow steering for InfiniBand UD traffic
 - IP-based addressing for IBoE aka RoCE
 - Pass SRP submaintainership from Dave to Bart
 - SRP transport fixes from Bart
 - Add the new Cisco usNIC low-level device driver
 - Various other fixes

----------------------------------------------------------------
Bart Van Assche (4):
      scsi_transport_srp: Block rport upon TL error even with fast_io_fail_tmo = off
      scsi_transport_srp: Fix a race condition
      scsi_transport_srp: Add rport state diagram
      scsi_transport_srp: Fix kernel-doc warnings

Dan Carpenter (2):
      mlx5_core: Remove dead code
      IB/usnic: Use GFP_ATOMIC under spinlock

David Dillow (1):
      MAINTAINERS: Pass the torch of SRP submaintainership

Devesh Sharma (2):
      RDMA/ocrdma: Fix AV_VALID bit position
      RDMA/ocrdma: Fix OCRDMA_GEN2_FAMILY macro definition

Ding Tianhong (1):
      RDMA/nes: Slight optimization of Ethernet address compare

Eli Cohen (13):
      IB/mlx5: Remove unused code in mr.c
      IB/mlx5: Fix micro UAR allocator
      IB/mlx5: Clear out struct before create QP command
      mlx5_core: Use mlx5 core style warning
      IB/mlx5: Make sure doorbell record is visible before doorbell
      IB/mlx5: Implement modify CQ
      IB/mlx5: Add support for resize CQ
      mlx5_core: Improve debugfs readability
      mlx5_core: Fix PowerPC support
      IB/mlx5: Allow creation of QPs with zero-length work queues
      IB/mlx5: Abort driver cleanup if teardown hca fails
      IB/mlx5: Remove old field for create mkey mailbox
      IB/mlx5: Verify reserved fields are cleared

Haggai Eran (1):
      mlx5_core: Fix out arg size in access_register command

Ira Weiny (1):
      IB/qib: Fix QP check when looping back to/from QP1

Julia Lawall (1):
      IB/mlx4: Fix error return code

Matan Barak (9):
      IB/core: Add flow steering support for IPoIB UD traffic
      IB/core: Add support for IB L2 device-managed steering
      mlx4_core: Add support for steerable IB UD QPs
      IB/mlx4: Enable device-managed steering support for IB ports too
      IB/mlx4: Add mechanism to support flow steering over IB links
      IB/mlx4: Add support for steerable IB UD QPs
      IB/core: Ethernet L2 attributes in verbs/cm structures
      IB/core: Make ib_addr a core IB module
      IB/mlx4: Add dependency INET

Michal Schmidt (1):
      IPoIB: Report operstate consistently when brought up without a link

Moni Shoua (5):
      IB/cma: IBoE (RoCE) IP-based GID addressing
      IB/mlx4: Use IBoE (RoCE) IP based GIDs in the port GID table
      IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing
      RDMA/ocrdma: Handle Ethernet L2 parameters for IP based GID addressing
      RDMA/ocrdma: Populate GID table with IP based gids

Or Gerlitz (2):
      IB/core: Resolve Ethernet L2 addresses when modifying QP
      IB/core: Fix unused variable warning

Paul Bolle (1):
      RDMA/cxgb4: Fix gcc warning on 32-bit arch

Roland Dreier (6):
      IB/usnic: Fix typo "Ignorning" -> "Ignoring"
      RDMA/ocrdma: Move ocrdma_inetaddr_event outside of "#if CONFIG_IPV6"
      RDMA/ocrdma: Add dependency on INET
      IB/mlx4: Use IS_ENABLED(CONFIG_IPV6)
      Merge branches 'cma', 'cxgb4', 'flowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'ocrdma', 'qib', 'srp' and 'usnic' into for-next
      Merge branch 'ip-roce' into for-next

Somnath Kotur (1):
      RDMA/cma: Handle global/non-linklocal IPv6 addresses in cma_check_linklocal()

Svetlana Mavrina (1):
      RDMA/amso1100: Add check if cache memory was allocated before freeing it

Upinder Malhi (22):
      IB/usnic: Add Cisco VIC low-level hardware driver
      IB/usnic: Change WARN_ON to lockdep_assert_held
      IB/usnic: Add struct usnic_transport_spec
      IB/usnic: Push all forwarding state to usnic_fwd.[hc]
      IB/usnic: Port over main.c and verbs.c to the usnic_fwd.h
      IB/usnic: Port over usnic_ib_qp_grp.[hc] to new usnic_fwd.h
      IB/usnic: Port over sysfs to new usnic_fwd.h
      IB/usnic: Update ABI and Version file for UDP support
      IB/usnic: Add UDP support to usnic_fwd.[hc]
      IB:usnic: Add UDP support to usnic_transport.[hc]
      IB/usnic: Add UDP support in u*verbs.c, u*main.c and u*util.h
      IB/usnic: Add UDP support in usnic_ib_qp_grp.[hc]
      IB/core: Add RDMA_TRANSPORT_USNIC_UDP
      IB/usnic: Remove superflous parentheses
      IB/usnic: Use for_each_sg instead of a for-loop
      IB/usnic: Expose flows via debugfs
      IB/usnic: Append documentation to usnic_transport.h and cleanup
      IB/usnic: Fix endianness-related warnings
      IB/usnic: Add dependency on CONFIG_INET
      IB/core: Add support for RDMA_NODE_USNIC_UDP
      IB/usnic: Advertise usNIC devices as RDMA_NODE_USNIC_UDP
      IB/usnic: Set userspace/kernel ABI ver to 4

Wei Yongjun (3):
      IB/usnic: Remove unused variable in usnic_debugfs_exit()
      IB/cm: Fix missing unlock on error in cm_init_qp_rtr_attr()
      IB/usnic: Remove unused includes of <linux/version.h>

 Documentation/scsi/scsi_transport_srp/Makefile     |   7 +
 .../scsi_transport_srp/rport_state_diagram.dot     |  26 +
 MAINTAINERS                                        |   7 +-
 drivers/infiniband/Kconfig                         |   6 +-
 drivers/infiniband/Makefile                        |   1 +
 drivers/infiniband/core/Makefile                   |   5 +-
 drivers/infiniband/core/addr.c                     |  97 ++-
 drivers/infiniband/core/cm.c                       |  52 ++
 drivers/infiniband/core/cma.c                      |  81 ++-
 drivers/infiniband/core/core_priv.h                |   2 +
 drivers/infiniband/core/iwcm.c                     |   3 +-
 drivers/infiniband/core/sa_query.c                 |  12 +-
 drivers/infiniband/core/sysfs.c                    |   1 +
 drivers/infiniband/core/ucma.c                     |  18 +-
 drivers/infiniband/core/uverbs_cmd.c               |   4 +
 drivers/infiniband/core/verbs.c                    | 101 ++-
 drivers/infiniband/hw/amso1100/c2_intr.c           |   3 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   2 +-
 drivers/infiniband/hw/ehca/ehca_qp.c               |   2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c             |   2 +-
 drivers/infiniband/hw/mlx4/Kconfig                 |   2 +-
 drivers/infiniband/hw/mlx4/ah.c                    |  40 +-
 drivers/infiniband/hw/mlx4/cq.c                    |   9 +
 drivers/infiniband/hw/mlx4/main.c                  | 747 +++++++++++++++-----
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  18 +-
 drivers/infiniband/hw/mlx4/qp.c                    | 157 ++++-
 drivers/infiniband/hw/mlx4/sysfs.c                 |   8 +-
 drivers/infiniband/hw/mlx5/cq.c                    | 310 ++++++++-
 drivers/infiniband/hw/mlx5/main.c                  |  13 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   1 -
 drivers/infiniband/hw/mlx5/qp.c                    | 133 ++--
 drivers/infiniband/hw/mlx5/user.h                  |   3 +
 drivers/infiniband/hw/mthca/mthca_qp.c             |   3 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   3 +-
 drivers/infiniband/hw/ocrdma/Kconfig               |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h              |  12 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |  21 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h           |   1 -
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         | 138 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h          |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   3 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |   2 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |   9 +-
 drivers/infiniband/hw/usnic/Kconfig                |  10 +
 drivers/infiniband/hw/usnic/Makefile               |  15 +
 drivers/infiniband/hw/usnic/usnic.h                |  29 +
 drivers/infiniband/hw/usnic/usnic_abi.h            |  73 ++
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h |  27 +
 drivers/infiniband/hw/usnic/usnic_common_util.h    |  68 ++
 drivers/infiniband/hw/usnic/usnic_debugfs.c        | 154 +++++
 drivers/infiniband/hw/usnic/usnic_debugfs.h        |  29 +
 drivers/infiniband/hw/usnic/usnic_fwd.c            | 350 ++++++++++
 drivers/infiniband/hw/usnic/usnic_fwd.h            | 113 +++
 drivers/infiniband/hw/usnic/usnic_ib.h             | 118 ++++
 drivers/infiniband/hw/usnic/usnic_ib_main.c        | 682 ++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      | 754 ++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      | 117 ++++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       | 341 +++++++++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       |  29 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       | 765 +++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |  72 ++
 drivers/infiniband/hw/usnic/usnic_log.h            |  58 ++
 drivers/infiniband/hw/usnic/usnic_transport.c      | 202 ++++++
 drivers/infiniband/hw/usnic/usnic_transport.h      |  51 ++
 drivers/infiniband/hw/usnic/usnic_uiom.c           | 604 ++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_uiom.h           |  80 +++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c | 236 +++++++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h |  73 ++
 drivers/infiniband/hw/usnic/usnic_vnic.c           | 467 +++++++++++++
 drivers/infiniband/hw/usnic/usnic_vnic.h           | 103 +++
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   3 +
 drivers/infiniband/ulp/srp/ib_srp.c                |   1 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   9 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  10 +
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |  17 +
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   5 +
 drivers/net/ethernet/mellanox/mlx4/port.c          |  20 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  39 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  10 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   5 +-
 drivers/scsi/scsi_transport_srp.c                  |  95 ++-
 include/linux/mlx4/cmd.h                           |   1 +
 include/linux/mlx4/cq.h                            |  15 +-
 include/linux/mlx4/device.h                        |   7 +-
 include/linux/mlx5/cq.h                            |  18 +-
 include/linux/mlx5/device.h                        |  31 +-
 include/linux/mlx5/qp.h                            |  45 ++
 include/rdma/ib_addr.h                             |  69 +-
 include/rdma/ib_cm.h                               |   1 +
 include/rdma/ib_pack.h                             |   1 +
 include/rdma/ib_sa.h                               |   3 +
 include/rdma/ib_verbs.h                            |  42 +-
 include/scsi/scsi_transport_srp.h                  |  36 +-
 100 files changed, 7663 insertions(+), 567 deletions(-)
 create mode 100644 Documentation/scsi/scsi_transport_srp/Makefile
 create mode 100644 Documentation/scsi/scsi_transport_srp/rport_state_diagram.dot
 create mode 100644 drivers/infiniband/hw/usnic/Kconfig
 create mode 100644 drivers/infiniband/hw/usnic/Makefile
 create mode 100644 drivers/infiniband/hw/usnic/usnic.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_abi.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_common_util.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_debugfs.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_debugfs.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_fwd.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_fwd.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_main.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_verbs.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_ib_verbs.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_log.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_transport.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_transport.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
 create mode 100644 drivers/infiniband/hw/usnic/usnic_vnic.c
 create mode 100644 drivers/infiniband/hw/usnic/usnic_vnic.h

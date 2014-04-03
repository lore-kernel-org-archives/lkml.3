Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaDCPyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:54:25 -0400
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:51168 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752565AbaDCPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:54:20 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  3 Apr 2014 08:54:12 -0700
Message-Id: <1396540452-25075-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.15:

 - The biggest change is core API extensions and mlx5 low-level driver
   support for handling DIF/DIX-style protection information, and the
   addition of PI support to the iSER initiator.  Target support will be
   arriving shortly through the SCSI target tree.

 - A nice simplification to the "umem" memory pinning library now that
   we have chained sg lists.  Kudos to Yishai Hadas for realizing our
   code didn't have to be so crazy.

 - Another nice simplification to the sg wrappers used by qib, ipath and
   ehca to handle their mapping of memory to adapter.

 - The usual batch of fixes to bugs found by static checkers etc. from
   intrepid people like Dan Carpenter and Yann Droneaud.

 - A large batch of cxgb4, ocrdma, qib driver updates.

----------------------------------------------------------------
Alex Tabachnik (2):
      IB/iser: Introduce pi_enable, pi_guard module parameters
      IB/iser: Initialize T10-PI resources

Ariel Nahum (1):
      IB/iser: Remove struct iscsi_iser_conn

Bart Van Assche (7):
      IB/mlx4: Fix a sparse endianness warning
      scsi_transport_srp: Fix two kernel-doc warnings
      IB/srp: Add more logging
      IB/srp: Avoid duplicate connections
      IB/srp: Make writing into the "add_target" sysfs attribute interruptible
      IB/srp: Avoid that writing into "add_target" hangs due to a cable pull
      IB/srp: Fix a race condition between failing I/O and I/O completion

CQ Tang (1):
      IB/qib: Change SDMA progression mode depending on single- or multi-rail

Dan Carpenter (7):
      IB/qib: Remove duplicate check in get_a_ctxt()
      RDMA/nes: Clean up a condition
      RDMA/cxgb4: Fix underflows in c4iw_create_qp()
      RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()
      IB/qib: Cleanup qib_register_observer()
      mlx4_core: Fix some indenting in mlx4_ib_add()
      mlx4_core: Make buffer larger to avoid overflow warning

Dennis Dalessandro (3):
      IB/qib: Fix potential buffer overrun in sending diag packet routine
      IB/ipath: Fix potential buffer overrun in sending diag packet routine
      IB/qib: Fix memory leak of recv context when driver fails to initialize.

Devesh Sharma (9):
      RDMA/ocrdma: EQ full catastrophe avoidance
      RDMA/ocrdma: SQ and RQ doorbell offset clean up
      RDMA/ocrdma: Read ASIC_ID register to select asic_gen
      RDMA/ocrdma: Allow DPP QP creation
      RDMA/ocrdma: ABI versioning between ocrdma and be2net
      be2net: Add abi version between be2net and ocrdma
      RDMA/ocrdma: Update version string
      RDMA/ocrdma: Increment abi version count
      RDMA/ocrdma: Code clean-up

Fabio Estevam (1):
      IB/usnic: Remove '0x' when using %pa format

Mike Marciniszyn (7):
      IB/qib: Fix debugfs ordering issue with multiple HCAs
      IB/qib: Add percpu counter replacing qib_devdata int_counter
      IB/qib: Modify software pma counters to use percpu variables
      IB/qib: Remove ib_sg_dma_address() and ib_sg_dma_len() overloads
      IB/ipath: Remove ib_sg_dma_address() and ib_sg_dma_len() overloads
      IB/ehca: Remove ib_sg_dma_address() and ib_sg_dma_len() overloads
      IB/core: Remove overload in ib_sg_dma*

Moni Shoua (1):
      IB/core: Don't resolve passive side RoCE L2 address in CMA REQ handler

Or Gerlitz (3):
      IB/iser: Print QP information once connection is established
      IB/iser: Update Mellanox copyright note
      IB/iser: Bump driver version to 1.3

Prarit Bhargava (1):
      RDMA/ocrdma: Fix compiler warning

Randy Dunlap (1):
      IB/iser: Fix sector_t format warning

Roi Dayan (1):
      IB/iser: Drain the tx cq once before looping on the rx cq

Roland Dreier (2):
      RDMA/ocrdma: Fix warnings about pointer <-> integer casts
      Merge branches 'core', 'cxgb4', 'ip-roce', 'iser', 'misc', 'mlx4', 'nes', 'ocrdma', 'qib', 'sgwrapper', 'srp' and 'usnic' into for-next

Sagi Grimberg (23):
      IB/core: Introduce protected memory regions
      IB/core: Introduce signature verbs API
      mlx5: Implement create_mr and destroy_mr
      IB/mlx5: Initialize mlx5_ib_qp signature-related members
      IB/mlx5: Break up wqe handling into begin & finish routines
      IB/mlx5: Remove MTT access mode from umr flags helper function
      IB/mlx5: Keep mlx5 MRs in a radix tree under device
      IB/mlx5: Support IB_WR_REG_SIG_MR
      IB/mlx5: Collect signature error completion
      IB/mlx5: Expose support for signature MR feature
      IB/iser: Suppress completions for fast registration work requests
      IB/iser: Avoid FRWR notation, use fastreg instead
      IB/iser: Push the decision what memory key to use into fast_reg_mr routine
      IB/iser: Move fast_reg_descriptor initialization to a function
      IB/iser: Keep IB device attributes under iser_device
      IB/iser: Replace fastreg descriptor valid bool with indicators container
      IB/iser: Generalize iser_unmap_task_data and finalize_rdma_unaligned_sg
      IB/iser: Generalize fall_to_bounce_buf routine
      IB/iser: Support T10-PI operations
      SCSI/libiscsi: Add check_protection callback for transports
      IB/iser: Implement check_protection
      IB/iser: Publish T10-PI support to SCSI midlayer
      IB/srp: Check ib_query_gid return value

Selvin Xavier (8):
      RDMA/ocrdma: Memory leak fix in ocrdma_dereg_mr()
      RDMA/ocrdma: Use non-zero tag in SRQ posting
      RDMA/ocrdma: Display proper value for max_mw
      RDMA/ocrdma: Handle CQ overrun error
      RDMA/ocrdma: Support non-embedded mailbox commands
      RDMA/ocrdma: Query controller information
      RDMA/ocrdma: Display FW version
      RDMA/ocrdma: Unregister inet notifier when unloading ocrdma

Steve Wise (16):
      RDMA/cxgb4: Cap CQ size at T4_MAX_IQ_SIZE
      RDMA/cxgb4: Allow loopback connections
      RDMA/cxgb4: Always release neigh entry
      RDMA/cxgb4: Fix incorrect BUG_ON conditions
      RDMA/cxgb4: Mind the sq_sig_all/sq_sig_type QP attributes
      RDMA/cxgb4: Default peer2peer mode to 1
      RDMA/cxgb4: Save the correct map length for fast_reg_page_lists
      RDMA/cxgb4: Don't leak skb in c4iw_uld_rx_handler()
      RDMA/cxgb4: Fix possible memory leak in RX_PKT processing
      RDMA/cxgb4: Ignore read reponse type 1 CQEs
      RDMA/cxgb4: Connect_request_upcall fixes
      RDMA/cxgb4: Update snd_seq when sending MPA messages
      RDMA/cxgb4: Lock around accept/reject downcalls
      RDMA/cxgb4: Drop RX_DATA packets if the endpoint is gone
      RDMA/cxgb4: rx_data() needs to hold the ep mutex
      RDMA/cxgb4: Disable DSGL use by default

Tatyana Nikolova (2):
      RDMA/nes: Fixes for IRD/ORD negotiation with MPA v2
      RDMA/nes: Fix for passing a valid QP pointer to the user space library

Yan Burman (1):
      IB/mad: Check and handle potential DMA mapping errors

Yann Droneaud (5):
      IB/qib: add missing braces in do_qib_user_sdma_queue_create()
      IB/qib: fixup indentation in qib_ib_rcv()
      IB/nes: Return an error on ib_copy_from_udata() failure instead of NULL
      IB/mthca: Return an error on ib_copy_to_udata() failure
      IB/ehca: Returns an error on ib_copy_to_udata() failure

Yishai Hadas (1):
      IB: Refactor umem to use linear SG table

 drivers/infiniband/core/cm.c                   |  17 -
 drivers/infiniband/core/cma.c                  |  26 --
 drivers/infiniband/core/mad.c                  |  14 +
 drivers/infiniband/core/umem.c                 | 120 +++--
 drivers/infiniband/core/verbs.c                |  47 ++
 drivers/infiniband/hw/amso1100/c2_provider.c   |  23 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |  19 +-
 drivers/infiniband/hw/cxgb4/cm.c               | 110 +++--
 drivers/infiniband/hw/cxgb4/cq.c               |  31 +-
 drivers/infiniband/hw/cxgb4/device.c           |   6 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h         |   2 +
 drivers/infiniband/hw/cxgb4/mem.c              |  55 +--
 drivers/infiniband/hw/cxgb4/qp.c               |   8 +-
 drivers/infiniband/hw/ehca/ehca_classes.h      |   2 +-
 drivers/infiniband/hw/ehca/ehca_cq.c           |   1 +
 drivers/infiniband/hw/ehca/ehca_mrmw.c         | 257 ++++------
 drivers/infiniband/hw/ipath/ipath_diag.c       |  66 +--
 drivers/infiniband/hw/ipath/ipath_dma.c        |  43 +-
 drivers/infiniband/hw/ipath/ipath_mr.c         |  39 +-
 drivers/infiniband/hw/mlx4/doorbell.c          |   4 +-
 drivers/infiniband/hw/mlx4/main.c              |  11 +-
 drivers/infiniband/hw/mlx4/mr.c                |  39 +-
 drivers/infiniband/hw/mlx4/qp.c                |   2 +-
 drivers/infiniband/hw/mlx5/cq.c                |  62 +++
 drivers/infiniband/hw/mlx5/doorbell.c          |   4 +-
 drivers/infiniband/hw/mlx5/main.c              |  12 +
 drivers/infiniband/hw/mlx5/mem.c               |  80 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  14 +
 drivers/infiniband/hw/mlx5/mr.c                | 157 +++++++
 drivers/infiniband/hw/mlx5/qp.c                | 540 +++++++++++++++++++--
 drivers/infiniband/hw/mthca/mthca_provider.c   |  43 +-
 drivers/infiniband/hw/nes/nes_cm.c             | 121 +++--
 drivers/infiniband/hw/nes/nes_cm.h             |   3 +
 drivers/infiniband/hw/nes/nes_user.h           |   5 +-
 drivers/infiniband/hw/nes/nes_verbs.c          | 261 +++++------
 drivers/infiniband/hw/nes/nes_verbs.h          |   1 +
 drivers/infiniband/hw/ocrdma/Makefile          |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h          | 110 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h      |   7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |   2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c       | 299 +++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h       |   6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     |  81 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h      | 261 ++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c    | 623 +++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h    |  54 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    | 233 ++++-----
 drivers/infiniband/hw/qib/qib.h                |  12 +-
 drivers/infiniband/hw/qib/qib_diag.c           |  52 +--
 drivers/infiniband/hw/qib/qib_dma.c            |  21 +-
 drivers/infiniband/hw/qib/qib_file_ops.c       |   5 +-
 drivers/infiniband/hw/qib/qib_fs.c             |   1 +
 drivers/infiniband/hw/qib/qib_iba6120.c        |  11 +-
 drivers/infiniband/hw/qib/qib_iba7220.c        |  12 +-
 drivers/infiniband/hw/qib/qib_iba7322.c        |  37 +-
 drivers/infiniband/hw/qib/qib_init.c           |  96 ++--
 drivers/infiniband/hw/qib/qib_mad.c            |  44 +-
 drivers/infiniband/hw/qib/qib_mr.c             |  14 +-
 drivers/infiniband/hw/qib/qib_rc.c             |   2 +-
 drivers/infiniband/hw/qib/qib_ruc.c            |   1 +
 drivers/infiniband/hw/qib/qib_ud.c             |   6 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c      | 136 +++++-
 drivers/infiniband/hw/qib/qib_verbs.c          |   8 +-
 drivers/infiniband/hw/qib/qib_verbs.h          |  16 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c       |   2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       |  93 ++--
 drivers/infiniband/ulp/iser/iscsi_iser.h       |  85 +++-
 drivers/infiniband/ulp/iser/iser_initiator.c   | 154 ++++--
 drivers/infiniband/ulp/iser/iser_memory.c      | 470 ++++++++++++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c       | 325 +++++++++----
 drivers/infiniband/ulp/srp/ib_srp.c            |  83 ++--
 drivers/infiniband/ulp/srp/ib_srp.h            |   1 +
 drivers/net/ethernet/emulex/benet/be_roce.c    |   6 +
 drivers/net/ethernet/emulex/benet/be_roce.h    |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c   |  85 ++++
 drivers/scsi/libiscsi.c                        |  32 ++
 drivers/scsi/scsi_transport_srp.c              |   1 +
 include/linux/mlx5/cq.h                        |   1 +
 include/linux/mlx5/device.h                    |  43 ++
 include/linux/mlx5/driver.h                    |  41 ++
 include/linux/mlx5/qp.h                        |  67 +++
 include/rdma/ib_cm.h                           |   1 -
 include/rdma/ib_umem.h                         |  11 +-
 include/rdma/ib_verbs.h                        | 201 +++++++-
 include/scsi/libiscsi.h                        |   4 +
 include/scsi/scsi_transport_iscsi.h            |   1 +
 include/scsi/scsi_transport_srp.h              |   1 -
 88 files changed, 4634 insertions(+), 1475 deletions(-)
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_stats.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_stats.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaJPWw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 18:52:27 -0400
Received: from na3sys010aog103.obsmtp.com ([74.125.245.74]:50902 "HELO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750969AbaJPWw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 18:52:26 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu, 16 Oct 2014 15:52:18 -0700
Message-Id: <1413499938-2378-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
Main set of InfiniBand/RDMA updates for 3.18 merge window:

 - Large set of iSER initiator improvements
 - Hardware driver fixes for cxgb4, mlx5 and ocrdma
 - Small fixes to core midlayer

----------------------------------------------------------------
Ariel Nahum (3):
      IB/iser: Unbind at conn_stop stage
      IB/iser: Use iser_warn instead of BUG_ON in iser_conn_release
      IB/iser: Change iscsi_conn_stop log level to info

Devesh Sharma (3):
      RDMA/ocrdma: Add default GID at index 0
      RDMA/ocrdma: Convert kernel VA to PA for mmap in user
      IB/core: Clear AH attr variable to prevent garbage data

Eli Cohen (5):
      IB/mlx5: Clear umr resources after ib_unregister_device
      IB/mlx5: Improve debug prints in mlx5_ib_reg_user_mr
      IB/core: Avoid leakage from kernel to user space
      IB/mlx5: Fix possible array overflow
      IB/mlx5: Remove duplicate code from mlx5_set_path

Hariprasad S (3):
      RDMA/cxgb4: Take IPv6 into account for best_mtu and set_emss
      RDMA/cxgb4: Add missing neigh_release in find_route
      RDMA/cxgb4: Fix ntuple calculation for ipv6 and remove duplicate line

Jack Morgenstein (1):
      IB/core: Fix XRC race condition in ib_uverbs_open_qp

Jes Sorensen (3):
      RDMA/ocrdma: Don't memset() buffers we just allocated with kzalloc()
      RDMA/ocrdma: The kernel has a perfectly good BIT() macro - use it
      RDMA/ocrdma: Save the bit environment, spare unncessary parenthesis

Li RongQing (1):
      RDMA/ocrdma: Remove a unused-label warning

Or Gerlitz (1):
      IB/iser: Bump version, add maintainer

Roi Dayan (1):
      IB/iser: Remove unused variables and dead code

Roland Dreier (1):
      Merge branches 'core', 'cxgb4', 'iser', 'mlx5' and 'ocrdma' into for-next

Sagi Grimberg (23):
      IB/iser: Rename ib_conn -> iser_conn
      IB/iser: Re-introduce ib_conn
      IB/iser: Extend iser_free_ib_conn_res()
      IB/iser: Fix DEVICE REMOVAL handling in the absence of iscsi daemon
      IB/iser: Don't bound release_work completions timeouts
      IB/iser: Protect tasks cleanup in case IB device was already released
      IB/iser: Signal iSCSI layer that transport is broken in error completions
      IB/iser: Centralize iser completion contexts
      IB/iser: Use internal polling budget to avoid possible live-lock
      IB/iser: Use single CQ for RX and TX
      IB/iser: Use beacon to indicate all completions were consumed
      IB/iser: Optimize completion polling
      IB/iser: Suppress scsi command send completions
      IB/iser: Nit - add space after __func__ in iser logging
      IB/iser: Add/Fix kernel doc style descriptions in iscsi_iser.h
      IB/iser: Fix/add kernel-doc style description in iscsi_iser.c
      IB/mlx5: Use enumerations for PI copy mask
      IB/iser: Remove redundant assignment
      IB/iser: Set IP_CSUM as default guard type
      IB/mlx5: Use extended internal signature layout
      IB/iser: Centralize ib_sig_domain settings
      Target/iser: Centralize ib_sig_domain setting
      IB/mlx5, iser, isert: Add Signature API additions

Selvin Xavier (1):
      RDMA/ocrdma: Get vlan tag from ib_qp_attrs

Steve Wise (1):
      RDMA/cxgb4: Make c4iw_wr_log_size_order static

Yishai Hadas (1):
      IB/mlx5: Modify to work with arbitrary page size

 MAINTAINERS                                  |   1 +
 drivers/infiniband/core/uverbs_cmd.c         |   2 +
 drivers/infiniband/core/uverbs_main.c        |   5 +
 drivers/infiniband/hw/cxgb4/cm.c             |  32 +-
 drivers/infiniband/hw/cxgb4/device.c         |   2 +-
 drivers/infiniband/hw/mlx5/main.c            |   8 +-
 drivers/infiniband/hw/mlx5/mem.c             |  18 +-
 drivers/infiniband/hw/mlx5/mr.c              |   6 +-
 drivers/infiniband/hw/mlx5/qp.c              | 149 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c     |  25 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  12 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h    | 238 +++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  10 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c     | 313 ++++++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 408 +++++++++++-----
 drivers/infiniband/ulp/iser/iser_initiator.c | 198 ++++----
 drivers/infiniband/ulp/iser/iser_memory.c    |  99 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c     | 667 +++++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.c      |  65 ++-
 include/linux/mlx5/qp.h                      |  35 +-
 include/rdma/ib_verbs.h                      |  32 +-
 21 files changed, 1372 insertions(+), 953 deletions(-)

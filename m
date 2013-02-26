Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3BZRlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:41:46 -0500
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:46973 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753405Ab3BZRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:41:45 -0500
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 26 Feb 2013 09:41:37 -0800
Message-Id: <1361900497-11767-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Main batch of InfiniBand/RDMA changes for 3.9:
 - SRP error handling fixes from Bart Van Assche
 - Implementation of memory windows for mlx4 from Shani Michaeli
 - Lots of cxgb4 HW driver fixes from Vipul Pandya
 - Make iSER work for virtual functions, other fixes from Or Gerlitz
 - Fix for bug in qib HW driver from Mike Marciniszyn
 - IPoIB fixes from me, Itai Garbi, Shlomo Pongratz, Yan Burman
 - Various cleanups and warning fixes from Julia Lawall, Paul Bolle, Wei Yongjun

----------------------------------------------------------------
Bart Van Assche (4):
      IB/srp: Track connection state properly
      IB/srp: Avoid sending a task management function needlessly
      IB/srp: Avoid endless SCSI error handling loop
      IB/srp: Fail I/O requests if the transport is offline

Dan Carpenter (1):
      IB/mlx4: Fix bug unwinding on error in mlx4_ib_init_sriov()

Itai Garbi (1):
      IPoIB: Don't attempt to release resources on error flow

Julia Lawall (1):
      IB/mlx4: Adjust duplicate test

Mike Marciniszyn (1):
      IB/qib: Fix QP locate/remove race

Or Gerlitz (3):
      IB/iser: Use proper define for the commands per LUN value advertised to SCSI ML
      IB/iser: Avoid error prints on EAGAIN registration failures
      IB/iser: Enable iser when FMRs are not supported

Paul Bolle (2):
      RDMA/cxgb4: "cookie" can stay in host endianness
      IB/mlx4: Fix compiler warning about uninitialized 'vlan' variable

Roland Dreier (3):
      IB/mlx4: Convert is_xxx variables in build_mlx_header() to bool
      IPoIB: Free ipoib neigh on path record failure so path rec queries are retried
      Merge branches 'core', 'cxgb4', 'ipoib', 'iser', 'misc', 'mlx4', 'qib' and 'srp' into for-next

Shani Michaeli (10):
      IB/mlx4_ib: Remove local invalidate segment unused fields
      mlx4_core: Rename MPT-related functions to have mpt_ prefix
      mlx4_core: Propagate MR deregistration failures to caller
      IB/core: Add "type 2" memory windows support
      IB/uverbs: Implement memory windows support in uverbs
      mlx4_core: Disable memory windows for virtual functions
      mlx4_core: Enable memory windows in {INIT, QUERY}_HCA
      mlx4: Implement memory windows allocation and deallocation
      IB/mlx4: Support memory window binding
      IB/mlx4: Advertise MW support

Shlomo Pongratz (1):
      IPoIB: Fix ipoib_neigh hashing to use the correct daddr octets

Stefan Hasko (1):
      RDMA/cxgb4: Fix cast warning

Syam Sidhardhan (1):
      IB/mlx4: Remove redundant NULL check before kfree

Vipul Pandya (11):
      RDMA/cxgb4: Abort connections that receive unexpected streaming mode data
      RDMA/cxgb4: Abort connections when moving to ERROR state
      RDMA/cxgb4: Display streaming mode error only if detected in RTS
      RDMA/cxgb4: Keep QP referenced until TID released
      RDMA/cxgb4: Always log async errors
      RDMA/cxgb4: Only log rx_data warnings if cpl status is non-zero
      RDMA/cxgb4: Fix endpoint timeout race condition
      RDMA/cxgb4: Don't reconnect on abort for mpa_rev 1
      RDMA/cxgb4: Don't wakeup threads for MPAv2
      RDMA/cxgb4: Insert hwtid in pass_accept_req instead in pass_establish
      RDMA/cxgb4: Address sparse warnings

Wei Yongjun (1):
      RDMA/amso1100: Use module_pci_driver() to simplify the code

Yan Burman (1):
      IPoIB: Add version and firmware info to ethtool reporting

 drivers/infiniband/core/uverbs.h                   |   2 +
 drivers/infiniband/core/uverbs_cmd.c               | 121 ++++++++++++++
 drivers/infiniband/core/uverbs_main.c              |  13 +-
 drivers/infiniband/core/verbs.c                    |   5 +-
 drivers/infiniband/hw/amso1100/c2.c                |  13 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   5 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c              |  15 +-
 drivers/infiniband/hw/cxgb4/cm.c                   | 170 +++++++++++--------
 drivers/infiniband/hw/cxgb4/device.c               |   5 +-
 drivers/infiniband/hw/cxgb4/ev.c                   |   8 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |   4 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   5 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |   1 +
 drivers/infiniband/hw/ehca/ehca_iverbs.h           |   2 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c             |   5 +-
 drivers/infiniband/hw/mlx4/mad.c                   |   7 +-
 drivers/infiniband/hw/mlx4/main.c                  |  22 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  18 +-
 drivers/infiniband/hw/mlx4/mr.c                    |  87 +++++++++-
 drivers/infiniband/hw/mlx4/qp.c                    |  49 ++++--
 drivers/infiniband/hw/mlx4/sysfs.c                 |   2 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |  19 ++-
 drivers/infiniband/hw/qib/qib_qp.c                 |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   4 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  19 ++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  14 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   2 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |   9 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |   8 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |  42 +++--
 drivers/infiniband/ulp/srp/ib_srp.h                |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |   4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  14 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   4 +
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  34 +++-
 drivers/net/ethernet/mellanox/mlx4/mr.c            | 186 ++++++++++++++++-----
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  63 ++++++-
 include/linux/mlx4/device.h                        |  22 ++-
 include/linux/mlx4/qp.h                            |  19 ++-
 include/rdma/ib_verbs.h                            |  73 +++++++-
 include/uapi/rdma/ib_user_verbs.h                  |  16 ++
 net/sunrpc/xprtrdma/verbs.c                        |  20 +--
 43 files changed, 885 insertions(+), 253 deletions(-)

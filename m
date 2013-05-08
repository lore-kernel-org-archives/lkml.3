Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3EHVUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:20:52 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:44456 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751520Ab3EHVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:20:50 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Wed,  8 May 2013 14:20:37 -0700
Message-Id: <1368048037-7958-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

InfiniBand/RDMA changes for the 3.10 merge window:
 - XRC transport fixes
 - Fix DHCP on IPoIB
 - mlx4 preparations for flow steering
 - iSER fixes
 - miscellaneous other fixes

Sorry for being so late on this -- I moved houses and the system with
all my private keys was offline for a week or so.

----------------------------------------------------------------
Akinobu Mita (1):
      RDMA: Rename random32() to prandom_u32()

Cong Ding (1):
      RDMA/cxgb3: Fix uninitialized variable

Dotan Barak (1):
      IB/mlx4: Disable VLAN stripping for RAW PACKET QPs

Doug Ledford (1):
      IPoIB: Fix ipoib_hard_header() return value

Eli Cohen (1):
      IB/mlx4: Set link type for RAW PACKET QPs in the QP context

Grant Grundler (1):
      SRPT: Fix odd use of WARN_ON()

Hadar Hen Zion (5):
      mlx4_core: Move DMFS HW structs to common header file
      mlx4: Match DMFS promiscuous field names to firmware spec
      mlx4_core: Change a few DMFS fields names to match firmare spec
      mlx4_core: Directly expose fields of DMFS HW rule control segment
      mlx4_core: Expose a few helpers to fill DMFS HW strucutures

Jack Morgenstein (1):
      mlx4_core: Reduce warning message for SRQ_LIMIT event to debug level

Mike Marciniszyn (2):
      IB/ipath: Correct ipath_verbs_register_sysfs() error handling
      IB/qib: Correct qib_verbs_register_sysfs() error handling

Or Gerlitz (2):
      IB/iser: Return error to upper layers on EAGAIN registration failures
      IB/iser: Add support for iser CM REQ additional info

Roi Dayan (2):
      IB/iser: Add module version
      IB/iser: Move informational messages from error to info level

Roland Dreier (1):
      Merge branches 'cxgb4', 'ipoib', 'iser', 'misc', 'mlx4', 'qib' and 'srp' into for-next

Shlomo Pongratz (3):
      IB/core: Verify that QP handler is valid before dispatching events
      mlx4_core: Implement SRQ object lookup from srqn
      IB/mlx4: Fetch XRC SRQ in the CQ polling code

Steve Wise (1):
      RDMA/iwcm: Don't touch cmid after dropping reference

Thadeu Lima de Souza Cascardo (1):
      RDMA/cxgb4: Fix SQ allocation when on-chip SQ is disabled

 drivers/infiniband/core/iwcm.c                  |   2 +
 drivers/infiniband/core/verbs.c                 |   3 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c     |   4 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |   2 +-
 drivers/infiniband/hw/cxgb4/id_table.c          |   4 +-
 drivers/infiniband/hw/cxgb4/qp.c                |  25 ++---
 drivers/infiniband/hw/ipath/ipath_verbs.c       |  19 ++--
 drivers/infiniband/hw/mlx4/cq.c                 |  21 +++++
 drivers/infiniband/hw/mlx4/mad.c                |   2 +-
 drivers/infiniband/hw/mlx4/qp.c                 |   6 ++
 drivers/infiniband/hw/qib/qib_sysfs.c           |   6 +-
 drivers/infiniband/hw/qib/qib_verbs.c           |   3 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |   2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c        |  24 ++---
 drivers/infiniband/ulp/iser/iscsi_iser.h        |  24 ++++-
 drivers/infiniband/ulp/iser/iser_memory.c       |   3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c        |  36 ++++---
 drivers/infiniband/ulp/srpt/ib_srpt.c           |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |  16 ++--
 drivers/net/ethernet/mellanox/mlx4/eq.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c        | 120 +++++++++++++++---------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h       |  79 ----------------
 drivers/net/ethernet/mellanox/mlx4/srq.c        |  15 +++
 include/linux/mlx4/device.h                     | 104 ++++++++++++++++++--
 include/linux/mlx4/srq.h                        |   2 +
 27 files changed, 328 insertions(+), 204 deletions(-)

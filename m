Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaIWWEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:04:38 -0400
Received: from na3sys010aog105.obsmtp.com ([74.125.245.78]:42537 "HELO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755000AbaIWWEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:04:36 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 18:04:36 EDT
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Tue, 23 Sep 2014 14:58:21 -0700
Message-Id: <1411509501-23138-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

This is later and bigger than I would like, and the blame is all on
me: I got very busy with other stuff for a few weeks during the 3.17
cycle, and didn't prepare this tree as soon as I should have.  However
I don't think there's anything risky here, and no one really cares if
we break InfiniBand in 3.17 anyway...

----------------------------------------------------------------
Last late set of InfiniBand/RDMA fixes for 3.17:

 - Fixes for the new memory region re-registration support
 - iSER initiator error path fixes
 - Grab bag of small fixes for the qib and ocrdma hardware drivers
 - Larger set of fixes for mlx4, especially in RoCE mode

----------------------------------------------------------------
Alex Estrin (1):
      IPoIB: Remove unnecessary port query

Devesh Sharma (2):
      RDMA/ocrdma: Report correct value of max_fast_reg_page_list_len
      RDMA/ocrdma: Do not skip setting deferred_arm

Jack Morgenstein (6):
      IB/mlx4: Fix lockdep splat for the iboe lock
      mlx4: Fix mlx4 reg/unreg mac to work properly with 0-mac addresses
      IB/mlx4: Avoid accessing netdevice when building RoCE qp1 header
      IB/mlx4: Don't update QP1 in native mode
      IB/mlx4: Do not allow APM under RoCE
      IB/mlx4: Fix VF mac handling in RoCE

Markus Stockhausen (1):
      IB/mlx4: Disable TSO for Connect-X rev. A0 HCAs

Matan Barak (2):
      mlx4: Correct error flows in rereg_mr
      IB/core: When marshaling uverbs path, clear unused fields

Mike Marciniszyn (3):
      IB/ipath: Change get_user_pages() usage to always NULL vmas
      IB/qib: Change get_user_pages() usage to always NULL vmas
      IB/qib: Correct reference counting in debugfs qp_stats

Moni Shoua (5):
      IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
      IB/mlx4: Don't duplicate the default RoCE GID
      IB/mlx4: Reorder steps in RoCE GID table initialization
      IB/mlx4: Get upper dev addresses as RoCE GIDs when port comes up
      IB/mlx4: Avoid executing gid task when device is being removed

Or Gerlitz (1):
      IB/iser: Bump version to 1.4.1

Roi Dayan (1):
      IB/iser: Fix RX/TX CQ resource leak on error flow

Roland Dreier (1):
      Merge branches 'core', 'ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next

Sagi Grimberg (1):
      IB/iser: Allow bind only when connection state is UP

Shawn Bohrer (1):
      IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get

devesh.sharma@emulex.com (2):
      RDMA/ocrdma: Resolve L2 address when creating user AH
      RDMA/ocrdma: Use right macro in query AH

 drivers/infiniband/core/umem.c                 |  19 ++-
 drivers/infiniband/core/uverbs_marshall.c      |   4 +
 drivers/infiniband/hw/ipath/ipath_user_pages.c |   6 +-
 drivers/infiniband/hw/mlx4/main.c              | 169 +++++++++++++++++--------
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   1 +
 drivers/infiniband/hw/mlx4/mr.c                |   7 +-
 drivers/infiniband/hw/mlx4/qp.c                |  60 +++++----
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c       |  43 +++++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |   6 +-
 drivers/infiniband/hw/qib/qib_debugfs.c        |   3 +-
 drivers/infiniband/hw/qib/qib_qp.c             |   8 --
 drivers/infiniband/hw/qib/qib_user_pages.c     |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  10 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       |  19 ++-
 drivers/infiniband/ulp/iser/iscsi_iser.h       |   2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c       |  24 ++--
 drivers/net/ethernet/mellanox/mlx4/mr.c        |  33 +++--
 drivers/net/ethernet/mellanox/mlx4/port.c      |  11 +-
 include/rdma/ib_umem.h                         |   1 +
 19 files changed, 277 insertions(+), 155 deletions(-)

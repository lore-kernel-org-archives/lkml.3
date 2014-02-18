Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaBRKH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:07:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbaBRKGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:06:48 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com, linux-net-drivers@solarflare.com,
        linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pv-drivers@vmware.com,
        wil6210@qca.qualcomm.com
Subject: [PATCH net-next 00/35] net: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:07:52 +0100
Message-Id: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Cc: e1000-devel@lists.sourceforge.net
Cc: linux-driver@qlogic.com
Cc: linux-net-drivers@solarflare.com
Cc: linux-pci@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: pv-drivers@vmware.com
Cc: wil6210@qca.qualcomm.com

Alexander Gordeev (35):
  bnx2: Use pci_enable_msix_range() instead of pci_enable_msix()
  bnx2x: Use pci_enable_msix_range() instead of pci_enable_msix()
  tg3: Use pci_enable_msix_range() instead of pci_enable_msix()
  bna: Use pci_enable_msix_range() instead of pci_enable_msix()
  cxgb3: Remove superfluous call to pci_disable_msix()
  cxgb3: Use pci_enable_msix_range() instead of pci_enable_msix()
  cxgb4: Use pci_enable_msix_range() instead of pci_enable_msix()
  cxgb4vf: Remove superfluous call to pci_disable_msix()
  cxgb4vf: Use pci_enable_msix_range() instead of pci_enable_msix()
  enic: Use pci_enable_msix_range() instead of pci_enable_msix()
  benet: Use pci_enable_msix_range() instead of pci_enable_msix()
  e1000e: Use pci_enable_msix_range() instead of pci_enable_msix()
  i40e: Use pci_enable_msix_range() instead of pci_enable_msix()
  igb: Use pci_enable_msix_range() instead of pci_enable_msix()
  igbvf: Use pci_enable_msix_range() instead of pci_enable_msix()
  ixgbe: Use pci_enable_msix_range() instead of pci_enable_msix()
  ixgbevf: Use pci_enable_msix_range() instead of pci_enable_msix()
  mlx4: Use pci_enable_msix_range() instead of pci_enable_msix()
  mlx5: Use pci_enable_msix_range() instead of pci_enable_msix()
  myri10ge: Use pci_enable_msix_range() instead of pci_enable_msix()
  s2io: Use pci_enable_msix_range() instead of pci_enable_msix()
  vxge: Use pci_enable_msix_range() instead of pci_enable_msix()
  forcedeth: Fix invalid errno reporting in nv_request_irq()
  forcedeth: Cleanup MSI-X to MSI to INTx fallback code
  forcedeth: Use pci_enable_msix_range() instead of pci_enable_msix()
  netxen: Use pci_enable_msix_range() instead of pci_enable_msix()
  qlcnic: Cleanup qlcnic_enable_msix() return values
  qlcnic: Use pci_enable_msix_range() instead of pci_enable_msix()
  qlge: Get rid of an redundant assignment
  qlge: Use pci_enable_msix_range() instead of pci_enable_msix()
  sfc: Use pci_enable_msix_range() instead of pci_enable_msix()
  niu: Use pci_enable_msix_range() instead of pci_enable_msix()
  vmxnet3: Fix MSI-X/MSI enablement code
  vmxnet3: Use pci_enable_msix_range() instead of pci_enable_msix()
  wil6210: Use pci_enable_msi_range() instead of pci_enable_msi_block()

 drivers/net/ethernet/broadcom/bnx2.c               |   15 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   46 ++++-----
 drivers/net/ethernet/broadcom/tg3.c                |    6 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   23 ++---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   26 ++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   50 +++++-----
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   35 +++----
 drivers/net/ethernet/cisco/enic/enic_main.c        |    6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   31 +++---
 drivers/net/ethernet/intel/e1000e/netdev.c         |   11 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   33 +-----
 drivers/net/ethernet/intel/igb/igb_main.c          |    9 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |   16 +--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   32 ++----
 drivers/net/ethernet/mellanox/mlx4/main.c          |   21 +---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   16 +--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   40 ++++----
 drivers/net/ethernet/neterion/s2io.c               |    5 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   15 ++-
 drivers/net/ethernet/nvidia/forcedeth.c            |   41 +++++---
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   18 ++--
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   16 +--
 drivers/net/ethernet/sfc/efx.c                     |   20 ++--
 drivers/net/ethernet/sun/niu.c                     |   11 +--
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  110 ++++++++-----------
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   32 +++---
 28 files changed, 295 insertions(+), 400 deletions(-)

-- 
1.7.7.6


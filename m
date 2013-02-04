Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3BDD2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:28:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49354 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258Ab3BDD2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:28:42 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-hams@vger.kernel.org,
        linux-usb@vger.kernel.org, virtualization@lists.linux-foundation.org,
        wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, libertas-dev@lists.infradead.org
Subject: [PATCH 0/8] drivers/net: Remove unnecessary alloc/OOM messages
Date: Sun,  3 Feb 2013 19:28:07 -0800
Message-Id: <cover.1359939012.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the OOM messages that follow kernel alloc
failures as there is already a generic equivalent to
these messages in the mm subsystem.

Joe Perches (8):
  caif: Remove unnecessary alloc/OOM messages
  can: Remove unnecessary alloc/OOM messages
  ethernet: Remove unnecessary alloc/OOM messages, alloc cleanups
  drivers: net: usb: Remove unnecessary alloc/OOM messages
  wan: Remove unnecessary alloc/OOM messages
  wimax: Remove unnecessary alloc/OOM messages, alloc cleanups
  wireless: Remove unnecessary alloc/OOM messages, alloc cleanups
  drivers:net:misc: Remove unnecessary alloc/OOM messages

 drivers/net/caif/caif_shmcore.c                    |  6 -----
 drivers/net/can/sja1000/ems_pci.c                  |  1 -
 drivers/net/can/sja1000/peak_pci.c                 |  5 +---
 drivers/net/can/sja1000/peak_pcmcia.c              |  1 -
 drivers/net/can/sja1000/plx_pci.c                  |  1 -
 drivers/net/can/usb/ems_usb.c                      |  4 +---
 drivers/net/can/usb/kvaser_usb.c                   |  2 --
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  5 ----
 drivers/net/can/usb/usb_8dev.c                     |  4 +---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  6 ++---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  2 --
 drivers/net/ethernet/broadcom/b44.c                |  4 +---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |  6 ++---
 drivers/net/ethernet/broadcom/cnic.c               |  6 ++---
 drivers/net/ethernet/broadcom/tg3.c                |  4 +---
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  9 ++++----
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  4 +---
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c           | 19 +++++----------
 drivers/net/ethernet/ibm/emac/mal.c                |  7 ++----
 drivers/net/ethernet/ibm/ibmveth.c                 |  1 -
 drivers/net/ethernet/intel/igb/igb_main.c          |  5 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c          |  8 +++----
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  8 +++----
 drivers/net/ethernet/marvell/mvmdio.c              |  1 -
 drivers/net/ethernet/marvell/skge.c                |  5 ++--
 drivers/net/ethernet/marvell/sky2.c                |  4 +---
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |  4 +---
 drivers/net/ethernet/mellanox/mlx4/main.c          |  4 +---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  5 ++--
 .../net/ethernet/qlogic/netxen/netxen_nic_ctx.c    |  5 +---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c | 18 ++++-----------
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   | 27 ++++++++--------------
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  5 +---
 drivers/net/ethernet/qlogic/qla3xxx.c              | 10 ++++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  | 14 ++++-------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |  6 ++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   | 26 +++++++--------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   | 19 +++++----------
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |  7 ++----
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |  1 -
 drivers/net/ethernet/rdc/r6040.c                   |  3 +--
 drivers/net/ethernet/renesas/sh_eth.c              | 10 ++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 11 +++++----
 drivers/net/ethernet/sun/niu.c                     |  2 +-
 drivers/net/ethernet/ti/cpsw.c                     |  8 +++----
 drivers/net/ethernet/ti/davinci_mdio.c             |  4 +---
 drivers/net/ethernet/xilinx/ll_temac_main.c        |  6 ++---
 drivers/net/hamradio/dmascc.c                      |  7 +-----
 drivers/net/phy/spi_ks8995.c                       |  4 +---
 drivers/net/usb/ax88172a.c                         |  6 ++---
 drivers/net/usb/hso.c                              | 25 ++++++--------------
 drivers/net/usb/sierra_net.c                       | 10 +++-----
 drivers/net/usb/smsc75xx.c                         |  6 ++---
 drivers/net/usb/smsc95xx.c                         |  6 ++---
 drivers/net/usb/usbnet.c                           |  5 +---
 drivers/net/virtio_net.c                           |  4 +---
 drivers/net/wan/cosa.c                             |  9 ++++----
 drivers/net/wan/farsync.c                          |  6 ++---
 drivers/net/wan/hdlc.c                             |  9 ++++----
 drivers/net/wan/x25_asy.c                          |  1 -
 drivers/net/wimax/i2400m/rx.c                      | 16 ++++---------
 drivers/net/wimax/i2400m/usb-notif.c               |  1 -
 drivers/net/wireless/airo_cs.c                     |  5 ++--
 drivers/net/wireless/at76c50x-usb.c                |  4 +---
 .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |  6 ++---
 drivers/net/wireless/atmel_cs.c                    |  5 ++--
 drivers/net/wireless/ipw2x00/ipw2100.c             |  9 +++-----
 drivers/net/wireless/libertas/cfg.c                |  4 +---
 drivers/net/wireless/mwifiex/11n.c                 |  5 +---
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |  5 +---
 drivers/net/wireless/mwifiex/cfg80211.c            |  4 +---
 drivers/net/wireless/mwifiex/cmdevt.c              | 11 +++------
 drivers/net/wireless/mwifiex/init.c                |  5 +---
 drivers/net/wireless/mwifiex/scan.c                | 27 +++++++---------------
 drivers/net/wireless/mwifiex/sdio.c                | 11 ++-------
 drivers/net/wireless/mwifiex/sta_ioctl.c           | 11 +++------
 drivers/net/wireless/mwifiex/wmm.c                 |  7 ++----
 drivers/net/wireless/orinoco/main.c                | 16 ++++---------
 drivers/net/wireless/p54/p54usb.c                  | 10 ++------
 drivers/net/wireless/prism54/islpci_mgt.c          | 14 ++++-------
 drivers/net/wireless/rndis_wlan.c                  |  5 +---
 drivers/net/wireless/ti/wlcore/sdio.c              |  4 +---
 drivers/net/wireless/ti/wlcore/spi.c               | 14 +++--------
 drivers/net/wireless/zd1211rw/zd_usb.c             |  1 -
 84 files changed, 185 insertions(+), 436 deletions(-)

-- 
1.8.0.dirty


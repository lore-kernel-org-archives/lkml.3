Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316Ab3GWUVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:21:31 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23547 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3GWUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:21:29 -0400
Message-ID: <cover.1374609948.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 23 Jul 2013 16:05:48 -0400
Subject: [PATCH 00/13] update tile network drivers
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains changes made to the Tilera on-chip
network drivers for both the 64-bit tilegx and 32-bit tilepro
architectures.  The changes involve a number of bug fixes, support
for the multiple mPIPEs on the new Gx72 chip, support for jumbo
frames, TSO for IPv6, GRO, PTP support, and statistics improvements.

The series can be pulled from:

git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git tile-net-next

Chris Metcalf (13):
  tile: handle 64-bit statistics in tilepro network driver
  tile: support rx_dropped/rx_errors in tilepro net driver
  tile: avoid bug in tilepro net driver built with old hypervisor
  tile: remove dead is_dup_ack() function from tilepro net driver
  tile: support PTP using the tilegx mPIPE (IEEE 1588)
  tile: support jumbo frames in the tilegx network driver
  tile: update dev->stats directly in tilegx network driver
  tile: fix panic bug in napi support for tilegx network driver
  tile: enable GRO in the tilegx network driver
  tile: support multiple mPIPE shims in tilegx network driver
  tile: support TSO for IPv6 in tilegx network driver
  tile: make "tile_net.custom" a proper bool module parameter
  tile: remove deprecated NETIF_F_LLTX flag from tile drivers

 arch/tile/gxio/iorpc_mpipe.c              |  66 +++
 arch/tile/gxio/iorpc_mpipe_info.c         |  18 +
 arch/tile/gxio/mpipe.c                    |  44 +-
 arch/tile/include/gxio/iorpc_mpipe.h      |   8 +
 arch/tile/include/gxio/iorpc_mpipe_info.h |   4 +
 arch/tile/include/gxio/mpipe.h            | 142 ++++-
 arch/tile/include/hv/drv_mpipe_intf.h     |   3 +
 drivers/net/ethernet/tile/Makefile        |   1 +
 drivers/net/ethernet/tile/tilegx.c        | 954 ++++++++++++++++++------------
 drivers/net/ethernet/tile/tilegx_ptp.c    | 212 +++++++
 drivers/net/ethernet/tile/tilepro.c       | 171 ++----
 drivers/ptp/Kconfig                       |  10 +
 12 files changed, 1127 insertions(+), 506 deletions(-)
 create mode 100644 drivers/net/ethernet/tile/tilegx_ptp.c

-- 
1.8.3.1


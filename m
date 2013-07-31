Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3GaPVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:21:38 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31236 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255Ab3GaPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:21:36 -0400
Message-ID: <cover.1375283104.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1374609948.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 31 Jul 2013 11:05:04 -0400
Subject: [PATCH v2 00/12] update tile network drivers
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Richard Cochran <richardcochran@gmail.com> Eric Dumazet" 
	<eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the patch series to update the Tilera network drivers.

>From the v1 00/13 cover letter: "This patch series contains changes made
to the Tilera on-chip network drivers for both the 64-bit tilegx and
32-bit tilepro architectures.  The changes involve a number of bug fixes,
support for the multiple mPIPEs on the new Gx72 chip, support for jumbo
frames, TSO for IPv6, GRO, PTP support, and statistics improvements."

David has already applied the v2 patch for what was patch 01/13 in the
first series ("handle 64-bit statistics in tilepro network driver")
so it is not included in this v2 series.

Changes from the v1 series include:

- Nearly complete rewrite of PTP changes based on feedback from
  Richard Cochran
- Removal of NETIF_F_GRO as unnecessary (from Eric Dumazet)
- A few minor whitespace and code style changes

The revised PTP change (12/12 in this series) was already posted
separately, but this version includes one whitespace tweak (leading tabs
instead of spaces on one line) that I missed in the initial PTP v2,
as well as the Acked-by from Richard Cochran.

Chris Metcalf (12):
  tile: support rx_dropped/rx_errors in tilepro net driver
  tile: avoid bug in tilepro net driver built with old hypervisor
  tile: remove dead is_dup_ack() function from tilepro net driver
  tile: support jumbo frames in the tilegx network driver
  tile: update dev->stats directly in tilegx network driver
  tile: fix panic bug in napi support for tilegx network driver
  tile: enable GRO in the tilegx network driver
  tile: support multiple mPIPE shims in tilegx network driver
  tile: support TSO for IPv6 in tilegx network driver
  tile: make "tile_net.custom" a proper bool module parameter
  tile: remove deprecated NETIF_F_LLTX flag from tile drivers
  tile: support PTP using the tilegx mPIPE (IEEE 1588)

 arch/tile/gxio/iorpc_mpipe.c              |   66 ++
 arch/tile/gxio/iorpc_mpipe_info.c         |   18 +
 arch/tile/gxio/mpipe.c                    |   43 +-
 arch/tile/include/gxio/iorpc_mpipe.h      |   14 +-
 arch/tile/include/gxio/iorpc_mpipe_info.h |    4 +
 arch/tile/include/gxio/mpipe.h            |  143 +++-
 arch/tile/include/hv/drv_mpipe_intf.h     |    3 +
 drivers/net/ethernet/tile/Kconfig         |   11 +
 drivers/net/ethernet/tile/tilegx.c        | 1097 +++++++++++++++++++----------
 drivers/net/ethernet/tile/tilepro.c       |  129 +---
 10 files changed, 1046 insertions(+), 482 deletions(-)

-- 
1.8.3.1


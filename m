Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaGXLvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:51:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20525 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaGXLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:51:08 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 0/6] net/macb: add HW features to macb driver
Date: Thu, 24 Jul 2014 13:50:57 +0200
Message-ID: <cover.1406192657.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series of patches adds new hardware features to macb driver. These
features can be enabled/disabled at runtime using ethtool. Depending on
hardware and design configuration, some are enabled by default whereas other
are disabled.

For instance, checksum offload features are enabled by default for gem designed
for packet buffer mode but disabled for fifo mode design or for old macb.

Besides, the scatter-gather feature is enabled and tested on macb but disabled
on sama5d3x gem. When testing this feature on sama5d3x gem, TX lockups occured
frequently.

Also, the RX checksum offload feature is enabled at GEM level only when both
IFF_PROMISC bit is clear in dev->flags and NETIF_F_RXCSUM bit is set in
dev->features.

These patches were made for net-next.git repository.

Cyrille Pitchen (5):
  net/macb: add scatter-gather hw feature
  net/macb: add TX checksum offload feature
  net/macb: add RX checksum offload feature
  ARM: at91: change compatibility string for sama5d3x gem
  net/macb: enable scatter-gather feature and set DMA burst length for
    sama5d4 gem

Nicolas Ferre (1):
  net/macb: configure for FIFO mode and non-gigabit

 arch/arm/boot/dts/sama5d3_gmac.dtsi |   2 +-
 drivers/net/ethernet/cadence/macb.c | 419 ++++++++++++++++++++++++++++++------
 drivers/net/ethernet/cadence/macb.h |  53 ++++-
 3 files changed, 399 insertions(+), 75 deletions(-)

-- 
1.8.2.2


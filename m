Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbaGROVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:21:25 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:37012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761268AbaGROVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:21:23 -0400
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/6] net/macb: add HW features to macb driver
Date: Fri, 18 Jul 2014 16:21:12 +0200
Message-ID: <cover.1405689937.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
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
 drivers/net/ethernet/cadence/macb.c | 409 ++++++++++++++++++++++++++++++------
 drivers/net/ethernet/cadence/macb.h |  36 +++-
 3 files changed, 375 insertions(+), 72 deletions(-)

-- 
1.8.2.2


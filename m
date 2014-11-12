Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaKLBUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaKLBUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 026/319] stmmac: pci: set default of the filter bins
Date: Wed, 12 Nov 2014 10:12:44 +0900
Message-Id: <20141112010957.016758254@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1e19e084eae727654052339757ab7f1eaff58bad ]

The commit 3b57de958e2a brought the support for a different amount of the
filter bins, but didn't update the PCI driver accordingly. This patch appends
the default values when the device is enumerated via PCI bus.

Fixes: 3b57de958e2a (net: stmmac: Support devicetree configs for mcast and ucast filter entries)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -33,6 +33,7 @@ static struct stmmac_dma_cfg dma_cfg;
 static void stmmac_default_data(void)
 {
 	memset(&plat_dat, 0, sizeof(struct plat_stmmacenet_data));
+
 	plat_dat.bus_id = 1;
 	plat_dat.phy_addr = 0;
 	plat_dat.interface = PHY_INTERFACE_MODE_GMII;
@@ -47,6 +48,12 @@ static void stmmac_default_data(void)
 	dma_cfg.pbl = 32;
 	dma_cfg.burst_len = DMA_AXI_BLEN_256;
 	plat_dat.dma_cfg = &dma_cfg;
+
+	/* Set default value for multicast hash bins */
+	plat_dat.multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat_dat.unicast_filter_entries = 1;
 }
 
 /**



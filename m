Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3IXVKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:10:46 -0400
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:49182 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071Ab3IXVKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1535:1606:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2904:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4117:4321:4385:4605:5007:6261:7903:10004:10026:10848:11026:11473:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tail19_55884edcbb27
X-Filterd-Recvd-Size: 6085
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] stmicro: Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:10:00 -0700
Message-Id: <d6cc64ef73f74edfc485fefb5e6dc2ba625bd675.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h    | 12 ++++++------
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h | 17 ++++++++---------
 drivers/net/ethernet/stmicro/stmmac/mmc.h       |  6 +++---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h    | 10 +++++-----
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 7eb8bab..fc94f20 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -451,14 +451,14 @@ struct mac_device_info {
 struct mac_device_info *dwmac1000_setup(void __iomem *ioaddr);
 struct mac_device_info *dwmac100_setup(void __iomem *ioaddr);
 
-extern void stmmac_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
-				unsigned int high, unsigned int low);
-extern void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
-				unsigned int high, unsigned int low);
+void stmmac_set_mac_addr(void __iomem *ioaddr, u8 addr[6],
+			 unsigned int high, unsigned int low);
+void stmmac_get_mac_addr(void __iomem *ioaddr, unsigned char *addr,
+			 unsigned int high, unsigned int low);
 
-extern void stmmac_set_mac(void __iomem *ioaddr, bool enable);
+void stmmac_set_mac(void __iomem *ioaddr, bool enable);
 
-extern void dwmac_dma_flush_tx_fifo(void __iomem *ioaddr);
+void dwmac_dma_flush_tx_fifo(void __iomem *ioaddr);
 extern const struct stmmac_ring_mode_ops ring_mode_ops;
 extern const struct stmmac_chain_mode_ops chain_mode_ops;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
index 8e5662c..def266d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h
@@ -104,14 +104,13 @@
 #define DMA_STATUS_TI	0x00000001	/* Transmit Interrupt */
 #define DMA_CONTROL_FTF		0x00100000	/* Flush transmit FIFO */
 
-extern void dwmac_enable_dma_transmission(void __iomem *ioaddr);
-extern void dwmac_enable_dma_irq(void __iomem *ioaddr);
-extern void dwmac_disable_dma_irq(void __iomem *ioaddr);
-extern void dwmac_dma_start_tx(void __iomem *ioaddr);
-extern void dwmac_dma_stop_tx(void __iomem *ioaddr);
-extern void dwmac_dma_start_rx(void __iomem *ioaddr);
-extern void dwmac_dma_stop_rx(void __iomem *ioaddr);
-extern int dwmac_dma_interrupt(void __iomem *ioaddr,
-			       struct stmmac_extra_stats *x);
+void dwmac_enable_dma_transmission(void __iomem *ioaddr);
+void dwmac_enable_dma_irq(void __iomem *ioaddr);
+void dwmac_disable_dma_irq(void __iomem *ioaddr);
+void dwmac_dma_start_tx(void __iomem *ioaddr);
+void dwmac_dma_stop_tx(void __iomem *ioaddr);
+void dwmac_dma_start_rx(void __iomem *ioaddr);
+void dwmac_dma_stop_rx(void __iomem *ioaddr);
+int dwmac_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x);
 
 #endif /* __DWMAC_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/mmc.h b/drivers/net/ethernet/stmicro/stmmac/mmc.h
index 48ec001..8607488 100644
--- a/drivers/net/ethernet/stmicro/stmmac/mmc.h
+++ b/drivers/net/ethernet/stmicro/stmmac/mmc.h
@@ -128,8 +128,8 @@ struct stmmac_counters {
 	unsigned int mmc_rx_icmp_err_octets;
 };
 
-extern void dwmac_mmc_ctrl(void __iomem *ioaddr, unsigned int mode);
-extern void dwmac_mmc_intr_all_mask(void __iomem *ioaddr);
-extern void dwmac_mmc_read(void __iomem *ioaddr, struct stmmac_counters *mmc);
+void dwmac_mmc_ctrl(void __iomem *ioaddr, unsigned int mode);
+void dwmac_mmc_intr_all_mask(void __iomem *ioaddr);
+void dwmac_mmc_read(void __iomem *ioaddr, struct stmmac_counters *mmc);
 
 #endif /* __MMC_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index f16a9bd..22f89ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -110,14 +110,14 @@ struct stmmac_priv {
 
 extern int phyaddr;
 
-extern int stmmac_mdio_unregister(struct net_device *ndev);
-extern int stmmac_mdio_register(struct net_device *ndev);
-extern void stmmac_set_ethtool_ops(struct net_device *netdev);
+int stmmac_mdio_unregister(struct net_device *ndev);
+int stmmac_mdio_register(struct net_device *ndev);
+void stmmac_set_ethtool_ops(struct net_device *netdev);
 extern const struct stmmac_desc_ops enh_desc_ops;
 extern const struct stmmac_desc_ops ndesc_ops;
 extern const struct stmmac_hwtimestamp stmmac_ptp;
-extern int stmmac_ptp_register(struct stmmac_priv *priv);
-extern void stmmac_ptp_unregister(struct stmmac_priv *priv);
+int stmmac_ptp_register(struct stmmac_priv *priv);
+void stmmac_ptp_unregister(struct stmmac_priv *priv);
 int stmmac_freeze(struct net_device *ndev);
 int stmmac_restore(struct net_device *ndev);
 int stmmac_resume(struct net_device *ndev);
-- 
1.8.1.2.459.gbcd45b4.dirty


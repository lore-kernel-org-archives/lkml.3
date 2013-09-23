Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3IWWL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:11:57 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:50721 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754418Ab3IWWL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4605:5007:6261:7903:10004:10026:10848:11026:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skin15_2db8381b5730c
X-Filterd-Recvd-Size: 4269
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Rasesh Mody <rmody@brocade.com>
Subject: [PATCH 07/10] brocade: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:34 -0700
Message-Id: <068587054a8cd5308d1fdf6a5f9bde1078a50cee.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
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
 drivers/net/ethernet/brocade/bna/bnad.h | 43 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.h b/drivers/net/ethernet/brocade/bna/bnad.h
index aefee77..f7e033f 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.h
+++ b/drivers/net/ethernet/brocade/bna/bnad.h
@@ -372,38 +372,37 @@ extern u32		bnad_rxqs_per_cq;
 /*
  * EXTERN PROTOTYPES
  */
-extern u32 *cna_get_firmware_buf(struct pci_dev *pdev);
+u32 *cna_get_firmware_buf(struct pci_dev *pdev);
 /* Netdev entry point prototypes */
-extern void bnad_set_rx_mode(struct net_device *netdev);
-extern struct net_device_stats *bnad_get_netdev_stats(
-				struct net_device *netdev);
-extern int bnad_mac_addr_set_locked(struct bnad *bnad, u8 *mac_addr);
-extern int bnad_enable_default_bcast(struct bnad *bnad);
-extern void bnad_restore_vlans(struct bnad *bnad, u32 rx_id);
-extern void bnad_set_ethtool_ops(struct net_device *netdev);
-extern void bnad_cb_completion(void *arg, enum bfa_status status);
+void bnad_set_rx_mode(struct net_device *netdev);
+struct net_device_stats *bnad_get_netdev_stats(struct net_device *netdev);
+int bnad_mac_addr_set_locked(struct bnad *bnad, u8 *mac_addr);
+int bnad_enable_default_bcast(struct bnad *bnad);
+void bnad_restore_vlans(struct bnad *bnad, u32 rx_id);
+void bnad_set_ethtool_ops(struct net_device *netdev);
+void bnad_cb_completion(void *arg, enum bfa_status status);
 
 /* Configuration & setup */
-extern void bnad_tx_coalescing_timeo_set(struct bnad *bnad);
-extern void bnad_rx_coalescing_timeo_set(struct bnad *bnad);
+void bnad_tx_coalescing_timeo_set(struct bnad *bnad);
+void bnad_rx_coalescing_timeo_set(struct bnad *bnad);
 
-extern int bnad_setup_rx(struct bnad *bnad, u32 rx_id);
-extern int bnad_setup_tx(struct bnad *bnad, u32 tx_id);
-extern void bnad_destroy_tx(struct bnad *bnad, u32 tx_id);
-extern void bnad_destroy_rx(struct bnad *bnad, u32 rx_id);
+int bnad_setup_rx(struct bnad *bnad, u32 rx_id);
+int bnad_setup_tx(struct bnad *bnad, u32 tx_id);
+void bnad_destroy_tx(struct bnad *bnad, u32 tx_id);
+void bnad_destroy_rx(struct bnad *bnad, u32 rx_id);
 
 /* Timer start/stop protos */
-extern void bnad_dim_timer_start(struct bnad *bnad);
+void bnad_dim_timer_start(struct bnad *bnad);
 
 /* Statistics */
-extern void bnad_netdev_qstats_fill(struct bnad *bnad,
-		struct rtnl_link_stats64 *stats);
-extern void bnad_netdev_hwstats_fill(struct bnad *bnad,
-		struct rtnl_link_stats64 *stats);
+void bnad_netdev_qstats_fill(struct bnad *bnad,
+			     struct rtnl_link_stats64 *stats);
+void bnad_netdev_hwstats_fill(struct bnad *bnad,
+			      struct rtnl_link_stats64 *stats);
 
 /* Debugfs */
-void	bnad_debugfs_init(struct bnad *bnad);
-void	bnad_debugfs_uninit(struct bnad *bnad);
+void bnad_debugfs_init(struct bnad *bnad);
+void bnad_debugfs_uninit(struct bnad *bnad);
 
 /* MACROS */
 /* To set & get the stats counters */
-- 
1.8.1.2.459.gbcd45b4.dirty


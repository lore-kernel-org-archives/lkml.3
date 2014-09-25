Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaIYO3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:29:34 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:55729 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752198AbaIYO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:29:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:69:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3871:3873:3874:4250:4321:5007:6119:7576:7652:9592:10004:10848:11026:11232:11473:11657:11658:11914:12043:12294:12296:12438:12517:12519:12555:12740:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dog20_351c3763c4b49
X-Filterd-Recvd-Size: 5228
Message-ID: <1411655363.4026.13.camel@joe-AO725>
Subject: Re: [PATCH v4 2/3] net: Add Keystone NetCP ethernet driver
From: Joe Perches <joe@perches.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, sandeep_n@ti.com
Date: Thu, 25 Sep 2014 07:29:23 -0700
In-Reply-To: <1411653805-29257-3-git-send-email-santosh.shilimkar@ti.com>
References: <1411653805-29257-1-git-send-email-santosh.shilimkar@ti.com>
	 <1411653805-29257-3-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 10:03 -0400, Santosh Shilimkar wrote:
> From: Sandeep Nair <sandeep_n@ti.com>
> 
> The network coprocessor (NetCP) is a hardware accelerator that processes
> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
> switch sub-module to send and receive packets. NetCP also includes a packet
> accelerator (PA) module to perform packet classification operations such as
> header matching, and packet modification operations such as checksum
> generation. NetCP can also optionally include a Security Accelerator(SA)
> capable of performing IPSec operations on ingress/egress packets.

Some checkpatch trivia you might consider:
---
 drivers/net/ethernet/ti/netcp_ethss.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 4b273a2..8443bf3 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -253,6 +253,7 @@ struct xgbe_hw_stats {
 	u32	rx_mof_overruns;
 	u32	rx_dma_overruns;
 };
+
 #define XGBE10_NUM_STAT_ENTRIES (sizeof(struct xgbe_hw_stats)/sizeof(u32))
 
 struct gbe_ss_regs {
@@ -264,12 +265,12 @@ struct gbe_ss_regs {
 	u32	rx_en;
 	u32	tx_en;
 	u32	misc_en;
-	u32	mem_allign1[8];
+	u32	mem_align1[8];
 	u32	rx_thresh_stat;
 	u32	rx_stat;
 	u32	tx_stat;
 	u32	misc_stat;
-	u32	mem_allign2[8];
+	u32	mem_align2[8];
 	u32	rx_imax;
 	u32	tx_imax;
 };
@@ -398,6 +399,7 @@ struct gbe_hw_stats {
 	u32	rx_mof_overruns;
 	u32	rx_dma_overruns;
 };
+
 #define GBE13_NUM_HW_STAT_ENTRIES (sizeof(struct gbe_hw_stats)/sizeof(u32))
 #define GBE13_NUM_HW_STATS_MOD			2
 #define XGBE10_NUM_HW_STATS_MOD			3
@@ -1188,7 +1190,6 @@ static void gbe_slave_stop(struct gbe_intf *intf)
 	cpsw_ale_del_mcast(gbe_dev->ale, intf->ndev->broadcast,
 			   1 << slave->port_num, 0, 0);
 
-
 	if (!slave->phy)
 		return;
 
@@ -1253,12 +1254,11 @@ static int gbe_slave_open(struct gbe_intf *gbe_intf)
 			dev_err(priv->dev, "phy not found on slave %d\n",
 				slave->slave_num);
 			return -ENODEV;
-		} else {
-			dev_dbg(priv->dev, "phy found: id is: 0x%s\n",
-				dev_name(&slave->phy->dev));
-			phy_start(slave->phy);
-			phy_read_status(slave->phy);
 		}
+		dev_dbg(priv->dev, "phy found: id is: 0x%s\n",
+			dev_name(&slave->phy->dev));
+		phy_start(slave->phy);
+		phy_read_status(slave->phy);
 	}
 	return 0;
 }
@@ -1501,7 +1501,6 @@ static int gbe_open(void *intf_priv, struct net_device *ndev)
 	else
 		gbe_intf->tx_pipe.dma_psflags = port_num;
 
-
 	dev_dbg(gbe_dev->dev, "opened TX channel %s: %p with psflags %d\n",
 		gbe_intf->tx_pipe.dma_chan_name,
 		gbe_intf->tx_pipe.dma_channel,
@@ -1557,7 +1556,7 @@ static int init_slave(struct gbe_priv *gbe_dev, struct gbe_slave *slave,
 	u32 port_reg_ofs, emac_reg_ofs;
 
 	if (of_property_read_u32(node, "slave-port", &slave->slave_num)) {
-		dev_err(gbe_dev->dev, "missing slave-port paramater\n");
+		dev_err(gbe_dev->dev, "missing slave-port parameter\n");
 		return -EINVAL;
 	}
 
@@ -1906,10 +1905,8 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 	}
 
 	gbe_dev = devm_kzalloc(dev, sizeof(struct gbe_priv), GFP_KERNEL);
-	if (!gbe_dev) {
-		dev_err(dev, "gbe_dev memory allocation failed\n");
+	if (!gbe_dev)
 		return -ENOMEM;
-	}
 
 	gbe_dev->dev = dev;
 	gbe_dev->netcp_device = netcp_device;
@@ -2053,10 +2050,9 @@ static int gbe_attach(void *inst_priv, struct net_device *ndev,
 	}
 
 	gbe_intf = devm_kzalloc(gbe_dev->dev, sizeof(*gbe_intf), GFP_KERNEL);
-	if (!gbe_intf) {
-		dev_err(gbe_dev->dev, "gbe interface memory allocation failed\n");
+	if (!gbe_intf)
 		return -ENOMEM;
-	}
+
 	gbe_intf->ndev = ndev;
 	gbe_intf->dev = gbe_dev->dev;
 	gbe_intf->gbe_dev = gbe_dev;
@@ -2065,7 +2061,6 @@ static int gbe_attach(void *inst_priv, struct net_device *ndev,
 					sizeof(*gbe_intf->slave),
 					GFP_KERNEL);
 	if (!gbe_intf->slave) {
-		dev_err(gbe_dev->dev, "gbe interface slave memory allocation failed\n");
 		ret = -ENOMEM;
 		goto fail;
 	}



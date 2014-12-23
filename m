Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaLWMiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:38:13 -0500
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:53520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754701AbaLWMiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:38:10 -0500
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <anirudh@xilinx.com>, <John.Linn@xilinx.com>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
CC: <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH] net: xilinx: Remove unnecessary temac_property in the driver
Date: Tue, 23 Dec 2014 18:07:55 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21194.006
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <072fa5b149374b09b3f6d5d767714d3e@BN1AFFO11FD010.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(106466001)(107046002)(46102003)(64706001)(229853001)(47776003)(20776003)(74316001)(48376002)(50466002)(31966008)(4396001)(104016003)(33646002)(53416004)(87936001)(19580405001)(19580395003)(86362001)(575784001)(108616004)(50986999)(77156002)(21056001)(99396003)(62966003)(89996001)(6806004)(92726002)(120916001)(92566001)(2201001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB029;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB029;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB029;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB029;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 12:38:06.6956
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1AFFO11HUB029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property is no longer used in the code yet the code looks for it in the device tree.
It does not cause an error if it's not in the tree.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |    2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 44b8d2b..4c9b4fa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -388,7 +388,6 @@ struct axidma_bd {
  * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
- * @temac_type:	axienet type to identify between soft and hard temac
  * @phy_type:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
  * @options:	AxiEthernet option word
  * @last_link:	Phy link state in which the PHY was negotiated earlier
@@ -431,7 +430,6 @@ struct axienet_local {
 
 	int tx_irq;
 	int rx_irq;
-	u32 temac_type;
 	u32 phy_type;
 
 	u32 options;			/* Current options word */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4ea2d4e..c18a0c6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1555,10 +1555,6 @@ static int axienet_of_probe(struct platform_device *op)
 		if ((be32_to_cpup(p)) >= 0x4000)
 			lp->jumbo_support = 1;
 	}
-	p = (__be32 *) of_get_property(op->dev.of_node, "xlnx,temac-type",
-				       NULL);
-	if (p)
-		lp->temac_type = be32_to_cpup(p);
 	p = (__be32 *) of_get_property(op->dev.of_node, "xlnx,phy-type", NULL);
 	if (p)
 		lp->phy_type = be32_to_cpup(p);
-- 
1.7.4


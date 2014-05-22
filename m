Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaEVTK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:10:59 -0400
Received: from mout.gmx.net ([212.227.17.21]:54136 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaEVTK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:10:58 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: michal.simek@xilinx.com
Cc: anirudh@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] xilinx: Use time_before_eq()
Date: Thu, 22 May 2014 21:10:28 +0200
Message-Id: <1400785828-1551-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:AL7qGz0gt6PKbZ8qkZePAhP9y8yGELwGhUU0gubzE4zG08RVpfy
 MW71UpevZfIKi8Khu15QvSoYVDlNbz7/zeR2n172D9bqwp1NmBlHm8rtsFnerm0Y259cki6
 l8b+O+w4SfA1BqgTvz5XuOKJsd4xstbIRn9iq1SuBRmIye7wX7DpH8WnorCz3KsbIBd/7Wn
 diaaED7X41q257b1W2+3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before_eq() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index fa193c4..4ef818a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -75,7 +75,7 @@ int temac_indirect_busywait(struct temac_local *lp)
 	long end = jiffies + 2;
 
 	while (!(temac_ior(lp, XTE_RDY0_OFFSET) & XTE_RDY0_HARD_ACS_RDY_MASK)) {
-		if (end - jiffies <= 0) {
+		if (time_before_eq(end, jiffies)) {
 			WARN_ON(1);
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 64b4639..d4abf47 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -22,7 +22,7 @@ int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 	long end = jiffies + 2;
 	while (!(axienet_ior(lp, XAE_MDIO_MCR_OFFSET) &
 		 XAE_MDIO_MCR_READY_MASK)) {
-		if (end - jiffies <= 0) {
+		if (time_before_eq(end, jiffies)) {
 			WARN_ON(1);
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0d87c67..8c4aed3 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -702,7 +702,7 @@ static int xemaclite_mdio_wait(struct net_local *lp)
 	*/
 	while (__raw_readl(lp->base_addr + XEL_MDIOCTRL_OFFSET) &
 			XEL_MDIOCTRL_MDIOSTS_MASK) {
-		if (end - jiffies <= 0) {
+		if (time_before_eq(end, jiffies)) {
 			WARN_ON(1);
 			return -ETIMEDOUT;
 		}
-- 
1.7.10.4


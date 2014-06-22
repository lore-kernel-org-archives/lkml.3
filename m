Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaFVLZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:25:23 -0400
Received: from mout.gmx.net ([212.227.15.18]:60024 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaFVLZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:25:22 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: sergei.shtylyov@cogentembedded.com
Cc: michal.simek@xilinx.com, anirudh@xilinx.com, John.Linn@xilinx.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH v2] xilinx: Fix compiler warning
Date: Sun, 22 Jun 2014 13:24:54 +0200
Message-Id: <1403436294-21301-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <53A6BAC5.80206@cogentembedded.com>
References: <53A6BAC5.80206@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:vLSvRk+B5w0flAtQbcDiD+PE5U2VGDLO2UnipwXg656xVDvjMEs
 kc5xKHtbCrNpp8VmZD8feCHq9ERbYdUhhszTYremkSewf9soYSQg2DkWUkzTys1DVfmh2mG
 vfzoDJcjBfSF8J25XGQlHTT1Knif7ghwwn18XPJiiJotubnl4VdHrJn13PeU2L2FK9LH2dV
 HWocfD0rVTZSn0ydGKCdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time comparsion functions require arguments of type unsigned long
instead of (signed) long.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 4ef818a..8a6e5c2 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -72,7 +72,7 @@ void temac_iow(struct temac_local *lp, int offset, u32 value)
 
 int temac_indirect_busywait(struct temac_local *lp)
 {
-	long end = jiffies + 2;
+	unsigned long end = jiffies + 2;
 
 	while (!(temac_ior(lp, XTE_RDY0_OFFSET) & XTE_RDY0_HARD_ACS_RDY_MASK)) {
 		if (time_before_eq(end, jiffies)) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index d4abf47..3b67d60 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -19,7 +19,7 @@
 /* Wait till MDIO interface is ready to accept a new transaction.*/
 int axienet_mdio_wait_until_ready(struct axienet_local *lp)
 {
-	long end = jiffies + 2;
+	unsigned long end = jiffies + 2;
 	while (!(axienet_ior(lp, XAE_MDIO_MCR_OFFSET) &
 		 XAE_MDIO_MCR_READY_MASK)) {
 		if (time_before_eq(end, jiffies)) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 8c4aed3..782bb93 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -695,7 +695,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 
 static int xemaclite_mdio_wait(struct net_local *lp)
 {
-	long end = jiffies + 2;
+	unsigned long end = jiffies + 2;
 
 	/* wait for the MDIO interface to not be busy or timeout
 	   after some time.
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaKKLKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbaKKLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 060/170] can: flexcan: mark TX mailbox as TX_INACTIVE
Date: Tue, 11 Nov 2014 11:06:59 +0000
Message-Id: <1415704129-12709-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit c32fe4ad3e4861b2bfa1f44114c564935a123dda upstream.

This patch fixes the initialization of the TX mailbox. It is now correctly
initialized as TX_INACTIVE not RX_EMPTY.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f425ec2c7839..f846bf63e347 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -136,6 +136,17 @@
 
 /* FLEXCAN message buffers */
 #define FLEXCAN_MB_CNT_CODE(x)		(((x) & 0xf) << 24)
+#define FLEXCAN_MB_CODE_RX_INACTIVE	(0x0 << 24)
+#define FLEXCAN_MB_CODE_RX_EMPTY	(0x4 << 24)
+#define FLEXCAN_MB_CODE_RX_FULL		(0x2 << 24)
+#define FLEXCAN_MB_CODE_RX_OVERRRUN	(0x6 << 24)
+#define FLEXCAN_MB_CODE_RX_RANSWER	(0xa << 24)
+
+#define FLEXCAN_MB_CODE_TX_INACTIVE	(0x8 << 24)
+#define FLEXCAN_MB_CODE_TX_ABORT	(0x9 << 24)
+#define FLEXCAN_MB_CODE_TX_DATA		(0xc << 24)
+#define FLEXCAN_MB_CODE_TX_TANSWER	(0xe << 24)
+
 #define FLEXCAN_MB_CNT_SRR		BIT(22)
 #define FLEXCAN_MB_CNT_IDE		BIT(21)
 #define FLEXCAN_MB_CNT_RTR		BIT(20)
@@ -858,8 +869,8 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
-	/* Abort any pending TX, mark Mailbox as INACTIVE */
-	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+	/* mark TX mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 
 	/* acceptance mask/acceptance code (accept everything) */
-- 
2.1.0


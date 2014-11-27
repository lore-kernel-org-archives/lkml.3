Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaK0Iss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:42294 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbaK0Iso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:44 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 54/91] can: flexcan: mark TX mailbox as TX_INACTIVE
Date: Thu, 27 Nov 2014 16:42:37 +0800
Message-Id: <1417077794-9299-54-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c32fe4ad3e4861b2bfa1f44114c564935a123dda upstream.

This patch fixes the initialization of the TX mailbox. It is now correctly
initialized as TX_INACTIVE not RX_EMPTY.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/can/flexcan.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 75e9233..062bbe2 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -134,6 +134,17 @@
 
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
@@ -734,8 +745,8 @@ static int flexcan_chip_start(struct net_device *dev)
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
-	/* Abort any pending TX, mark Mailbox as INACTIVE */
-	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
+	/* mark TX mailbox as INACTIVE */
+	flexcan_write(FLEXCAN_MB_CODE_TX_INACTIVE,
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);
 
 	/* acceptance mask/acceptance code (accept everything) */
-- 
1.9.1


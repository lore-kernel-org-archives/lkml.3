Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab3BSTK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:10:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089Ab3BSSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 28/81] can: c_can: Set reserved bit in IFx_MASK2 to 1 on write
Date: Tue, 19 Feb 2013 15:48:51 -0300
Message-Id: <1361299784-8830-29-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit 2bd3bc4e8472424f1a6009825397639a8968920a upstream.

According to C_CAN documentation, the reserved bit in IFx_MASK2 register is
fixed 1.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/can/c_can/c_can.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 21a3d77..64647d4 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -446,8 +446,12 @@ static void c_can_setup_receive_object(struct net_device *dev, int iface,
 
 	priv->write_reg(priv, &priv->regs->ifregs[iface].mask1,
 			IFX_WRITE_LOW_16BIT(mask));
+
+	/* According to C_CAN documentation, the reserved bit
+	 * in IFx_MASK2 register is fixed 1
+	 */
 	priv->write_reg(priv, &priv->regs->ifregs[iface].mask2,
-			IFX_WRITE_HIGH_16BIT(mask));
+			IFX_WRITE_HIGH_16BIT(mask) | BIT(13));
 
 	priv->write_reg(priv, &priv->regs->ifregs[iface].arb1,
 			IFX_WRITE_LOW_16BIT(id));
-- 
1.7.9.5


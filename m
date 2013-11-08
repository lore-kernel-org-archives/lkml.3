Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3KHCRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3KHCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 21/91] can: dev: fix nlmsg size calculation in can_get_size()
Date: Thu,  7 Nov 2013 18:14:36 -0800
Message-Id: <1383876946-2396-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit fe119a05f8ca481623a8d02efcc984332e612528 ]

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/dev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 8233e5e..6afbe46 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -698,14 +698,14 @@ static size_t can_get_size(const struct net_device *dev)
 	size_t size;
 
 	size = nla_total_size(sizeof(u32));   /* IFLA_CAN_STATE */
-	size += sizeof(struct can_ctrlmode);  /* IFLA_CAN_CTRLMODE */
+	size += nla_total_size(sizeof(struct can_ctrlmode));  /* IFLA_CAN_CTRLMODE */
 	size += nla_total_size(sizeof(u32));  /* IFLA_CAN_RESTART_MS */
-	size += sizeof(struct can_bittiming); /* IFLA_CAN_BITTIMING */
-	size += sizeof(struct can_clock);     /* IFLA_CAN_CLOCK */
+	size += nla_total_size(sizeof(struct can_bittiming)); /* IFLA_CAN_BITTIMING */
+	size += nla_total_size(sizeof(struct can_clock));     /* IFLA_CAN_CLOCK */
 	if (priv->do_get_berr_counter)        /* IFLA_CAN_BERR_COUNTER */
-		size += sizeof(struct can_berr_counter);
+		size += nla_total_size(sizeof(struct can_berr_counter));
 	if (priv->bittiming_const)	      /* IFLA_CAN_BITTIMING_CONST */
-		size += sizeof(struct can_bittiming_const);
+		size += nla_total_size(sizeof(struct can_bittiming_const));
 
 	return size;
 }
-- 
1.8.1.2


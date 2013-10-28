Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3J1OzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3J1Oth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 45/64] can: dev: fix nlmsg size calculation in can_get_size()
Date: Mon, 28 Oct 2013 14:48:04 +0000
Message-Id: <1382971703-17393-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit fe119a05f8ca481623a8d02efcc984332e612528 upstream.

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/dev.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 4972609..ffda218 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -665,14 +665,14 @@ static size_t can_get_size(const struct net_device *dev)
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
1.8.3.2


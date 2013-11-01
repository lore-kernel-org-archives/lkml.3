Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3KAWna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:43:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3KAWE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 14/54] can: dev: fix nlmsg size calculation in can_get_size()
Date: Fri,  1 Nov 2013 15:03:42 -0700
Message-Id: <20131101220212.918450876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit fe119a05f8ca481623a8d02efcc984332e612528 ]

This patch fixes the calculation of the nlmsg size, by adding the missing
nla_total_size().

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -705,14 +705,14 @@ static size_t can_get_size(const struct
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



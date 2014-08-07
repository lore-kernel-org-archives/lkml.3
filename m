Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaHGIRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:17:55 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:61369 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaHGIRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:17:53 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] can: dev: remove unused variable from can_calc_bittiming() function
Date: Thu,  7 Aug 2014 09:17:24 +0100
Message-Id: <1407399444-16427-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch removes best_rate variable from can_calc_bittiming()
function which was set but was never used.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/net/can/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index e318e87..56e1069 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -103,11 +103,11 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 			      const struct can_bittiming_const *btc)
 {
 	struct can_priv *priv = netdev_priv(dev);
-	long rate, best_rate = 0;
 	long best_error = 1000000000, error = 0;
 	int best_tseg = 0, best_brp = 0, brp = 0;
 	int tsegall, tseg = 0, tseg1 = 0, tseg2 = 0;
 	int spt_error = 1000, spt = 0, sampl_pt;
+	long rate;
 	u64 v64;
 
 	/* Use CIA recommended sample points */
@@ -152,7 +152,6 @@ static int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		}
 		best_tseg = tseg / 2;
 		best_brp = brp;
-		best_rate = rate;
 		if (error == 0)
 			break;
 	}
-- 
1.9.1


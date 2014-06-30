Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaF3Qll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:41:41 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:44069 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbaF3Qiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:38:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] tlan: Make autonegotiation faster
Date: Mon, 30 Jun 2014 18:38:33 +0200
Message-Id: <1404146317-3094-8-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
References: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the autonegotiation poll interval from 8 seconds to 2.
This greatly reduces the time needed to detect link presence,
especially on Olicom cards at 10 Mbps (two autonegoatiations required).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 2d70a89..3e6a80b 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2699,7 +2699,7 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
 		/* Wait for 8 sec to give the process
 		 * more time.  Perhaps we should fail after a while.
 		 */
-		tlan_set_timer(dev, (8*HZ), TLAN_TIMER_PHY_FINISH_AN);
+		tlan_set_timer(dev, 2 * HZ, TLAN_TIMER_PHY_FINISH_AN);
 		return;
 	}
 
-- 
Ondrej Zary


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaE0VjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:39:13 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:58371 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbaE0VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:39:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] tlan: Make autonegotiation faster
Date: Tue, 27 May 2014 23:38:45 +0200
Message-Id: <1401226727-5508-8-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401226727-5508-1-git-send-email-linux@rainbow-software.org>
References: <1401226727-5508-1-git-send-email-linux@rainbow-software.org>
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
index 628a779..007c2fe 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -2699,7 +2699,7 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
 		/* Wait for 8 sec to give the process
 		 * more time.  Perhaps we should fail after a while.
 		 */
-		tlan_set_timer(dev, (8*HZ), TLAN_TIMER_PHY_FINISH_AN);
+		tlan_set_timer(dev, (2*HZ), TLAN_TIMER_PHY_FINISH_AN);
 		return;
 	}
 
-- 
Ondrej Zary


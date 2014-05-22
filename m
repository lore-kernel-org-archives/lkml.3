Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaEVRxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:53:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:59179 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaEVRxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:53:07 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: jg1.han@samsung.com, dingtianhong@huawei.com, ebiederm@xmission.com,
        Julia.Lawall@lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] micrel: Use time_before_eq()
Date: Thu, 22 May 2014 19:52:45 +0200
Message-Id: <1400781165-26498-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ibeO3tiO6SKCIGrJv2h6dYuYGA4T9vLmpPx+Gc0b5NwJfrPEiDI
 GL7Zt+aYggWjwbnBXnK5JBIlDg3Q7uwwJ/UvH9aLdHroCfxYLfmcVXLlvGi2JS4XWeU9Wnn
 OQ59/ijh8E0Gp5AJKi7SJSIOFApp9gs8J6pZ4FApFm10cz78217HXxSoic0ruzAx40Q7sQS
 9ITEm2+w/Mn/ITtGbgyWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before_eq() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/ethernet/micrel/ksz884x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 14ac0e2..90fa5f3 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4930,7 +4930,7 @@ static void netdev_tx_timeout(struct net_device *dev)
 		 * Only reset the hardware if time between calls is long
 		 * enough.
 		 */
-		if (jiffies - last_reset <= dev->watchdog_timeo)
+		if (time_before_eq(jiffies, last_reset + dev->watchdog_timeo))
 			hw_priv = NULL;
 	}
 
-- 
1.7.10.4


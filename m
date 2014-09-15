Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaIOOEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:04:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38267 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840AbaIOOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:01:59 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/9] net: pxa168_eth: fix Ethernet flow control status
Date: Mon, 15 Sep 2014 16:01:48 +0200
Message-Id: <1410789713-15341-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410789713-15341-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IEEE 802.3x Ethernet flow control is disabled when bit (1 << 2) is set
in the port status register. Fix the flow control detection in the link
event handling function which was relying on the opposite assumption.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index a27cd85c030d..5aa2ce2625b4 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -163,7 +163,7 @@
 /* Bit definitions for Port status */
 #define PORT_SPEED_100		(1 << 0)
 #define FULL_DUPLEX		(1 << 1)
-#define FLOW_CONTROL_ENABLED	(1 << 2)
+#define FLOW_CONTROL_DISABLED	(1 << 2)
 #define LINK_UP			(1 << 3)
 
 /* Bit definitions for work to be done */
@@ -885,7 +885,7 @@ static void handle_link_event(struct pxa168_eth_private *pep)
 		speed = 10;
 
 	duplex = (port_status & FULL_DUPLEX) ? 1 : 0;
-	fc = (port_status & FLOW_CONTROL_ENABLED) ? 1 : 0;
+	fc = (port_status & FLOW_CONTROL_DISABLED) ? 0 : 1;
 	netdev_info(dev, "link up, %d Mb/s, %s duplex, flow control %sabled\n",
 		    speed, duplex ? "full" : "half", fc ? "en" : "dis");
 	if (!netif_carrier_ok(dev))
-- 
1.9.1


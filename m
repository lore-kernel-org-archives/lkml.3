Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaFUU3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:29:21 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:56092 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaFUU3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:29:16 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tulip: Poll link status more frequently for Comet chips
Date: Sat, 21 Jun 2014 22:29:01 +0200
Message-Id: <1403382541-7129-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Poll link status every 2 seconds instead of 60 for ADMtek Comet chips.
Tested with AN983B.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/dec/tulip/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/timer.c b/drivers/net/ethernet/dec/tulip/timer.c
index 768379b..523d9dd 100644
--- a/drivers/net/ethernet/dec/tulip/timer.c
+++ b/drivers/net/ethernet/dec/tulip/timer.c
@@ -158,7 +158,7 @@ void comet_timer(unsigned long data)
 {
 	struct net_device *dev = (struct net_device *)data;
 	struct tulip_private *tp = netdev_priv(dev);
-	int next_tick = 60*HZ;
+	int next_tick = 2*HZ;
 
 	if (tulip_debug > 1)
 		netdev_dbg(dev, "Comet link status %04x partner capability %04x\n",
-- 
Ondrej Zary


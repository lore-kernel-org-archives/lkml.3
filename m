Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaJQSrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:47:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54444 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaJQSrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:47:10 -0400
Date: Sat, 18 Oct 2014 00:17:05 +0530
From: Balavasu <kp.balavasu@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: octeon: Replace memcpy with ETH_ALEN
Message-ID: <20141017184705.GA17944@vasu-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch.pl issue
WARNING: memcpy(dev->dev_addr, mac, ETH_ALEN);

Signed-off-by: Balavasu <kp.balavasu@gmail.com>
---
 drivers/staging/octeon/ethernet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 8f9e3fb..47d4277 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -452,7 +452,7 @@ int cvm_oct_common_init(struct net_device *dev)
 		mac = of_get_mac_address(priv->of_node);
 
 	if (mac)
-		memcpy(dev->dev_addr, mac, ETH_ALEN);
+		ether_addr_copy(dev->dev_addr, mac);
 	else
 		eth_hw_addr_random(dev);
 
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaEHOru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:47:50 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59498 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaEHOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:47:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] mdio_bus: fix devm_mdiobus_alloc_size export
Date: Thu,  8 May 2014 16:46:52 +0200
Message-Id: <1399560433-1402630-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:2UpEL2GZKuHR7EejhcaBkLfJ3U+lRO2hcWdGbyBekks
 TaJsaRuhDIuDDwr17EptETDfgDllG5/ivWkphOcXeEOeEH1ac3
 lyDZ3Z1ZA3HmPrm31bMtFA0EpBeW+4rzqhpCRRn/LjPIcDurtp
 VlBlWr45z0yqJr1VWU9fTsS+LSSDy+pQ9QIieMuZmUMJej/d/y
 vdew2Xct1IRcB3Cddmj4sA6/Po2F7md1qmqqphUl5eMk6acArW
 ug0Z50FJ8iMQ+m5DUelPv7EAWwrRJlvcsPo4fQh8ceWewYsHI8
 t3tT2x/2EV47HgQm5pEh723cv6HKl4CdVtx9u9xKBdECCbV+xE
 hNEqnlFrgxdHws0gFtmqSPcDXKxdT1OMotMZSxkna
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6d48f44b7b2 "mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free"
introduced a new function devm_mdiobus_alloc_size() but added an export
for a different function devm_mdiobus_alloc(), which was obviously
a simple mistake that leads to  build error whenever this function is
used from a loadable module:

ERROR: "devm_mdiobus_alloc_size" [drivers/net/ethernet/ti/davinci_mdio.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 68a9a38..a628496 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -117,7 +117,7 @@ struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
 
 	return bus;
 }
-EXPORT_SYMBOL_GPL(devm_mdiobus_alloc);
+EXPORT_SYMBOL_GPL(devm_mdiobus_alloc_size);
 
 /**
  * devm_mdiobus_free - Resource-managed mdiobus_free()
-- 
1.8.3.2


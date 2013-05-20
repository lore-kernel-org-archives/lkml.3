Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3ETTtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:49:39 -0400
Received: from mout.gmx.net ([212.227.15.18]:57892 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab3ETTti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:49:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18SW0sybzYSex6cjPPrdPvoSAXY+v10wZEeHyHpF8
	QGg1Yd94uutKuK
From: Peter Huewe <peterhuewe@gmx.de>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] net/ieee802154/mrf24j40: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 21:54:46 +0200
Message-Id: <1369079686-6160-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_spi_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/ieee802154/mrf24j40.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
index 3f2c7aa..4dcae02 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -749,19 +749,7 @@ static struct spi_driver mrf24j40_driver = {
 	.remove = mrf24j40_remove,
 };
 
-static int __init mrf24j40_init(void)
-{
-	return spi_register_driver(&mrf24j40_driver);
-}
-
-static void __exit mrf24j40_exit(void)
-{
-	spi_unregister_driver(&mrf24j40_driver);
-}
-
-module_init(mrf24j40_init);
-module_exit(mrf24j40_exit);
-
+module_spi_driver(mrf24j40_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alan Ott");
 MODULE_DESCRIPTION("MRF24J40 SPI 802.15.4 Controller Driver");
-- 
1.8.1.5


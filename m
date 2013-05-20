Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3ETTvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:51:08 -0400
Received: from mout.gmx.net ([212.227.15.19]:52852 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab3ETTvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:51:06 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/IdlURXNHIJlPvcQ+ETBi4tWEuusfmJOZPolFFPG
	MKq9nq42NtwI7X
From: Peter Huewe <peterhuewe@gmx.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Bill Pemberton <wfp5p@virginia.edu>, Peter Huewe <peterhuewe@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/ethernet/micrel/ks8851.c: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 21:56:16 +0200
Message-Id: <1369079776-6214-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_spi_driver instead of calling
register and unregister in the otherwise empty init/exit functions

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/net/ethernet/micrel/ks8851.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 33bcb63..ca91e7c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1539,19 +1539,7 @@ static struct spi_driver ks8851_driver = {
 	.resume = ks8851_resume,
 };
 
-static int __init ks8851_init(void)
-{
-	return spi_register_driver(&ks8851_driver);
-}
-
-static void __exit ks8851_exit(void)
-{
-	spi_unregister_driver(&ks8851_driver);
-}
-
-module_init(ks8851_init);
-module_exit(ks8851_exit);
-
+module_spi_driver(ks8851_driver);
 MODULE_DESCRIPTION("KS8851 Network driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaAOEOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:14:10 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:42953
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbaAOEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:14:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] misc: sram: cleanup the code
Date: Wed, 15 Jan 2014 11:16:35 +0800
Message-ID: <1389755795-17584-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the devm_gen_pool_create() is used, so the gen_pool_destroy()
here is redundant.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/misc/sram.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index afe66571..e3e421d 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -87,8 +87,6 @@ static int sram_remove(struct platform_device *pdev)
 	if (gen_pool_avail(sram->pool) < gen_pool_size(sram->pool))
 		dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
 
-	gen_pool_destroy(sram->pool);
-
 	if (sram->clk)
 		clk_disable_unprepare(sram->clk);
 
-- 
1.8.4



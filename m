Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3EUQqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:46:43 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:34768 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3EUQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:42:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 02/12] net: mv643xx_eth: use managed devm_ioremap for port registers
Date: Tue, 21 May 2013 18:41:40 +0200
Message-Id: <1369154510-4927-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of managed devm_ioremap and remove corresponding iounmap.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Miller <davem@davemloft.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org       
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index ef3454c..e658ebd 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2470,7 +2470,7 @@ static int mv643xx_eth_shared_probe(struct platform_device *pdev)
 	if (msp == NULL)
 		return -ENOMEM;
 
-	msp->base = ioremap(res->start, resource_size(res));
+	msp->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (msp->base == NULL)
 		return -ENOMEM;
 
@@ -2498,7 +2498,6 @@ static int mv643xx_eth_shared_remove(struct platform_device *pdev)
 {
 	struct mv643xx_eth_shared_private *msp = platform_get_drvdata(pdev);
 
-	iounmap(msp->base);
 	if (!IS_ERR(msp->clk))
 		clk_disable_unprepare(msp->clk);
 
-- 
1.7.10.4


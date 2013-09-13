Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3IMEE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 00:04:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42897 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751382Ab3IMEE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 00:04:27 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] net: pxa168_eth: remove deprecated IRQF_DISABLED
Date: Fri, 13 Sep 2013 06:04:23 +0200
Message-Id: <1379045063-6604-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 4ae0c74..fff6246 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1123,8 +1123,7 @@ static int pxa168_eth_open(struct net_device *dev)
 	struct pxa168_eth_private *pep = netdev_priv(dev);
 	int err;
 
-	err = request_irq(dev->irq, pxa168_eth_int_handler,
-			  IRQF_DISABLED, dev->name, dev);
+	err = request_irq(dev->irq, pxa168_eth_int_handler, 0, dev->name, dev);
 	if (err) {
 		dev_err(&dev->dev, "can't assign irq\n");
 		return -EAGAIN;
-- 
1.8.1.2


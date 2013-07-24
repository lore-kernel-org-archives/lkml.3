Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3GXGLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:11:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:60887 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3GXGLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:11:12 -0400
From: Prashant Shah <pshah.mumbai@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mwhitehe@redhat.com, pshah.mumbai@gmail.com,
        kernel-mentors@selenic.com
Subject: [PATCH] Change request_irq() to use struct net_device *dev->name
Date: Wed, 24 Jul 2013 11:39:59 +0530
Message-Id: <1374646199-9398-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Prashant Shah <pshah.mumbai@gmail.com>
---
 drivers/net/ethernet/8390/wd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 03eb3ee..b43a63f 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -308,7 +308,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 
 	/* Snarf the interrupt now.  There's no point in waiting since we cannot
 	   share and the board will usually be enabled. */
-	i = request_irq(dev->irq, ei_interrupt, 0, DRV_NAME, dev);
+	i = request_irq(dev->irq, ei_interrupt, 0, dev->name, dev);
 	if (i) {
 		printk (" unable to get IRQ %d.\n", dev->irq);
 		return i;
-- 
1.7.9.5


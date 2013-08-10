Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966556Ab3HJQjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:39:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46454 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965964Ab3HJQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:39:16 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: t.sailer@alumni.ethz.ch, jreuter@yaina.de, jpr@f6fbb.org
Cc: linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: [PATCH] drivers:net:hamradio: Removing Depricated IRQF_DISABLED
Date: Sat, 10 Aug 2013 22:08:58 +0530
Message-Id: <1376152738-14944-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed IRQF_DISABLED as it's deprecated and should be removed

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/net/hamradio/baycom_ser_fdx.c |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c |    2 +-
 drivers/net/hamradio/scc.c            |    2 +-
 drivers/net/hamradio/yam.c            |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index a974727..c114009 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -445,7 +445,7 @@ static int ser12_open(struct net_device *dev)
 	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
 	outb(0x0d, MCR(dev->base_addr));
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(dev->irq, ser12_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED,
 			"baycom_ser_fdx", dev)) {
 		release_region(dev->base_addr, SER12_EXTENT);
 		return -EBUSY;
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index e349d86..d91c1fd 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -490,7 +490,7 @@ static int ser12_open(struct net_device *dev)
 	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
 	outb(0x0d, MCR(dev->base_addr));
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(dev->irq, ser12_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED,
 			"baycom_ser12", dev)) {
 		release_region(dev->base_addr, SER12_EXTENT);       
 		return -EBUSY;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index bc1d521..4bc6ee8 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1734,7 +1734,7 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
 			{
 				if (request_irq(hwcfg.irq, scc_isr,
-						IRQF_DISABLED, "AX.25 SCC",
+						0, "AX.25 SCC",
 						(void *)(long) hwcfg.irq))
 					printk(KERN_WARNING "z8530drv: warning, cannot get IRQ %d\n", hwcfg.irq);
 				else
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 0721e72..f947887 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -888,7 +888,7 @@ static int yam_open(struct net_device *dev)
 		goto out_release_base;
 	}
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, yam_interrupt, IRQF_DISABLED | IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, yam_interrupt, IRQF_TRIGGER_NONE | IRQF_SHARED, dev->name, dev)) {
 		printk(KERN_ERR "%s: irq %d busy\n", dev->name, dev->irq);
 		ret = -EBUSY;
 		goto out_release_base;
-- 
1.7.9.5


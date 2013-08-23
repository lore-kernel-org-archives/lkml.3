Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3HWMzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:55:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:54049 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3HWMzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:55:42 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, maxtram95@gmail.com, viro@zeniv.linux.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navinp@cdac.in>
Subject: [PATCH v2] staging: rtl8187se: Remove pt_regs * irq handler parameter
Date: Fri, 23 Aug 2013 18:24:02 +0530
Message-Id: <1377262442-20111-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pt_regs pointer is no longer passed as a irq handler
argument.

v2:
remove rtl8180_interrupt cast to (void *) .

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/rtl8187se/r8180_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ca69155..eee4fd3 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -197,7 +197,7 @@ inline void force_pci_posting(struct net_device *dev)
 	mb();
 }

-irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs);
+static irqreturn_t rtl8180_interrupt(int irq, void *netdev);
 void set_nic_rxring(struct net_device *dev);
 void set_nic_txring(struct net_device *dev);
 static struct net_device_stats *rtl8180_stats(struct net_device *dev);
@@ -2666,7 +2666,7 @@ short rtl8180_init(struct net_device *dev)
 				  TX_BEACON_RING_ADDR))
 		return -ENOMEM;

-	if (request_irq(dev->irq, (void *)rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, rtl8180_interrupt, IRQF_SHARED, dev->name, dev)) {
 		DMESGE("Error allocating IRQ %d", dev->irq);
 		return -1;
 	} else {
@@ -3537,7 +3537,7 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 	spin_unlock_irqrestore(&priv->tx_lock, flag);
 }

-irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs)
+irqreturn_t rtl8180_interrupt(int irq, void *netdev)
 {
 	struct net_device *dev = (struct net_device *) netdev;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
--
1.7.10.4


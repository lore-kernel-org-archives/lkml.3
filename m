Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3HWLcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:32:04 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61678 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3HWLcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:32:02 -0400
From: navin patidar <navinp@cdac.in>
To: gregkh@linuxfoundation.org
Cc: maxtram95@gmail.com, viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navinp@cdac.in>
Subject: [PATCH] staging: rtl8187se: Remove pt_regs * irq handler parameter
Date: Fri, 23 Aug 2013 17:00:06 +0530
Message-Id: <1377257406-16787-1-git-send-email-navinp@cdac.in>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct pt_regs pointer is no longer passed as a irq handler
argument.

Signed-off-by: navin patidar <navinp@cdac.in>
---
 drivers/staging/rtl8187se/r8180_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ca69155..d722bed 100644
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


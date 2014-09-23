Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaIWTl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:41:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51875 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaIWTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:41:26 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tklauser@distanz.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: don't cast a void* to a struct pointer
Date: Tue, 23 Sep 2014 20:41:12 +0100
Message-Id: <1411501274-2970-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411501274-2970-1-git-send-email-mark.einon@gmail.com>
References: <20140923100106.GE4657@distanz.ch>
 <1411501274-2970-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting a void* popinter to a struct pointer is unnecessary, don't do
it.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2889f86..6539a8a 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3624,7 +3624,7 @@ static irqreturn_t et131x_isr(int irq, void *dev_id)
 {
 	bool handled = true;
 	bool enable_interrupts = true;
-	struct net_device *netdev = (struct net_device *)dev_id;
+	struct net_device *netdev = dev_id;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct address_map __iomem *iomem = adapter->regs;
 	struct rx_ring *rx_ring = &adapter->rx_ring;
-- 
2.1.0


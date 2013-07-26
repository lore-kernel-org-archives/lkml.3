Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab3GZVf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:35:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759938Ab3GZUsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/79] alx: fix lockdep annotation
Date: Fri, 26 Jul 2013 13:47:17 -0700
Message-Id: <20130726204724.778646088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

[ Upstream commit a8798a5c77c9981e88caef1373a3310bf8aed219 ]

Move spin_lock_init to be called before the spinlocks are used, preventing a lockdep splat.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/alx/main.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1303,6 +1303,8 @@ static int alx_probe(struct pci_dev *pde
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	alx = netdev_priv(netdev);
+	spin_lock_init(&alx->hw.mdio_lock);
+	spin_lock_init(&alx->irq_lock);
 	alx->dev = netdev;
 	alx->hw.pdev = pdev;
 	alx->msg_enable = NETIF_MSG_LINK | NETIF_MSG_HW | NETIF_MSG_IFUP |
@@ -1385,9 +1387,6 @@ static int alx_probe(struct pci_dev *pde
 
 	INIT_WORK(&alx->link_check_wk, alx_link_check);
 	INIT_WORK(&alx->reset_wk, alx_reset);
-	spin_lock_init(&alx->hw.mdio_lock);
-	spin_lock_init(&alx->irq_lock);
-
 	netif_carrier_off(netdev);
 
 	err = register_netdev(netdev);



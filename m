Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbaGANAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:00:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43580 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbaGANAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:00:22 -0400
X-Sasl-enc: WDOXj2xAQ0eGYzmpvF2n/6P0GE0nUuYtTaN2wLMuyjAB 1404219621
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm72xx: remove unused code
Date: Tue,  1 Jul 2014 14:00:14 +0100
Message-Id: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code surrounded by otherwise unused #define LOOPBACK_TEST

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 4148013..c2e6bfe 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -368,8 +368,6 @@ int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev)
 static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int ret = 0;
-	struct nic *nic = netdev_priv(dev);
-	struct fsm_s *fsm = (struct fsm_s *)nic->sdk_data[SIOC_DATA_FSM].buf;
 
 	dump_eth_packet(dev, "TX", skb->data, skb->len);
 
@@ -379,17 +377,6 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 		return ret;
 	}
 
-	#if !defined(LOOPBACK_TEST)
-	if (!fsm) {
-		netdev_err(dev, "ASSERTION ERROR: fsm is NULL!!\n");
-	} else if (fsm->m_status != M_CONNECTED) {
-		netdev_emerg(dev, "ASSERTION ERROR: Device is NOT ready. status=%d\n",
-			     fsm->m_status);
-		kfree_skb(skb);
-		return 0;
-	}
-	#endif
-
 #if defined(CONFIG_WIMAX_GDM72XX_QOS)
 	ret = gdm_qos_send_hci_pkt(skb, dev);
 #else
@@ -919,12 +906,7 @@ int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
 	if (ret)
 		goto cleanup;
 
-	#if defined(LOOPBACK_TEST)
-	netif_start_queue(dev);
-	netif_carrier_on(dev);
-	#else
 	netif_carrier_off(dev);
-	#endif
 
 #ifdef CONFIG_WIMAX_GDM72XX_QOS
 	gdm_qos_init(nic);
-- 
1.8.4


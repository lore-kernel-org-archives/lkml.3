Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaEIKL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:11:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34749 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbaEIKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:30 -0400
X-Sasl-enc: +g/UVhJ4RwwANieuX8rsI04axi7P274aVA70LQu3rl7T 1399630164
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 06/10] staging: gdm72xx: Fix braces to conform with coding style
Date: Fri,  9 May 2014 18:08:25 +0800
Message-Id: <1399630109-18701-6-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

CHECK: braces {} should be used on all arms of this statement

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.c | 16 ++++++++--------
 drivers/staging/gdm72xx/netlink_k.c |  7 ++++---
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 05ce2a2..814d2e4 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -263,9 +263,9 @@ static struct evt_entry *get_event_entry(void)
 {
 	struct evt_entry *e;
 
-	if (list_empty(&wm_event.freeq))
+	if (list_empty(&wm_event.freeq)) {
 		e = alloc_event_entry();
-	else {
+	} else {
 		e = list_entry(wm_event.freeq.next, struct evt_entry, list);
 		list_del(&e->list);
 	}
@@ -379,9 +379,9 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	#if !defined(LOOPBACK_TEST)
-	if (!fsm)
+	if (!fsm) {
 		netdev_err(dev, "ASSERTION ERROR: fsm is NULL!!\n");
-	else if (fsm->m_status != M_CONNECTED) {
+	} else if (fsm->m_status != M_CONNECTED) {
 		netdev_emerg(dev, "ASSERTION ERROR: Device is NOT ready. status=%d\n",
 			     fsm->m_status);
 		kfree_skb(skb);
@@ -544,9 +544,9 @@ static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 
 	if (cur_fsm->m_status != new_fsm->m_status ||
 		cur_fsm->c_status != new_fsm->c_status) {
-		if (new_fsm->m_status == M_CONNECTED)
+		if (new_fsm->m_status == M_CONNECTED) {
 			netif_carrier_on(dev);
-		else if (cur_fsm->m_status == M_CONNECTED) {
+		} else if (cur_fsm->m_status == M_CONNECTED) {
 			netif_carrier_off(dev);
 			#if defined(CONFIG_WIMAX_GDM72XX_QOS)
 			gdm_qos_release_list(nic);
@@ -855,9 +855,9 @@ static void prepare_rx_complete(void *arg, void *data, int len)
 	int ret;
 
 	ret = gdm_wimax_get_prepared_info(nic->netdev, data, len);
-	if (ret == 1)
+	if (ret == 1) {
 		gdm_wimax_rcv_with_cb(nic, rx_complete, nic);
-	else {
+	} else {
 		if (ret < 0)
 			netdev_err(nic->netdev,
 				   "get_prepared_info failed(%d)\n", ret);
diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index af7f1c1..52317c7 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -75,8 +75,9 @@ static void netlink_rcv_cb(struct sk_buff *skb)
 				netdev_err(skb->dev,
 					   "dev_get_by_index(%d) is not found.\n",
 					   ifindex);
-		} else
+		} else {
 			netdev_err(skb->dev, "Unregistered Callback\n");
+		}
 	}
 }
 
@@ -144,9 +145,9 @@ int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
 
 	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
 
-	if (!ret)
+	if (!ret) {
 		return len;
-	else {
+	} else {
 		if (ret != -ESRCH) {
 			pr_err("netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
 			       group, type, len, ret);
-- 
1.8.4


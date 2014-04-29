Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaD2CQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:16:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35997 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaD2CQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:16:05 -0400
X-Sasl-enc: oPJcO0l1Z2PVJjVUeHkVF7+hP5zpMec2vmGCfoM552HA 1398737763
Message-ID: <535F0B41.40809@fastmail.fm>
Date: Tue, 29 Apr 2014 10:15:29 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/10] staging: gdm72xx: Fixed some braces to conform with
 coding style
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed some braces to conform with coding style

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


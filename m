Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3JWKMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:12:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49144 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3JWKMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:12:37 -0400
From: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
Subject: [PATCH 1/1] mac80211:Resetting connection monitor timers in transmit path
Date: Wed, 23 Oct 2013 15:42:25 +0530
Message-Id: <1382523145-2302-1-git-send-email-dhahira.thesneem@mistralsolutions.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset connection monitor timers when we are able to successfully transmit data to an AP.

Signed-off-by: Dhahira Thesneem <dhahira.thesneem@mistralsolutions.com>
---
 net/mac80211/tx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3456c04..e7725cf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1700,7 +1700,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	ieee80211_xmit(sdata, skb, chan->band);
 	rcu_read_unlock();
-
+	/*To reset connection monitor timers, after successful transmission*/
+	ieee80211_sta_reset_conn_monitor(sdata);
 	return NETDEV_TX_OK;
 
 fail_rcu:
@@ -2139,7 +2140,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	ieee80211_xmit(sdata, skb, band);
 	rcu_read_unlock();
-
+	/*To reset connection monitor timers, after successful transmission*/
+	ieee80211_sta_reset_conn_monitor(sdata);
 	return NETDEV_TX_OK;
 
  fail_rcu:
-- 
1.7.5.4


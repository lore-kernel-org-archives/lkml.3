Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaJVTBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:01:52 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:48820 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbaJVTBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:01:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukNALz+R1RR86AM/2dsb2JhbABcgw6BLLh3BQFzmj6BDxcBfYRfI4EaN4hEAbcojwyGJYoyHYQ1BZ1djGiJQoFHAYIyOy+CSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] lapb: move EXPORT_SYMBOL after functions.
Date: Wed, 22 Oct 2014 21:01:41 +0200
Message-Id: <1414004501-7715-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See Documentation/CodingStyle Chapter 6

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/lapb/lapb_iface.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 3cdaa04..fc60d9d 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -73,6 +73,7 @@ static void __lapb_remove_cb(struct lapb_cb *lapb)
 		lapb_put(lapb);
 	}
 }
+EXPORT_SYMBOL(lapb_register);
 
 /*
  *	Add a socket to the bound sockets list.
@@ -195,6 +196,7 @@ out:
 	write_unlock_bh(&lapb_list_lock);
 	return rc;
 }
+EXPORT_SYMBOL(lapb_unregister);
 
 int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
 {
@@ -227,6 +229,7 @@ int lapb_getparms(struct net_device *dev, struct lapb_parms_struct *parms)
 out:
 	return rc;
 }
+EXPORT_SYMBOL(lapb_getparms);
 
 int lapb_setparms(struct net_device *dev, struct lapb_parms_struct *parms)
 {
@@ -262,6 +265,7 @@ out_put:
 out:
 	return rc;
 }
+EXPORT_SYMBOL(lapb_setparms);
 
 int lapb_connect_request(struct net_device *dev)
 {
@@ -290,6 +294,7 @@ out_put:
 out:
 	return rc;
 }
+EXPORT_SYMBOL(lapb_connect_request);
 
 int lapb_disconnect_request(struct net_device *dev)
 {
@@ -334,6 +339,7 @@ out_put:
 out:
 	return rc;
 }
+EXPORT_SYMBOL(lapb_disconnect_request);
 
 int lapb_data_request(struct net_device *dev, struct sk_buff *skb)
 {
@@ -355,6 +361,7 @@ out_put:
 out:
 	return rc;
 }
+EXPORT_SYMBOL(lapb_data_request);
 
 int lapb_data_received(struct net_device *dev, struct sk_buff *skb)
 {
@@ -369,6 +376,7 @@ int lapb_data_received(struct net_device *dev, struct sk_buff *skb)
 
 	return rc;
 }
+EXPORT_SYMBOL(lapb_data_received);
 
 void lapb_connect_confirmation(struct lapb_cb *lapb, int reason)
 {
@@ -415,15 +423,6 @@ int lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *skb)
 	return used;
 }
 
-EXPORT_SYMBOL(lapb_register);
-EXPORT_SYMBOL(lapb_unregister);
-EXPORT_SYMBOL(lapb_getparms);
-EXPORT_SYMBOL(lapb_setparms);
-EXPORT_SYMBOL(lapb_connect_request);
-EXPORT_SYMBOL(lapb_disconnect_request);
-EXPORT_SYMBOL(lapb_data_request);
-EXPORT_SYMBOL(lapb_data_received);
-
 static int __init lapb_init(void)
 {
 	return 0;
-- 
1.9.1


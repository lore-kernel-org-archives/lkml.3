Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbaGPFbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:31:12 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55013 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaGPFbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:31:08 -0400
From: varkabhadram@gmail.com
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next] netlink: remove bool varible
Date: Wed, 16 Jul 2014 10:59:47 +0530
Message-Id: <1405488587-26119-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This patch removes the bool variable 'pass'.
If the swith case exist return true or return false.

Signed-off-by: Varka Bhadram <varkab@cdac.in>
---
 net/netlink/af_netlink.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e8c9f97..5dd8193 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -170,7 +170,6 @@ EXPORT_SYMBOL_GPL(netlink_remove_tap);
 static bool netlink_filter_tap(const struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
-	bool pass = false;
 
 	/* We take the more conservative approach and
 	 * whitelist socket protocols that may pass.
@@ -184,11 +183,10 @@ static bool netlink_filter_tap(const struct sk_buff *skb)
 	case NETLINK_FIB_LOOKUP:
 	case NETLINK_NETFILTER:
 	case NETLINK_GENERIC:
-		pass = true;
-		break;
+		return true;
 	}
 
-	return pass;
+	return false;
 }
 
 static int __netlink_deliver_tap_skb(struct sk_buff *skb,
-- 
1.7.9.5


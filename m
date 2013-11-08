Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3KHCRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3KHCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ansis Atteka <aatteka@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 05/91] vxlan: fix ip_select_ident skb parameter
Date: Thu,  7 Nov 2013 18:14:20 -0800
Message-Id: <1383876946-2396-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

[3.8-stable only] Fix a call to ip_select_ident() that I missed in commit
1a3365ee55bc5b7e9a752e3a535fd983714d8db2, which is the 3.8 backport
of commit 703133de331a7a7df47f31fb9de51dc6f68a9de8 upstream.

Cc: Ansis Atteka <aatteka@nicira.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 9b2cc0c..cb6f529 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -977,7 +977,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* See iptunnel_xmit() */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
 		skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 
 	err = ip_local_out(skb);
 	if (likely(net_xmit_eval(err) == 0)) {
-- 
1.8.1.2


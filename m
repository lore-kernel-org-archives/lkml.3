Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750846AbaESEcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 00:32:50 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17570 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaESEcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 00:32:48 -0400
X-IronPort-AV: E=Sophos;i="4.98,865,1392159600"; 
   d="scan'208";a="74474213"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/13] libertas: make return of 0 explicit
Date: Mon, 19 May 2014 06:31:03 +0200
Message-Id: <1400473875-22228-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary local variable whose value is always 0 and that hides
the fact that the result is always 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Alternatively, was an error code intended in the bad length case, as is
done in process_brxed_802_11_packet?

 drivers/net/wireless/libertas/rx.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index c7366b0..807c5b8 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -55,7 +55,6 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
  */
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
-	int ret = 0;
 	struct net_device *dev = priv->dev;
 	struct rxpackethdr *p_rx_pkt;
 	struct rxpd *p_rx_pd;
@@ -86,7 +85,6 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
 		lbs_deb_rx("rx err: frame received with bad length\n");
 		dev->stats.rx_length_errors++;
-		ret = 0;
 		dev_kfree_skb(skb);
 		goto done;
 	}
@@ -154,10 +152,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	else
 		netif_rx_ni(skb);
 
-	ret = 0;
 done:
-	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
-	return ret;
+	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", 0);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(lbs_process_rxed_packet);
 


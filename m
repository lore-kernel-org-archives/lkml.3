Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162176Ab3DEUhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:37:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41922 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162032Ab3DEUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:36:58 -0400
X-Sasl-enc: I1zkCD2igPfzucJuJTYIQxLZaRPTdxBoahSlbn+HXA8p 1365194217
From: Alan Ott <alan@signal11.us>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Ott <alan@signal11.us>
Subject: [PATCH] mac802154: Keep track of the channel when changed
Date: Fri,  5 Apr 2013 16:36:41 -0400
Message-Id: <1365194201-2635-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent set_channel() from getting called every time a packet is sent. This
looks like it was an oversight.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 net/mac802154/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
index 3fd3e07..6d16473 100644
--- a/net/mac802154/tx.c
+++ b/net/mac802154/tx.c
@@ -58,6 +58,9 @@ static void mac802154_xmit_worker(struct work_struct *work)
 			pr_debug("set_channel failed\n");
 			goto out;
 		}
+
+		xw->priv->phy->current_channel = xw->chan;
+		xw->priv->phy->current_page = xw->page;
 	}
 
 	res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
-- 
1.7.11.2


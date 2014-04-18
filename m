Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaDRJcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:32:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45968 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Stevens <dlstevens@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 47/72] vxlan: fix potential NULL dereference in arp_reduce()
Date: Fri, 18 Apr 2014 11:22:20 +0200
Message-Id: <c72c1e886766c2be276e765fc444c23d2ee1543e.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Stevens <dlstevens@us.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 7346135dcd3f9b57f30a5512094848c678d7143e ]

This patch fixes a NULL pointer dereference in the event of an
skb allocation failure in arp_reduce().

Signed-Off-By: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Cong Wang <cwang@twopensource.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/vxlan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 32c45c3d820d..020fe03f37c0 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1212,6 +1212,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb)
 
 		neigh_release(n);
 
+		if (reply == NULL)
+			goto out;
+
 		skb_reset_mac_header(reply);
 		__skb_pull(reply, skb_network_offset(reply));
 		reply->ip_summed = CHECKSUM_UNNECESSARY;
-- 
1.9.2


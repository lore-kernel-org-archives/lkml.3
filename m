Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbaDVVfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:35:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbaDVUPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David L Stevens <dlstevens@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 011/133] vxlan: fix potential NULL dereference in arp_reduce()
Date: Tue, 22 Apr 2014 13:12:29 -0700
Message-Id: <1398197671-12786-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <dlstevens@us.ibm.com>

[ Upstream commit 7346135dcd3f9b57f30a5512094848c678d7143e ]

This patch fixes a NULL pointer dereference in the event of an
skb allocation failure in arp_reduce().

Signed-Off-By: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Cong Wang <cwang@twopensource.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index cb6f529..dedad38 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -724,6 +724,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb)
 
 		neigh_release(n);
 
+		if (reply == NULL)
+			goto out;
+
 		skb_reset_mac_header(reply);
 		__skb_pull(reply, skb_network_offset(reply));
 		reply->ip_summed = CHECKSUM_UNNECESSARY;
-- 
1.9.1


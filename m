Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaDPKrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:47:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbaDPKck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David L Stevens <dlstevens@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 22/46] vxlan: fix potential NULL dereference in arp_reduce()
Date: Wed, 16 Apr 2014 11:31:38 +0100
Message-Id: <1397644322-13905-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <dlstevens@us.ibm.com>

commit 7346135dcd3f9b57f30a5512094848c678d7143e upstream.

This patch fixes a NULL pointer dereference in the event of an
skb allocation failure in arp_reduce().

Signed-Off-By: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Cong Wang <cwang@twopensource.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 8a05d77..116810f 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -978,6 +978,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb)
 
 		neigh_release(n);
 
+		if (reply == NULL)
+			goto out;
+
 		skb_reset_mac_header(reply);
 		__skb_pull(reply, skb_network_offset(reply));
 		reply->ip_summed = CHECKSUM_UNNECESSARY;
-- 
1.9.1


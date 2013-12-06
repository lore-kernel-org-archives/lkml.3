Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3LFUOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:14:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:54661 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab3LFUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:13:26 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v4 net-next 2/4] macvtap: remove the dead branch
Date: Sat,  7 Dec 2013 04:13:04 +0800
Message-Id: <1386360786-17687-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
References: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120620-9332-0000-0000-00000267B0CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/macvtap.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 9093004..f599c47 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -588,7 +588,7 @@ static int macvtap_skb_from_vnet_hdr(struct sk_buff *skb,
 	return 0;
 }
 
-static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
+static void macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
 				   struct virtio_net_hdr *vnet_hdr)
 {
 	memset(vnet_hdr, 0, sizeof(*vnet_hdr));
@@ -619,8 +619,6 @@ static int macvtap_skb_to_vnet_hdr(const struct sk_buff *skb,
 	} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 		vnet_hdr->flags = VIRTIO_NET_HDR_F_DATA_VALID;
 	} /* else everything is zero */
-
-	return 0;
 }
 
 /* Get packet from user space buffer */
@@ -778,9 +776,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 		if ((len -= vnet_hdr_len) < 0)
 			return -EINVAL;
 
-		ret = macvtap_skb_to_vnet_hdr(skb, &vnet_hdr);
-		if (ret)
-			return ret;
+		macvtap_skb_to_vnet_hdr(skb, &vnet_hdr);
 
 		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
 			return -EFAULT;
-- 
1.7.6.5


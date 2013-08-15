Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab3HORoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:44:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3HORop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:44:45 -0400
Date: Thu, 15 Aug 2013 20:46:26 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Vlad Yasevich <vyasevic@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] macvtap: fix up direction in comment on offloading
Message-ID: <20130815174626.GA10874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It speaks about receiving frames, so while
it says GSO, it really means GRO.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/macvtap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index a98fb0e..a98ed9f 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -1047,7 +1047,7 @@ static int set_offload(struct macvtap_queue *q, unsigned long arg)
 	 * accept TSO frames and turning it off means that user space
 	 * does not support TSO.
 	 * For macvtap, we have to invert it to mean the same thing.
-	 * When user space turns off TSO, we turn off GSO/LRO so that
+	 * When user space turns off TSO, we turn off GRO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
 	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_UFO))
-- 
MST

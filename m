Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaKPWI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:08:29 -0500
Received: from 1wt.eu ([62.212.114.60]:47946 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaKPWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:03 -0500
Message-Id: <20141116215329.691547353@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 25/48] macvlan: Initialize vlan_features to turn on offload
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 support.

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 081e83a78db9b0ae1f5eabc2dedecc865f509b98 ]

Macvlan devices do not initialize vlan_features.  As a result,
any vlan devices configured on top of macvlans perform very poorly.
Initialize vlan_features based on the vlan features of the lower-level
device.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 2490aa3..47ff740 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -360,6 +360,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
+	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->iflink		= lowerdev->ifindex;
 	dev->hard_header_len	= lowerdev->hard_header_len;
-- 
1.7.12.2.21.g234cd45.dirty




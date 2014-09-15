Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbaIOXWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:22:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50483 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbaIOWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 008/187] macvlan: Initialize vlan_features to turn on offload support.
Date: Mon, 15 Sep 2014 15:06:58 -0700
Message-Id: <1410818997-9432-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 081e83a78db9b0ae1f5eabc2dedecc865f509b98 ]

Macvlan devices do not initialize vlan_features.  As a result,
any vlan devices configured on top of macvlans perform very poorly.
Initialize vlan_features based on the vlan features of the lower-level
device.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 333f8bc..a430b99 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -549,6 +549,7 @@ static int macvlan_init(struct net_device *dev)
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
 	dev->features		|= ALWAYS_ON_FEATURES;
+	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->gso_max_size	= lowerdev->gso_max_size;
 	dev->iflink		= lowerdev->ifindex;
 	dev->hard_header_len	= lowerdev->hard_header_len;
-- 
1.9.1


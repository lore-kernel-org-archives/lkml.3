Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaKFXXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:23:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaKFWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 014/162] bridge: Fix br_should_learn to check vlan_enabled
Date: Thu,  6 Nov 2014 14:34:38 -0800
Message-Id: <1415313426-9622-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit c095f248e63ada504dd90c90baae673ae10ee3fe ]

As Toshiaki Makita pointed out, the BRIDGE_INPUT_SKB_CB will
not be initialized in br_should_learn() as that function
is called only from br_handle_local_finish().  That is
an input handler for link-local ethernet traffic so it perfectly
correct to check br->vlan_enabled here.

Reported-by: Toshiaki Makita<toshiaki.makita1@gmail.com>
Fixes: 20adfa1 bridge: Check if vlan filtering is enabled only once.
Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index f71b4d8..a22abd1 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -265,7 +265,7 @@ bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
 	struct net_port_vlans *v;
 
 	/* If filtering was disabled at input, let it pass. */
-	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
+	if (!br->vlan_enabled)
 		return true;
 
 	v = rcu_dereference(p->vlan_info);
-- 
1.9.1


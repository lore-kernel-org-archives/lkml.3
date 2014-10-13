Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaJMC2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:28:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaJMC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:28:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 24/55] bridge: Fix br_should_learn to check vlan_enabled
Date: Mon, 13 Oct 2014 04:24:38 +0200
Message-Id: <20141013022444.773409316@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022443.729870634@linuxfoundation.org>
References: <20141013022443.729870634@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -278,7 +278,7 @@ bool br_should_learn(struct net_bridge_p
 	struct net_port_vlans *v;
 
 	/* If filtering was disabled at input, let it pass. */
-	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
+	if (!br->vlan_enabled)
 		return true;
 
 	v = rcu_dereference(p->vlan_info);



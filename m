Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaJOTDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:03:49 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:52641 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaJOTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:03:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNALbEPlRbtBXi/2dsb2JhbABbgw6BK7guBQFzmimBGBcBfYQwLyOBGjeIQgG5Xo8aLIYiiiwdhDUFnVSWGoFHATgegVs7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Pravin Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] openvswitch: use vport instead of p
Date: Wed, 15 Oct 2014 21:03:41 +0200
Message-Id: <1413399821-8558-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All functions used struct vport *vport except
ovs_vport_find_upcall_portid.

This fixes 1 kerneldoc warning

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/openvswitch/vport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 53001b0..6015802 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -408,13 +408,13 @@ int ovs_vport_get_upcall_portids(const struct vport *vport,
  *
  * Returns the portid of the target socket.  Must be called with rcu_read_lock.
  */
-u32 ovs_vport_find_upcall_portid(const struct vport *p, struct sk_buff *skb)
+u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
 {
 	struct vport_portids *ids;
 	u32 ids_index;
 	u32 hash;
 
-	ids = rcu_dereference(p->upcall_portids);
+	ids = rcu_dereference(vport->upcall_portids);
 
 	if (ids->n_ids == 1 && ids->ids[0] == 0)
 		return 0;
-- 
1.9.3


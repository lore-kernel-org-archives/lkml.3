Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab3E1Veh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:34:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab3E1VZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 75/78] ipv6,gre: do not leak info to user-space
Date: Tue, 28 May 2013 14:20:24 -0700
Message-Id: <1369776027-17859-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amerigo Wang <amwang@redhat.com>

[ Upstream commit 5dbd5068430b8bd1c19387d46d6c1a88b261257f ]

There is a hole in struct ip6_tnl_parm2, so we have to
zero the struct on stack before copying it to user-space.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_gre.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 131dd09..a4c5ae7 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1137,6 +1137,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 		}
 		if (t == NULL)
 			t = netdev_priv(dev);
+		memset(&p, 0, sizeof(p));
 		ip6gre_tnl_parm_to_user(&p, &t->parms);
 		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
 			err = -EFAULT;
@@ -1184,6 +1185,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 		if (t) {
 			err = 0;
 
+			memset(&p, 0, sizeof(p));
 			ip6gre_tnl_parm_to_user(&p, &t->parms);
 			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
 				err = -EFAULT;
-- 
1.8.1.2


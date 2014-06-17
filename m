Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967644AbaFQWv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:51:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965505AbaFQVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/212] ipv4: return valid RTA_IIF on ip route get
Date: Tue, 17 Jun 2014 14:41:47 -0700
Message-Id: <1403041506-13646-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 91146153da2feab18efab2e13b0945b6bb704ded ]

Extend commit 13378cad02afc2adc6c0e07fca03903c7ada0b37
("ipv4: Change rt->rt_iif encoding.") from 3.6 to return valid
RTA_IIF on 'ip route get ... iif DEVICE' instead of rt_iif 0
which is displayed as 'iif *'.

inet_iif is not appropriate to use because skb_iif is not set.
Use the skb->dev->ifindex instead.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e611651f..de44aee 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2362,7 +2362,7 @@ static int rt_fill_info(struct net *net,  __be32 dst, __be32 src,
 			}
 		} else
 #endif
-			if (nla_put_u32(skb, RTA_IIF, rt->rt_iif))
+			if (nla_put_u32(skb, RTA_IIF, skb->dev->ifindex))
 				goto nla_put_failure;
 	}
 
-- 
1.9.1


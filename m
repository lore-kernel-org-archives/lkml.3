Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbaE2OJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:09:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59430 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/103] ipv4: return valid RTA_IIF on ip route get
Date: Thu, 29 May 2014 15:48:52 +0200
Message-Id: <d3fe9147a60663d3329e557df9edbfdb2fdedde3.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 91146153da2feab18efab2e13b0945b6bb704ded ]

Extend commit 13378cad02afc2adc6c0e07fca03903c7ada0b37
("ipv4: Change rt->rt_iif encoding.") from 3.6 to return valid
RTA_IIF on 'ip route get ... iif DEVICE' instead of rt_iif 0
which is displayed as 'iif *'.

inet_iif is not appropriate to use because skb_iif is not set.
Use the skb->dev->ifindex instead.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2557b9a52373..ae8aadbbb3c7 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2358,7 +2358,7 @@ static int rt_fill_info(struct net *net,  __be32 dst, __be32 src,
 			}
 		} else
 #endif
-			if (nla_put_u32(skb, RTA_IIF, rt->rt_iif))
+			if (nla_put_u32(skb, RTA_IIF, skb->dev->ifindex))
 				goto nla_put_failure;
 	}
 
-- 
1.9.3


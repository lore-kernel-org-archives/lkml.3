Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaFCLxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:53:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43761 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaFCLm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/138] ipv4: return valid RTA_IIF on ip route get
Date: Tue,  3 Jun 2014 12:39:10 +0100
Message-Id: <1401795584-22664-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 91146153da2feab18efab2e13b0945b6bb704ded upstream.

Extend commit 13378cad02afc2adc6c0e07fca03903c7ada0b37
("ipv4: Change rt->rt_iif encoding.") from 3.6 to return valid
RTA_IIF on 'ip route get ... iif DEVICE' instead of rt_iif 0
which is displayed as 'iif *'.

inet_iif is not appropriate to use because skb_iif is not set.
Use the skb->dev->ifindex instead.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a8bcc2274097..06329ca4787d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2360,7 +2360,7 @@ static int rt_fill_info(struct net *net,  __be32 dst, __be32 src,
 			}
 		} else
 #endif
-			if (nla_put_u32(skb, RTA_IIF, rt->rt_iif))
+			if (nla_put_u32(skb, RTA_IIF, skb->dev->ifindex))
 				goto nla_put_failure;
 	}
 
-- 
1.9.1


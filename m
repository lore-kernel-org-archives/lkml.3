Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaJJOJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 10:09:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051AbaJJOJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 10:09:49 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH] ipv6: notify userspace when we added or changed an ipv6 token
Date: Fri, 10 Oct 2014 16:08:32 +0200
Message-Id: <1412950112-15593-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NetworkManager might want to know that it changed when the router advertisement
arrives.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Daniel Borkmann <dborkman@redhat.com>
---
 net/ipv6/addrconf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3e118df..3d11390 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4528,6 +4528,7 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token)
 	}
 
 	write_unlock_bh(&idev->lock);
+	netdev_state_change(dev);
 	addrconf_verify_rtnl();
 	return 0;
 }
-- 
1.9.3


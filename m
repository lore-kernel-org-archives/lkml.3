Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967775AbaFQWoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:44:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965453AbaFQVrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 062/212] ipv4: initialise the itag variable in __mkroute_input
Date: Tue, 17 Jun 2014 14:42:36 -0700
Message-Id: <1403041506-13646-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit fbdc0ad095c0a299e9abf5d8ac8f58374951149a ]

the value of itag is a random value from stack, and may not be initiated by
fib_validate_source, which called fib_combine_itag if CONFIG_IP_ROUTE_CLASSID
is not set

This will make the cached dst uncertainty

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index de44aee..a25c6e7 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1529,7 +1529,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct in_device *out_dev;
 	unsigned int flags = 0;
 	bool do_cache;
-	u32 itag;
+	u32 itag = 0;
 
 	/* get a working reference to the output device */
 	out_dev = __in_dev_get_rcu(FIB_RES_DEV(*res));
-- 
1.9.1


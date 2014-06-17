Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349AbaFQQv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:51:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50684 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934042AbaFQQW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:22:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 075/121] ipv4: initialise the itag variable in __mkroute_input
Date: Tue, 17 Jun 2014 09:17:33 -0700
Message-Id: <1403021899-16708-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

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
index 12ab6de..24ba6e1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1482,7 +1482,7 @@ static int __mkroute_input(struct sk_buff *skb,
 	struct in_device *out_dev;
 	unsigned int flags = 0;
 	bool do_cache;
-	u32 itag;
+	u32 itag = 0;
 
 	/* get a working reference to the output device */
 	out_dev = __in_dev_get_rcu(FIB_RES_DEV(*res));
-- 
1.9.1


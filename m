Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3JEXVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:21:30 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:43042 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3JEXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:21:08 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 8/8] net: switch net_secret key generation to net_get_random_once
Date: Sun,  6 Oct 2013 01:20:58 +0200
Message-Id: <1381015258-7667-9-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381015258-7667-1-git-send-email-hannes@stressinduktion.org>
References: <1381015258-7667-1-git-send-email-hannes@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 net/core/secure_seq.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 3f1ec15..b02fd16 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -7,6 +7,7 @@
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>
 #include <linux/string.h>
+#include <linux/net.h>
 
 #include <net/secure_seq.h>
 
@@ -16,18 +17,7 @@ static u32 net_secret[NET_SECRET_SIZE] ____cacheline_aligned;
 
 static void net_secret_init(void)
 {
-	u32 tmp;
-	int i;
-
-	if (likely(net_secret[0]))
-		return;
-
-	for (i = NET_SECRET_SIZE; i > 0;) {
-		do {
-			get_random_bytes(&tmp, sizeof(tmp));
-		} while (!tmp);
-		cmpxchg(&net_secret[--i], 0, tmp);
-	}
+	net_get_random_once(net_secret, sizeof(net_secret));
 }
 
 #ifdef CONFIG_INET
-- 
1.8.3.1


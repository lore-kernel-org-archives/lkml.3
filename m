Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaDRJmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:42:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45938 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 35/72] ipv6: don't set DST_NOCOUNT for remotely added routes
Date: Fri, 18 Apr 2014 11:22:08 +0200
Message-Id: <50fb0fafd1546f2dc6bf931f3a44f63704ce78ac.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit c88507fbad8055297c1d1e21e599f46960cbee39 ]

DST_NOCOUNT should only be used if an authorized user adds routes
locally. In case of routes which are added on behalf of router
advertisments this flag must not get used as it allows an unlimited
number of routes getting added remotely.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0accb1321dd6..77f81beabbd3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1500,7 +1500,7 @@ int ip6_route_add(struct fib6_config *cfg)
 	if (!table)
 		goto out;
 
-	rt = ip6_dst_alloc(net, NULL, DST_NOCOUNT, table);
+	rt = ip6_dst_alloc(net, NULL, (cfg->fc_flags & RTF_ADDRCONF) ? 0 : DST_NOCOUNT, table);
 
 	if (!rt) {
 		err = -ENOMEM;
-- 
1.9.2


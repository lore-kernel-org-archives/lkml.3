Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaDPKtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:49:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaDPKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 16/46] ipv6: don't set DST_NOCOUNT for remotely added routes
Date: Wed, 16 Apr 2014 11:31:32 +0100
Message-Id: <1397644322-13905-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit c88507fbad8055297c1d1e21e599f46960cbee39 upstream.

DST_NOCOUNT should only be used if an authorized user adds routes
locally. In case of routes which are added on behalf of router
advertisments this flag must not get used as it allows an unlimited
number of routes getting added remotely.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2a0f219..bf7a99f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1451,7 +1451,7 @@ int ip6_route_add(struct fib6_config *cfg)
 	if (!table)
 		goto out;
 
-	rt = ip6_dst_alloc(net, NULL, DST_NOCOUNT, table);
+	rt = ip6_dst_alloc(net, NULL, (cfg->fc_flags & RTF_ADDRCONF) ? 0 : DST_NOCOUNT, table);
 
 	if (!rt) {
 		err = -ENOMEM;
-- 
1.9.1


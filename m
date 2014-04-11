Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbaDKQJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:09:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbaDKQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:07:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 13/41] ipv6: dont set DST_NOCOUNT for remotely added routes
Date: Fri, 11 Apr 2014 09:09:44 -0700
Message-Id: <20140411160933.774420041@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160932.865173041@linuxfoundation.org>
References: <20140411160932.865173041@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit c88507fbad8055297c1d1e21e599f46960cbee39 ]

DST_NOCOUNT should only be used if an authorized user adds routes
locally. In case of routes which are added on behalf of router
advertisments this flag must not get used as it allows an unlimited
number of routes getting added remotely.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1428,7 +1428,7 @@ int ip6_route_add(struct fib6_config *cf
 	if (!table)
 		goto out;
 
-	rt = ip6_dst_alloc(net, NULL, DST_NOCOUNT, table);
+	rt = ip6_dst_alloc(net, NULL, (cfg->fc_flags & RTF_ADDRCONF) ? 0 : DST_NOCOUNT, table);
 
 	if (!rt) {
 		err = -ENOMEM;



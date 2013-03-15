Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3COSXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:23:18 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48035 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3COSXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:23:17 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] net: dns_resolver: Use kmemdup instead of kmalloc and memcpy
Date: Fri, 15 Mar 2013 20:21:52 +0200
Message-Id: <1363371712-11566-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace use of kmalloc followed by memcpy with kmemdup.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 net/dns_resolver/dns_query.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index c32be29..4ac62fb 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -146,11 +146,10 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	len = upayload->datalen;
 
 	ret = -ENOMEM;
-	*_result = kmalloc(len + 1, GFP_KERNEL);
+	*_result = kmemdup(upayload->data, len + 1, GFP_KERNEL);
 	if (!*_result)
 		goto put;
 
-	memcpy(*_result, upayload->data, len + 1);
 	if (_expiry)
 		*_expiry = rkey->expiry;
 
-- 
1.7.9.5


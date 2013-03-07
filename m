Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3CGGtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:49:32 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36163 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3CGGta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:49:30 -0500
From: Martin Zhang <martinbj2008@gmail.com>
To: <steffen.klassert@secunet.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Junwei Zhang <junwei.zhang@6wind.com>,
        Martin Zhang <martinbj2008@gmail.com>
Subject: [PATCH] fix a typo in afkey
Date: Thu,  7 Mar 2013 14:48:47 +0800
Message-Id: <1362638927-5617-1-git-send-email-martinbj2008@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junwei Zhang <junwei.zhang@6wind.com>

Signed-off-by: Martin Zhang <martinbj2008@gmail.com>
---
 net/key/af_key.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 556fdaf..8555f33 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2201,7 +2201,7 @@ static int pfkey_spdadd(struct sock *sk, struct sk_buff *skb, const struct sadb_
 		      XFRM_POLICY_BLOCK : XFRM_POLICY_ALLOW);
 	xp->priority = pol->sadb_x_policy_priority;
 
-	sa = ext_hdrs[SADB_EXT_ADDRESS_SRC-1],
+	sa = ext_hdrs[SADB_EXT_ADDRESS_SRC-1];
 	xp->family = pfkey_sadb_addr2xfrm_addr(sa, &xp->selector.saddr);
 	if (!xp->family) {
 		err = -EINVAL;
@@ -2214,7 +2214,7 @@ static int pfkey_spdadd(struct sock *sk, struct sk_buff *skb, const struct sadb_
 	if (xp->selector.sport)
 		xp->selector.sport_mask = htons(0xffff);
 
-	sa = ext_hdrs[SADB_EXT_ADDRESS_DST-1],
+	sa = ext_hdrs[SADB_EXT_ADDRESS_DST-1];
 	pfkey_sadb_addr2xfrm_addr(sa, &xp->selector.daddr);
 	xp->selector.prefixlen_d = sa->sadb_address_prefixlen;
 
@@ -2315,7 +2315,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
 
 	memset(&sel, 0, sizeof(sel));
 
-	sa = ext_hdrs[SADB_EXT_ADDRESS_SRC-1],
+	sa = ext_hdrs[SADB_EXT_ADDRESS_SRC-1];
 	sel.family = pfkey_sadb_addr2xfrm_addr(sa, &sel.saddr);
 	sel.prefixlen_s = sa->sadb_address_prefixlen;
 	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
@@ -2323,7 +2323,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, const struct sa
 	if (sel.sport)
 		sel.sport_mask = htons(0xffff);
 
-	sa = ext_hdrs[SADB_EXT_ADDRESS_DST-1],
+	sa = ext_hdrs[SADB_EXT_ADDRESS_DST-1];
 	pfkey_sadb_addr2xfrm_addr(sa, &sel.daddr);
 	sel.prefixlen_d = sa->sadb_address_prefixlen;
 	sel.proto = pfkey_proto_to_xfrm(sa->sadb_address_proto);
-- 
1.7.10.4


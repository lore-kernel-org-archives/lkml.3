Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaAAF1g (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 1 Jan 2014 00:27:36 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39992 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaAAF1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 00:27:34 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH RESEND] netfilter: remove unused variable
Date: Wed,  1 Jan 2014 06:27:19 +0100
Message-Id: <1388554039-28452-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nfmsg variable is not used (except in sizeof operator which does
not care about its value) between the first and second time it is
assigned the value.  Furthermore, nlmsg_data has no side effects, so
the assignment can be safely removed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f93b7d0..9c56adc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2521,7 +2521,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	u32 portid, seq;
 	int event, err;
 
-	nfmsg = nlmsg_data(cb->nlh);
 	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_ELEM_LIST_MAX,
 			  nft_set_elem_list_policy);
 	if (err < 0)
-- 
1.8.4


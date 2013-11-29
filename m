Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3K2RD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:03:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51665 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab3K2RDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:03:23 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>
Cc: netfilter@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: remove unused variable
Date: Fri, 29 Nov 2013 18:03:11 +0100
Message-Id: <1385744591-9743-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The nfmsg variable is not used (except in sizeof operator which does
not care about its value) between the first and second time it is
assigned the value.  Furthermore, nlmsg_data has no side effects, so
the whole assignment insruction can be safely removed.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 net/netfilter/nf_tables_api.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcddc49..ebf2f96 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2501,7 +2501,6 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	u32 portid, seq;
 	int event, err;
 
-	nfmsg = nlmsg_data(cb->nlh);
 	err = nlmsg_parse(cb->nlh, sizeof(*nfmsg), nla, NFTA_SET_ELEM_LIST_MAX,
 			  nft_set_elem_list_policy);
 	if (err < 0)
-- 
1.8.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaBLJxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:53:07 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:58638 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaBLJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:53:04 -0500
Message-ID: <1392198781.23759.15.camel@x220>
Subject: [PATCH] netfilter: nft_meta: fix typo "CONFIG_NET_CLS_ROUTE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Cc: Richard Weinberger <richard@nod.at>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 10:53:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 09:53:02.0594 (UTC) FILETIME=[382D3620:01CF27D8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two checks for CONFIG_NET_CLS_ROUTE, but the corresponding
Kconfig symbol was dropped in v2.6.39. Since the code guards access to
dst_entry.tclassid it seems CONFIG_IP_ROUTE_CLASSID should be used
instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested! I don't use CONFIG_NF_TABLES in my .config (yet). Besides, I
would have no clue how to runtime test this.

And, yes, typo is stretching it a bit.

 net/netfilter/nft_meta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e8254ad..425cf39 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -116,7 +116,7 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 				 skb->sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
-#ifdef CONFIG_NET_CLS_ROUTE
+#ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID: {
 		const struct dst_entry *dst = skb_dst(skb);
 
@@ -199,7 +199,7 @@ static int nft_meta_init_validate_get(uint32_t key)
 	case NFT_META_OIFTYPE:
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
-#ifdef CONFIG_NET_CLS_ROUTE
+#ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID:
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
-- 
1.8.5.3


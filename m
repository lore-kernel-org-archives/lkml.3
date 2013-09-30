Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3I3L2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:28:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48856 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3I3L2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:04 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ipsec-next tree
Date: Mon, 30 Sep 2013 13:26:07 +0200
Message-Id: <1380540373-25352-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the ipsec-next tree got conflicts in

	include/net/xfrm.h

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc include/net/xfrm.h
index 7657461,c7afa6e..041820c
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@@ -1493,39 -1495,35 +1499,39 @@@ static inline int xfrm4_rcv_spi(struct 
  	return xfrm4_rcv_encap(skb, nexthdr, spi, 0);
  }
  
 -extern int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 -extern int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 -extern int xfrm4_output(struct sk_buff *skb);
 -extern int xfrm4_output_finish(struct sk_buff *skb);
 -extern int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned short family);
 -extern int xfrm4_tunnel_deregister(struct xfrm_tunnel *handler, unsigned short family);
 -extern int xfrm4_mode_tunnel_input_register(struct xfrm_tunnel_notifier *handler);
 -extern int xfrm4_mode_tunnel_input_deregister(struct xfrm_tunnel_notifier *handler);
 -extern int xfrm6_extract_header(struct sk_buff *skb);
 -extern int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 -extern int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi);
 -extern int xfrm6_transport_finish(struct sk_buff *skb, int async);
 -extern int xfrm6_rcv(struct sk_buff *skb);
 -extern int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 -			    xfrm_address_t *saddr, u8 proto);
 -extern int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family);
 -extern int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family);
 -extern __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 -extern __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
 -extern int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 -extern int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 -extern int xfrm6_output(struct sk_buff *skb);
 -extern int xfrm6_output_finish(struct sk_buff *skb);
 -extern int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 -				 u8 **prevhdr);
 +int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 +int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 +int xfrm4_output(struct sk_buff *skb);
 +int xfrm4_output_finish(struct sk_buff *skb);
 +int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned short family);
 +int xfrm4_tunnel_deregister(struct xfrm_tunnel *handler, unsigned short family);
- int xfrm4_mode_tunnel_input_register(struct xfrm_tunnel *handler);
- int xfrm4_mode_tunnel_input_deregister(struct xfrm_tunnel *handler);
++int xfrm4_mode_tunnel_input_register(struct xfrm_tunnel_notifier *handler);
++int xfrm4_mode_tunnel_input_deregister(struct xfrm_tunnel_notifier *handler);
 +void xfrm4_local_error(struct sk_buff *skb, u32 mtu);
 +int xfrm6_extract_header(struct sk_buff *skb);
 +int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 +int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi);
 +int xfrm6_transport_finish(struct sk_buff *skb, int async);
 +int xfrm6_rcv(struct sk_buff *skb);
 +int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 +		     xfrm_address_t *saddr, u8 proto);
 +int xfrm6_tunnel_register(struct xfrm6_tunnel *handler, unsigned short family);
 +int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler,
 +			    unsigned short family);
 +__be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 +__be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
 +int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 +int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 +int xfrm6_output(struct sk_buff *skb);
 +int xfrm6_output_finish(struct sk_buff *skb);
 +int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 +			  u8 **prevhdr);
 +void xfrm6_local_error(struct sk_buff *skb, u32 mtu);
  
  #ifdef CONFIG_XFRM
 -extern int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 -extern int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optval, int optlen);
 +int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 +int xfrm_user_policy(struct sock *sk, int optname,
 +		     u8 __user *optval, int optlen);
  #else
  static inline int xfrm_user_policy(struct sock *sk, int optname, u8 __user *optval, int optlen)
  {

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaCLTlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:41:42 -0400
Received: from smtp-in.kfki.hu ([148.6.0.28]:60686 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaCLTli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:41:38 -0400
Date: Wed, 12 Mar 2014 20:41:34 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Joe Perches <joe@perches.com>
cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/6] netfilter: Convert uses of __constant_<foo>
 to <foo>
In-Reply-To: <d0259d9122d308e3297cac6f7bc47c9955c3597b.1394643455.git.joe@perches.com>
Message-ID: <alpine.DEB.2.10.1403122040360.18314@blackhole.kfki.hu>
References: <cover.1394643455.git.joe@perches.com> <d0259d9122d308e3297cac6f7bc47c9955c3597b.1394643455.git.joe@perches.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Joe Perches wrote:

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

> ---
>  net/netfilter/ipset/pfxlen.c | 4 ++--
>  net/netfilter/xt_AUDIT.c     | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipset/pfxlen.c b/net/netfilter/ipset/pfxlen.c
> index 4f29fa9..04d15fd 100644
> --- a/net/netfilter/ipset/pfxlen.c
> +++ b/net/netfilter/ipset/pfxlen.c
> @@ -7,8 +7,8 @@
>  
>  #define E(a, b, c, d) \
>  	{.ip6 = { \
> -		__constant_htonl(a), __constant_htonl(b), \
> -		__constant_htonl(c), __constant_htonl(d), \
> +		htonl(a), htonl(b), \
> +		htonl(c), htonl(d), \
>  	} }
>  
>  /*
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index 3228d7f..4973cbd 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -146,11 +146,11 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  
>  		if (par->family == NFPROTO_BRIDGE) {
>  			switch (eth_hdr(skb)->h_proto) {
> -			case __constant_htons(ETH_P_IP):
> +			case htons(ETH_P_IP):
>  				audit_ip4(ab, skb);
>  				break;
>  
> -			case __constant_htons(ETH_P_IPV6):
> +			case htons(ETH_P_IPV6):
>  				audit_ip6(ab, skb);
>  				break;
>  			}
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

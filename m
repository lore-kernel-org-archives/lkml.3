Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3JROka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:40:30 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:62556 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab3JROk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:40:27 -0400
Message-ID: <5261481C.7090605@gmail.com>
Date: Fri, 18 Oct 2013 10:39:24 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree
References: <20131018125814.GL2443@sirena.org.uk>
In-Reply-To: <20131018125814.GL2443@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 08:58 AM, Mark Brown wrote:
> Today's linux-next merge of the next-next tree got a conflict in
> include/net/dst.h between e87b3998d (net: dst: provide accessor function
> to dst->xfrm) in the net tree and a4023dd01 (dst.h: Remove extern from
> function prototypes) in net-next.
>
> I've fixed up as below and can carry as required.
>
> diff --cc include/net/dst.h
> index 3c4c944,211dcf1..0000000
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@@ -479,22 -478,10 +478,22 @@@ static inline struct dst_entry *xfrm_lo
>    {
>    	return dst_orig;
>    }
>   +
>   +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
>   +{
>   +	return NULL;
>   +}
>   +
>    #else
> - extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
> - 				     const struct flowi *fl, struct sock *sk,
> - 				     int flags);
> + struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
> + 			      const struct flowi *fl, struct sock *sk,
> + 			      int flags);
>   +
>   +/* skb attached with this dst needs transformation if dst->xfrm is valid */
>   +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
>   +{
>   +	return dst->xfrm;
>   +}
>    #endif
>
>    #endif /* _NET_DST_H */
>

Looks right.

Thanks
-vlad

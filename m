Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3JRNIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:08:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37756 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3JRNIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:08:34 -0400
Date: Fri, 18 Oct 2013 09:08:18 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Mark Brown <broonie@kernel.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the net-next tree
Message-ID: <20131018130818.GA4019@hmsreliant.think-freely.org>
References: <20131018125814.GL2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018125814.GL2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:58:14PM +0100, Mark Brown wrote:
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
>   {
>   	return dst_orig;
>   } 
>  +
>  +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
>  +{
>  +	return NULL;
>  +}
>  +
>   #else
> - extern struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
> - 				     const struct flowi *fl, struct sock *sk,
> - 				     int flags);
> + struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
> + 			      const struct flowi *fl, struct sock *sk,
> + 			      int flags);
>  +
>  +/* skb attached with this dst needs transformation if dst->xfrm is valid */
>  +static inline struct xfrm_state *dst_xfrm(const struct dst_entry *dst)
>  +{
>  +	return dst->xfrm;
>  +}
>   #endif
>   
>   #endif /* _NET_DST_H */



Looks correct to me.
Thanks!
Neil


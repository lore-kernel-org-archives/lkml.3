Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaFYHTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:19:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46509 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaFYHTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:19:11 -0400
Message-ID: <1403680744.3796.41.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] tcp: fix setting csum_start in tcp_gso_segment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tom Herbert <therbert@google.com>
Cc: davem@davemloft.net, torvalds@linux-foundation.org, davej@redhat.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 00:19:04 -0700
In-Reply-To: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
References: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 21:03 -0700, Tom Herbert wrote:

> 
> It looks like a likely culprit is that SKB_GSO_CB()->csum_start is
> not set correctly when doing non-scatter gather. We are using
> offset as opposed to doffset.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Tom Herbert <therbert@google.com>
> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 9cd5344..c1a3303 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2993,7 +2993,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>  							    skb_put(nskb, len),
>  							    len, 0);
>  			SKB_GSO_CB(nskb)->csum_start =
> -			    skb_headroom(nskb) + offset;
> +			    skb_headroom(nskb) + doffset;
>  			continue;
>  		}
>  

Yes, seems an obvious typo, but please change patch title.

This is not "tcp: fix setting csum_start in tcp_gso_segment"

Maybe "net: fix setting csum_start in skb_segment()"



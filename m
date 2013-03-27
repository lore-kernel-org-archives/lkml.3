Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3C0OnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:43:01 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:33641 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3C0Om7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:42:59 -0400
Message-ID: <1364395376.15753.5.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 1/3] net: core: let skb_partial_csum_set() set
 transport header
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Eric Dumazet <edumazet@google.com>
Date: Wed, 27 Mar 2013 07:42:56 -0700
In-Reply-To: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
References: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 17:11 +0800, Jason Wang wrote:
> For untrusted packets with partial checksum, we need to set the transport header
> for precise packet length estimation. We can just let skb_pratial_csum_set() to
> do this to avoid extra call to skb_flow_dissect() and simplify the caller.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  net/core/skbuff.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 31c6737..ba64614 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3370,6 +3370,7 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off)
>  	skb->ip_summed = CHECKSUM_PARTIAL;
>  	skb->csum_start = skb_headroom(skb) + start;
>  	skb->csum_offset = off;
> +	skb_set_transport_header(skb, start);
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(skb_partial_csum_set);

Acked-by: Eric Dumazet <edumazet@google.com>



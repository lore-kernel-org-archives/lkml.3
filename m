Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3E0SS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 14:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3E0SS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 14:18:26 -0400
Date: Mon, 27 May 2013 15:18:14 -0300
From: Rafael Aquini <aquini@redhat.com>
To: atomlin@redhat.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
Message-ID: <20130527181813.GB6509@optiplex.redhat.com>
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 09:45:01PM +0100, atomlin@redhat.com wrote:
> From: Aaron Tomlin <atomlin@redhat.com>
> 
> Since v1:
>  - Removed unnecessary parentheses (sergei.shtylyov)
> 
> ---8<---
> 
> Failed GFP_ATOMIC allocations by the network stack result in dropped
> packets, which will be received on a subsequent retransmit, and an
> unnecessary, noisy warning with a kernel backtrace.
> 
> These warnings are harmless, but they still cause users to panic and
> file bug reports over dropped packets. It would be better to hide the
> failed allocation warnings and backtraces, and let retransmits handle
> dropped packets quietly.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> ---

Acked-by: Rafael Aquini <aquini@redhat.com>


>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index af9185d..84aa870 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -236,7 +236,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  		? skbuff_fclone_cache : skbuff_head_cache;
>  
>  	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> -		gfp_mask |= __GFP_MEMALLOC;
> +		gfp_mask |= __GFP_MEMALLOC | __GFP_NOWARN;
>  
>  	/* Get the HEAD */
>  	skb = kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA, node);
> -- 
> 1.8.1.4
> 

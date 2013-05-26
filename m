Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3EZWAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:00:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53275 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755242Ab3EZWAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:00:10 -0400
Message-ID: <1369605607.2034.4.camel@joe-AO722>
Subject: Re: [Patch v1] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: atomlin@redhat.com, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pshelar@nicira.com, mst@redhat.com,
        alexander.h.duyck@intel.com, linux-kernel@vger.kernel.org
Date: Sun, 26 May 2013 15:00:07 -0700
In-Reply-To: <51A23825.7000303@cogentembedded.com>
References: <1369574241-21397-1-git-send-email-atomlin@redhat.com>
	 <51A23825.7000303@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-26 at 20:28 +0400, Sergei Shtylyov wrote:
> On 26-05-2013 17:17, atomlin@redhat.com wrote:
> > Failed GFP_ATOMIC allocations by the network stack result in dropped
> > packets, which will be received on a subsequent retransmit, and an
> > unnecessary, noisy warning with a kernel backtrace.
> 
> > These warnings are harmless, but they still cause users to panic and
> > file bug reports over dropped packets. It would be better to hide the
> > failed allocation warnings and backtraces, and let retransmits handle
> > dropped packets quietly.

> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
[]
> > @@ -236,7 +236,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >   		? skbuff_fclone_cache : skbuff_head_cache;
> >
> >   	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
> > -		gfp_mask |= __GFP_MEMALLOC;
> > +		gfp_mask |= (__GFP_MEMALLOC|__GFP_NOWARN);
> 
>     Parens not needed here.

Maybe add a pr_debug before the goto out instead.



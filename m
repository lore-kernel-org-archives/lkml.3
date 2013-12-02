Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3LBPFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:05:46 -0500
Received: from a9-92.smtp-out.amazonses.com ([54.240.9.92]:59847 "EHLO
	a9-92.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab3LBPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:05:44 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 10:05:44 EST
Date: Mon, 2 Dec 2013 14:58:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 5/5] slab: make more slab management structure off
 the slab
In-Reply-To: <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142b3d18433-eacdc401-434f-42e1-8988-686bd15a3e20-000000@email.amazonses.com>
References: <1385974183-31423-1-git-send-email-iamjoonsoo.kim@lge.com> <1385974183-31423-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.02-54.240.9.92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Joonsoo Kim wrote:

> Now, the size of the freelist for the slab management diminish,
> so that the on-slab management structure can waste large space
> if the object of the slab is large.

Hmmm.. That is confusing to me. "Since the size of the freelist has shrunk
significantly we have to adjust the heuristic for making the on/off slab
placement decision"?

Make this clearer.

Acked-by: Christoph Lameter <cl@linux.com>

> Consider a 128 byte sized slab. If on-slab is used, 31 objects can be
> in the slab. The size of the freelist for this case would be 31 bytes
> so that 97 bytes, that is, more than 75% of object size, are wasted.
>
> In a 64 byte sized slab case, no space is wasted if we use on-slab.
> So set off-slab determining constraint to 128 bytes.
>
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 7fab788..1a7f19d 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2264,7 +2264,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
>  	 * it too early on. Always use on-slab management when
>  	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
>  	 */
> -	if ((size >= (PAGE_SIZE >> 3)) && !slab_early_init &&
> +	if ((size >= (PAGE_SIZE >> 5)) && !slab_early_init &&
>  	    !(flags & SLAB_NOLEAKTRACE))
>  		/*
>  		 * Size is large, assume best to place the slab management obj
>

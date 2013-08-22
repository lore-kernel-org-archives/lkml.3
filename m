Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3HVRtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:49:46 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:57553 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab3HVRtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:49:45 -0400
Date: Thu, 22 Aug 2013 17:49:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] slab: change return type of kmem_getpages() to
 struct page
In-Reply-To: <1377161065-30552-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140a725706c-27ed3820-ef32-4388-825a-de582055d91d-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.22-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> @@ -2042,7 +2042,7 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep, struct slab *slab
>   */
>  static void slab_destroy(struct kmem_cache *cachep, struct slab *slabp)
>  {
> -	void *addr = slabp->s_mem - slabp->colouroff;
> +	struct page *page = virt_to_head_page(slabp->s_mem);
>
>  	slab_destroy_debugcheck(cachep, slabp);
>  	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU)) {

Ok so this removes slab offset management. The use of a struct page
pointer therefore results in coloring support to be not possible anymore.

I would suggest to have a separate patch for coloring removal before this
patch. It seems that the support is removed in two different patches now.


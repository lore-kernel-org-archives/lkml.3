Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3HVSGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:06:15 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:37234 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab3HVSGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:06:14 -0400
X-Greylist: delayed 855 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 14:06:14 EDT
Date: Thu, 22 Aug 2013 17:51:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/16] slab: remove nodeid in struct slab
In-Reply-To: <1377161065-30552-5-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000140a7277e81-d259fd75-0dcb-4bef-9e32-d615800201a6-000000@email.amazonses.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com> <1377161065-30552-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.22-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013, Joonsoo Kim wrote:

> @@ -1099,8 +1098,7 @@ static void drain_alien_cache(struct kmem_cache *cachep,
>
>  static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
>  {
> -	struct slab *slabp = virt_to_slab(objp);
> -	int nodeid = slabp->nodeid;
> +	int nodeid = page_to_nid(virt_to_page(objp));
>  	struct kmem_cache_node *n;
>  	struct array_cache *alien = NULL;
>  	int node;

virt_to_page is a relatively expensive operation. How does this affect
performance?

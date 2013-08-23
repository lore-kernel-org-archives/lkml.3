Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3HWGt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:49:29 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60945 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3HWGt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:49:28 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-3f-521705f70487
Date: Fri, 23 Aug 2013 15:49:39 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/16] slab: remove nodeid in struct slab
Message-ID: <20130823064938.GF22605@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1377161065-30552-5-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140a7277e81-d259fd75-0dcb-4bef-9e32-d615800201a6-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140a7277e81-d259fd75-0dcb-4bef-9e32-d615800201a6-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:51:58PM +0000, Christoph Lameter wrote:
> On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> 
> > @@ -1099,8 +1098,7 @@ static void drain_alien_cache(struct kmem_cache *cachep,
> >
> >  static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
> >  {
> > -	struct slab *slabp = virt_to_slab(objp);
> > -	int nodeid = slabp->nodeid;
> > +	int nodeid = page_to_nid(virt_to_page(objp));
> >  	struct kmem_cache_node *n;
> >  	struct array_cache *alien = NULL;
> >  	int node;
> 
> virt_to_page is a relatively expensive operation. How does this affect
> performance?

Previous code, that is virt_to_slab(), already do virt_to_page().
So this doesn't matter at all.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

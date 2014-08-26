Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaHZC0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:26:38 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35544 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaHZC0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:26:37 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 26 Aug 2014 11:26:49 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/slab: support slab merge
Message-ID: <20140826022649.GC1035@js1304-P5Q-DELUXE>
References: <1408608675-20420-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1408608675-20420-3-git-send-email-iamjoonsoo.kim@lge.com>
 <alpine.DEB.2.11.1408251028420.27302@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408251028420.27302@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:29:19AM -0500, Christoph Lameter wrote:
> On Thu, 21 Aug 2014, Joonsoo Kim wrote:
> 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 09b060e..a1cc1c9 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -2052,6 +2052,26 @@ static int __init_refok setup_cpu_cache(struct kmem_cache *cachep, gfp_t gfp)
> >  	return 0;
> >  }
> >
> > +unsigned long kmem_cache_flags(unsigned long object_size,
> > +	unsigned long flags, const char *name,
> > +	void (*ctor)(void *))
> > +{
> > +	return flags;
> > +}
> > +
> > +struct kmem_cache *
> > +__kmem_cache_alias(const char *name, size_t size, size_t align,
> > +		   unsigned long flags, void (*ctor)(void *))
> > +{
> > +	struct kmem_cache *cachep;
> > +
> > +	cachep = find_mergeable(size, align, flags, name, ctor);
> > +	if (cachep)
> > +		cachep->refcount++;
> > +
> > +	return cachep;
> > +}
> > +
> 
> These could be commonized as well. Make refcount a common field and then
> the same function can be used for both caches.

refcount is already common field. These can't be commonized, because
SLUB need some other SLUB specific processing related to debug flags
and object size change.

Thanks.


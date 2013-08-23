Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3HWGze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:55:34 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48970 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab3HWGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:55:33 -0400
X-AuditID: 9c93017e-b7c76ae000003897-b6-52170763d346
Date: Fri, 23 Aug 2013 15:55:43 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/16] slab: use __GFP_COMP flag for allocating slab pages
Message-ID: <20130823065543.GH22605@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1377161065-30552-10-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140a72fb556-3269e81c-8829-4c26-a57f-c1bb7e40977b-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140a72fb556-3269e81c-8829-4c26-a57f-c1bb7e40977b-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 06:00:56PM +0000, Christoph Lameter wrote:
> On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> 
> > If we use 'struct page' of first page as 'struct slab', there is no
> > advantage not to use __GFP_COMP. So use __GFP_COMP flag for all the cases.
> 
> Ok that brings it in line with SLUB and SLOB.

Yes!

> 
> > @@ -2717,17 +2701,8 @@ static void slab_put_obj(struct kmem_cache *cachep, struct slab *slabp,
> >  static void slab_map_pages(struct kmem_cache *cache, struct slab *slab,
> >  			   struct page *page)
> >  {
> > -	int nr_pages;
> > -
> > -	nr_pages = 1;
> > -	if (likely(!PageCompound(page)))
> > -		nr_pages <<= cache->gfporder;
> > -
> > -	do {
> > -		page->slab_cache = cache;
> > -		page->slab_page = slab;
> > -		page++;
> > -	} while (--nr_pages);
> > +	page->slab_cache = cache;
> > +	page->slab_page = slab;
> >  }
> 
> And saves some processing.

Yes!


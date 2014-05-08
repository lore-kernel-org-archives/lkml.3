Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaEHNvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:51:45 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:56161 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbaEHNvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:51:43 -0400
Date: Thu, 8 May 2014 08:51:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: George Spelvin <linux@horizon.com>, iamjoonsoo.kim@lge.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/10] slab: move up code to get kmem_cache_node in
 free_block()
In-Reply-To: <alpine.DEB.2.02.1405071429310.8454@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1405080850420.22626@gentwo.org>
References: <20140507212224.9085.qmail@ns.horizon.com> <alpine.DEB.2.02.1405071429310.8454@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, David Rientjes wrote:

> > @@ -3362,17 +3359,12 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
> >  		       int node)
> >  {
> >  	int i;
> > -	struct kmem_cache_node *n;
> > +	struct kmem_cache_node *n = cachep->node[node];
> >
> >  	for (i = 0; i < nr_objects; i++) {
> > -		void *objp;
> > -		struct page *page;
> > -
> > -		clear_obj_pfmemalloc(&objpp[i]);
> > -		objp = objpp[i];
> > +		void *objp = clear_obj_pfmemalloc(&objpp[i]);
> > +		struct page *page = virt_to_head_page(objp);
> >
> > -		page = virt_to_head_page(objp);
> > -		n = cachep->node[node];
> >  		list_del(&page->lru);
> >  		check_spinlock_acquired_node(cachep, node);
> >  		slab_put_obj(cachep, page, objp, node);
>
> I think this unnecessarily obfuscates the code.

It takes the lookup out of the loop. What does the obfuscation?



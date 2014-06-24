Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaFXHnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:43:15 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38077 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaFXHnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:43:14 -0400
Date: Tue, 24 Jun 2014 11:42:58 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: <akpm@linux-foundation.org>, <cl@linux.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140624074258.GA18121@esperanza>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
 <20140624072554.GB4836@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140624072554.GB4836@js1304-P5Q-DELUXE>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 24, 2014 at 04:25:54PM +0900, Joonsoo Kim wrote:
> On Fri, Jun 13, 2014 at 12:38:22AM +0400, Vladimir Davydov wrote:
> > @@ -3368,7 +3379,8 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
> >  
> >  		/* fixup slab chains */
> >  		if (page->active == 0) {
> > -			if (n->free_objects > n->free_limit) {
> > +			if (n->free_objects > n->free_limit ||
> > +			    memcg_cache_dead(cachep)) {
> 
> I'd like to set 0 to free_limit in __kmem_cache_shrink()
> rather than memcg_cache_dead() test here, because memcg_cache_dead()
> is more expensive than it. Is there any problem in this way?

We'd have to be careful on cpu hotplug then, because it may update the
free_limit. Not a big problem though. Will fix.

Thanks.

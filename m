Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbbAZRE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:04:29 -0500
Received: from mx2.parallels.com ([199.115.105.18]:47535 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAZRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:04:27 -0500
Date: Mon, 26 Jan 2015 20:04:18 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/3] slab: zap kmem_cache_shrink return value
Message-ID: <20150126170418.GC28978@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
 <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501260949150.15849@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501260949150.15849@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:49:47AM -0600, Christoph Lameter wrote:
> On Mon, 26 Jan 2015, Vladimir Davydov wrote:
> 
> > @@ -2400,11 +2400,16 @@ int __kmem_cache_shrink(struct kmem_cache *cachep)
> >  	return (ret ? 1 : 0);
> >  }
> >
> > +void __kmem_cache_shrink(struct kmem_cache *cachep)
> > +{
> > +	__cache_shrink(cachep);
> > +}
> > +
> 
> Why do we need this wrapper? Rename __cache_shrink to __kmem_cache_shrink
> instead?
> 

__cache_shrink() is used not only in __kmem_cache_shrink(), but also in
SLAB's __kmem_cache_shutdown(), where we do need its return value to
check if the cache is empty.

Thanks,
Vladimir

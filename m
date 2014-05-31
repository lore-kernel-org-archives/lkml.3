Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaEaK1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:27:50 -0400
Received: from mx2.parallels.com ([199.115.105.18]:38121 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaEaK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:27:49 -0400
Date: Sat, 31 May 2014 14:27:42 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
Message-ID: <20140531102740.GB25076@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300947170.11943@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405300947170.11943@gentwo.org>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:49:55AM -0500, Christoph Lameter wrote:
> On Fri, 30 May 2014, Vladimir Davydov wrote:
> 
> > First, nobody uses it. Second, it differs across the implementations:
> > for SLUB it always returns 0, for SLAB it returns 0 if the cache appears
> > to be empty. So let's get rid of it.
> 
> Well slub returns an error code if it fails

... to sort slabs by the nubmer of objects in use, which is not even
implied by the function declaration. Why can *shrinking*, which is what
kmem_cache_shrink must do at first place, ever fail?

> I am all in favor of making it consistent. The indication in SLAB that
> the slab is empty may be useful. May return error code or the number
> of slab pages in use?

We can, but why if nobody is going to use it?

> Some of the code that is shared by the allocators here could be moved into
> mm/slab_common.c. Put kmem_cache_shrink there and then have
> __kmem_cache_shrink to the allocator specific things?

Already did in scope of mm-commit 4fabfe86c4a5 ("slab: get_online_mems
for kmem_cache_{create,destroy,shrink}") :-)

Thanks.

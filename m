Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbaFINE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:04:29 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51129 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbaFINE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:04:27 -0400
Date: Mon, 9 Jun 2014 17:04:16 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <iamjoonsoo.kim@lge.com>,
        <rientjes@google.com>, <penberg@kernel.org>, <hannes@cmpxchg.org>,
        <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v2 8/8] slab: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140609130414.GB32192@esperanza>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <27a202c6084d6bb19cc3e417793f05104b908ded.1402060096.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1406060949430.32229@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406060949430.32229@gentwo.org>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 09:52:17AM -0500, Christoph Lameter wrote:
> On Fri, 6 Jun 2014, Vladimir Davydov wrote:
> 
> > @@ -740,7 +740,8 @@ static void start_cpu_timer(int cpu)
> >  	}
> >  }
> >
> > -static struct array_cache *alloc_arraycache(int node, int entries,
> > +static struct array_cache *alloc_arraycache(struct kmem_cache *cachep,
> > +					    int node, int entries,
> >  					    int batchcount, gfp_t gfp)
> >  {
> >  	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
> 
> If you pass struct kmem_cache * into alloc_arraycache then we do not need
> to pass entries or batchcount because they are available in struct
> kmem_cache.

Seems you're right. Will rework.

> Otherwise this patch looks a bit too large to me. Simplify a bit?

Yeah, exactly. I will split it and resend.

Thank you.

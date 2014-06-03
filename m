Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaFCTBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:01:13 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49185 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaFCTBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:01:12 -0400
Date: Tue, 3 Jun 2014 23:00:59 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
Message-ID: <20140603190056.GD6013@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300947170.11943@gentwo.org>
 <20140531102740.GB25076@esperanza>
 <alpine.DEB.2.10.1406021014140.2987@gentwo.org>
 <20140603090623.GC6013@esperanza>
 <alpine.DEB.2.10.1406030948310.13291@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406030948310.13291@gentwo.org>
X-Originating-IP: [109.195.248.178]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:48:51AM -0500, Christoph Lameter wrote:
> On Tue, 3 Jun 2014, Vladimir Davydov wrote:
> 
> > Still, I really want to evict all empty slabs from cache on memcg
> > offline for sure. Handling failures there means introducing a worker
> > that will retry shrinking, but that seems to me as an unnecessary
> > complication, because there's nothing that can prevent us from shrinking
> > empty slabs from the cache, even if we merge slab defragmentation, isn't
> > it?
> >
> > May be, it's worth introducing a special function, say kmem_cache_zap(),
> > that will only evict empty slabs from the cache, plus disable empty
> > slabs caching? This function would be called only from memcg offline for
> > dead memcg caches.
> 
> I am fine with the lower impact version that you came up with later.

Oh, I missed a couple of your previous e-mails, because our mail server
marked them (along with a hundred or so another messages :-) ) as junk
for some reason. Going to turn off the filter completely.

Sorry for being inconsistent and thank you.

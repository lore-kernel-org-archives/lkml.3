Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaFCOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:48:56 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:49757 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbaFCOsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:48:54 -0400
Date: Tue, 3 Jun 2014 09:48:51 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
In-Reply-To: <20140603090623.GC6013@esperanza>
Message-ID: <alpine.DEB.2.10.1406030948310.13291@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405300947170.11943@gentwo.org> <20140531102740.GB25076@esperanza> <alpine.DEB.2.10.1406021014140.2987@gentwo.org>
 <20140603090623.GC6013@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014, Vladimir Davydov wrote:

> Still, I really want to evict all empty slabs from cache on memcg
> offline for sure. Handling failures there means introducing a worker
> that will retry shrinking, but that seems to me as an unnecessary
> complication, because there's nothing that can prevent us from shrinking
> empty slabs from the cache, even if we merge slab defragmentation, isn't
> it?
>
> May be, it's worth introducing a special function, say kmem_cache_zap(),
> that will only evict empty slabs from the cache, plus disable empty
> slabs caching? This function would be called only from memcg offline for
> dead memcg caches.

I am fine with the lower impact version that you came up with later.


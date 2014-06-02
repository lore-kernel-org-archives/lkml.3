Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaFBPYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:24:13 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:45094 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbaFBPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:24:12 -0400
Date: Mon, 2 Jun 2014 10:24:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
In-Reply-To: <20140531111922.GD25076@esperanza>
Message-ID: <alpine.DEB.2.10.1406021019350.2987@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405300957390.11943@gentwo.org> <20140531111922.GD25076@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, Vladimir Davydov wrote:

> > You can use a similar approach than in SLUB. Reduce the size of the per
> > cpu array objects to zero. Then SLAB will always fall back to its slow
> > path in cache_flusharray() where you may be able to do something with less
> > of an impact on performace.
>
> In contrast to SLUB, for SLAB this will slow down kfree significantly.

But that is only when you want to destroy a cache. This is similar.

> Fast path for SLAB is just putting an object to a per cpu array, while
> the slow path requires taking a per node lock, which is much slower even
> with no contention. There still can be lots of objects in a dead memcg
> cache (e.g. hundreds of megabytes of dcache), so such performance
> degradation is not acceptable, IMO.

I am not sure that there is such a stark difference to SLUB. SLUB also
takes the per node lock if necessary to handle freeing especially if you
zap the per cpu partial slab pages.

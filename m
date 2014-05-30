Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaE3Oqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:46:37 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:33772 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbaE3Oqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:46:36 -0400
Date: Fri, 30 May 2014 09:46:33 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 4/8] slub: never fail kmem_cache_shrink
In-Reply-To: <ac8907cace921c3209aa821649349106f4f70b34.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300937560.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <ac8907cace921c3209aa821649349106f4f70b34.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> SLUB's kmem_cache_shrink not only removes empty slabs from the cache,
> but also sorts slabs by the number of objects in-use to cope with
> fragmentation. To achieve that, it tries to allocate a temporary array.
> If it fails, it will abort the whole procedure.

If we cannot allocate a kernel structure that is mostly less than a page
size then we have much more important things to worry about.

The maximum number of objects per slab is 512 on my system here.

> This is unacceptable for kmemcg, where we want to be sure that all empty
> slabs are removed from the cache on memcg offline, so let's just skip
> the de-fragmentation step if the allocation fails, but still get rid of
> empty slabs.

Lets just try the shrink and log the fact that it failed? Try again later?



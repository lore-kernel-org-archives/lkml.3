Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbaE3OuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:50:00 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:59290
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964783AbaE3Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:49:58 -0400
Date: Fri, 30 May 2014 09:49:55 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
In-Reply-To: <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300947170.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> First, nobody uses it. Second, it differs across the implementations:
> for SLUB it always returns 0, for SLAB it returns 0 if the cache appears
> to be empty. So let's get rid of it.

Well slub returns an error code if it fails. I am all in favor of making
it consistent. The indication in SLAB that the slab is empty may be
useful. May return error code or the number of slab pages in use?

Some of the code that is shared by the allocators here could be moved into
mm/slab_common.c. Put kmem_cache_shrink there and then have
__kmem_cache_shrink to the allocator specific things?
x

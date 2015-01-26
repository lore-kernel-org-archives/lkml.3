Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbbAZPtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:49:50 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:35298 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbbAZPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:49:48 -0500
Date: Mon, 26 Jan 2015 09:49:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/3] slab: zap kmem_cache_shrink return value
In-Reply-To: <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1501260949150.15849@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> @@ -2400,11 +2400,16 @@ int __kmem_cache_shrink(struct kmem_cache *cachep)
>  	return (ret ? 1 : 0);
>  }
>
> +void __kmem_cache_shrink(struct kmem_cache *cachep)
> +{
> +	__cache_shrink(cachep);
> +}
> +

Why do we need this wrapper? Rename __cache_shrink to __kmem_cache_shrink
instead?

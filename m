Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbbA1Uv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:51:29 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:49072 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbbA1Uv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:51:26 -0500
Date: Wed, 28 Jan 2015 10:33:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 2/3] slub: fix kmem_cache_shrink return value
In-Reply-To: <7ee54d0d26f6c61e2ecf50300ee955610749b344.1422461573.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1501281032220.32147@gentwo.org>
References: <cover.1422461573.git.vdavydov@parallels.com> <7ee54d0d26f6c61e2ecf50300ee955610749b344.1422461573.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Vladimir Davydov wrote:

> @@ -3419,6 +3420,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
>  		for (i = SHRINK_PROMOTE_MAX - 1; i >= 0; i--)
>  			list_splice_init(promote + i, &n->partial);
>
> +		if (n->nr_partial || slabs_node(s, node))

The total number of slabs obtained via slabs_node always contains the
number of partial ones. So no need to check n->nr_partial.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaLHOtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:49:35 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:34470 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbaLHOte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:49:34 -0500
Date: Mon, 8 Dec 2014 08:49:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] memcg: fix possible use-after-free in
 memcg_kmem_get_cache
In-Reply-To: <1417969947-4072-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1412080848240.21299@gentwo.org>
References: <1417969947-4072-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2014, Vladimir Davydov wrote:

> diff --git a/mm/slub.c b/mm/slub.c
> index 95d214255663..7ddf01e2a465 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2450,6 +2450,7 @@ redo:
>
>  	slab_post_alloc_hook(s, gfpflags, object);
>
> +	memcg_kmem_put_cache(s);
>  	return object;
>  }

The function should be added to slab_post_alloc().

Also move the memcg_kmem_get_cache() into slab_pre_alloc_hook().


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499AbbA1Ue5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:34:57 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:43510 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305AbbA1Uey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:54 -0500
Date: Wed, 28 Jan 2015 13:19:54 -0600 (CST)
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
In-Reply-To: <20150128174639.GB16011@esperanza>
Message-ID: <alpine.DEB.2.11.1501281319350.32767@gentwo.org>
References: <cover.1422461573.git.vdavydov@parallels.com> <7ee54d0d26f6c61e2ecf50300ee955610749b344.1422461573.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501281032220.32147@gentwo.org> <20150128174639.GB16011@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Vladimir Davydov wrote:

> Yeah, right. In addition to that I misplaced the check - it should go
> after discard_slab, where we decrement nr_slabs. Here goes the updated
> patch:
>
> From: Vladimir Davydov <vdavydov@parallels.com>
> Subject: [PATCH] slub: fix kmem_cache_shrink return value
>
> It is supposed to return 0 if the cache has no remaining objects and 1
> otherwise, while currently it always returns 0. Fix it.

Acked-by: Christoph Lameter <cl@linux.com>

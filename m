Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbbA1UtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:24 -0500
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:42943 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758735AbbA1UtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:49:20 -0500
Date: Wed, 28 Jan 2015 10:31:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 1/3] slub: never fail to shrink cache
In-Reply-To: <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1501281031190.32147@gentwo.org>
References: <cover.1422461573.git.vdavydov@parallels.com> <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Vladimir Davydov wrote:

> This patch therefore makes __kmem_cache_shrink() allocate the array on
> stack instead of calling kmalloc, which may fail. The array size is
> chosen to be equal to 32, because most SLUB caches store not more than
> 32 objects per slab page. Slab pages with <= 32 free objects are sorted
> using the array by the number of objects in use and promoted to the head
> of the partial list, while slab pages with > 32 free objects are left in
> the end of the list without any ordering imposed on them.

Acked-by: Christoph Lameter <cl@linux.com>

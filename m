Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbbAZS1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:27:01 -0500
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:56906 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058AbbAZS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:26:59 -0500
Date: Mon, 26 Jan 2015 12:26:57 -0600 (CST)
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
In-Reply-To: <20150126170418.GC28978@esperanza>
Message-ID: <alpine.DEB.2.11.1501261226250.16638@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <b89d28384f8ec7865c3fefc2f025955d55798b78.1422275084.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501260949150.15849@gentwo.org> <20150126170418.GC28978@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vladimir Davydov wrote:

> __cache_shrink() is used not only in __kmem_cache_shrink(), but also in
> SLAB's __kmem_cache_shutdown(), where we do need its return value to
> check if the cache is empty.

It could be useful to know if a slab is empty. So maybe leave
kmem_cache_shrink the way it is and instead fix up slub to return the
proper value?


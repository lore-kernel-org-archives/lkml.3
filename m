Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbbA2B6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:58:32 -0500
Received: from mx2.parallels.com ([199.115.105.18]:34928 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbbA2Bzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:45 -0500
Date: Wed, 28 Jan 2015 20:32:21 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v2 1/3] slub: never fail to shrink cache
Message-ID: <20150128173221.GA16011@esperanza>
References: <cover.1422461573.git.vdavydov@parallels.com>
 <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501281034290.32147@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501281034290.32147@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:37:09AM -0600, Christoph Lameter wrote:
> On Wed, 28 Jan 2015, Vladimir Davydov wrote:
> 
> > +			/* We do not keep full slabs on the list */
> > +			BUG_ON(free <= 0);
> 
> Well sorry we do actually keep a number of empty slabs on the partial
> lists. See the min_partial field in struct kmem_cache.

It's not about empty slabs, it's about full slabs: free == 0 means slab
is full.

Thanks,
Vladimir

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbbA1Ufg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:35:36 -0500
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:44360 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760433AbbA1Uf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:26 -0500
Date: Wed, 28 Jan 2015 13:20:28 -0600 (CST)
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
In-Reply-To: <20150128173221.GA16011@esperanza>
Message-ID: <alpine.DEB.2.11.1501281319570.32767@gentwo.org>
References: <cover.1422461573.git.vdavydov@parallels.com> <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501281034290.32147@gentwo.org> <20150128173221.GA16011@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Vladimir Davydov wrote:

> On Wed, Jan 28, 2015 at 10:37:09AM -0600, Christoph Lameter wrote:
> > On Wed, 28 Jan 2015, Vladimir Davydov wrote:
> >
> > > +			/* We do not keep full slabs on the list */
> > > +			BUG_ON(free <= 0);
> >
> > Well sorry we do actually keep a number of empty slabs on the partial
> > lists. See the min_partial field in struct kmem_cache.
>
> It's not about empty slabs, it's about full slabs: free == 0 means slab
> is full.

Correct. I already acked the patch.


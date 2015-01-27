Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbbA0RCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:02:18 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:37639 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290AbbA0RCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:02:13 -0500
Date: Tue, 27 Jan 2015 11:02:12 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
In-Reply-To: <20150127125838.GD5165@esperanza>
Message-ID: <alpine.DEB.2.11.1501271100520.25124@gentwo.org>
References: <cover.1422275084.git.vdavydov@parallels.com> <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501260944550.15849@gentwo.org> <20150126170147.GB28978@esperanza> <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
 <20150126193629.GA2660@esperanza> <alpine.DEB.2.11.1501261353020.16786@gentwo.org> <20150127125838.GD5165@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Vladimir Davydov wrote:

> May be, we could remove this allocation at all then? I mean, always
> distribute slabs among constant number of buckets, say 32, like this:

The point of the sorting is to have the slab pages that only have a few
objects available at the beginning of the list. Allocations can then
easily reduce the size of hte partial page list.

What you could do is simply put all slab pages with more than 32 objects
available at the end of the list.

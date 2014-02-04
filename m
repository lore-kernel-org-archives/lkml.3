Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaBDPLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:11:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaBDPLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:11:47 -0500
Date: Tue, 4 Feb 2014 16:11:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, penberg@kernel.org,
        cl@linux.com, glommer@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 3/8] memcg, slab: never try to merge memcg caches
Message-ID: <20140204151145.GI4890@dhcp22.suse.cz>
References: <cover.1391356789.git.vdavydov@parallels.com>
 <27c4e7d7fb6b788b66995d2523225ef2dcbc6431.1391356789.git.vdavydov@parallels.com>
 <20140204145210.GH4890@dhcp22.suse.cz>
 <52F1004B.90307@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F1004B.90307@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-02-14 18:59:23, Vladimir Davydov wrote:
> On 02/04/2014 06:52 PM, Michal Hocko wrote:
> > On Sun 02-02-14 20:33:48, Vladimir Davydov wrote:
> >> Suppose we are creating memcg cache A that could be merged with cache B
> >> of the same memcg. Since any memcg cache has the same parameters as its
> >> parent cache, parent caches PA and PB of memcg caches A and B must be
> >> mergeable too. That means PA was merged with PB on creation or vice
> >> versa, i.e. PA = PB. From that it follows that A = B, and we couldn't
> >> even try to create cache B, because it already exists - a contradiction.
> > I cannot tell I understand the above but I am totally not sure about the
> > statement bellow.
> >
> >> So let's remove unused code responsible for merging memcg caches.
> > How come the code was unused? find_mergeable called cache_match_memcg...
> 
> Oh, sorry for misleading comment. I mean the code handling merging of
> per-memcg caches is useless, AFAIU: if we find an alias for a per-memcg
> cache on kmem_cache_create_memcg(), the parent of the found alias must
> be the same as the parent_cache passed to kmem_cache_create_memcg(), but
> if it were so, we would never proceed to the memcg cache creation,
> because the cache we want to create already exists.

I am still not sure I understand this correctly. So the outcome of this
patch is that compatible caches of different memcgs can be merged
together? Sorry if this is a stupid question but I am not that familiar
with this area much I am just seeing that cache_match_memcg goes away
and my understanding of the function is that it should prevent from
different memcg's caches merging.
-- 
Michal Hocko
SUSE Labs

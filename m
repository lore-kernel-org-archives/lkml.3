Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaIVOtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:49:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaIVOtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:49:13 -0400
Date: Mon, 22 Sep 2014 16:49:10 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] memcg: move memcg_update_cache_size to slab_common.c
Message-ID: <20140922144910.GH336@dhcp22.suse.cz>
References: <e768785511927d65bd3e6d9f65ab2a9851a3d73d.1411054735.git.vdavydov@parallels.com>
 <0689062e28e13375241dcc64df2a398c9d606c64.1411054735.git.vdavydov@parallels.com>
 <20140922140734.GF336@dhcp22.suse.cz>
 <20140922142035.GE18526@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922142035.GE18526@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-09-14 18:20:35, Vladimir Davydov wrote:
> On Mon, Sep 22, 2014 at 04:07:34PM +0200, Michal Hocko wrote:
> > On Thu 18-09-14 19:50:20, Vladimir Davydov wrote:
> > > The only reason why this function lives in memcontrol.c is that it
> > > depends on memcg_caches_array_size. However, we can pass the new array
> > > size immediately to it instead of new_id+1 so that it will be free of
> > > any memcontrol.c dependencies.
> > > 
> > > So let's move this function to slab_common.c and make it static.
> > 
> > Why?
> 
> Jumping from memcontrol.c to slab_common.c and then back to memcontrol.c
> while updating per-memcg caches looks ugly IMO. We can do the update on
> the slab's side.

Then put this into the patch description. I am always kind of lost when
following all those slab <-> memcg jumps so I definitely do not have
anything against cleaning this up. But please be explicit about your
motivation about the change and put it into the changelog. Things might
be obvious for you when you are deeply familiar with the code but the
poor reviewer has to build up the whole thing from scratch usually.

> > besides that the patch does more code reshuffling which should be
> > documented. I have got lost a bit to be honest.
> 
> It just makes it sane :-) Currently we walk over all slab caches each
> time new kmemcg is created even if memcg_limited_groups_array_size
> doesn't grow and we've actually nothing to do. So it moves cache id
> allocation stuff to a separate function (memcg_alloc_cache_id) and
> places the check there so that memcg_update_all_caches is only called
> when it's really necessary.
> 
> I'm sorry if it confuses you. I thought the patch isn't big and rather
> easy to understand :-/ Next time will split better.

This would be worth a separate patch then and explain all of this.

Thanks!
-- 
Michal Hocko
SUSE Labs

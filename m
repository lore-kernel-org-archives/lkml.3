Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaAOIVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:21:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaAOIVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:21:01 -0500
Date: Wed, 15 Jan 2014 09:20:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/memcg: iteration skip memcgs not yet fully
 initialized
Message-ID: <20140115082058.GA8782@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1401131742370.2229@eggly.anvils>
 <alpine.LSU.2.11.1401131752360.2229@eggly.anvils>
 <20140114133005.GC32227@dhcp22.suse.cz>
 <20140114142904.GA12131@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114142904.GA12131@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-01-14 09:29:04, Tejun Heo wrote:
> Hey, Michal.
> 
> On Tue, Jan 14, 2014 at 02:30:05PM +0100, Michal Hocko wrote:
> > On Mon 13-01-14 17:54:04, Hugh Dickins wrote:
> > > It is surprising that the mem_cgroup iterator can return memcgs which
> > > have not yet been fully initialized.  By accident (or trial and error?)
> > > this appears not to present an actual problem; but it may be better to
> > > prevent such surprises, by skipping memcgs not yet online.
> > 
> > My understanding was that !online cgroups are not visible for the
> > iterator. it is css_online that has to be called before they are made
> > visible.
> > 
> > Tejun?
> 
> From the comment above css_for_each_descendant_pre()
> 
>  * Walk @root's descendants.  @root is included in the iteration and the
>  * first node to be visited.  Must be called under rcu_read_lock().  A
>  * descendant css which hasn't finished ->css_online() or already has
>  * finished ->css_offline() may show up during traversal and it's each
>  * subsystem's responsibility to verify that each @pos is alive.

/me slaps self. I was even reviewing patches which introduced that.
But still I managed to convince myself that online means before online
rather than right after again and again.

Sorry about the confusion.

> What it guarantees is that an online css would *always* show up in the
> iteration.  It's kinda difficult to guarantee both directions just
> with RCU locking.  You gotta make at least one end loose to make it
> work with RCU.
> 
> Thanks.
> 
> -- 
> tejun

-- 
Michal Hocko
SUSE Labs

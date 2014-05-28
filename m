Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaE1Ldb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:33:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbaE1Lda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:33:30 -0400
Date: Wed, 28 May 2014 13:33:28 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/9] mm: memcontrol: do not acquire page_cgroup lock for
 kmem pages
Message-ID: <20140528113328.GG9895@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-8-git-send-email-hannes@cmpxchg.org>
 <20140523133938.GC22135@dhcp22.suse.cz>
 <20140527195342.GD2878@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527195342.GD2878@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-05-14 15:53:42, Johannes Weiner wrote:
> On Fri, May 23, 2014 at 03:39:38PM +0200, Michal Hocko wrote:
[...]
> > >  	if (!PageCgroupUsed(pc))
> > >  		return;
> > >  
> > > -	lock_page_cgroup(pc);
> > > -	if (PageCgroupUsed(pc)) {
> > > -		memcg = pc->mem_cgroup;
> > > -		ClearPageCgroupUsed(pc);
> > > -	}
> > > -	unlock_page_cgroup(pc);
> > 
> > maybe add
> > 	WARN_ON_ONCE(pc->flags != PCG_USED);
> > 
> > to check for an unexpected flags usage in the kmem path?
> 
> There is no overlap between page types that use PCG_USED and those
> that don't.  What would be the value of adding this?

I meant it as an early warning that something bad is going on.

-- 
Michal Hocko
SUSE Labs

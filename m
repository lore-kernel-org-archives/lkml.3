Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaJHMs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:48:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbaJHMs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:48:28 -0400
Date: Wed, 8 Oct 2014 14:48:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] mm: memcontrol: eliminate charge reparenting
Message-ID: <20141008124823.GA4592@dhcp22.suse.cz>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 20-09-14 16:00:32, Johannes Weiner wrote:
> Hi,
> 
> we've come a looong way when it comes to the basic cgroups model, and
> the recent changes there open up a lot of opportunity to make drastic
> simplifications to memory cgroups as well.
> 
> The decoupling of css from the user-visible cgroup, word-sized per-cpu
> css reference counters, and css iterators that include offlined groups
> means we can take per-charge css references, continue to reclaim from
> offlined groups, and so get rid of the error-prone charge reparenting.
> 
> Combined with the higher-order reclaim fixes, lockless page counters,
> and memcg iterator simplification I sent on Friday, the memory cgroup
> core code is finally no longer the biggest file in mm/.  Yay!

Yeah, the code reduction (as per the diffstat - I didn't get to the code
yet) seems really promising.

> These patches are based on mmotm + the above-mentioned changes

> + Tj's percpu-refcount conversion to atomic_long_t.

This is https://lkml.org/lkml/2014/9/20/11 right?

> Thanks!
> 
>  include/linux/cgroup.h          |  26 +++
>  include/linux/percpu-refcount.h |  43 ++++-
>  mm/memcontrol.c                 | 337 ++------------------------------------
>  3 files changed, 75 insertions(+), 331 deletions(-)
> 

-- 
Michal Hocko
SUSE Labs

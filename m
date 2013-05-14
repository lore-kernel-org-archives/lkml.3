Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3ENHRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:17:22 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48049 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3ENHRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:17:21 -0400
X-AuditID: 9c930197-b7b76ae000003523-8b-5191e4ff8414
Date: Tue, 14 May 2013 16:17:18 +0900
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC 3/4] mm: support remove_mapping in irqcontext
Message-ID: <20130514071718.GC9466@blaptop>
References: <1368411048-3753-1-git-send-email-minchan@kernel.org>
 <1368411048-3753-4-git-send-email-minchan@kernel.org>
 <20130513145857.GD5246@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513145857.GD5246@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Michal,

On Mon, May 13, 2013 at 04:58:57PM +0200, Michal Hocko wrote:
> On Mon 13-05-13 11:10:47, Minchan Kim wrote:
> [...]
> > My rough plan is following as,
> > 
> > 1. Make mctz->lock beging aware of irq by changing spin_lock with
> >    spin_lock_irqsave.
> 
> I wouldn't be worried about this one as it is on its way out with the
> soft limit rework (the core uncontroversial part ;))

Good to hear!

> 
> > 2. Introuduce new argument "locked" in __mem_cgroup_uncharge_common
> >    so that __mem_cgroup_uncharge_common can avoid lock_page_cgroup in
> >    irqcontext to avoid deadlock but caller in irqcontext should be held
> >    it in advance by next patch.
> > 3. Introduce try_lock_page_cgroup, which will be used __swapcache_free.
> > 4. __remove_mapping can held a page_cgroup lock in advance before calling
> >    __swapcache_free
> > 
> > I'd like to listen memcg people's opinions before diving into coding.
> 
> It should work. It will require some code moving, though.

Yeb. I will give it a shot!

Thanks for the review!

-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaLCPw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:52:27 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46274 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaLCPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:52:26 -0500
Date: Wed, 3 Dec 2014 16:52:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove gfp helper function
Message-ID: <20141203155222.GH23236@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
 <20141127102547.GA18833@dhcp22.suse.cz>
 <20141201233040.GB29642@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201233040.GB29642@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-12-14 18:30:40, Johannes Weiner wrote:
> On Thu, Nov 27, 2014 at 11:25:47AM +0100, Michal Hocko wrote:
> > On Wed 26-11-14 14:17:32, David Rientjes wrote:
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2706,7 +2706,7 @@ rebalance:
> > >  	 * running out of options and have to consider going OOM
> > >  	 */
> > >  	if (!did_some_progress) {
> > > -		if (oom_gfp_allowed(gfp_mask)) {
> > 		/*
> > 		 * Do not attempt to trigger OOM killer for !__GFP_FS
> > 		 * allocations because it would be premature to kill
> > 		 * anything just because the reclaim is stuck on
> > 		 * dirty/writeback pages.
> > 		 * __GFP_NORETRY allocations might fail and so the OOM
> > 		 * would be more harmful than useful.
> > 		 */
> 
> I don't think we need to explain the individual flags, but it would
> indeed be useful to remark here that we shouldn't OOM kill from
> allocations contexts with (severely) limited reclaim abilities.

Is __GFP_NORETRY really related to limited reclaim abilities? I thought
it was merely a way to tell the allocator to fail rather than spend too
much time reclaiming. If you are referring to __GFP_FS part then I have
no objections to be less specific, of course, but __GFP_IO would fall
into the same category but we are not checking for it. I have no idea
why we consider the first and not the later one, to be honest...

-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbaLAXaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:30:46 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:51224 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484AbaLAXap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:30:45 -0500
Date: Mon, 1 Dec 2014 18:30:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, oom: remove gfp helper function
Message-ID: <20141201233040.GB29642@phnom.home.cmpxchg.org>
References: <alpine.DEB.2.10.1411261416480.13014@chino.kir.corp.google.com>
 <20141127102547.GA18833@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127102547.GA18833@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:25:47AM +0100, Michal Hocko wrote:
> On Wed 26-11-14 14:17:32, David Rientjes wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2706,7 +2706,7 @@ rebalance:
> >  	 * running out of options and have to consider going OOM
> >  	 */
> >  	if (!did_some_progress) {
> > -		if (oom_gfp_allowed(gfp_mask)) {
> 		/*
> 		 * Do not attempt to trigger OOM killer for !__GFP_FS
> 		 * allocations because it would be premature to kill
> 		 * anything just because the reclaim is stuck on
> 		 * dirty/writeback pages.
> 		 * __GFP_NORETRY allocations might fail and so the OOM
> 		 * would be more harmful than useful.
> 		 */

I don't think we need to explain the individual flags, but it would
indeed be useful to remark here that we shouldn't OOM kill from
allocations contexts with (severely) limited reclaim abilities.

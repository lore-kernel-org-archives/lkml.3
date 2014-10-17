Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaJQDCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:02:35 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42099 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbaJQDCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:02:33 -0400
Date: Thu, 16 Oct 2014 23:02:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/5] mm: memcontrol: continue cache reclaim from offlined
 groups
Message-ID: <20141017030221.GA8506@phnom.home.cmpxchg.org>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
 <20141015152555.GI23547@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015152555.GI23547@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:25:55PM +0200, Michal Hocko wrote:
> On Tue 14-10-14 12:20:36, Johannes Weiner wrote:
> > On cgroup deletion, outstanding page cache charges are moved to the
> > parent group so that they're not lost and can be reclaimed during
> > pressure on/inside said parent.  But this reparenting is fairly tricky
> > and its synchroneous nature has led to several lock-ups in the past.
> > 
> > Since css iterators now also include offlined css, memcg iterators can
> > be changed to include offlined children during reclaim of a group, and
> > leftover cache can just stay put.
> 
> I think it would be nice to mention c2931b70a32c (cgroup: iterate
> cgroup_subsys_states directly) here to have a full context about the
> tryget vs tryget_online.

Yes, that commit is probably the most direct dependency.

Andrew, could you update the changelog in place to have that paragraph
read

Since c2931b70a32c ("cgroup: iterate cgroup_subsys_states directly")
css iterators now also include offlined css, so memcg iterators can be
changed to include offlined children during reclaim of a group, and
leftover cache can just stay put.

please?  Thanks!

> > There is a slight change of behavior in that charges of deleted groups
> > no longer show up as local charges in the parent.  But they are still
> > included in the parent's hierarchical statistics.
> 
> Thank you for pulling drain_stock cleanup out. This made the patch so
> much easier to review.
>  
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks you!

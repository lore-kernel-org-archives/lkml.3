Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaBENt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaBENt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:49:58 -0500
Date: Wed, 5 Feb 2014 14:49:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/6] memcg: do not replicate
 try_get_mem_cgroup_from_mm in __mem_cgroup_try_charge
Message-ID: <20140205134956.GC2425@dhcp22.suse.cz>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-2-git-send-email-mhocko@suse.cz>
 <20140204155508.GM6963@cmpxchg.org>
 <20140204160521.GM4890@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204160521.GM4890@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-02-14 17:05:21, Michal Hocko wrote:
> On Tue 04-02-14 10:55:08, Johannes Weiner wrote:
> > On Tue, Feb 04, 2014 at 02:28:55PM +0100, Michal Hocko wrote:
> > > Johannes Weiner has pointed out that __mem_cgroup_try_charge duplicates
> > > try_get_mem_cgroup_from_mm for charges which came without a memcg. The
> > > only reason seems to be a tiny optimization when css_tryget is not
> > > called if the charge can be consumed from the stock. Nevertheless
> > > css_tryget is very cheap since it has been reworked to use per-cpu
> > > counting so this optimization doesn't give us anything these days.
> > > 
> > > So let's drop the code duplication so that the code is more readable.
> > > While we are at it also remove a very confusing comment in
> > > try_get_mem_cgroup_from_mm.
> > > 
> > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > > ---
> > >  mm/memcontrol.c | 49 ++++++++-----------------------------------------
> > >  1 file changed, 8 insertions(+), 41 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 53385cd4e6f0..042e4ff36c05 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1081,11 +1081,7 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
> > >  
> > >  	if (!mm)
> > >  		return NULL;
> > 
> > While you're at it, this check also seems unnecessary.
> 
> Yes, it will be removed in a later patch. I wanted to have it in a
> separate patch for a better bisectability just in case I have really
> missed mm-might-by-NULL case.

Ohh, I have mixed that with the other mm check. You are right we can
remove this one as well. Thanks and sorry for confusion!
-- 
Michal Hocko
SUSE Labs

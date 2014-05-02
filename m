Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaEBJqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:46:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaEBJqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:46:23 -0400
Date: Fri, 2 May 2014 11:46:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] memcg: Document memory.low_limit_in_bytes
Message-ID: <20140502094622.GE3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-5-git-send-email-mhocko@suse.cz>
 <20140430225748.GE26041@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430225748.GE26041@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 18:57:48, Johannes Weiner wrote:
> On Mon, Apr 28, 2014 at 02:26:45PM +0200, Michal Hocko wrote:
> > Describe low_limit_in_bytes and its effect.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  Documentation/cgroups/memory.txt | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > index add1be001416..a52913fe96fb 100644
> > --- a/Documentation/cgroups/memory.txt
> > +++ b/Documentation/cgroups/memory.txt
> > @@ -57,6 +57,7 @@ Brief summary of control files.
> >   memory.memsw.usage_in_bytes	 # show current res_counter usage for memory+Swap
> >  				 (See 5.5 for details)
> >   memory.limit_in_bytes		 # set/show limit of memory usage
> > + memory.low_limit_in_bytes	 # set/show low limit for memory reclaim
> >   memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
> >   memory.failcnt			 # show the number of memory usage hits limits
> >   memory.memsw.failcnt		 # show the number of memory+Swap hits limits
> > @@ -249,6 +250,14 @@ is the objective of the reclaim. The global reclaim aims at balancing
> >  zones' watermarks while the limit reclaim frees some memory to allow new
> >  charges.
> >  
> > +Groups might be also protected from both global and limit reclaim by
> > +low_limit_in_bytes knob. If the limit is non-zero the reclaim logic
> > +doesn't include groups (and their subgroups - see 6. Hierarchy support)
> > +which are bellow the low limit if there is other eligible cgroup in the
> 
> 'below' :-) Although I really like that spello.

ups
-- 
Michal Hocko
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaELH7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:59:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaELH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:59:40 -0400
Date: Mon, 12 May 2014 09:59:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] mm: memcontrol: rearrange charging fast path
Message-ID: <20140512075938.GB9564@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-3-git-send-email-hannes@cmpxchg.org>
 <20140507143334.GH9489@dhcp22.suse.cz>
 <20140508182224.GO19914@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508182224.GO19914@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-05-14 14:22:24, Johannes Weiner wrote:
> On Wed, May 07, 2014 at 04:33:34PM +0200, Michal Hocko wrote:
> > On Wed 30-04-14 16:25:36, Johannes Weiner wrote:
[...]
> > > -	if (unlikely(task_in_memcg_oom(current)))
> > > -		goto nomem;
> > > -
> > > -	if (gfp_mask & __GFP_NOFAIL)
> > > -		oom = false;
> > >  retry:
> > >  	if (consume_stock(memcg, nr_pages))
> > >  		goto done;
> > [...]
> > > @@ -2662,6 +2660,9 @@ retry:
> > >  	if (mem_cgroup_wait_acct_move(mem_over_limit))
> > >  		goto retry;
> > >  
> > > +	if (gfp_mask & __GFP_NOFAIL)
> > > +		goto bypass;
> > > +
> > 
> > This is a behavior change because we have returned ENOMEM previously
> 
> __GFP_NOFAIL must never return -ENOMEM, or we'd have to rename it ;-)
> It just looks like this in the patch, but this is the label code:
> 
> nomem:
> 	if (!(gfp_mask & __GFP_NOFAIL))
> 		return -ENOMEM;
> bypass:
> 	...

Ouch. Brain fart. Sorry...

-- 
Michal Hocko
SUSE Labs

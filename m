Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaEHSaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:30:09 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60612 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaEHSaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:30:08 -0400
Date: Thu, 8 May 2014 14:30:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 4/9] mm: memcontrol: catch root bypass in move precharge
Message-ID: <20140508183004.GQ19914@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-5-git-send-email-hannes@cmpxchg.org>
 <20140507145553.GJ9489@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507145553.GJ9489@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:55:53PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:38, Johannes Weiner wrote:
> [...]
> > @@ -6546,8 +6546,9 @@ one_by_one:
> >  			cond_resched();
> >  		}
> >  		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
> > +		if (ret == -EINTR)
> > +			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
> >  		if (ret)
> > -			/* mem_cgroup_clear_mc() will do uncharge later */
> 
> I would prefer to keep the comment and explain that we will loose return
> code on the way and that is why cancel on root has to be done here.

That makes sense, I'll add an explanation of who is (un)charged when
and where.  Thanks!


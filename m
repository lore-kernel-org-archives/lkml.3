Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3LLXb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:31:56 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:53448 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LLXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:31:54 -0500
Date: Thu, 12 Dec 2013 15:31:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg, oom: lock mem_cgroup_print_oom_info
In-Reply-To: <20131212084420.GA2630@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312121528400.17641@chino.kir.corp.google.com>
References: <1386776545-24916-1-git-send-email-mhocko@suse.cz> <alpine.DEB.2.02.1312111421320.7354@chino.kir.corp.google.com> <20131212084420.GA2630@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Michal Hocko wrote:

> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 28c9221b74ea..c72b03bf9679 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -1647,13 +1647,13 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
> > >   */
> > >  void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
> > >  {
> > > -	struct cgroup *task_cgrp;
> > > -	struct cgroup *mem_cgrp;
> > >  	/*
> > > -	 * Need a buffer in BSS, can't rely on allocations. The code relies
> > > -	 * on the assumption that OOM is serialized for memory controller.
> > > -	 * If this assumption is broken, revisit this code.
> > > +	 * protects memcg_name and makes sure that parallel ooms do not
> > > +	 * interleave
> > 
> > Parallel memcg oom kills can happen in disjoint memcg hierarchies, this 
> > just prevents the printing of the statistics from interleaving.  I'm not 
> > sure if that's clear from this comment.
> 
> What about this instead:
> 	* Protects memcg_name and makes sure that ooms from parallel
> 	* hierarchies do not interleave.
> ?

I think it would be better to explicitly say that you're referring only to 
the printing here and that we're ensuring it does not interleave in the 
kernel log.

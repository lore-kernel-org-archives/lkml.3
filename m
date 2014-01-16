Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaAPHpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 02:45:33 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53107 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPHp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 02:45:26 -0500
Date: Wed, 15 Jan 2014 23:45:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
In-Reply-To: <20140116070549.GL6963@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com> <20140116070549.GL6963@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Johannes Weiner wrote:

> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a815686..b482f49 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  				break;
> >  			};
> >  			points = oom_badness(task, memcg, NULL, totalpages);
> > -			if (points > chosen_points) {
> > -				if (chosen)
> > -					put_task_struct(chosen);
> > -				chosen = task;
> > -				chosen_points = points;
> > -				get_task_struct(chosen);
> 
> Where did that GET go?
> 

No idea, good catch!  This patch was doomed from the GET-go.
